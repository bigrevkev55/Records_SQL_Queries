

#Pip install pandas, sqlalchemy if not already installed.  

import sqlite3
import pandas as pd
from sqlalchemy import create_engine, engine

file='Name of the file to be used as the database'
sheet='Name of the sheet (tab) to be used as the table'
output='The name you wish to give the results of the SQL Query'

engine=create_engine('sqlite://', echo=False) #Creates a database in RAM
df=pd.read_excel(file,sheet_name=sheet)
df.sql('{table_name}', engine, if_exists='replace', index=False)  #Create a table in memory for SQL Query below

results=engine.execute('SELECT {needed data} FROM {table_name} listed above;')

final=pd.DataFrame(results, columns=df.columns) #Creates the dataframe
final.to_excel(output, index=False) #Writes the dataframe into an Excel file

print()
print('File file has been created and saved in the ... directory')