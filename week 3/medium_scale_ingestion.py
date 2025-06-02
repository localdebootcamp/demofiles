#importing the libraries
import json
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, Float

#postgresql connection setup
engine = create_engine('postgresql://username:password@localhost:5432/mydatabase')
Session = sessionmaker(bind=engine)
base = declarative_base()


#define the user model for storing data
class User(base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    age = Column(Integer)
    email = Column(String)
    balance = Column(Float)

#create the table in postgresql if it doesn't exist
base.metadata.create_all(engine)

#function to load data from json files
def load_data_from_json(file_path):
    with open(file_path,'r') as files:
        data = json.load(files)
    return data

#function to store json data into the database
def store_data(data):
    session = Session()
    try:
        for record in data:
            session.add(User(name=record['name'],
                            age=record['age'],
                            email=record['email'],
                            balance=record['balance']))
            session.commit()
    except Exception as e:
        print(f"An error occurred: {e}")
        session.rollback()
    finally:
        session.close()

#example for loading and storing multiple json files
def main():
    json_files = ['data1.json', 'data2.json', 'data3.json']
    for file in json_files:
        data = load_data_from_json(file)
        store_data(data)

if __name__ == "__main__":
    main()
# This script will load data from multiple JSON files and store it in a PostgreSQL database.
# Make sure to replace 'username', 'password', and 'mydatabase' with your actual PostgreSQL credentials and database name.
# Ensure that the JSON files have the correct structure:
# [
#   {
#     "name": "John Doe",
#     "age": 30,
#     "email": "alice@example.com",
#     "balance": 1000.50
#   }
#   ...
# ]
# The script will create a 'users' table if it does not exist and insert the data from the JSON files into this table.
