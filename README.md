
# COVID-19 Data Exploration with SQL

This project demonstrates SQL skills by exploring COVID-19 data, focusing on analysis through various SQL techniques such as Joins, Common Table Expressions (CTEs), Temporary Tables, Window Functions, Aggregate Functions, and Views. The dataset includes COVID-19 deaths and vaccinations globally, and the code analyzes infection rates, death rates, and vaccination progress across different countries and continents.

## Skills Used
- Joins
- Common Table Expressions (CTEs)
- Temporary Tables
- Window Functions
- Aggregate Functions
- Creating Views
- Data Type Conversion

## Datasets
The data used in this project comes from two tables:
1. **CovidDeaths**: Contains data on COVID-19 cases, deaths, and population by country and date.
2. **CovidVaccinations**: Contains data on COVID-19 vaccinations by country and date.

## SQL Queries

### 1. Basic Data Exploration
Query to select and display key data columns from the `CovidDeaths` table:
```sql
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2;
```

### 2. Total Cases vs Total Deaths
Calculate the likelihood of dying if infected with COVID-19:
```sql
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%' and continent is not null 
order by 1,2;
```

### 3. Total Cases vs Population
Shows the percentage of the population infected with COVID-19:
```sql
Select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
order by 1,2;
```

### 4. Countries with Highest Infection Rate
Query to identify countries with the highest infection rate relative to their population:
```sql
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc;
```

### 5. Countries with Highest Death Count per Population
```sql
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc;
```

### 6. Breakdown by Continent
Find the continents with the highest death counts relative to their populations:
```sql
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc;
```

### 7. Global Numbers
Calculate total COVID-19 cases and deaths, as well as the global death percentage:
```sql
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2;
```

### 8. Population vs Vaccinations
Show the percentage of the population that has received at least one COVID-19 vaccine dose:
```sql
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location and dea.date = vac.date
where dea.continent is not null 
order by 2,3;
```

### 9. Using CTE to Calculate Vaccination Progress
```sql
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
From PopvsVac;
```

### 10. Temporary Table for Vaccination Progress
```sql
DROP Table if exists #PercentPopulationVaccinated;
Create Table #PercentPopulationVaccinated (
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated numeric
);
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location and dea.date = vac.date;
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
From #PercentPopulationVaccinated;
```

### 11. Creating a View for Vaccination Data
```sql
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location and dea.date = vac.date
where dea.continent is not null;
```

## Conclusion
This project provides insights into global COVID-19 trends by exploring case rates, death rates, and vaccination progress using SQL. The queries allow for flexible analysis and reporting by breaking down data by country and continent and using advanced SQL techniques like CTEs, Temp Tables, and Window Functions.

## License
This project is open-source and available for anyone to use.

