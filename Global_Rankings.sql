/* Global Rankings Data Exploration
Skills Used: Aggregate Functions, Case Statements, Joins, Creating Views
*/

USE project;

-- Select initial data to start with

Select * FROM global_data
WHERE GDPDollars AND MilitarySpendingDollars IS NOT NULL
ORDER BY 1,2;

-- Shows most populous countries to least populous

SELECT CountryName,Population
FROM global_data
WHERE Population IS NOT NULL
ORDER BY population desc;

-- Select sum of entire world economy

SELECT SUM(GDPDollars) AS 'World_Economy' 
FROM global_data
WHERE CountryName NOT LIKE 'European Union';

-- Select GDP per capita average of all countries

SELECT AVG(GDPPerCapita)
FROM global_data
WHERE CountryName NOT LIKE('European Union');

-- Divide countries into high GDP per capita vs lower GDP per capita

SELECT 
CASE
    WHEN GDPPerCapita > 20000 THEN 'Higher standard of living'
    WHEN GDPPerCapita < 20000 THEN 'Lower standard of living'
END AS livingstandards,CountryName,GDPPerCapita
FROM global_data;

-- Shows GDP of five major global power in order from highest to lowest GDP

Select CountryName,GDPDollars 
FROM global_data
WHERE CountryName IN('United States','China','Japan','India','European Union')
Order BY GDPDollars DESC;

-- Shows military spending of five major world powers in order from greatest to least spending

SELECT CountryName,MilitarySpendingDollars
FROM global_data
WHERE CountryName IN ('United States','European Union','China','India','Japan')
ORDER BY MilitarySpendingDollars DESC;

-- Joins global_data and global_co2 tables

SELECT global_data.CountryName,global_data.GDPPerCapita,global_data.Population,global_co2.CO2_KT
FROM global_data
Inner JOIN global_co2
ON global_data.CountryName= global_co2.CountryName;

-- Creating view for more data visualization
-- Orders Countries from most carbon emmissions to least

CREATE VIEW PollutionPerCapita as
SELECT global_data.CountryName,global_data.GDPPerCapita,global_data.Population,global_co2.CO2_KT
,SUM((global_co2.CO2_KT/global_data.Population)*100) OVER(PARTITION BY global_co2.CountryName)
AS PollutionQuotient
FROM global_data
Inner JOIN global_co2
ON global_data.CountryName= global_co2.CountryName
WHERE CO2_KT IS NOT NULL
ORDER BY PollutionQuotient DESC;
