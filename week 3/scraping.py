import requests
from bs4 import BeautifulSoup

# Define the URL of the webpage to scrape
url = 'https://quotes.toscrape.com/'

#send an http rquest to the URL
response = requests.get(url)

# Check if the request was successful (status code 200)
if response.status_code == 200:
    soup = BeautifulSoup(response.text, 'html.parser')  # parse the HTML content
    quotes = soup.find_all('span', class_='text')  # find all quote elements

    print("quotes from the webpage:")
    for quote in quotes:
        print(quote.text)
else:
    print(f"failed to retrieve data. status code: {response.status_code}")  # print error message
