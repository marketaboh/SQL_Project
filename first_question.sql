/*
 * 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 ********************************************************************************** 
 * */
CREATE TEMP TABLE temp_wage AS (
WITH  wage_icrease_by_year AS (--- porovnaní rustu mezd s predchozim rokem pro kazde odvětví
SELECT *,
		yearly_avg_wage -LAG(yearly_avg_wage) OVER (PARTITION BY industry_name ORDER BY payroll_year ) AS wage_increase,
CASE
      WHEN yearly_avg_wage IS NULL THEN NULL
      ELSE ROUND((yearly_avg_wage - LAG(yearly_avg_wage) OVER (PARTITION BY industry_name ORDER BY payroll_year)) 
           / LAG(yearly_avg_wage) OVER (PARTITION BY industry_name ORDER BY payroll_year) * 100,2)
END AS wage_pct_change
FROM (
SELECT distinct yearly_avg_wage,
				industry_name,
				payroll_year
FROM t_marketa_bohackova_project_SQL_primary_final
WHERE industry_name IS NOT  NULL --- odstraneni dat pro celou ČR
ORDER BY payroll_year)
),
wage_increase_flag AS(
SELECT *,
CASE
	WHEN wage_increase >=0 THEN 1
	WHEN wage_increase IS NULL THEN NULL
	ELSE 0
END AS increase_flag
FROM wage_icrease_by_year
ORDER BY industry_name,payroll_year
	)
SELECT *
FROM wage_increase_flag
);
--- vyber odvetvi, kde mzdy kazdy rok stoupaly
SELECT industry_name
FROM temp_wage 
GROUP BY industry_name
HAVING SUM(increase_flag)= 12;

----vyber odvetvi ve kterem doslo behem let k poklesu mezd a jejich serazeni dle poctu let a zjisteni o jak velky celkovy pokles se jednalo
SELECT industry_name,
       COUNT(increase_flag) AS wage_decline,
       SUM(wage_pct_change) AS wage_pct_change
FROM temp_wage
WHERE increase_flag = 0
GROUP BY industry_name
HAVING COUNT(increase_flag) > 2
ORDER BY wage_decline DESC;

---- nejvetši pokles mezd
SELECT industry_name,
		SUM(wage_pct_change) AS sum_wage_pct_change
FROM temp_wage
WHERE increase_flag = 0
GROUP BY industry_name
ORDER BY sum_wage_pct_change
LIMIT 1;
---- overeni zda nedochazi k trvalemu poklesu cen u nekterych odvetvi
SELECT industry_name,
		payroll_year,
		wage_increase,
		wage_pct_change
FROM temp_wage
WHERE increase_flag = 0
ORDER BY industry_name, payroll_year; 



