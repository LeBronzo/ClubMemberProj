---------------- Data Cleaning Project in SQL ----------------

SELECT *
FROM club_member_info$

-- Creating a unique id for each row and removing duplicate rows

WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY email ORDER BY full_name) as id
FROM club_member_info$
)

DELETE
FROM RowNumCTE
WHERE id > 1

ALTER TABLE club_member_info$
ADD id int identity(1,1)

-- Removing special characters and ensuring all entries of "full_name" are lowercase (except first letter) and free of whitespace

SELECT full_name, replace(full_name, '?', '')
FROM club_member_info$

SELECT full_name, LTRIM(replace(full_name, '?', ''))
FROM club_member_info$

ALTER TABLE club_member_info$
Add toSplitName nvarchar(255);

Update club_member_info$
SET toSplitName = LTRIM(replace(full_name, '?', ''))

-- Separate "full_name" into "first_name" and "last_name"

SELECT toSplitName, SUBSTRING(toSplitName, 1, CHARINDEX(' ', toSplitName)-1), SUBSTRING(toSplitName, CHARINDEX(' ', toSplitName)+1, LEN(toSplitName))
FROM club_member_info$

ALTER TABLE club_member_info$
Add first_name nvarchar(255);

Update club_member_info$
SET first_name = SUBSTRING(toSplitName, 1, CHARINDEX(' ', toSplitName)-1)

ALTER TABLE club_member_info$
Add last_name nvarchar(255);

Update club_member_info$
SET last_name = SUBSTRING(toSplitName, CHARINDEX(' ', toSplitName)+1, LEN(toSplitName))

SELECT first_name, UPPER(LEFT(first_name,1))+LOWER(SUBSTRING(first_name,2,LEN(first_name))) 
FROM club_member_info$

Update club_member_info$
SET first_name = UPPER(LEFT(first_name,1))+LOWER(SUBSTRING(first_name,2,LEN(first_name)))

Update club_member_info$
SET last_name = UPPER(LEFT(last_name,1))+LOWER(SUBSTRING(last_name,2,LEN(last_name)))

SELECT toSplitName, first_name, last_name
FROM club_member_info$

-- Ensuring correct age is displayed

SELECT age, LEFT(age, 2) as correct_age
FROM club_member_info$

-- Breaking out Address into Individual columns (Address, City, State)

SELECT full_address, SUBSTRING(full_address, 1, CHARINDEX(',', full_address)-1) as address, SUBSTRING(full_address, CHARINDEX(',', full_address)+1, LEN(full_address)) as restofaddress
FROM club_member_info$

ALTER TABLE club_member_info$
Add split_address nvarchar(255);

Update club_member_info$
SET split_address = SUBSTRING(full_address, 1, CHARINDEX(',', full_address)-1)

SELECT SUBSTRING(full_address, CHARINDEX(',', full_address)+1, LEN(full_address)) as restofaddress
FROM club_member_info$

ALTER TABLE club_member_info$
Add split_city nvarchar(255);

Update club_member_info$
SET split_city = SUBSTRING(SUBSTRING(full_address, CHARINDEX(',', full_address)+1, LEN(full_address)), 1, CHARINDEX(',', SUBSTRING(full_address, CHARINDEX(',', full_address)+1, LEN(full_address)))-1)

ALTER TABLE club_member_info$
Add split_state nvarchar(255);

Update club_member_info$
SET split_state = SUBSTRING(SUBSTRING(full_address, CHARINDEX(',', full_address)+1, LEN(full_address)), CHARINDEX(',', SUBSTRING(full_address, CHARINDEX(',', full_address)+1, LEN(full_address)))+1, LEN(SUBSTRING(full_address, CHARINDEX(',', full_address)+1, LEN(full_address))))

----------------- Note: all columns that were changed or created as temp columns were kept to show progress :) -----------------
