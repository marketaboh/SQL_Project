/*
 * VYTVORENI TABULKY secondary_final
 * *********************************************
 *	 data omezena na stejné roky jako tabulka primary_final a pro analyzu staci data pouze pro ČR
 **/
CREATE VIEW t_marketa_bohackova_project_SQL_secondary_final AS
SELECT *  
FROM economies  
WHERE country = 'Czech Republic' 
	AND year BETWEEN 2006 AND 2018; 
SELECT * 
FROM t_marketa_bohackova_project_SQL_secondary_final;