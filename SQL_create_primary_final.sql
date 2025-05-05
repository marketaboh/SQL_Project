/*
 * VYTVORENI TABULKY primary_final
 * *****************************************************************
 */
CREATE VIEW t_marketa_bohackova_project_SQL_primary_final AS
WITH payroll AS (
SELECT  ROUND(AVG(cp.value),0) AS yearly_avg_wage,
	cpib.name AS industry_name,
	cp.payroll_year
FROM czechia_payroll cp 
LEFT JOIN 
	czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code
WHERE  cp.value_type_code =5958  --- vyber hodnot pro prumerne mzdy
		AND cp.calculation_code = 200 ---- prumerna mzda prepoctena na plne zamestnane
		AND cp.payroll_year BETWEEN 2006 AND 2018 --- omezeni na stejne roky jako czechia_price
GROUP BY industry_name,
		 cp.payroll_year
		 
),
price as (
SELECT ROUND(AVG(cp.value)::numeric, 1) AS yearly_avg_food_price,
	cpc.name AS food_name,
CASE 
	WHEN cp.category_code IN (112101,112201,112401,2000001) THEN 'Maso ryby'
	WHEN cp.category_code IN (114201,114401,114501,114701) THEN 'Mléčné výrobky a vejce'
	WHEN cp.category_code IN (122102,212101,213201) THEN 'Nápoje'
	WHEN cp.category_code IN (116101,116103,116104,117101,117103,117106,117401) THEN 'Ovoce a zelenina'
	WHEN cp.category_code IN (111301,111303) THEN 'Pečivo'
	WHEN cp.category_code IN (111101,111201,111602,118101) THEN 'Trvanlivé potraviny'
	WHEN cp.category_code IN (115101,115201) THEN 'Tuky'
	ELSE 'Uzeniny'
END AS food_category,
	cpc.price_value,
	cpc.price_unit,
	DATE_PART('YEAR',cp.date_from ) AS price_year
FROM czechia_price cp
JOIN 
czechia_price_category cpc 
ON cp.category_code =cpc.code
WHERE cp.region_code IS NULL --- hodnoty za cr v danem obdobi (vyrazeni hodnot pro regiony)
GROUP BY cpc.name,
	food_category,
	cpc.price_value,
	cpc.price_unit,
	price_year
) 
SELECT * 
FROM payroll pa
JOIN price pr
ON pa.payroll_year= pr.price_year;

SELECT * FROM t_marketa_bohackova_project_SQL_primary_final;
DROP VIEW t_marketa_bohackova_project_SQL_primary_final;
