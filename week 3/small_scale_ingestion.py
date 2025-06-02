#import necessary libraries
import pandas as pd
import sqlite3

#read the CSV file
df = pd.read_csv('data.csv')

#connect to the SQLite database
conn = sqlite3.connect('database.db')

#store the DataFrame in the SQLite database
df.to_sql('data_table', conn, if_exists='replace', index=False)

#close the database connection
conn.close()