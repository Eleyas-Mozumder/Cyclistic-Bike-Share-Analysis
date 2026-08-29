# Cyclistic Bike-Share User Behavior Analysis

## Project Overview

This project analyzes 12 months of Cyclistic bike-share trip data from **January to December 2025** to understand differences in usage patterns between annual members and casual riders.

The analysis was performed using **MySQL** for data cleaning and analysis and **Tableau** for data visualization and dashboard development.

---

## Business Questions

- How do member and casual riders differ in their usage patterns?
- Which rider type generates more rides?
- How does average ride duration differ between members and casual riders?
- When are bikes used most frequently?
- Which bike types are most popular among each rider group?
- How can Cyclistic increase membership among casual riders?

---

## Key Findings

- **5.44M total rides** were analyzed.
- **Members generated 3.51M rides**, compared with **1.93M casual rides**.
- Casual riders had a higher average ride duration: **19.88 minutes**, compared with **12.13 minutes** for members.
- Ride activity was strongest during the **summer months**.
- Casual riders showed stronger usage on **weekends**.
- Ride demand increased during **morning and evening peak hours**.
- **Electric bikes** showed strong usage among both rider groups.

---

## Recommendations

1. **Convert casual riders into members**  
   Target frequent casual riders with membership promotions and incentives.

2. **Focus on weekend usage**  
   Develop campaigns specifically for casual riders who frequently ride on weekends.

3. **Optimize peak-hour availability**  
   Ensure sufficient bike availability during morning and evening demand peaks.

4. **Promote electric bikes**  
   Highlight electric bikes and maintain sufficient availability based on their strong usage.

---

## Data & Methodology

### Dataset

The analysis uses 12 months of Cyclistic bike-share trip data covering:

**January 2025 – December 2025**

The dataset contains individual trip records including:

- Ride ID
- Bike type
- Start and end timestamps
- Start and end stations
- Start and end coordinates
- Rider type (member or casual)

### Data Preparation

The raw monthly datasets were combined and imported into MySQL.

The analysis followed these steps:

1. **Data validation**
   - Checked total record counts
   - Reviewed rider categories and bike types
   - Checked important fields for missing values
   - Identified invalid ride durations

2. **Data cleaning**
   - Converted timestamp fields to `DATETIME`
   - Removed rides shorter than 1 minute
   - Removed rides longer than 24 hours
   - Performed post-cleaning quality checks

3. **Data transformation**
   - Calculated ride duration in minutes
   - Created ride date
   - Extracted month
   - Extracted weekday
   - Extracted hour of day

4. **SQL analysis**
   - Compared member and casual riders
   - Analyzed monthly trends
   - Analyzed weekday patterns
   - Analyzed hourly demand
   - Compared bike type usage

5. **Visualization**
   - Created summary datasets from the SQL analysis
   - Built an interactive Tableau dashboard

---

## Project Workflow

```text
Raw Trip Data
      ↓
Data Validation & Cleaning
      ↓
Data Transformation
      ↓
MySQL Analysis
      ↓
Summary Datasets
      ↓
Tableau Visualization
      ↓
Insights & Recommendations
```

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| **MySQL** | Data cleaning, transformation and SQL analysis |
| **Tableau Public** | Data visualization and dashboard development |
| **Excel / CSV** | Data preparation and summary datasets |

---

## Tableau Dashboard

The interactive dashboard presents the main findings from the analysis, including rider type, ride duration, monthly patterns, weekday patterns, hourly usage and bike type usage.

### Interactive Dashboard

[View the interactive Tableau dashboard on Tableau Public](https://public.tableau.com/app/profile/eleyas.mozumder/viz/Book1_17876330302320/CyclisticBike-ShareUserBehaviorAnalysis)

### Dashboard Preview

![Cyclistic Bike-Share User Behavior Analysis](Screenshots/dashboard_overview.png)

---

## Repository Structure

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
│       ├── Cyclistic_Bike_Summary.csv
│       ├── Cyclistic_Hour_Summary.csv
│       ├── Cyclistic_Member_Summary.csv
│       ├── Cyclistic_Month_Summary.csv
│       ├── Cyclistic_Station_Summary.csv
│       └── Cyclistic_Weekday_Summary.csv
│
├── Tableau/
│   └── dashboard/
│       └── README.md
│
└── Screenshots/
    └── dashboard_overview.png
```

---
---

## Author

**Eleyas Mozumder**

M.Sc. Economics | Data Analytics

Interested in Data Analyst, Business Analyst and Business Intelligence roles.

[LinkedIn](https://www.linkedin.com/in/eleyas-mozumder-063179197/) · [GitHub](https://github.com/Eleyas-Mozumder)

## Conclusion

The analysis shows clear differences between member and casual rider behavior. Members generate more rides overall, while casual riders take longer trips and show stronger weekend usage. These patterns provide opportunities for targeted membership campaigns and improved bike availability during high-demand periods.
