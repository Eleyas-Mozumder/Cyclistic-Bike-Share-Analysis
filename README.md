# Cyclistic Bike-Share User Behavior Analysis

## Project Overview

This project analyzes 12 months of Cyclistic bike-share trip data from January to December 2025 to understand differences in usage patterns between annual members and casual riders.

The analysis was performed using **MySQL** for data cleaning and analysis and **Tableau** for interactive data visualization and dashboard development.

## Business Questions

- How do member and casual riders differ in their usage patterns?
- Which rider type generates more rides?
- How does average ride duration differ between members and casual riders?
- When are bikes used most frequently?
- Which bike types are most popular among each rider group?
- How can Cyclistic increase membership among casual riders?

## Key Findings

- Members generated **3.51M rides**, compared with **1.93M casual rides**.
- Casual riders had a longer average ride duration: **19.88 minutes** vs. **12.13 minutes** for members.
- Ride activity was highest during the summer months, particularly July–September.
- Casual riding activity was stronger on weekends, especially Saturday and Sunday.
- Ride demand increased strongly during morning and evening peak hours.
- Electric bikes showed high usage among both rider groups, particularly members.

## Recommendations

1. **Convert casual riders into members**  
   Use weekend and day-pass promotions combined with membership incentives.

2. **Target peak demand**  
   Ensure sufficient bike availability during morning and evening peak periods.

3. **Focus on weekend casual riders**  
   Develop targeted campaigns for casual riders who frequently ride on weekends.

4. **Promote electric bikes**  
   Increase availability and highlight the convenience of electric bikes.

## Tools & Technologies

- **MySQL** — Data cleaning, transformation and SQL analysis
- **Tableau Public** — Data visualization and dashboard development
- **Excel/CSV** — Data preparation and summary outputs

## Project Workflow

```text
Raw Trip Data
     ↓
Data Cleaning & Transformation
     ↓
MySQL Analysis
     ↓
Summary Tables
     ↓
Tableau Visualization
     ↓
Insights & Recommendations

```

## Tableau Dashboard

[View the interactive Tableau dashboard](https://public.tableau.com/app/profile/eleyas.mozumder/viz/Book1_17876330302320/CyclisticBike-ShareUserBehaviorAnalysis)

## Project Structure

```text
Cyclistic-Bike-Share-Analysis/
│
├── README.md
│
├── SQL/
│   └── cyclistic_analysis.sql
│
├── Data/
│   └── summary_files/
│       ├── member_summary.csv
│       ├── weekday_summary.csv
│       ├── hour_summary.csv
│       ├── month_summary.csv
│       ├── bike_summary.csv
│       └── station_summary.csv
│
├── Tableau/
│   └── README.md
│
└── Screenshots/
    ├── dashboard_overview.png
    └── insights_recommendations.png

```
## Conclusion

The analysis shows clear differences between member and casual rider behavior. Members generate more rides overall, while casual riders tend to take longer trips and show stronger weekend usage. These patterns provide opportunities for targeted membership campaigns and improved bike availability during periods of high demand.
