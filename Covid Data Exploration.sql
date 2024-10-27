SELECT * 
FROM PortfolioProject..CovidDeaths$
where continent is not null
Order by 3, 4

-- Select Data that are going to be used

Select Location, date, total_cases, new_cases, total_deaths, population
 From PortfolioProject.dbo.CovidDeaths$
 where continent is not null
 Order by 1, 2

-- Total Cases vs Total Deaths
Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
 From PortfolioProject.dbo.CovidDeaths$
 Where location like '%india%'
 Order by 1, 2

 -- Total Cases vs Population
 -- Shows what percentage of population got Covid
 Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
 From PortfolioProject.dbo.CovidDeaths$
 Where location like '%india%'
 Order by 1, 2

 -- Countries with Higherst Infection Rate campared to Population
 
 Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
 From PortfolioProject.dbo.CovidDeaths$
-- Where location like '%india%'
 group by population, Location
 Order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Poopulation
 Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
 From PortfolioProject.dbo.CovidDeaths$
-- Where location like '%india%'
 where continent is not null
 group by Location
 Order by TotalDeathCount desc

 --continent with the highest death count

 Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
 From PortfolioProject.dbo.CovidDeaths$
-- Where location like '%india%'
 where continent is not null
 group by continent
 Order by TotalDeathCount desc

 -- GLOBAL NUMBERS

 Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
 From PortfolioProject.dbo.CovidDeaths$
 Where continent is not null
 Order by 1, 2


 -- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by  dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- use CTE

with PopvsVac (continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by  dea.location Order by 
dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac