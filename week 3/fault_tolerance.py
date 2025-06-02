import logging
from tenacity import retry, stop_after_attempt, wait_exponential
import requests


#setup logging configuration
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Function to fetch data from an API with retry logic
@retry(wait=wait_exponential(min=1, max=10), stop=stop_after_attempt(5))
def fetch_data_from_api(url):
    logging.info(f"Attempting to fetch data from {url}")
    response = requests.get(url)
    
    if response.status_code != 200:
        logging.error(f"Failed to fetch data: {response.status_code} - {response.text}")
        raise Exception("API request failed")
    
    logging.info("Data fetched successfully")
    return response.json()

#example url
url = "https://api.example.com/data"

try:
    data = fetch_data_from_api(url)
    logging.info(f"Data received: {data}")
except Exception as e:
    logging.error(f"An error occurred while fetching data: {e}")
    # Handle the error appropriately, e.g., notify the user, log to a file, etc.


# attempt       delay before retry
#    1           0 second
#    2           2**1 = 2 second
#    3           2**2 = 4 seconds
#    4           2**3 = 8 seconds
#    5           2**4 = 16 seconds ~ max at 10 seconds