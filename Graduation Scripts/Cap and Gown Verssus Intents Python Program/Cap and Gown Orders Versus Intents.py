
"""      Author:  Kevin Thomas, Interim Registrar
##        Date:  01-APR-2024
#      Purpose:  This program merges two SQL output files and creates the Stage Clips Participants File for virtual graduation.
# Instructions:  1.  Run SQL script labeled "Intent to Graduate Script (Commencement Eligible).txt" save as CSV file with encoding=utf-8
#                2.  Save cap and gown orders file from Jostens as CSV with encoding=utf-8.  Use the copy from the 
#                    bookstore General Manager, current Kiel Murphy.
#         Note:  The script will create an entry for every student on the cap and gown order list from Jostens and every student
#                on the intent to graduate SQL Script via an outter join on the A#. 
"""

#Imports
import pandas as pd

#Convert Files to a Pandas Dataframe and pull them into the program
jostens = pd.read_csv('Cap and Gown Orders as of 04012024.csv')      ### VIP Use Notepad++ to convert encoding to UTF 8 or do it programatically###
intents = pd.read_csv('2324 Intents as of 04012024.csv')

jostens = jostens.iloc[:,[2,3,21, 20, 23]]

intents['First Name']=intents['First Name'].str.upper() #All caps for intents file to match Jostens for merging purposes
intents['Last Name']=intents['Last Name'].str.upper()

jostens['First Name']=jostens['First Name'].str.upper() #All caps for jostens file to match 'intents' for merging purposes
jostens['Last Name']=jostens['Last Name'].str.upper()


print('Files have been imported and converted for manipulation.')

comparisonReport = pd.merge(
    intents,
    jostens,
    #left_on='Last Name' + 'First Name',
    #right_on='Last Name' + 'First Name',
    how='outer',
    indicator=True,
    suffixes=('_Intent Only', 'C & G Only')
)

#Rename Indicator Column
comparisonReport['_merge'] = comparisonReport['_merge'].str.replace('left_only', 'intent_only').str.replace('right_only', 'C & G Only')

#Rename _merge column to "Results"
comparisonReport.rename({'_merge': 'Result'}, axis=1, inplace=True)

print(comparisonReport.head(10))


comparisonReport.to_csv('Comparison Report.csv', index =False, header=True,)
print('Files have been merged and the new file name is "Comparison Report.csv".')
