#importing required libraries
import pyarrow as pa
import pyarrow.parquet as pq
import pandas as pd
import os

#simulate large data
data ={'name': ['Alice', 'Bob', 'Charlie', 'David'] * 2500,
        'age': [25, 30, 35, 40] * 2500,
        'city': ['New York', 'Los Angeles', 'Chicago', 'Houston'] * 2500}
df = pd.DataFrame(data)

#convert pandas dataframe to pyarrow table
table = pa.Table.from_pandas(df)

#write data to parquet file with snappy compression and partitioning by 'age'
pq.write_to_dataset(table, 'data_parquet', partition_cols=['age'], compression='snappy')

#option 1: read the parquet file if you know the exact partition of the parquet file
#that has your data
df_parquet = pd.read_parquet('data_parquet/age=25/1e708eb517bd4bcd9b54833f1582359b-0.parquet')
print(df_parquet.head())

#option 2: build the path dynamically to read the parquet file
#target partition table
age_value = 25

#construct the path to the parquet file
partition_path = os.path.join('data_parquet', f'age={age_value}')

#list all the files in that partition folder
files = [f for f in os.listdir(partition_path) if f.endswith('.parquet')]

#read the first paraquet file found in that partition
if files:
    full_path = os.path.join(partition_path, files[0])
    df_parquet = pd.read_parquet(full_path)
    print(df_parquet.head())
else:
    print(f"No parquet files found in partition: {partition_path}")