USE Project2;
SELECT * FROM hr_dataset;
-- See the type data from columns of dataset
EXEC sp_columns hr_dataset;

-- Change Type 'termdate' into date in new Column called 'NewCols'
ALTER TABLE hr_dataset
ADD NewCols date;

UPDATE hr_dataset
SET NewCols = CONVERT(DATETIME, LEFT(CONVERT(VARCHAR(MAX), termdate), 19), 120);

-- Drop 'termdate' column & Change 'NewCols' column name to termdate
ALTER TABLE hr_dataset
DROP COLUMN termdate;
EXEC sp_rename 'hr_dataset.NewCols', 'termdate', 'COLUMN';

-- Add 'age' column into data
ALTER TABLE hr_dataset ADD age INT;

UPDATE hr_dataset
SET age = DATEDIFF(YEAR, birthdate, GETDATE());

SELECT birthdate,age FROM hr_dataset;

-- See the youngest & oldest age from employee
SELECT
	MIN(age) AS youngest,
	MAX(age) AS oldest
FROM hr_dataset;