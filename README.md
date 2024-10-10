# SQL_Data_Cleaning_Layoffs

The Most Crucial Step in Data Analysis: Data Cleaning! Without it, you'll never uncover the true insights hidden in your dataset. Recently, I completed a data cleaning project in MySQL on a dataset covering layoffs, and it reminded me just how vital this phase is for any analysis.

Situation: I was tasked with preparing a dataset on company layoffs, but the raw data was riddled with duplicates, inconsistencies, and missing values—challenges that could skew any meaningful insights.

Task: My objective was to clean the dataset and ensure its accuracy, so that we could proceed with a reliable analysis of layoff patterns. The goal was to standardize, clean, and make the data analysis-ready without altering the integrity of the original data.

Action: I began by importing the raw CSV file into MySQL and immediately duplicated it to safeguard against any potential mistakes. Then, I systematically tackled the key issues:
A) Duplicates Removal: Using the row number function, I identified and flagged duplicate rows that lacked a unique identifier, allowing me to clean the dataset safely.
B) Standardization: I standardized columns like "Company" (removing extra spaces), "Industry," and "Country" by utilizing the Trim function and setting values uniformly. The date column, 
   which was in text format, was converted to the appropriate date format using STR_TO_DATE().
C) Handling Nulls: Missing values in the "Industry" column were populated by self-joining based on company and location, while blank values were replaced with NULL for better consistency.
D) Irrelevant Data Removal: I filtered out rows where both "Percentage Laid Off" and "Total Laid Off" were missing since these rows wouldn't contribute to the analysis.
E) Final Touch: I dropped any unnecessary columns like row_num to keep the dataset clean and focused.

Result: The result was a clean, standardized dataset ready for deep analysis. This process ensured that the insights derived from it—such as layoff trends, regional impact, and industry-specific data—were accurate and trustworthy.

Key Takeaway: Data cleaning is often overlooked, but it’s the backbone of any robust analysis. My work on this project helped me appreciate how meticulous cleaning opens the doors to meaningful insights. Looking forward to applying these techniques to new challenges!
