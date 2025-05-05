/*
 * 	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
 ******************************************************************************************************* 
 * */
--- prumerna cena kazde potraviny za rok
WITH annual_value AS (
SELECT  yearly_avg_food_price,
		food_name,
		food_category,
		price_year 
FROM t_marketa_bohackova_project_SQL_primary_final  pf
WHERE industry_name IS NULL --- odtraneni duplicitnich hodnot pro kazde odvetvi
),---- mezirocni percentualni zmena pro kazdou potravinu
food_price_increase AS (
SELECT  *,
	    yearly_avg_food_price -LAG(yearly_avg_food_price) OVER (PARTITION BY food_name ORDER BY price_year )  AS price_increase,
CASE
	WHEN yearly_avg_food_price -LAG(yearly_avg_food_price) OVER (PARTITION BY food_name ORDER BY price_year ) IS NULL THEN NULL
	ELSE ROUND((yearly_avg_food_price -LAG(yearly_avg_food_price) OVER (PARTITION BY food_name ORDER BY price_year ))
			/LAG(yearly_avg_food_price) OVER (PARTITION BY food_name ORDER BY price_year ) *100,2)
END AS pct_change
FROM annual_value
),--- vypocet zmeny cen pro kazdou kategorii potravin za kazdy rok
category_avg_pct as (
SELECT  ROUND(AVG(pct_change),2) avg_pct_change,
		price_year, 
		food_category
FROM food_price_increase
GROUP BY food_category,price_year 
)--- zjisteni, ktera kategorie potravin mela nejmensi narust cen behem let
SELECT SUM(avg_pct_change) AS sum_pct_change,
	    food_category
FROM category_avg_pct
GROUP BY food_category
ORDER BY sum_pct_change
LIMIT 1;
