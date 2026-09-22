"""
Author:      Kevin Thomas, Registrar
Date:        30-OCT-2021
Purpose:     This program audits DCMs; comparing the DCM spreadsheet from the bookstore
             and the DCM output from the 'SSADETL - SSASECT Sections with DCM Fees.txt' SQL script.
Directions:  1.  Get DCM file from Laura Loeb, NSCC Bookstore General Manager, and or AVPAA, Dr. Sarah Roberts. 
             2.  Save the file as '{term} DCM from bookstore.xlsx' in the same directory as this program.
             3.  Run 'SSADETL - SSASECT Sections with DCM Fees.txt' SQL script.
             3.  Save as '{termcode} DCM in Banner.xlsx' in the same directory as this program.  
             4.  If necessary, pip install Pandas and Openpyxl.
             5.  Run this program
"""


import pandas as pd

#Read files into Pandas data frame#

term=input('Enter Term Code:  ')

bookstore = pd.read_excel(f'{term} DCM from bookstore.xlsx')
records = pd.read_excel(f'{term} DCM in Banner.xlsx')

# Locate columns by index that need to be used in the program
bookstore = bookstore.iloc[:, [0, 1, 2, 3, 4, 8]]
records = records.iloc[:, [0, 1, 2, 3, 4, 8]]

# Rearrange columns on records file to match the bookstore columns.
cols = list(records.columns.values)
records = records[[cols[4]] + [cols[0]] +
                  [cols[1]] + [cols[2]] + [cols[3]] + [cols[5]]]

print('/nFiles have been imported and converted for manipulation.')

#  ***Merge the files on the CRNs***

"""   
#Merge the two dataframes on CRN
# df = pd.merge(
#     bookstore, #left DataFrame
#     records,   #right DataFrame
#     how='left', #left will include all CRNs on the Bookstore file: Right=all CRNs on the Records file.
#     indicator=True  
#     )
#audit = pd.concat([bookstore, records], join='outer')
"""

audit = pd.merge(
    bookstore,
    records,
    left_on='CRN',
    right_on='CRN',
    how='outer',
    indicator=True,  # will be named '_merge'.  Useful information when changing the output of this column below
    suffixes=('_SSS', '_Banner')
)

# Rename the "_merge" column output from "left_only", "right_only", "both" to useful user instructions
audit['_merge'] = audit['_merge'].str.replace('left_only', 'Bkstr Only, ADD DCM IN BANNER if DCM Amount Listed').str.replace(
    'right_only', 'Banner Only; DELETE DCM FROM BANNER').str.replace('both', 'Both, DOUBLE CHECK that prices Match')


# Rename columns to to user friendly column names. --rename({old:new})
audit.rename({'_merge': 'Comments'}, axis=1, inplace=True)
audit.rename({'DCM cost':'Bookstore Charge'}, axis=1, inplace=True)
audit.rename({'Amount':'Banner Charge'}, axis=1, inplace=True)


# Create the "DCM Audit Results" file
while True:
    try:
        fileName = input('Name the file: ')
        #audit.to_excel('DCM Audit Results.xlsx', index =False, header=True,)
        break
    except:
        print("Try again, name the file...")

fileName = fileName+'.xlsx'
audit.to_excel(fileName, index=False, header=True,
               sheet_name='DCM_Audit_Results')
print()
print('\nFiles have been merged and the new file name is ', fileName, '.', sep='')
input('Press enter to continue...')
print()
print('The', fileName, 'file has been created and saved in the Records S Drive > ')
print('...Schedule Cleanup Scripts > DCM Cleanup and Audit directory.  Please verify accuracy.')
#input('Press enter to continue...')

input('\nPress enter to see file preview.')

print(audit.head(15))
input('\nAfter previewing the file press enter to exit the program:  ')

print('\n The program will now close, Have a great day!')
