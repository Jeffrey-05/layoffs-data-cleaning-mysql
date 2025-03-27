-- DATA CLEANING

SELECT *
FROM layoffs;

-- 1.REMOVE DUPLICATES
-- 2.STANDARTIZE DUPLICATES
-- 3.REMOVE NULL AND DUPLICATES VALUES
-- 4.REMOVE ANY COLUMNS OR ROWS

CREATE TABLE layoffs_staging
AS 
SELECT*
FROM layoffs;


WITH dupicate_cte AS (
    SELECT *,
	ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM dupicate_cte 
WHERE row_num > 1;

-- CREATE TABLE LAYOFF_STAGING2

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
	ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
    FROM layoffs_staging;
    
    
-- REMOVING DIPLICATES FORM THE TABLE

SELECT *
FROM layoffs_staging2
WHERE row_num >1;

DELETE
FROM layoffs_staging2
WHERE row_num >1;

-- STANDARDIZING DATA

SELECT company,trim(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT country,trim(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = trim(TRAILING '.' FROM country)
WHERE country LIKE 'United St%';


SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') AS converted_date 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- CHANGING BLANK AND NULL VALUE

SELECT industry
from layoffs_staging2
where industry IS NULL;


SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
WHERE (t1.industry IS NULL OR t1.industry = '') 
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2
set industry = NULL
WHERE industry ='';


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL  
AND t2.industry IS NOT NULL;

-- DELETING BOTH TOTAL LAID OFF AND PERCENTAGE LAID OFF IS NULL

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;