import requests

#define the API URL
url = 'https://jsonplaceholder.typicode.com/users'

#make an API request
response = requests.get(url)

#check if the request was successful (status code 200)
if response.status_code == 200:
    data = response.json()  # parse the JSON response
    print("Data fetched from API:")
    print(data)

    user_names = [user['name'] for user in data]  # extract names from the data
    print("\nUser Names:")
    print(user_names)
else:
    print(f"Failed to fetch data. Status code: {response.status_code}")
    print("Response:", response.text)
