SELECT *
from Portfolio..carAnalysis

SELECT *
from Portfolio..carAnalysis
ORDER BY COEMISSIONS DESC

SELECT *
from Portfolio..carAnalysis
ORDER BY COEMISSIONS ASC

--Fuel efficiency based on vehicle class (compact, medium, etc.)
SELECT DISTINCT VEHICLE_CLASS
from Portfolio..carAnalysis

SELECT VEHICLE_CLASS, FORMAT(avg("FUEL CONSUMPTION"), 'N2') as AvgFuelPerVehicle
from Portfolio..carAnalysis
GROUP BY VEHICLE_CLASS

SELECT FUEL, CAST(ROUND(avg("FUEL CONSUMPTION"),2) AS DECIMAL(10,2)) as AvgFuelPerType
from Portfolio..carAnalysis
GROUP BY FUEL

--Difference in CO2 emissions between vehicles of different classes (compact, medium, etc.)
SELECT VEHICLE_CLASS, FORMAT(avg(COEMISSIONS), 'N2') as AvgCO2Emissions
from Portfolio..carAnalysis
GROUP BY VEHICLE_CLASS

SELECT FUEL, FORMAT(avg(COEMISSIONS), 'N2') as AvgCO2Emissions
from Portfolio..carAnalysis
GROUP BY FUEL

SELECT MAKE, FORMAT(avg(COEMISSIONS), 'N2') as AvgCO2Emissions
from Portfolio..carAnalysis
GROUP BY MAKE
ORDER BY AvgCO2Emissions DESC

SELECT MODEL, FORMAT(avg(COEMISSIONS), 'N2') as AvgCO2Emissions
from Portfolio..carAnalysis
GROUP BY MODEL
ORDER BY AvgCO2Emissions DESC

SELECT MAKE, MODEL, FORMAT(AvgCO2Emissions, 'N2') as AvgCO2Emissions
FROM (
    SELECT MAKE, MODEL, AVG(COEMISSIONS) AS AvgCO2Emissions
    FROM Portfolio..carAnalysis
    GROUP BY MAKE, MODEL
) AS AvgCO2
WHERE AvgCO2Emissions = (
    SELECT MAX(AvgCO2Emissions)
    FROM (
        SELECT MAKE, MODEL, AVG(COEMISSIONS) AS AvgCO2Emissions
        FROM Portfolio..carAnalysis
        GROUP BY MAKE, MODEL
    ) AS SubQuery
    WHERE SubQuery.MAKE = AvgCO2.MAKE
)
ORDER BY AvgCO2Emissions DESC;


--How are engine size and number of cylinders related to CO2 emissions?
SELECT "ENGINE SIZE", CYLINDERS, FORMAT(avg(COEMISSIONS), 'N2') as AvgCOPerEsc
from Portfolio..carAnalysis
GROUP BY "ENGINE SIZE", CYLINDERS;

--ENGINE SIZE vs CYLINDERS with highest CO2 emission
WITH EmissionsRank AS (
    SELECT
        "ENGINE SIZE",
        CYLINDERS,
        COEMISSIONS,
        ROW_NUMBER() OVER (PARTITION BY CYLINDERS ORDER BY COEMISSIONS DESC) AS Rank
    FROM Portfolio..carAnalysis
    WHERE CYLINDERS IN (3, 4, 5, 6, 8, 10, 12)
)
SELECT
    "ENGINE SIZE",
    CYLINDERS,
    COEMISSIONS
FROM EmissionsRank
WHERE Rank = 1;



