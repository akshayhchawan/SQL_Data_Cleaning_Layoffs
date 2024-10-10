-- Data cleaning-- 

-- Remove Duplicates
-- Standardize the Data
-- Null Values and Blank Values
-- Remove Any Columns


-- Creating Staging means creating duplicate table
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_staging;

-- Remove Duplicates

-- Using row number we are finding duplicate rows
select * , 
ROW_NUMBER() OVER(
PARTITION BY Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging;

-- To filter out rows with more than rows 1 row number
WITH duplicate_cte as
(
select *, 
ROW_NUMBER() OVER(
PARTITION BY Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging
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


SELECT *
FROM layoffs_staging2;

-- Inerting data into new table
INSERT INTO layoffs_staging2
select * , 
ROW_NUMBER() OVER(
PARTITION BY Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging;

SELECT *
FROM layoffs_staging2 
where row_num > 1;

-- deleting duplicate rows 
DELETE 
FROM layoffs_staging2
where row_num > 1;

-- Standardizing data

SELECT company, TRIM(company)
FROM layoffs_staging2;

-- Remove dextra spaces from company column
UPDATE layoffs_staging2
SET company = TRIM(company);

-- for checking if any issue
SELECT DISTINCT industry
FROM layoffs_staging2;

-- for checking the what value is maximum 
SELECT * 
FROM layoffs_staging2
where industry LIKE 'crypto%';

-- Standardizing all values same
UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

-- Checking country column
SELECT DISTINCT country
FROM layoffs_staging;

-- technique for removing extra charaters from end
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


-- Null Values and Blank Values
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

-- Finding which value is corresponding
SELECT *
FROM layoffs_staging2 AS t1
join layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL OR t1.industry = ''
AND t2.industry IS NOT NULL;

-- Before populating changing all blank values to null
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN  layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- Removing columns and rows
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

SELECT * 
FROM layoffs_staging2








