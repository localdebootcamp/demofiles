import pyarrow.parquet as pq

#define the paraquet file path
file_path = 'data.parquet'

#read the paraquet file into a pyarrow table
table = pq.read_table(file_path)

#convert the tables to a pandas DataFrame for easier manipulation
df = table.to_pandas()

#display the first few rows of the DataFrame
print("Data fetched from Parquet file:")
print(df.head())
