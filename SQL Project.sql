SELECT *
FROM PortfolioProject..CovidDeaths
Order by 3,4

SELECT *
FROM PortfolioProject..Covidvaccine
Order by 3,4

SELECT location, date, population, total_cases, total_deaths, new_cases
FROM PortfolioProject..CovidDeaths
Order by 1,4

ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_deaths float;

ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_cases float;

ALTER TABLE dbo.CovidDeaths
ALTER COLUMN population bigint;

SELECT location, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases,0))* 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location like '%Nigeria%'
Order by 1,2

SELECT location, date, total_cases, population, (total_cases/population)* 100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
Where location like '%Nigeria%'
Order by 1,2

SELECT location, MAX(total_cases) as HighestInfectionCount, population, MAX(total_cases/NULLIF (population,0))* 100 as PopulationInfectedPercentage
FROM PortfolioProject..CovidDeaths
Group by location, population
Order by 4 desc

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Group by location
Order by TotalDeathCount desc

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Group by continent 
Order by TotalDeathCount desc

ALTER Table PortfolioProject..CovidDeaths
ALTER column new_cases int;

ALTER Table PortfolioProject..CovidDeaths
ALTER column new_deaths int;

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Order by 1,2


DROP Table if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent varchar(50),
location varchar(50),
date datetime, 
population bigint,
new_vaccinations varchar(50),
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
  dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..Covidvaccine vac
	on dea.location = vac.location
	and dea.date = vac.date
--ORDER BY 2,3

Select *, (RollingPeopleVaccinated/NULLIF(population,0))*100
FROM #PercentPopulationVaccinated


CREATE View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
  dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..Covidvaccine vac
	on dea.location = vac.location
	and dea.date = vac.date

SELECT *
FROM PercentPopulationVaccinated