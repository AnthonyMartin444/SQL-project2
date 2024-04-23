SELECT location,date,total_cases,new_cases,total_deaths,population
FROM [Portfolio Project]..CovidDeaths
ORDER BY 1,2

SELECT * 
FROM [Portfolio Project]..covidVaccinations
ORDER BY 3,4

--- looking at total cases vs total death

SELECT location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage 
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%States%'
ORDER BY 1,2

SELECT location, MAX(cast(total_deaths AS int)) as totaldeath
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%States%'
GROUP BY location
ORDER BY totaldeath desc
