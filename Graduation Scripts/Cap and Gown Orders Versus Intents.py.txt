
##      Author:  Kevin Thomas, Interim Registrar
##        Date:  04-APR-2024
#      Purpose:  This merges two SQL output files and creates a comparision report between students that have ordered caps and gowns and those that have submitted an intent to graduate. 
# Instructions:  1.  Run SQL script labeled "Intent to Graduate Script (Commencement Eligible)" save as CSV file with encoding=utf-8
#                2.  Save cap and gown orders file from Jostens as CSV with encoding=utf-8.  Use the copy from the 
#                    bookstore General Manager, (current Kiel Murphy).
#         Note:  The program will create an entry for every student on the cap and gown order list from Jostens and every student
#                on the intent to graduate SQL Script via an outter join on the A#. 
#


import pandas as pd

#Create objects from the files to use in the program
jostens = pd.read_csv('Cap and Gown Orders as of 04012024.csv')      ### VIP Use Notepad++ to convert encoding to UTF 8 or do it programatically###
intents = pd.read_csv('2324 Intents as of 04012024.csv')

jostens = jostens.iloc[:,[2,3,23]]

print(jostens.head(10))
#jostens.describe()
#intents.info()
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

"""  ***Merge the files.  Then create Report.***
"""


#Merge the two dataframes on First and Last Name
comparisonReport = pd.merge(
    intents,
    jostens,
    left_on='ID', right_on='Reference #',
    how='outer',
    indicator=True
)


#print(StageClips.columns)
#print(type(StageClips))

#StageClips = StageClips.loc[StageClips['Commencement Reg. Email'].notnull()] #uncomment out to only return students who completed the Cap and Gown order correctly
#print(StageClips)

# StageClips.set_index('First Name', inplace=True)
print(comparisonReport.head(10))
# StageClips.describe()
# StageClips.info()
#StageClips

comparisonReport.to_csv('Stage Clips Participants List.csv', index =False, header=False,)
print('Files have been merged and the new file name is "Stage Clips Participants List.csv". The final step is to download the file to your machine.')


print("The Cap and Gown Versus Intents report has been created and loaded to your machine.  Please verify accuracy.")