/*

Cleaning Data Using SQL queries

*/

-- Loading the data

SELECT * 
FROM NashvilleHouseData

-- 1. Standardize "SaleDate" Column

SELECT SaleDate, CONVERT(DATE, SaleDate) 
FROM NashvilleHouseData

ALTER TABLE NashvilleHouseData
ADD SaleDateConverted DATE;

UPDATE NashvilleHouseData
SET SaleDateConverted = CONVERT(DATE, SaleDate)

-----------------------------------------------------------------------

-- 2.Populate the 'PropertyAddress' column 

SELECT count(*) AS NullValues
FROM NashvilleHouseData
WHERE PropertyAddress IS NULL;



SELECT 
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress, b.PropertyAddress) AS Address
FROM NashvilleHouseData a
JOIN NashvilleHouseData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHouseData a
JOIN NashvilleHouseData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

---------------------------------------------------------------------------------------

-- 3. Breaking the 'Address' into individual columns (address, city, state)

-- 3-a. 'PropertyAddress'

SELECT PropertyAddress
FROM NashvilleHouseData


SELECT 
	PropertyAddress,
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM NashvilleHouseData


ALTER TABLE NashvilleHouseData
ADD PropertySplitAddress nvarchar(255)

ALTER TABLE NashvilleHouseData
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHouseData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

UPDATE NashvilleHouseData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


-- 3-b. Owner Addres

SELECT OwnerAddress
FROM NashvilleHouseData


SELECT 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address
FROM NashvilleHouseData


ALTER TABLE NashvilleHouseData
ADD OwnerSplitAddress nvarchar(255)

ALTER TABLE NashvilleHouseData
ADD OwnerSplitCity nvarchar(255)

ALTER TABLE NashvilleHouseData
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHouseData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE NashvilleHouseData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE NashvilleHouseData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM NashvilleHouseData


---------------------------------------------------------------------------------------

-- 4. Change Y and N to Yes and No in 'SoldAsVacant' column

SELECT DISTINCT(SoldAsVacant)
FROM NashvilleHouseData


SELECT 
	DISTINCT(SoldAsVacant),
	COUNT(SoldAsVacant) AS Value_Count
FROM NashvilleHouseData
GROUP BY SoldAsVacant
ORDER BY Value_Count DESC



UPDATE NashvilleHouseData
SET SoldAsVacant = CASE
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
				   END


SELECT 
	DISTINCT(SoldAsVacant),
	COUNT(SoldAsVacant) AS Value_Count
FROM NashvilleHouseData
GROUP BY SoldAsVacant
ORDER BY Value_Count DESC

-------------------------------------------------------------------------------------


-- 5. Find duplicates in the data

WITH ROW_CTE AS (
SELECT *,
		ROW_NUMBER() OVER  (PARTITION BY ParcelID,
										PropertyAddress,
										SaleDateConverted,
										LegalReference,
										SalePrice
										ORDER BY UniqueID) AS row_num
FROM NashvilleHouseData
)SELECT *
FROM ROW_CTE
WHERE row_num > 1

/*
 Deleting the duplicates if needed
(since it is not a good practice to delete information from the raw date loaded into the database)
*/

WITH ROW_CTE AS (
SELECT *,
		ROW_NUMBER() OVER  (PARTITION BY ParcelID,
										PropertyAddress,
										SaleDateConverted,
										LegalReference,
										SalePrice
										ORDER BY UniqueID) AS row_num
FROM NashvilleHouseData
)DELETE
FROM ROW_CTE
WHERE row_num > 1


-- 5. Removing unnecessary columns

ALTER TABLE NashvilleHouseData
DROP COLUMN SaleDate,
			PropertyAddress,
			OwnerAddress


SELECT * 
FROM NashvilleHouseData


