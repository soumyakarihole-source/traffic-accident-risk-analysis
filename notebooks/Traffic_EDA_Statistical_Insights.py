import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv(r'C:\Users\MicroApt\Desktop\Traffic Project\5.DataSet\Project_dataset.csv')
df.info()
df.shape
df.columns
df.describe()
print(df.isnull().sum())

df['speed_limit_kmph'].count()

# First Moment Business Decision
#Mean
df.lane_count.mean()
#median
df.lane_count.median()
#mode
df.lane_count.mode()

df.speed_limit_kmph.mean()
df.speed_limit_kmph.median()
df.speed_limit_kmph.mode()

df.blackspot_score.mean()
df.blackspot_score.median()
df.blackspot_score.mode()

df.vehicle_count_per_hr.mean()
df.vehicle_count_per_hr.median()
df.vehicle_count_per_hr.mode()

df.avg_speed_kmph.mean()
df.avg_speed_kmph.median()
df.avg_speed_kmph.mode()

df.green_duration_s.mean()
df.green_duration_s.median()
df.green_duration_s.mode()

df.red_duration_s.mean()
df.red_duration_s.median()
df.red_duration_s.mode()

df.yellow_duration_s.mean()
df.yellow_duration_s.median()
df.yellow_duration_s.mode()

df.cycle_time_s.mean()
df.cycle_time_s.median()
df.cycle_time_s.mode()

df.violations_count.mean()
df.violations_count.median()
df.violations_count.mode()

df.vehicles_involved.mean()
df.vehicles_involved.median()
df.vehicles_involved.mode()

df.veh_count_at_accident.mean()
df.veh_count_at_accident.median()
df.veh_count_at_accident.mode()

#################################
# Second Moment Business Decision
#Variance
df.lane_count.var()
#Standard Deviation
df.lane_count.std()
#range
range = max(df.lane_count) - min(df.lane_count)
range

df.speed_limit_kmph.var()
df.speed_limit_kmph.std()
range = max(df.speed_limit_kmph) - min(df.speed_limit_kmph)
range

df.blackspot_score.var()
df.blackspot_score.std()
range = max(df.blackspot_score) - min(df.blackspot_score)
range

df.vehicle_count_per_hr.var()
df.vehicle_count_per_hr.std()
range = max(df.vehicle_count_per_hr) - min(df.vehicle_count_per_hr)
range

df.avg_speed_kmph.var()
df.avg_speed_kmph.std()
range = max(df.avg_speed_kmph) - min(df.avg_speed_kmph)
range

df.green_duration_s.var()
df.green_duration_s.std()
range = max(df.green_duration_s) - min(df.green_duration_s)
range

df.red_duration_s.var()
df.red_duration_s.std()
range = max(df.red_duration_s) - min(df.red_duration_s)
range

df.yellow_duration_s.var()
df.yellow_duration_s.std()
range = max(df.yellow_duration_s) - min(df.yellow_duration_s)
range

df.cycle_time_s.var()
df.cycle_time_s.std()
range = max(df.cycle_time_s) - min(df.cycle_time_s)
range

df.violations_count.var()
df.violations_count.std()
range = max(df.violations_count) - min(df.violations_count)
range

df.vehicles_involved.var()
df.vehicles_involved.std()
range = max(df.vehicles_involved) - min(df.vehicles_involved)
range

df.veh_count_at_accident.var()
df.veh_count_at_accident.std()
range = max(df.veh_count_at_accident) - min(df.veh_count_at_accident)
range


################################
# Third Moment Business Decision
#Skewness
df.lane_count.skew()
df.speed_limit_kmph.skew()
df.blackspot_score.skew()
df.vehicle_count_per_hr.skew()
df.avg_speed_kmph.skew()
df.green_duration_s.skew()
df.red_duration_s.skew()
df.yellow_duration_s.skew()
df.cycle_time_s.skew()
df.violations_count.skew()
df.vehicles_involved.skew()
df.veh_count_at_accident.skew()


################################
# Fourth Moment Business Decision
#Kurtosis
df.lane_count.kurt()
df.speed_limit_kmph.kurt()
df.blackspot_score.kurt()
df.vehicle_count_per_hr.kurt()
df.avg_speed_kmph.kurt()
df.green_duration_s.kurt()
df.red_duration_s.kurt()
df.yellow_duration_s.kurt()
df.cycle_time_s.kurt()
df.violations_count.kurt()
df.vehicles_involved.kurt()
df.veh_count_at_accident.kurt()

# checking outliers
sns.boxplot(df.veh_count_at_accident)

## Univariate Analysis (Traffic & Risk Variables)

# Traffic Flow Distribution : Traffic flow shows right skew indicating peak congestion spikes.
sns.histplot(df['vehicle_count_per_hr'])
plt.title("Traffic Volume Distribution")
plt.show()

# Speed Distribution : Speed distribution shows presence of extreme speeding events.
sns.boxplot(x=df['avg_speed_kmph'])
plt.title("Speed Distribution")
plt.show()

# Violations Distribution :Violations mostly low but few extreme violation spikes exist.
sns.histplot(df['violations_count'])
plt.show()


## These two are IMP target variable for analysis 
# Accidents are relatively less frequent compared to non-accident observations.
sns.countplot(x='accident_occurred', data=df)
plt.title("Accident Occurrence Distribution")
plt.show()
# Majority accidents fall into moderate severity category.
sns.countplot(x='severity', data=df)
plt.title("Accident Severity Distribution")
plt.show()


## Bivariate Analysis
# Traffic Volume accident
# Accidents tend to occur during higher traffic congestion periods.
sns.boxplot(x='accident_occurred', y='vehicle_count_per_hr', data=df)
plt.show()

# Speed vs Severity
# Higher speeds are associated with more severe accidents.
sns.boxplot(x='severity', y='avg_speed_kmph', data=df)
plt.show()

# Violations vs Accident
# Violation spikes strongly relate to accident occurrence.
sns.boxplot(x='accident_occurred', y='violations_count', data=df)
plt.show()

# Weather Impact
# Adverse weather increases accident probability
sns.countplot(x='weather', hue='accident_occurred', data=df)
plt.show()


# Spatial and Time Analysis
# Hotspot Scatter
# Accident clusters are visible in specific geographic regions indicating hotspot zones.
sns.scatterplot(
    x='longitude',
    y='latitude',
    hue='accident_occurred',
    data=df
)
plt.title("Accident Hotspot Distribution")
plt.show()

# Accident by hour
# Evening peak hours show higher accident frequency.
sns.countplot(x='hour_of_day', hue='accident_occurred', data=df)
plt.show()

# peak vs non peak
# Peak traffic periods significantly increase accident risk.
sns.countplot(x='is_peak', hue='accident_occurred', data=df)
plt.show()



## Correlation Heatmap
# Traffic volume, violations and blackspot score show positive correlation with accident occurrence.
plt.figure(figsize=(14,10))
sns.heatmap(df.corr(), cmap='coolwarm')
plt.title("Correlation Heatmap")
plt.show()


