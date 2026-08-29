# Tableau Dashboard

Interactive Tableau dashboard for the Cyclistic Bike-Share User Behavior Analysis.

## Dashboard

The dashboard analyzes:

- Member vs. casual rider behavior
- Total rides
- Average ride duration
- Monthly ride patterns
- Weekly ride patterns
- Hourly ride patterns
- Bike type usage

## Tableau Public

[View the interactive Tableau dashboard](https://public.tableau.com/app/profile/eleyas.mozumder/viz/Book1_17876330302320/CyclisticBike-ShareUserBehaviorAnalysis)

## Key Insights

- Members generated 3.51M rides, compared with 1.93M casual rides.
- Casual riders had a higher average ride duration: 19.88 minutes vs. 12.13 minutes for members.
- Ride activity was highest during the summer months.
- Casual riders showed stronger weekend usage.
- Ride demand increased during morning and evening peak hours.
- Electric bikes were highly used by both rider groups.

## Recommendations

- Target casual riders with membership promotions.
- Focus campaigns on frequent weekend casual riders.
- Maintain sufficient bike availability during peak hours.
- Promote electric bikes based on their strong usage.
---

## Tableau Dashboard

The interactive Tableau dashboard provides an overview of rider behavior, including:

- Total rides by rider type
- Average ride duration
- Monthly ride trends
- Weekly ride patterns
- Hourly ride patterns
- Bike type usage

---

## Data & Methodology

### Dataset

The analysis uses 12 months of Cyclistic bike-share trip data covering:

**January 2025 – December 2025**

The dataset contains individual bike trip records, including:

- Ride ID
- Bike type
- Start and end timestamps
- Start and end stations
- Start and end coordinates
- Rider type (member or casual)

### Data Preparation

The raw monthly datasets were combined and imported into MySQL for processing.

The analysis followed these steps:

1. **Data validation**
   - Checked total record counts
   - Reviewed rider categories and bike types
   - Checked important fields for missing values
   - Identified invalid ride durations

2. **Data cleaning**
   - Converted timestamp fields from text to `DATETIME`
   - Removed rides shorter than 1 minute
   - Removed rides longer than 24 hours
   - Checked data quality after cleaning

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
   - Built an interactive Tableau dashboard to communicate the findings
### Interactive Dashboard

[View the interactive Tableau dashboard](https://public.tableau.com/app/profile/eleyas.mozumder/viz/Book1_17876330302320/CyclisticBike-ShareUserBehaviorAnalysis)

### Dashboard Preview

![Cyclistic Dashboard](Screenshots/dashboard_overview.png)
