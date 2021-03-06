# -*- coding: utf-8 -*-
"""StageClipParticipantsFile.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1a1t0KEh6jXxO-Spe9V37iNkOug9psFnT

# ***Upload files from local machine to Colab for editing***
"""

#@Stage Clip Participants Program Part 1
##      Author:  Kevin Thomas, Interim Registrar
##        Date:  31-MAR-2021
#      Purpose:  This merges two SQL output files and creates the Stage Clips Participants File for virtual graduation.
# Instructions:  1.  Run SQL script labeled "Intensts for Jostens.sql" save as CSV file with encoding=utf-8
#                2.  Save cap and gown orders file from Jostens as CSV with encoding=utf-8.  Use the copy from the 
#                    bookstore General Manager, Jameson Bear.
#         Note:  The script will create an entry for every student on the cap and gown order list from Jostens and every student
#                on the intent to graduate SQL Script via an outter join on the A#. 


'''Specifications:  Spreadsheet in .csv formatting

·         One Column for each of the following:
·            First Name (one column on spreadsheet) - 50-character limit (recommended)
·            Last Name (one column on spreadsheet) - 50-character limit (recommended)
·            Degree or other sub-title (single line, one column on spreadsheet) - 90-character limit
·            Second sub-title (optional, single line, one column on spreadsheet) - 50-character limit
·            Student ID (optional)
·            Email Address – one per participant
·         If you need to add middle names or suffixes, you will need to combine those with the first and/or last name column
·         Please note that names and sub-titles will appear on the clips exactly as they do in the spreadsheet, including spelling and capitalization
·         Participants will appear in the ceremony in the same order they are listed on the Participant List, although you will have the ability to re-order them manually in the Producer platform
·         If you have multiple ceremonies, please be sure to separate your participant lists'''

#Upload file from local machine to Google Colab for editing

from google.colab import files
uploaded = files.upload()

"""# ***Convert Files to a Pandas Dataframe and pull them into the program***"""

#@Stage Clip Participants Program Part 2
#Convert Files to a Pandas Dataframe and pull them into the program

import pandas as pd


'''with open('2021 Jostens Orders.csv', mode='w', encoding='utf-8', newline= '',) as updated_jostens:
  rows = ['Last Name', 'First Name']
  csv_writer=csv.writer(updated_jostens, rows)'''



jostens = pd.read_csv('2021 Jostens Orders.csv')      ### VIP Use Notepad++ to convert encoding to UTF 8 or do it programatically###
intents = pd.read_csv('2021 Intents for Stage Clip.csv')

'''#Strip Jostens File of data that Stage Clips doesn't need for their participants list
jostens = jostens.drop(columns=['Received Date'])
jostens = jostens.drop(columns=['Program', 'Degree', 'Height', 'Gown Size'])
jostens = jostens.drop(columns =['Requested Delivery', 'Order #', 'Reference #'])
jostens['First Name']=jostens['First Name'].str.upper()
jostens['First Name']=jostens['First Name'].str.upper()'''

jostens = jostens.iloc[:,[1,2,3,4]]

#print(jostens.head(10))

#Rearrange columns on Jostens file to the order Stage Clip needs for their participants list
cols = list(jostens.columns.values)
jostens = jostens[[cols[0]] + [cols[3]] + [cols[2]] + [cols[1]]]
#print(cols)
print(jostens.head(3))
#jostens.describe()
#intents.info()
print(intents.head(3))
#intents.tail(10)
#intents.describe()

intents['First Name']=intents['First Name'].str.upper() #All caps for intents file to match Jostens for merging purposes
intents['Last Name']=intents['Last Name'].str.upper()

jostens['First Name']=jostens['First Name'].str.upper() #All caps for jostens file to match 'intents' for merging purposes
jostens['Last Name']=jostens['Last Name'].str.upper()

#print(jostens.head(50))
#intents.head(5)
#check for duplicate values (can use Last Name, Email, First Name)
##jostens[jostens.duplicated(subset='Email')==True]

print('Files have been imported and converted for manipulation.')

"""#  ***Merge the files.  Then create Stage Clip Participants File.***

"""

#@Stage Clip Participants Program Part 3
#Merge the two dataframes on First and Last Name
# StageClips = pd.merge(
#     jostens, #left DataFrame
#     intents, #right DataFrame
#     how='left', #left will include everyone who order C&G, blank degree means didn't complete intent; Right=everyone on intent, blank email means didn't order C&G
#     indicator=True  
#     )

#StageClips = pd.concat([jostens,intents], join='outer')

StageClips = pd.merge(
    intents,
    jostens,
    left_on='ID', right_on='Commencement Reg. Student ID',
    how='outer',
    indicator=True
)


#print(StageClips.columns)
#print(type(StageClips))

#StageClips = StageClips.loc[StageClips['Commencement Reg. Email'].notnull()] #uncomment out to only return students who completed the Cap and Gown order correctly
#print(StageClips)

# StageClips.set_index('First Name', inplace=True)
print(StageClips.head(10))
# StageClips.describe()
# StageClips.info()
#StageClips



StageClips.to_csv('Stage Clips Participants List.csv', index =False, header=False,)
print('Files have been merged and the new file name is "Stage Clips Participants List.csv". The final step is to download the file to your machine.')

"""# ***Download created file to local machine.***

"""

#@Stage Clip Participants Program Part 4
#Download the file from Colab to the local machine

files.download('Stage Clips Participants List.csv')

print("The Stage Clips Particpants File has been created and loaded to your machine.  Please verify accuracy.")