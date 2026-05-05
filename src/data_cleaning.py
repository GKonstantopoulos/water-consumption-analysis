import pandas as pd


# File paths
file_path_2024 = "data/raw/consumptions_2024.csv"
file_path_2025 = "data/raw/consumptions_2025_q1.csv"


# Load raw CSV files
df_2024 = pd.read_csv(file_path_2024, encoding="utf-8")
df_2025 = pd.read_csv(file_path_2025, encoding="utf-8")


# Clean column names
df_2024.columns = df_2024.columns.str.strip()
df_2025.columns = df_2025.columns.str.strip()


# Clean total consumption
# Some values use comma as thousands separator, e.g. "1,541".
df_2024["Συνολική κατανάλωση"] = pd.to_numeric(
    df_2024["Συνολική κατανάλωση"].str.replace(",", ""),
    errors="coerce"
)

df_2025["Συνολική κατανάλωση"] = pd.to_numeric(
    df_2025["Συνολική κατανάλωση"].str.replace(",", ""),
    errors="coerce"
)


# Convert postal code to nullable integer
df_2024["ΤΚ"] = df_2024["ΤΚ"].astype("Int64")
df_2025["ΤΚ"] = df_2025["ΤΚ"].astype("Int64")


# Combine 2 datasets
df = pd.concat([df_2024, df_2025], ignore_index=True)


# Convert month string to real date
df["date"] = pd.to_datetime(df["Μήνας κατανάλωσης"], format="%m/%Y")


# Create year and month columns
df["year"] = df["date"].dt.year
df["month"] = df["date"].dt.month


# Rename columns 
df = df.rename(columns={
    "ΤΚ": "postal_code",
    "Περιοχή": "area",
    "Ζώνη": "consumption_class",
    "Συνολική κατανάλωση": "total_consumption",
    "Ημέρες κατανάλωσης": "consumption_days",
    "Μέση ημερήσια κατανάλωση": "avg_daily_consumption",
    "Πλήθος παροχών": "connections",
    "Μήνας κατανάλωσης": "month_str"
})


# Replace missing areas with explicit label
df["area"] = df["area"].fillna("UNKNOWN")


# Create normalized metric
df["consumption_per_connection_day"] = (
    df["total_consumption"] / df["consumption_days"] / df["connections"]
)


# Keep rows with enough connections for more reliable analysis
df_filtered = df[df["connections"] >= 10].copy()

# Remove rows with 0 consumption_days to avoid division errors
df_filtered = df_filtered[df_filtered["consumption_days"] > 0].copy()

# Flag anomalies using 99th percentile threshold found during exploration
df_filtered["is_anomaly"] = df_filtered["consumption_per_connection_day"] > 0.86


# Final checks
print("FINAL DATASET")
print(df_filtered.shape)

print("\nMISSING VALUES")
print(df_filtered.isnull().sum())

print("\nDTYPES")
print(df_filtered.dtypes)

df_filtered["is_anomaly"] = df_filtered["is_anomaly"].astype(int)
df_filtered["postal_code"] = df_filtered["postal_code"].fillna(0).astype(int)

# Export clean dataset for MySQL
df_filtered.to_csv("data/processed/clean_water_data.csv", index=False, encoding="utf-8-sig")

