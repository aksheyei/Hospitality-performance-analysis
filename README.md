# 🏨 HOSPITALITY PERFORMANCE & TREND ANALYSIS (2020–2025)
📋 Project Overview
This project provides a comprehensive end-to-end SQL analysis of the hospitality industry, examining 50,000 hotel reviews across 25 global cities from 2020 to 2025. The analysis focuses on identifying growth trends, seasonal patterns, and specific service dimensions that drive guest satisfaction or indicate business risk.

📊 Dataset Overview
The project utilizes three primary datasets representing a global hospitality footprint:

Hotels: 25 hotels across 25 cities and 25 countries.

Users: 2,000 unique users with demographic details including gender and traveller type.

Gender Distribution: 942 Female, 864 Male, and 194 Others.

Traveller Types: Primarily Couples (694) and Families (478), followed by Solo (420) and Business (408) travellers.

Reviews: 50,000 total reviews spanning six years, capturing scores for cleanliness, comfort, facilities, location, staff, and value for money.

🛠️ SQL Implementation
The analysis was performed using MySQL. The provided script (hospitality_sql_script.sql) covers:

Data Cleaning: Converting text-based dates to DATE types and setting up Primary/Foreign Key constraints.

Exploratory Data Analysis (EDA): Aggregating user demographics and review counts.

Advanced Analytics:

Year-over-Year (YoY) Growth: Calculated using Window Functions (LAG).

Performance Ranking: Using DENSE_RANK() to identify top and bottom-performing cities and hotels.

Risk Assessment: Identifying "Risky Hotels" that maintain high review volumes but fall below a 9.0 average rating.

📈 Key Insights
1. Growth & Seasonality
Peak Years: 2023 and 2024 were the highest-performing years for engagement.

Post-Pandemic Recovery: 2021 saw a massive 153% increase in user count compared to 2020.

2025 Decline: A sharp 44% drop in users occurred in 2025, likely driven by declining service quality in previous years.

Peak Months: High engagement is consistently observed from April to July, with June and July being the absolute peak.

2. Performance Leaders & Laggards
Top Cities: Dubai and Amsterdam lead with an average rating of 9.05.

Lowest Rated: Cairo and Lagos with an average rating of 8.7.

Top Hotels: The Golden Oasis, Canal House Grand, Marina Bay, The Bund Palace, and Maple Grove.

Bottom Hotels: Nile Grandor and The Savannah House.

3. Critical Drivers & Risks
Satisfaction Drivers: Cleanliness, Comfort, Location, and Staff quality are the primary boosters for high ratings.

Systemic Weakness: "Value for Money" and "Facilities" are the weakest dimensions across all segments.

Critical Threshold: Notably, no hotel in the dataset achieved a "Value for Money" rating of 9.0 or above.

🚀 How to Use
Database Setup: Create a database named hotel and import the provided CSV files (hotels.csv, users.csv, reviews.csv).

Execute Scripts: Run hospitality_sql_script.sql to clean the data and generate the analytical tables.

Review Findings: Refer to the Insights.docx (or a PDF version) for the detailed summary of business implications.

