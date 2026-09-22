
"""
Author:  Kevin Thomas, Registrar
Date:     04-APR-2023
Purpose:  This program joins the Jostens Cap and Gown order list with the Call Card List

Directions:             1.  Run SQL to find students who have filled out an intent
                        2.  Grad Spec will add a Y to column of the Intent File of 
                            students who ordered a 
                            cap and gown and move those who didn't to a separate tab.  
                            Grad Spec will name the file "Call Card List VIP File"
                        3.  Run Graduation Signal Vine Import SQL 
                        3.  Save both the file with Caps and Gown Ordered students and 
                            SV import to the same directory as this program.  
                        4.  Run this program
"""


import pandas as pd
import openpyxl 

#Read Files into Pandas Dataframe

cc=pd.read_excel('2023 Call Card List VIP File.xlsx')
sv=pd.read_excel('2023 Commencement Text List as of 04042023.xlsx')


#Merge the files on the students A#s"
callCards = pd.merge(
    cc, #Call Card VIP File
    sv, #SQL Output from extract for SV SQL
    left_on='STUDENT_ID',
    right_on='customer_id',
    how='outer',
    indicator=True,
    suffixes=('_CC','_SV')
    )

#Rename the indicator column
callCards['_merge']=callCards['_merge'].str.replace('left_only', 'C/G Only').str.replace('right_only', 'Intent Only').str.replace('both', 'Intent and C/G Order')

#Rename _merge column to "Cap and Gown Order"
callCards.rename({'_merge': 'Signal Vine'}, axis=1, inplace=True)

#Drop unwanted columns from the dataframe
callCards=callCards.drop(callCards.columns[:15], axis=1)

#Create final Call Card File from dataframe"
while True:
    try:
        fileName = input('Name the file: ')
        #audit.to_excel('DCM Audit Results.xlsx', index =False, header=True,)
        break
    except:
        print("Try again, name the file...")

fileName = fileName+'.xlsx'
date=input('Enter todays date mmddyyyy: ')


callCards.to_excel(fileName, index=False, header=True)

print('The', fileName, 'file has been created and saved in the Records S Drive > ')

input('\nPress enter to see file preview.')

print(callCards.head(15))


input('\nAfter previewing the file press enter to exit the program:  ')

print('\n The program will now close, Have a great day!')




