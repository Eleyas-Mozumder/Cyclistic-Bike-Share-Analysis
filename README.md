# Cyclistic Bike-Share User Behavior Analysis

## Project Overview

This project analyzes 12 months of Cyclistic bike-share trip data from January to December 2025 to understand differences in usage patterns between annual members and casual riders.

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

- **3.51M member rides** compared with **1.93M casual rides**.
- Casual riders have a higher average ride duration: **19.88 minutes vs. 12.13 minutes** for members.
- Ride activity is highest during the **summer months**.
- Casual riders show stronger usage on **weekends**.
- Ride demand increases during **morning and evening peak hours**.
- **Electric bikes** have high usage among both rider groups.

---

## Recommendations

1. **Convert casual riders into members**  
   Target frequent casual riders with membership promotions and incentives.

2. **Focus on weekend usage**  
   Develop campaigns specifically targeting casual riders who ride on weekends.

3. **Optimize peak-hour availability**  
   Ensure sufficient bike availability during morning and evening demand peaks.

4. **Promote electric bikes**  
   Highlight electric bikes and maintain sufficient availability based on their strong usage.

---

## Project Workflow

```text
Raw Trip Data
      ↓
Data Cleaning & Transformation
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
| **MySQL** | Data cleaning, transformation and analysis |
| **Tableau Public** | Data visualization and dashboard development |
| **Excel / CSV** | Data preparation and summary datasets |

---

## Tableau Dashboard

View the interactive dashboard on Tableau Public:

**[Cyclistic Bike-Share User Behavior Analysis](https://public.tableau.com/app/profile/eleyas.mozumder/viz/Book1_17876330302320/CyclisticBike-ShareUserBehaviorAnalysis)**

### Dashboard Preview

![Cyclistic Bike-Share Dashboard](Screenshots/dashboard_overview.png)

---

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

## Conclusion

The analysis shows clear differences between member and casual rider behavior. Members generate more rides overall, while casual riders take longer trips and show stronger weekend usage. These patterns provide opportunities for targeted membership campaigns and improved bike availability during high-demand periods.
