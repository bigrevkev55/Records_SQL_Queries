
"""
Author:  Kevin Thomas, Registrar
Date:     11-APR-2022
Purpose:  This program joins the Jostens Cap and Gown order list with the Call Card List

Directions:             1.  Get Jostens Cap and Gown Order list from bookstore manager
                        2.  Run ????.sql to pull in Call Cards spreadsheet
                        3.  Save both files in the same directory as this program
                        4.  Run this program
"""


import pandas as pd
import openpyxl 

#Read Files into Pandas Dataframe and create file objects
cc=pd.read_excel('2024 Call Card List.xlsx')
jostens=pd.read_excel('Student Regalia Order as of 040424 inc Summer.xlsx')

#Since A#s weren't in Josten File use First and Last Name as Unique ID.  
#Convert all characters to all caps so that they match in each file.  
cc['FIRST_NAME']=cc['FIRST_NAME'].str.upper() #All caps for intents file to match Jostens for merging purposes
cc['LAST_NAME']=cc['LAST_NAME'].str.upper()

jostens['First Name']=jostens['First Name'].str.upper() 
jostens['Last Name']=jostens['Last Name'].str.upper()

ccName=cc['FIRST_NAME']+cc['LAST_NAME']
jostensName = jostens['First Name']+jostens['Last Name']

#Merge the files on the students A#s (First Name Last Name)"
callCards = pd.merge(
    cc,
    jostens,
    left_on=ccName,
    right_on=jostensName,
    how='outer',
    indicator=True,
    suffixes=('_Banner','_Jostens')
    )

#Rename the indicator column
callCards['_merge']=callCards['_merge'].str.replace('left_only', 'Intent Only').str.replace('right_only', 'C/G  Only').str.replace('both', 'Yes')

#Rename _merge column to "Cap and Gown Order"
callCards.rename({'_merge': 'Cap and Gown Order'}, axis=1, inplace=True)

#Drop unwanted columns from the dataframe
#callCards=callCards.drop(callCards.columns[[6,13, 14, 16, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55]], axis=1)

#Create final Call Card File from dataframe"
while True:
    try:
        fileName = input('Name the file: ')
        #audit.to_excel('DCM Audit Results.xlsx', index =False, header=True,)
        break
    except:
        print("Try again, name the file...")

fileName = fileName+'.xlsx'
date=input('Enter todays date (mmddyyyy): ')


callCards.to_excel(fileName, index=False, header=True,
               sheet_name=f'Call Card List as of {date}.')

print('The', fileName, 'file has been created and saved in the Records S Drive > ')

input('\nPress enter to see file preview.')

#print(callCards.head(15))


#input('\nAfter previewing the file press enter to exit the program:  ')

input('\n The program will now close, Have a great day!')




