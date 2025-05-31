import pandas as pd
import great_expectations as gx

# Create a sample DataFrame
data = {
    'name': ['Alice', 'Bob', None, 'Charlie', 'David', 'Alice'],
    'age': [25, 30, None, 35, 40, 25],
    'email': ['alice@example.com', 'bob@example.com', None, 'charlie@example.com', 'david@example.com', 'alice@example.com'],
    'score': [85.5, 90.0, None, 95.0, 80.0, 85.5]
}
df = pd.DataFrame(data)

# Use GX's from_pandas API
df_ge = gx.from_pandas(df)

# Set expectations
df_ge.expect_column_values_to_not_be_null('name')
df_ge.expect_column_values_to_not_be_null('age')
df_ge.expect_column_values_to_be_between('age', 18, 100)
df_ge.expect_column_values_to_be_unique('email')
df_ge.expect_column_values_to_not_be_null('score')
df_ge.expect_column_values_to_be_between('score', 0, 100)
df_ge.expect_column_values_to_be_of_type('age', 'int')
df_ge.expect_column_values_to_be_in_set('status', ['active', 'inactive', 'pending'])
# Validate
results = df_ge.validate()

print("\nValidation Results:")
for res in results['results']:
    print(f"{res['expectation_config']['expectation_type']}: {res['success']}")
