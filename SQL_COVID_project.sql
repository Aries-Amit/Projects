/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

 -- Select the data from where the project is started.

SELECT location,
		date,
		total_cases,
		new_cases,
		total_deaths,
		population
FROM CovidDeaths
ORDER BY location, date


-- 1. Total deaths vs total cases(likelihood of dying of COVID infection)

SELECT location,
		date,
		total_cases,
		total_deaths,
		(total_deaths / total_cases) * 100 AS Death_Rate
FROM CovidDeaths
WHERE continent IS NOT NULL
--WHERE location = 'india'
ORDER BY location, date;


-- 2. Total cases vs population(Part of population that got the COVID infection)

SELECT location,
		date,
		total_cases,
		population,
		(total_cases / population) * 100 AS Diagnose_Rate
FROM CovidDeaths
WHERE continent IS NOT NULL
--WHERE location = 'india'
ORDER BY location, date


-- 3. Countries with highest Diagnose Rate vs Population

SELECT location,
		population,
		MAX(total_cases) AS Max_Infections,
		MAX((total_cases / population)) * 100 AS Max_Diagnose_Rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
	--HAVING location = 'india'
ORDER BY Max_Diagnose_Rate DESC


-- 4. Highest Death count per Population in each country

SELECT location,
--		MAX((total_deaths / population)) * 100 AS Death_Rate
		MAX(CAST(total_deaths AS INT)) AS Max_Death_Count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Max_Death_Count DESC


-- BREAKING DOWN USING CONTINENT

-- 1. Highest Death count per Population in each continent

SELECT continent,
--		MAX((total_deaths / population)) * 100 AS Death_Rate
		MAX(CAST(total_deaths AS INT)) AS Max_Death_Count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Max_Death_Count DESC

  
-- GLOBAL NUMBERS

-- 1. Daily cases vs deaths all over the world

SELECT date,
		SUM(new_cases) AS Total_Cases,
		SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
		(SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS Global_Death_Rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
--WHERE location = 'india'
ORDER BY date, Total_Cases;


-- 2. Total Cases all over the world

SELECT
		SUM(new_cases) AS Total_Cases,
		SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
		(SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS Global_Death_Rate
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY Total_Cases, Total_Deaths


-- 3.  Vaccinations vs Total population (Tells us the number of people who recieved atleast one dose of vaccination)

SELECT dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
ORDER BY dea.location, dea.date

-- 4. Rolling Vaccination per day vs Population

SELECT dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
		AS RollingVaccinationCount
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date


-- 5. Population vs rolling vaccination count

--5-a. USING CTE

WITH POPvsROLL (Continent, location, date, population, NewVaccinations, RollingVaccinatedPeople)
AS
(
SELECT dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(CONVERT(int, new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
		AS RollingVaccinationCount
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY dea.location, dea.date
)
SELECT *,
	(RollingVaccinatedPeople / population) * 100 AS RollingVaccinationRate
FROM POPvsROLL
ORDER BY location, date


-- 5-b. USING A TEMP TABLE

DROP TABLE IF EXISTS #Vaccinated
CREATE TABLE #Vaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	population numeric,
	newVaccinations numeric,
	RollingVaccinatedPeople numeric
)

INSERT INTO #Vaccinated
SELECT dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(CAST(new_vaccinations AS numeric)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
		RollingVaccinationRate
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *,
		(RollingVaccinatedPeople / population) * 100 AS RollingVaccinationRate
FROM #Vaccinated
order by Location, Date


-- 6. Countries with their maximum Vaccination rate vs population

SELECT Location,
		MAX(RollingVaccinatedPeople) AS TotalVaccinations,
		MAX(population) AS Population,
		(MAX(RollingVaccinatedPeople) / MAX(population)) * 100 AS MAX_RollingVaccinationRate
FROM #Vaccinated
GROUP BY Location
order by MAX_RollingVaccinationRate DESC


-- 7. Creating a view to store data for further process or visualizations

CREATE VIEW PercentPublicVaccinated AS
SELECT dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS 
		RollingVaccinationRate
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.location


--------------------------------------

DROP TABLE IF EXISTS Vaccinated
CREATE TABLE Vaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	population numeric,
	newVaccinations numeric,
	RollingVaccinatedPeople numeric
)

INSERT INTO Vaccinated
SELECT dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(CAST(new_vaccinations AS numeric)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
		RollingVaccinationRate
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


CREATE VIEW MAXVaccinations AS
SELECT Location,
		MAX(RollingVaccinatedPeople) AS TotalVaccinations,
		MAX(population) AS Population,
		(MAX(RollingVaccinatedPeople) / MAX(population)) * 100 AS MAX_RollingVaccinationRate
FROM Vaccinated
GROUP BY Location
--order by MAX_RollingVaccinationRate DESC