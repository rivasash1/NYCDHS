/*
DHS Daily Reports Data Exploration Project

Source: https://data.cityofnewyork.us/Social-Services/DHS-Daily-Report/k46n-sa2m

This dataset includes the daily number of families and individuals residing in the 
Department of Homeless Services (DHS) shelter system and the daily number of families applying to the DHS shelter system IN NYC. 




Skills used:  Aggregate Functions, Creating Views for Tableau 
*/
 
-- viewing data: 

select * 
from dhsproject.dhs_daily_report;

-- has the number of single women staying in DHS increased or decreased throughout the years? 
select year(date_of_census) as year, max(single_adult_women_in_shelter) as single_women_in_shelter
from dhsproject.dhs_daily_report
group by 1
order by 1 asc;

-- has the number of single men in DHS increased or decreased throughout the years?
select year(date_of_census) as year, max(single_adult_men_in_shelter) as single_men_in_shelter
from dhsproject.dhs_daily_report
group by 1 
order by 1 asc;

-- has the number of children in DHS increased or decreased throughout the years?
select year(date_of_census) as year, max(total_children_in_shelter) as total_children_in_shelter
from dhsproject.dhs_daily_report
group by 1 
order by 1 asc;

-- comparison of number of single men, single women and children in DHS per year: 

select year(date_of_census) as year, 
	   max(total_children_in_shelter) as children_in_shelter, 
       max(single_adult_men_in_shelter) as men_in_shelter,
       max(single_adult_women_in_shelter) as women_in_shelter
from dhsproject.dhs_daily_report
group by 1
order by 1 asc;



-- in 2020 what percentage of the shelter housed families with children? 
select year(date_of_census)as year, 
	   max(total_individuals_in_shelter) as People_in_shelter, 
       max(families_with_children_in_shelter) as families_with_children_in_shelter, 
       (max(total_individuals_in_shelter)/max(families_with_children_in_shelter) *100) as percentage_of_families_with_children
from dhsproject.dhs_daily_report
where year(date_of_census) = '2020'
group by 1
order by 1;

-- in 2022 what percentage of the shelter housed families with children? 
select year(date_of_census)as year, 
	   max(total_individuals_in_shelter) as People_in_shelter, 
       max(families_with_children_in_shelter) as families_with_children_in_shelter, 
       (max(total_individuals_in_shelter)/max(families_with_children_in_shelter) *100) as percentage_of_families_with_children
from dhsproject.dhs_daily_report
where year(date_of_census) = '2022'
group by 1
order by 1;

-- is the percentage of families with children increasing per year? 
select year(date_of_census) as year, 
		max(total_individuals_in_shelter) as people,
        max(families_with_children_in_shelter) as families_with_children,
        (max(total_individuals_in_shelter)/max(families_with_children_in_shelter)*100) as percent_of_families_with_children
from dhsproject.dhs_daily_report
group by 1
order by 1 asc;

-- is the percentage of adult families in dhs increasing per year?

/*What constitutes an adult family?
"The Department of Homeless Services (DHS) considers an adult family to be any family without minor children, including the following household compositions:

Applicants who are a legally married couple and present a valid original marriage certificate; or
Applicants who are a domestic partners couple and present a valid original domestic partnership certificate; or
Adults who provide, as part of their application for Temporary Housing Assistance, proof establishing the medical dependence of one applicant upon another;
Two or more adults who can provide birth certificates to prove a parent and child or sibling family relationship or share a "caretaking" (emotionally or physically supportive) relationship, including:
aunt or uncle to niece or nephew
grandparent to grandchild
parent to child or stepchild 
siblings" - source:https://www.nyc.gov/site/dhs/shelter/families/adult-families.page#:~:text=The%20Department%20of%20Homeless%20Services,valid%20original%20marriage%20certificate%3B%20or
*/

select year(date_of_census) as year, 
		max(total_individuals_in_shelter) as individuals,
        max(adult_families_in_shelter) as adult_families,
        (max(total_individuals_in_shelter)/max(adult_families_in_shelter)*100) as percent_of_adult_families
from dhsproject.dhs_daily_report
group by 1
order by 1 asc;




/*
Creating Tableau Views */

-- comparison of number of single men, single women and children in DHS per year: 
create view women_men_children_in_dhs_per_year
as
select year(date_of_census) as year, 
	   max(total_children_in_shelter) as children_in_shelter, 
       max(single_adult_men_in_shelter) as men_in_shelter,
       max(single_adult_women_in_shelter) as women_in_shelter
from dhsproject.dhs_daily_report
group by 1
order by 1 asc;


-- is the percentage of families with children  in dhs increasing per year?: 
create view percent_of_families_with_children_in_dhs
as
select year(date_of_census) as year,
	max(families_with_children_in_shelter) as families_with_children,
    max(total_individuals_in_shelter) as individuals,
    max(families_with_children_in_shelter)/max(total_individuals_in_shelter) * 100 as percent_of_families_with_children
from dhsproject.dhs_daily_report
group by 1
order by 1 asc;


-- is the percentage of adult families in dhs increasing per year?
create view percent_of_adult_families_in_dhs_per_year
as
select year(date_of_census) as year,
	max(adult_families_in_shelter) as adult_families,
    max(total_individuals_in_shelter) as individuals,
    max(adult_families_in_shelter)/max(total_individuals_in_shelter) * 100 as percent_of_adult_families
from dhsproject.dhs_daily_report
group by 1
order by 1 asc;


