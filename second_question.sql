/**
 * 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období 
 * v dostupných datech cen a mezd?
 * ***************************************************************************************************
 * */
WITH avg_wage_price_06_18 AS (
SELECT  yearly_avg_wage, 
		yearly_avg_food_price, 
		food_name,
		pf.payroll_year AS year	
FROM
t_marketa_bohackova_project_SQL_primary_final pf
WHERE industry_name IS NULL --- prumerna mzda za čr
	AND pf.payroll_year IN (2006,2018) --- prvni a posledni srovnatelne obdobi v datech 
	AND pf.food_name IN ('Chléb konzumní kmínový','Mléko polotučné pasterované') --- zajima nas pouze mleko a chleb
	ORDER BY year
)
SELECT year,
		food_name,
		ROUND(yearly_avg_wage/yearly_avg_food_price,0)  AS food_count,
		ROUND(yearly_avg_wage/yearly_avg_food_price - 
		LAG(yearly_avg_wage/yearly_avg_food_price) OVER (PARTITION BY food_name order BY year),0) AS diff_count  
FROM avg_wage_price_06_18
ORDER BY year; 