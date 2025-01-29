-- Data cleaning-- 

-- 1.Remove Duplicates
-- 2.Standardize the Data
-- 3.Null Values and Blank Values
-- 4.Remove Any unnecessory Columns

--creating duplicate table
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_staging;

--1.Remove Duplicates
-- assigning row number to duplicate rows
SELECT *,  
ROW_NUMBER() OVER (  
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions  
) AS row_num  
FROM layoffs_staging;

-- To check the rows with rank greater than 1
WITH duplicate_cte AS (  
    SELECT *,  
    ROW_NUMBER() OVER (  
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions  
    ) AS row_num  
    FROM layoffs_staging  
)  
SELECT *  
FROM duplicate_cte  
WHERE row_num > 1;

-- We can see the duplicate rows but cant delete them directly so create table 3 using adding row_num column
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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inerting data into new table
INSERT INTO layoffs_staging2  
SELECT *,  
ROW_NUMBER() OVER (  
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions  
) AS row_num  
FROM layoffs_staging;

-- deleting duplicate rows 
DELETE 
FROM layoffs_staging2
where row_num > 1;

--2.Standardizing data
-- To check whether there are extra spaces
SELECT company, TRIM(company)
FROM layoffs_staging2;

-- to Remove dextra spaces from company column
UPDATE layoffs_staging2
SET company = TRIM(company);

-- to check any inconsistencies in industry
SELECT DISTINCT industry
FROM layoffs_staging2;

-- to check which value is appearing mostly
SELECT * 
FROM layoffs_staging2
where industry LIKE 'crypto%';

-- Standardizing all values same
UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

-- to check country column
SELECT DISTINCT country
FROM layoffs_staging;

-- detecting extra charaters from end
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

-- Extra character removed
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United Staes%';

-- the date was in text format 
SELECT `date`
FROM layoffs_staging2;

-- Converting date in date format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Modifying table 
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3.Null Values and Blank Values
SELECT *
FROM layoffs_staging2
where industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2
WHERE company = "Bally's Interactive";

SELECT *
FROM layoffs_staging2
WHERE company = 'Carvana';

SELECT *
FROM layoffs_staging2
WHERE company = 'Juul';

-- Populating blank values

-- to check  which value is corresponding
SELECT *  
FROM layoffs_staging2 AS t1  
JOIN layoffs_staging2 AS t2  
    ON t1.company = t2.company  
    AND t1.location = t2.location  
WHERE t1.industry IS NULL OR t1.industry = ''  
AND t2.industry IS NOT NULL;


-- Before populating changing all blank values to null
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populating Values
UPDATE layoffs_staging2 t1  
JOIN layoffs_staging2 t2  
    ON t1.company = t2.company  
SET t1.industry = t2.industry  
WHERE t1.industry IS NULL  
AND t2.industry IS NOT NULL;

--4.Removing columns and rows
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Removed unnecessory column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final clean dataset
SELECT * 
FROM layoffs_staging2








