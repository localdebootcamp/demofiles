import csv

#Step 1: Read the CSV file
with open('data/users.csv', mode='r') as file:
    csv_reader = csv.DictReader(file)
    users = []
    for row in csv_reader:
        users.append(row)

print("total users loaded: ", len(users))

#Step 2: loop through the data and print names
print("User names:")
for user in users:
    print("-",user['full_name'])

#Step 3: Extract emails from gmail only
gmail_users = []
for user in users:
    if"gmail.com" in user['email']:
        gmail_users.append(user)

print("Gmail users count:", len(gmail_users))

#Step 4: Save filtered users into a new CSV file
with open('data/gmail_users.csv', mode='w', newline='') as file:
    write = csv.DictWriter(file, fieldnames=['full_name', 'email','signup_date'])
    write.writeheader()
    for user in gmail_users:
        write.writerow(user)
