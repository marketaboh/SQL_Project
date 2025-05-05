# PROJEKT SQL – ENGETO

## PRŮVODNÍ ZPRÁVA

### Úvod do projektu

Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.
Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období. 
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

### Datové sady, které je možné požít pro získání vhodného datového podkladu:
**Primární tabulky**
- `czechia_payroll`: obsahuje data o mzdách v jednotlivých odvětvích
- `czechia_payroll_calculation`: Číselník kalkulací v tabulce mezd
- `czechia_payroll_industry_branch`: Číselník odvětví v tabulce mezd
- `czechia_payroll_unit`: Číselník jednotek hodnot v tabulce mezd
- `czechia_payroll_value_type`: Číselník typů hodnot v tabulce mezd
- `czechia_price`: Informace o cenách vybraných potravin za několikaleté období.
                    Datová sada pochází z Portálu otevřených dat ČR
**Číselníky sdílených informací o ČR**
- `countries`: Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
- `economies`: HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

### Tabulky

#### Primární výstupní tabulka

`t_marketa_bohackova_project_SQL_primary_final`
Při tvorbě tohoto view  byly použity tyto zdrojové tabulky:
- `czechia_payroll`
- `czechia_payroll_industry_branch
-  `czechia_price`
  
Při analýze zdrojových dat bylo zjištěno, že dostupné roky u tabulky mezd jsou 2000 - 2021,  data končí v půlce roku 2021. V poli **payroll_unit** jsou prohozené hodnoty a mezd se zobrazuje jednotka tis. osob a pro počty zaměstnanců Kč.

- Použit `value_type_code = 5958` (průměrná hrubá mzda)
- Použit `calculation_code = 200` (přepočteno na plně zaměstnané)

Zdrojová tabulka czechia_payroll obsahuje velice málo dat v případě počtu zaměstnanců.

Data byla  porovnávána s aktuálními daty na stránkách gov.cz a ČSÚ a hodnoty pro průměrné mzdy se liší od roku 2020, kdy jsou hodnoty rozdílné mezi aktuálně distribuovanými daty na stránkách a námi používanou datovou sadou. Porovnaní bylo provedeno stažením aktuálních dat ze stránek gov.cz a jejich zobrazením v excelu. Do konce roku 2019 se hodnoty shodují.

V případě nevyplněné hodnoty **industry_brach_code** se jedná o data za celou ČR.

Data potravin v tabulce czechia_price  jsou rozdělená dle regionu, nebo v případě uvedené **NULL** hodnoty za celou ČR. Data v této tabulce končí 16.12.2018.
Analýza byla tedy zpracovaná v období **2006** až **2018**. Ceny potravin byly zpracovány jako průměrné hodnoty za daný rok a stejně byly upraveny i průměrné hodnoty mezd.
Potraviny byly rozděleny do kategorií viz tabulka níže:
| Kód produktu | Potravina                        | Kategorie               |
|--------------|----------------------------------|-------------------------|
| 111101       | Rýže loupaná dlouhozrnná         | Trvanlivé potraviny     |
| 111201       | Pšeničná mouka hladká            | Trvanlivé potraviny     |
| 111301       | Chléb konzumní kmínový           | Pečivo                  |
| 111303       | Pečivo pšeničné bílé             | Pečivo                  |
| 111602       | Těstoviny vaječné                | Trvanlivé potraviny     |
| 112101       | Hovězí maso zadní bez kosti      | Maso a ryby             |
| 112201       | Vepřová pečeně s kostí           | Maso a ryby             |
| 112401       | Kuřata kuchaná celá              | Maso a ryby             |
| 112704       | Šunkový salám                    | Uzeniny                 |
| 114201       | Mléko polotučné pasterované      | Mléčné výrobky a vejce  |
| 114401       | Jogurt bílý netučný              | Mléčné výrobky a vejce  |
| 114501       | Eidamská cihla                   | Mléčné výrobky a vejce  |
| 114701       | Vejce slepičí čerstvá            | Mléčné výrobky a vejce  |
| 115101       | Máslo                            | Tuky                    |
| 115201       | Rostlinný roztíratelný tuk       | Tuky                    |
| 116101       | Pomeranče                        | Ovoce a zelenina        |
| 116103       | Banány žluté                     | Ovoce a zelenina        |
| 116104       | Jablka konzumní                  | Ovoce a zelenina        |
| 117101       | Rajská jablka červená kulatá     | Ovoce a zelenina        |
| 117103       | Papriky                          | Ovoce a zelenina        |
| 117106       | Mrkev                            | Ovoce a zelenina        |
| 117401       | Konzumní brambory                | Ovoce a zelenina        |
| 118101       | Cukr krystalový                  | Trvanlivé potraviny     |
| 122102       | Minerální voda uhličitá          | Nápoje                  |
| 212101       | Jakostní víno bílé               | Nápoje                  |
| 213201       | Pivo výčepní, světlé, lahvové    | Nápoje                  |
| 2000001      | Kapr živý                        | Maso a ryby             |

---

#### Sekundární výstupní tabulka
`t_marketa_bohackova_project_SQL_secondary_final` 
View bylo naplněno ze zdrojové tabulky: 
- `economies`
  
Data byla následně omezena na srovnatelné období jako data mezd a cen potravin, tedy na roky **2006** až **2018**. Dále byla vybrána data jen pro **Českou republiku**, protože data pro jiné země nejsou pro tuto analýzu potřeba. Zajímají nás pouze hodnoty HDP v letech 2006 až 2018 pro ČR, ale v tabulce byly ponechány i ostatní pole.

## Výzkumné otázky

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Z dostupných dat bylo zjištěno, že v žádném odvětví nedošlo v letech 2006 až 2018 k trvalému poklesu mezd. Ve třech odvětvích došlo k trvalému růstu mezd každý rok a to konkrétně u těchto odvětví:
- Zpracovatelský průmysl
- Ostatní činnosti
- Zdravotní a sociální péče

V ostatních odvětvích došlo v průběhu let 2006 až 2018 k poklesu mezd. Nejvíce odvětví zaznamenalo pokles v roce **2013**. K největšímu jednorázovému poklesu mezd v tomto roce došlo v **Peněžnictví a pojišťovnictví** a to o **-8.83 %**.  Nejčetnější pokles mezd, konkrétně čtyřikrát, byl zaznamenán v **Těžbě a dobývání** a celkově zde mzdy klesly o **-7.53 %**. Na druhém místě je **Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu**, kde došlo k poklesu třikrát a celkově o **-6.23 %**.

### 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Tabulky níže ukazuje kolik kusů chleba a litrů mléka bylo možné si pořídit v roce 2006 a kolik v roce 2018. Tedy za první a poslední srovnatelné období dostupné v datech. Z tabulky je patrné, že v roce 2018 si za průměrnou mzdu bylo možné pořídit více chleba a více litrů mléka. Konkrétně o 111 kusů chleba a o 262 litrů mléka více.

| Rok  | Potravina                    | Počet kusů/litrů | Rozdíl |
|------|------------------------------|------------------|--------|
| 2006 | Chléb konzumní kmínový       | 1213             |        |
| 2006 | Mléko polotučné pasterované  | 1357             |        |
| 2018 | Chléb konzumní kmínový       | 1324             | +111   |
| 2018 | Mléko polotučné pasterované  | 1618             | +262   |

---

### 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Vzhledem k tomu, že v rámci jedné kategorie jsou občas produkty, kde je cena potraviny uvedena v rozdílných jednotkách např. v případě vajec a mléčných výrobků jde o kusy litry a g, byl v tomto případě proveden výpočet percentuálně meziroční změny a až poté z toho byl vytvořen průměr pro každou kategorii zvlášť. Na základě tohoto výpočtu bylo zjištěno, že nejpomaleji, tedy k nejnižšímu celkovému nárůstu cen došlo v kategorii **Uzenin** a to o **22 %**.

### 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Ne. K největšímu meziročnímu rozdílu mezi cenami potravin a změnou výše mezd, došlo v roce 2013, kdy rozdíl mezi procentuálním poklesem mezd a navýšením cen potravin činí **6 %**.

### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Ano. Z dostupných dat bylo zjištěno, že v letech 2007, 2015 a 2017 došlo k velkému nárůstu HDP v ČR a to přes 5 %. Tabulka níže ukazuje, že v roce 2007 došlo i k velkému nárůstu mezd a cen potravin a růst pokračoval i v roce 2008 i když HDP vzrostlo mírně. K dalšímu velkému nárůstu došlo v roce 2015, kdy došlo k mírnému nárůstu mezd, ale ceny potravin naopak klesly a v následujícím roce došlo opět k mírnému nárůstu mezd, ale k poklesu cen potravin. Poslední rok, kdy došlo k nárůstu HDP bylo v roce 2017 a zde došlo opět k velkému nárůstu mezd i cen potravin a v následujícím roce opět stoupaly mzdy, ale potraviny již o něco mírněji. Lze tedy říct, že větší růst HDP má větší vliv na výši mezd, než ceny potravin.

| Rok  | % změna HDP | % změna mezd | % změna cen potravin |
|------|-------------|---------------|------------------------|
| 2007 | 5.57        | 7.22          | 9.31                   |
| 2008 | 2.69        | 7.85          | 8.98                   |
| 2015 | 5.39        | 3.19          | -0.69                  |
| 2016 | 2.54        | 4.42          | -1.37                  |
| 2017 | 5.17        | 6.74          | 7.04                   |
| 2018 | 3.20        | 8.16          | 2.44                   |

---


