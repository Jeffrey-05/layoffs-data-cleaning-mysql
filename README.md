# layoffs-data-cleaning-mysql
Data cleaning and analysis of layoffs dataset using MySQL

Technologies Used:
MySQL – For data cleaning and querying
MySQL Workbench – For database management and query execution

Data Cleaning Steps:

1️.Created a Staging Table – Duplicated the original table (layoffs) into layoffs_staging for safe modifications.

2️.Removed Duplicates – Used CTEs with ROW_NUMBER() to find and delete duplicate records.

3️.Standardized Data – Trimmed spaces, corrected industry names, and cleaned country names.

4️.Formatted Dates – Converted text-based dates to proper DATE format using STR_TO_DATE().

5️.Handled NULL & Blank Values – Filled missing values using JOINs and set empty fields to NULL.

6️.Removed Unnecessary Rows – Deleted records where both total_laid_off and percentage_laid_off were NULL.
