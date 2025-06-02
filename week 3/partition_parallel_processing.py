import pandas as pd
from multiprocessing import Pool

#function to process each chunk of csv data
def process_chunk(chunk_file):
    chunk = pd.read_csv(chunk_file)
    processed_data = chunk.dropna(subset=['age'])
    return processed_data

#list of csv files each representing a partition
csv_files = ['data_2020.csv', 'data_2021.csv', 'data_2022.csv']

#using multiprocessing to process each file in parallel
with Pool(processes=3) as pool:
    results = pool.map(process_chunk, csv_files)

#combine all processed data into a single DataFrame
combined_data = pd.concat(results, ignore_index=True)

#store the final data in the database postgreSQL
from sqlalchemy import create_engine
engine = create_engine('postgresql://username:password@localhost:5432/mydatabase')
combined_data.to_sql('processed_data', engine, if_exists='replace', index=False)