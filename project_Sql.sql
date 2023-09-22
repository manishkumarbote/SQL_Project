use covid;

show variables like "secure_file_priv";

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\covidVacination.csv'
into table covidvacination
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;


SET GLOBAL sql_mode=" ";

select count(*) from covidvacination;
select * from covidvacination;
select count(*) from coviddeaths;

select * from covid.coviddeaths
order by 3, 4;

select * from covid.covidvacination
order by 3, 4;

select location, date, total_cases, new_cases, total_deaths, population
from covid.coviddeaths
order by 1,2;

-- Looking at total cases vs Total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid.coviddeaths
where location like '%India%'
order by 1,2; 

-- Shows what percentage of population got infected
Select location, date, total_cases, population, (total_cases/population)*100 as Infcatedpercentage 
from covid.coviddeaths
where location like '%India%'
order by 1,2; 

-- Looking at country with higest infection rate as compare to population
Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfcated 
from covid.coviddeaths
where location like '%India%'
group by location, population
order by PercentPopulationInfcated desc; 

-- Showing Countries Highest death Count per population 
Select location, max(total_deaths) as TotalDeathsCount 
from covid.coviddeaths
where continent is not null
group by location
order by TotalDeathsCount desc; 

-- Let's Break Things down by continent
Select continent, MAX(cast(total_deaths as int)) as TotalDeathsCount 
from covid.coviddeaths
where continent is not null
group by location
order by TotalDeathsCount desc; 

-- Global Numbers 
Select date, Sum(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/Sum(New_Cases)*100 as DeathPercentage 
from covid.coviddeaths
where continent is not null
group by date 
order by 1,2; 


-- Looking at Total Population vs Vaccination 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
From covid.coviddeaths dea
join covid.covidvacination vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 1,2,3;