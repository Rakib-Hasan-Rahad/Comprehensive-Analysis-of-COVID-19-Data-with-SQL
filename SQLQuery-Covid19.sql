Select *
From [SQL project -1 ]..CovidDeaths$
Order by 3,4

Select *
From [SQL project -1 ]..CovidVaccinations$
Order by 3,4
--First i will select data that i will be using
Select Location, date, total_cases, new_cases, total_deaths, population
From [SQL project -1 ]..CovidDeaths$
order by 1,2
--Total Cases vs Total Deaths in Bangladesh
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [SQL project -1 ]..CovidDeaths$
WHERE location = 'Bangladesh'
ORDER BY 5 DESC
--Total Cases vs Population
SELECT Location, date, population, total_cases, total_deaths, (total_cases/population)*100 AS CovidDetectionPercentage
FROM [SQL project -1 ]..CovidDeaths$
WHERE location = 'Bangladesh'
ORDER BY 2,3
--Countries with Highest Infection Rate compared to Population
SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 AS Highest_Detection_Percentage
FROM [SQL project -1 ]..CovidDeaths$
Where continent is not NULL
Group by Location, population
ORDER BY Highest_Detection_Percentage desc
/*
The error message you're encountering, Msg 8120, Level 16, State 1, Line 23, indicates an issue common in SQL queries that involve aggregate functions (like SUM(), COUNT(), AVG(), etc.) without properly using a GROUP BY clause for non-aggregated columns. This error means you're trying to select a column (location in this case) alongside aggregated data, but SQL doesn't know how to display this column since it could potentially represent multiple value
*/
--Must take a look at data types from column

--By Cotinent
Select location, MAX(cast(total_deaths as int)) As TotalDeaths
From [SQL project -1 ]..CovidDeaths$
Where continent is NUll
group by location

--Showing total cases , total deaths and Death percentage globally
Select SUM(new_cases) as Total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
From [SQL project -1 ]..CovidDeaths$
where continent is not null
order by 1,2


-- I want to look at date wise total population vs vaccination 
--First we need to join the tables
Select dea.location,dea.date,dea.population,vac.new_vaccinations
From [SQL project -1 ]..CovidDeaths$ dea
Join [SQL project -1 ]..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 1,2

--- Lets find out total vaccination compare to population
Select dea.location,dea.population,SUM(Convert (int,vac.new_vaccinations)) as Total_Vaccination
From [SQL project -1 ]..CovidDeaths$ dea
Join [SQL project -1 ]..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
Group by dea.location,dea.population
order by 1,2
----Lets practice CTE
WITH PopVsVac AS
(
    SELECT
        dea.location,
        dea.population,
        SUM(CONVERT(INT, vac.new_vaccinations)) AS Total_Vaccination
    FROM [SQL project -1]..CovidDeaths$ dea
    JOIN [SQL project -1]..CovidVaccinations$ vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    GROUP BY dea.location, dea.population
)
SELECT *
FROM PopVsVac
ORDER BY location, population; 


----Practice Temp Table
-- If the temp table exists, drop it to avoid errors
DROP TABLE IF EXISTS #PercentPopulationVaccinated;

-- Create the temp table with the specified structure
CREATE TABLE #PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric
);

-- Insert data into the temp table from a join between CovidDeaths$ and CovidVaccinations$
-- Adjust the database name if necessary, ensuring it matches your environment
INSERT INTO #PercentPopulationVaccinated (Continent, Location, Date, Population, New_vaccinations)
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations
FROM 
    [SQL project -1]..CovidDeaths$ dea
    JOIN [SQL project -1]..CovidVaccinations$ vac
        ON dea.location = vac.location
        AND dea.date = vac.date;


-- Select everything from the temp table and order by Continent and Location
SELECT *
FROM #PercentPopulationVaccinated
ORDER BY Continent, Location;


