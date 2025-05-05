/* 
 * 
 *5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
******************************************************************************************************************
* Zajimají nás roky 2007,2015 a 2017, kdy došlo k velkému nárůstu HDP v ČR přes 5%
*/
WITH gdp_increase AS ( --- vypocet mezirocniho narustu HDP
SELECT year,
		gdp,
		gdp -LAG(gdp) OVER (ORDER BY year) AS gdp_incease,
CASE
	WHEN gdp -LAG(gdp) OVER (ORDER BY year ) IS NULL THEN NULL
	ELSE (gdp -LAG(gdp) OVER ( ORDER BY year ))
			/LAG(gdp) OVER (ORDER BY year ) *100
END AS pct_change
FROM t_marketa_bohackova_project_SQL_secondary_final
ORDER BY year
),---- vypocet procentualni mezirocni zmeny mezd
pct_wage_change AS (
SELECT * ,
	yearly_avg_wage -LAG(yearly_avg_wage) OVER (ORDER BY payroll_year)  AS wage_increase,
CASE
	WHEN yearly_avg_wage -LAG(yearly_avg_wage) OVER (ORDER BY payroll_year ) IS NULL THEN NULL
	ELSE round((yearly_avg_wage -LAG(yearly_avg_wage) OVER ( ORDER BY payroll_year ))
			/LAG(yearly_avg_wage) OVER (ORDER BY payroll_year ) *100,2)
END AS pct_wage_change
FROM (-- odstraneni duplicit z dat
SELECT DISTINCT yearly_avg_wage,
		  		payroll_year
FROM t_marketa_bohackova_project_SQL_primary_final
WHERE industry_name IS NULL ---data pro celou CR
)
),--- vypocet procentualni mezirocni zmeny cen potravin
food_price_increase AS (
SELECT yearly_avg_food_price,
		food_name,
		price_year,
		yearly_avg_food_price -LAG(yearly_avg_food_price) OVER (PARTITION BY food_name ORDER BY price_year )  AS price_increase,
CASE
	WHEN yearly_avg_food_price -LAG(yearly_avg_food_price) OVER (PARTITION BY food_name ORDER BY price_year ) IS NULL THEN NULL
	ELSE ROUND((yearly_avg_food_price -LAG(yearly_avg_food_price) OVER (PARTITION BY food_name ORDER BY price_year ))
			/LAG(yearly_avg_food_price) OVER (PARTITION BY food_name ORDER BY price_year ) *100,2)
END AS pct_change
FROM t_marketa_bohackova_project_SQL_primary_final
WHERE industry_name IS NULL --- odstraneni dat za ostatni odvetvi
),--- rocni procentualni zmena cen potravin
pct_food_price_change AS (
SELECT ROUND(AVG(pct_change),2) AS pct_food_price_change,
		price_year
FROM food_price_increase
GROUP BY price_year
)--- vytvoreni tabulky zobrazujici mezirocni narust HDP, cen potravin a mezd
SELECT payroll_year AS YEAR,
		ROUND(gi.pct_change::numeric,2) AS yearly_pct_gdp_change,
		pct_wage_change,
		pct_food_price_change
FROM gdp_increase gi
LEFT JOIN pct_wage_change wch
ON gi.YEAR = wch.payroll_year
LEFT JOIN pct_food_price_change fp
ON wch.payroll_year =fp.price_year
WHERE YEAR IN (2007,2008,2015,2016,2017,2018);