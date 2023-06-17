
--exploring the whole table
SELECT *
FROM NashvilleHousing


--standardize date format
SELECT CONVERT(Date,SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)

SELECT *
FROM NashvilleHousing


--populate property address data
SELECT TOP 10 *
FROM NashvilleHousing
--where PropertyAddress IS NULL
ORDER BY ParcelID

SELECT n1.ParcelID,n1.PropertyAddress,n2.ParcelID,n2.PropertyAddress,IS NULL (n1.PropertyAddress,n2.PropertyAddress)
FROM NashvilleHousing n1
JOIN NashvilleHousing n2
ON n1.ParcelID = n2.ParcelID
AND n1.[UniqueID ] != n2.[UniqueID ]
WHERE n1.PropertyAddress IS NULL


UPDATE n1
SET PropertyAddress = ISNULL(n1.PropertyAddress,n2.PropertyAddress)
FROM NashvilleHousing n1
JOIN NashvilleHousing n2
ON n1.ParcelID = n2.ParcelID
AND n1.[UniqueID ] != n2.[UniqueID ]
WHERE n1.PropertyAddress IS NULL



--breaking out address into separated columns(address,city,state)
SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)address,PropertyAddress,
       SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


--breaking out OwnerAddress into separated columns(address,city,state)
SELECT TOP 5 OwnerAddress
FROM NashvilleHousing
WHERE OwnerAddress IS NOT NULL 


SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3) address,
       PARSENAME(REPLACE(OwnerAddress,',','.'),2) city,
	   PARSENAME(REPLACE(OwnerAddress,',','.'),1) state
FROM NashvilleHousing
WHERE OwnerAddress IS NOT NULL 


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)



ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),2)



ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



--Change 'Y' AND 'N' to 'YES' AND 'NO' in SoldAsVacant column

SELECT  DISTINCT SoldAsVacant,COUNT(*)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(*) DESC


SELECT SoldAsVacant,
        CASE WHEN SoldAsVacant = 'N' THEN 'No'
             WHEN SoldAsVacant = 'Y' THEN 'Yes'
			 ELSE SoldAsVacant
			 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'No'
                        WHEN SoldAsVacant = 'Y' THEN 'Yes'
			            ELSE SoldAsVacant
			            END





--Delete not needed columns 

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate


SELECT *
FROM NashvilleHousing










