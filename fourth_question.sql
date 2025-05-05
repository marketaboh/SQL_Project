/*
 * 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 ****************************************************************************************************************** 
  * */

WITH pct_wage_change AS ( ---- vypocet procentualni mezirocni zmeny mezd
SELECT * ,
		yearly_avg_wage -LAG(yearly_avg_wage) OVER (ORDER BY payroll_year)  AS wage_increase,
CASE
	WHEN yearly_avg_wage -LAG(yearly_avg_wage) OVER (ORDER BY payroll_year ) IS NULL THEN NULL
	ELSE ROUND((yearly_avg_wage -LAG(yearly_avg_wage) OVER ( ORDER BY payroll_year ))
			/LAG(yearly_avg_wage) OVER (ORDER BY payroll_year ) *100,2)
END AS pct_wage_change
FROM (
	SELECT DISTINCT yearly_avg_wage,
					payroll_year 
	FROM t_marketa_bohackova_project_SQL_primary_final
	WHERE industry_name IS NULL --- prumerna mzda za čr
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
)
SELECT payroll_year AS year,
		pct_wage_change,
		pct_food_price_change,
		pct_food_price_change - pct_wage_change  AS pct_diff
FROM pct_wage_change wch
LEFT JOIN pct_food_price_change fp
ON wch.payroll_year =fp.price_year
WHERE pct_food_price_change > 0 --- jen data, kde doslo k narustu cen potravin
ORDER BY pct_diff DESC
LIMIT 1 ;