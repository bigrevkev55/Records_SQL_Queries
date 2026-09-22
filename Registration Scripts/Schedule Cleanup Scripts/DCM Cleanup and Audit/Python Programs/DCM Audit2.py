


# pip install sqlalchemy, pandas, 

from os import replace
import sqlite3
import pandas as pd
from sqlalchemy import create_engine


audit2=input('Enter the name of the Excel File you wish to query:  ')
output=input('Enter the name you wish to give the results files:  ')

output=output+'.xlsx'


engine=create_engine('sqlite://', echo=False)
df=pd.read_excel(audit2, sheet_name='DCM_AUDIT_RESULTS')

df.to_sql('DCM_AUDIT', engine, if_exists='replace', index=False)

query=engine.execute('SELECT * from DCM_AUDIT WHERE Comments like "Both%" and Amount_Bookstore IS NOT NULL;')

final=pd.DataFrame(query, columns=df.columns)
final.to_excel(output, index=False)
print()
print()
print(f'The file {output} has been created and saved in the Records S Drive > ... > DCM Cleanup and Audit sub-directory.')