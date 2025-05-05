ENGETO SQL Projekt
Zadání projektu
Úvod do projektu
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.
Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období. 
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.
Datové sady, které je možné požít pro získání vhodného datového podkladu:
Primární tabulky:
czechia\_payroll – Data o mzdách v různých odvětvích za několik let. Datová sada je dostupná na Portálu otevřených dat ČR.
czechia\_payroll\_calculation – Číselník kalkulací v tabulce mezd.
czechia\_payroll\_industry\_branch – Číselník odvětví v tabulce mezd.
czechia\_payroll\_unit – Číselník jednotek hodnot v tabulce mezd.
czechia\_payroll\_value\_type – Číselník typů hodnot v tabulce mezd.
czechia\_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
Číselníky sdílených informací o ČR:
countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.
Tvorba tabulek t\_marketa\_bohackova\_project\_SQL\_primary\_final a t\_marketa\_bohackova\_project\_SQL\_secondary\_final
Tabulka t\_marketa\_bohackova\_project\_SQL\_primary\_final
Při tvorbě tohoto view byly použity tyto zdrojové tabulky:
czechia\_payroll
czechia\_payroll\_industry\_branch 
czechia\_price 
Při analýze zdrojových dat bylo zjištěno, že dostupné roky u tabulky mezd jsou 2000 - 2021, data končí v půlce roku 2021. V poli payroll\_unit jsou prohozené hodnoty a mezd se zobrazuje jednotka tis. osob a pro počty zaměstnanců Kč.
Pro omezení dat byla použita hodnota value\_type\_code = 5958 (Průměrná hrubá mzda na zaměstnance dle číselníku czechia\_payroll\_value\_type )
Dále calculation\_code = 200 (Hrubá průměrná mzda přepočtená na plně zaměstnané dle dokumentace na )
Zdrojová tabulka czechia\_payroll obsahuje velice málo dat v případě počtu zaměstnanců.
Data byla porovnávána s aktuálními daty na stránkách gov.cz a ČSÚ a hodnoty pro průměrné mzdy se liší od roku 2020, kdy jsou hodnoty rozdílné mezi aktuálně distribuovanými daty na stránkách a námi používanou datovou sadou. Porovnaní bylo provedeno stažením aktuálních dat ze stránek gov.cz a jejich zobrazením v excelu. Do konce roku 2019 se hodnoty shodují.
V případě nevyplněné hodnoty industry\_brach\_code se jedná o data za celou ČR.
Data potravin v tabulce czechia\_price  jsou rozdělená dle regionu, nebo v případě uvedené NULL hodnoty za celou ČR. Data v této tabulce končí 16.12.2018.
Analýza byla tedy zpracovaná v období 2006 až 2018. Ceny potravin byly zpracovány jako průměrné hodnoty za daný rok a stejně byly upraveny i průměrné hodnoty mezd.
Potraviny byly rozděleny do kategorií viz tabulka níže:

Tvorba tabulky t\_marketa\_bohackova\_project\_SQL\_secondary\_final
View bylo naplněno ze zdrojové tabulky: 
economies
Data byla následně omezena na srovnatelné období jako data mezd a cen potravin, tedy na roky 2006 až 2018. Dále byla vybrána data jen pro Českou republiku, protože data pro jiné země nejsou pro tuto analýzu potřeba. Zajímají nás pouze hodnoty HDP v letech 2006 až 2018 pro ČR, ale v tabulce byly ponechány i ostatní pole.
Výzkumné otázky:
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Z dostupných dat bylo zjištěno, že v žádném odvětví nedošlo v letech 2006 až 2018 k trvalému poklesu mezd. Ve třech odvětvích došlo k trvalému růstu mezd každý rok a to konkrétně u těchto odvětví:
Zpracovatelský průmysl
Ostatní činnosti
Zdravotní a sociální péče
V ostatních odvětvích došlo v průběhu let 2006 až 2018 k poklesu mezd. Nejvíce odvětví zaznamenalo pokles v roce 2013. K největšímu jednorázovému poklesu mezd v tomto roce došlo v Peněžnictví a pojišťovnictví a to o -8.83 %. Nejčetnější pokles mezd, konkrétně čtyřikrát, byl zaznamenán v Těžbě a dobývání a celkově zde mzdy klesly o -7.53 %. Na druhém místě je Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu, kde došlo k poklesu třikrát a celkově o -6.23 %.
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Tabulky níže ukazuje kolik kusů chleba a litrů mléka bylo možné si pořídit v roce 2006 a kolik v roce 2018. Tedy za první a poslední srovnatelné období dostupné v datech. Z tabulky je patrné, že v roce 2018 si za průměrnou mzdu bylo možné pořídit více chleba a více litrů mléka. Konkrétně o 111 kusů chleba a o 262 litrů mléka více.

Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Vzhledem k tomu, že v rámci jedné kategorie jsou občas produkty, kde je cena potraviny uvedena v rozdílných jednotkách např. v případě vajec a mléčných výrobků jde o kusy litry a g, byl v tomto případě proveden výpočet percentuálně meziroční změny a až poté z toho byl vytvořen průměr pro každou kategorii zvlášť. Na základě tohoto výpočtu bylo zjištěno, že nejpomaleji, tedy k nejnižšímu celkovému nárůstu cen došlo v kategorii uzenin a to o 22 %.
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
K největšímu meziročnímu rozdílu mezi cenami potravin a změnou výše mezd, došlo v roce 2013, kdy rozdíl mezi procentuálním poklesem mezd a navýšením cen potravin činí 6 %. V žádné roce tedy nedošlo k překročení hodnoty 10 %. 
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
Z dostupných dat bylo zjištěno, že v letech 2007, 2015 a 2017 došlo k velkému nárůstu HDP v ČR a to přes 5 %. Tabulka níže ukazuje, že v roce 2007 došlo i k velkému nárůstu mezd a cen potravin a růst pokračoval i v roce 2008 i když HDP vzrostlo mírně. K dalšímu velkému nárůstu došlo v roce 2015, kdy došlo k mírnému nárůstu mezd, ale ceny potravin naopak klesly a v následujícím roce došlo opět k mírnému nárůstu mezd, ale k poklesu cen potravin. Poslední rok, kdy došlo k nárůstu HDP bylo v roce 2017 a zde došlo opět k velkému nárůstu mezd i cen potravin a v následujícím roce opět stoupaly mzdy, ale potraviny již o něco mírněji. Lze tedy říct, že větší růst HDP má větší vliv na výši mezd, než ceny potravin.

