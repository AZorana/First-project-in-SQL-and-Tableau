/* 1. Firstly I have created an empty table as an outline for the inputs I will import the inputs as a .csv file */


CREATE TABLE whrData_2021
 (Country_name varchar(50), Population_2020 int, Population_2019 int,	COVID_19_deaths_per_100000_2020 float, Median_age float, Island int, 
 Index_exposure_COVID_19_infections_as_of_March_31 float,	Log_average_distance_to_SARS_countries float, WHO_Western_Pacific_Region int, 
 Female_head_government	int, Index_institutional_trust float, Gini_coefficient_income float, All_cause_death_2017 int default null,	
 All_cause_death_2018 int default null, All_cause_death_2019 int default null , All_cause_death_2020 int default null,
 Excess_deaths_2020_per_100_000_relative_2017_to_2019_average float)

SELECT * FROM world_happiness_report.whrdata_2021;


/* 2. Added the new column which consists of primary keys */

ALTER TABLE whrdata_2021 
ADD ID int not null primary key auto_increment FIRST;

SELECT * FROM world_happiness_report.whrdata_2021;

/* 3. Deleted column  */

START TRANSACTION;
DELETE FROM world_happiness_report.whrdata_2021
WHERE Country_name='Kosovo';
COMMIT;
SELECT * FROM world_happiness_report.whrdata_2021;

/* 4. Total populations for 2019 and 2020 and their difference*/

CREATE VIEW Total_population_and_difference AS
SELECT SUM(Population_2019) AS Total_population_2019, SUM(Population_2020) AS Total_population_2020,
SUM(Population_2020-Population_2019) AS Diff
FROM world_happiness_report.whrdata_2021;

SELECT * FROM Total_population_and_difference;

/* 5. Replaced 0 and 1 with False and True respectively in the column Island*/
ALTER TABLE world_happiness_report.whrdata_2021
MODIFY COLUMN Island varchar(50);
UPDATE world_happiness_report.whrdata_2021 SET Island = REPLACE(Island, '1', 'True')
WHERE  Island='1';
UPDATE world_happiness_report.whrdata_2021 SET Island = REPLACE(Island, '0', 'False')
WHERE  Island='0';

/* 6. The difference in the number of deaths in 2020 compared to 2019, 2018, 2017 */

CREATE VIEW Diff_death AS 
SELECT (All_cause_death_2020-All_cause_death_2019) AS Diff_2020_2019,
	   (All_cause_death_2020-All_cause_death_2018) AS Diff_2020_2018,
       (All_cause_death_2020-All_cause_death_2017) AS Diff_2020_2017
FROM world_happiness_report.whrdata_2021;
SELECT * FROM Diff_death ORDER BY Diff_2020_2019 DESC;
       
/* 7. Comparison of island countries and non-island countries in relation to population and the number of deaths */

CREATE VIEW Death_NoIsland_Island AS
SELECT  Island,
       SUM(Population_2020) AS Population_2020_NoIsland_Island,
       SUM(All_cause_death_2020) AS Death_2020_NoIsland_Island,
       SUM(All_cause_death_2020-All_cause_death_2019) AS Diff_Death_2020_2019_NoIsland_Island, 
       SUM(Population_2019) AS Population_2019_NoIsland_Island,
       SUM(All_cause_death_2019) AS Death_2019_NoIsland_Island,
       SUM(All_cause_death_2019-All_cause_death_2018) AS Diff_Death_2019_2018_NoIsland_Island
FROM world_happiness_report.whrdata_2021
GROUP BY Island;
SELECT * FROM Death_NoIsland_Island;

/* 8.  The index of exposure to COVID-19 infections in other countries as of march 31 higher than 3 */
SELECT Country_name, Index_exposure_COVID_19_infections_as_of_March_31
FROM world_happiness_report.whrdata_2021
WHERE  Index_exposure_COVID_19_infections_as_of_March_31>3
ORDER BY Index_exposure_COVID_19_infections_as_of_March_31 DESC;

/* 9. The country with the oldest population and the country with the youngest population */

SELECT Country_name, Median_age 
FROM world_happiness_report.whrdata_2021 
WHERE Median_age=(SELECT MIN(Median_age) FROM world_happiness_report.whrdata_2021) 
OR Median_age=(SELECT MAX(Median_age) FROM world_happiness_report.whrdata_2021)
