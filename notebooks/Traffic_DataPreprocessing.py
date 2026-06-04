# TRAFFIC ACCIDENT DATA PREPROCESSING


## Importing Libraries
import pandas as pd
import numpy as np

## Load Dataset
df = pd.read_csv(r'C:\Users\MicroApt\Desktop\Traffic Project\5.DataSet\Project_dataset.csv')


## Create copy of dataset 
df_prep = df.copy()


## Check Missing Values
# This helps identify which columns have missing data
# and decide filling or dropping strategy.
print(df_prep.isnull().sum().sort_values(ascending=False))


## Handle Missing Values
# Numerical Columns --> Fill with Median (robust to outliers)
num_cols = df_prep.select_dtypes(include=['int64','float64']).columns

# fill missing values in all numerical columns using the median.
for col in num_cols:
    df_prep[col].fillna(df_prep[col].median(), inplace=True)

# Categorical Columns --> Fill with Mode (most frequent value)
cat_cols = df_prep.select_dtypes(include='object').columns

for col in cat_cols:
    df_prep[col].fillna(df_prep[col].mode()[0], inplace=True)


## Convert Timestamp & Extract Useful Time Features
df_prep['timestamp'] = pd.to_datetime(df_prep['timestamp'])

df_prep['hour_of_day'] = df_prep['timestamp'].dt.hour
df_prep['day_of_week'] = df_prep['timestamp'].dt.day_name()
df_prep['month'] = df_prep['timestamp'].dt.month

# NOTE:
# Raw timestamp is not useful for analysis.
# Extracting hour/day/month helps identify accident patterns.


## Drop Irrelevant Columns
df_prep.drop(
['traffic_data_quality_flag','signal_data_quality_flag'],
axis=1,
inplace=True
)

# drop duplicate columns
df_prep = df_prep.drop(columns=['peak'], errors='ignore')

# NOTE: These are metadata columns and not useful for analytics.


## Outlier Treatment (IQR Capping Method)

outlier_cols = [
'vehicle_count_per_hr',
'avg_speed_kmph',
'violations_count',
'veh_count_at_accident'
]

for col in outlier_cols:
    Q1 = df_prep[col].quantile(0.25)
    Q3 = df_prep[col].quantile(0.75)
    IQR = Q3 - Q1
    
    lower_limit = Q1 - 1.5 * IQR
    upper_limit = Q3 + 1.5 * IQR
    
    df_prep[col] = df_prep[col].clip(lower_limit, upper_limit)

#checking outliers
import seaborn as sns
sns.boxplot(df_prep.veh_count_at_accident)

# NOTE: This prevents extreme traffic spikes from distorting analysis.


## Feature Engineering (Create Analytical Categories)

# Traffic Congestion Level
df_prep['traffic_level'] = pd.cut(
    df_prep['vehicle_count_per_hr'],
    bins=[-1,500,1000,2000,5000],
    labels=['Low','Medium','High','Extreme']
)

# Risk Zone Based on Historical Score
df_prep['risk_zone'] = pd.cut(
    df_prep['blackspot_score'],
    bins=[0,0.2,0.4,0.6,1],
    labels=['Safe','Moderate','Risky','Danger']
)


df_prep[df_prep['traffic_level'].isnull()][['vehicle_count_per_hr']]

df_prep['overspeed_flag'] = (
    df_prep['avg_speed_kmph'] > df_prep['speed_limit_kmph']
).astype(int)


df_prep['speed_risk_flag'] = (
    df_prep['avg_speed_kmph'] > 0.6 * df_prep['speed_limit_kmph']
).astype(int)

# NOTE: These derived columns are very useful for dashboard storytelling.


# Final Validation Check

print(df_prep.isnull().sum())
print(df_prep.describe())
df_prep.shape
df_prep.info()

# Save Cleaned Dataset (Dashboard Ready)

import os
os.getcwd()

os.chdir(r"C:\Users\MicroApt\Desktop\Traffic Project\5.DataSet\Python")

df_prep.to_csv("traffic_cleaned_dataset.csv", index=False)

print("Cleaned dataset saved successfully")

df_prep.shape




