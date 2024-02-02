create database food;                  # database creating of name food
use foods;                              # using the food database
# Basic SQL Queries
#find all the productions 
select* from worldfood;

# Find the sum of productions for each country in each year
SELECT 
    country,
    year,
    SUM(Sugarcane_Production + Soybeans_Production + Rye_Production + Potatoes_Production + Oranges_Production + Peas_dry_Production + Palm_oil_Production + Grapes_Production + Coffee_green_Production + Cocoa_beans_Production + Meat_chicken_Production + Bananas_Production + Avocados_Production + Apples_Production) AS Total_production
FROM
    worldfood
GROUP BY country , year;

# find the country with the highest apple production in each year
SELECT 
    country, year
FROM
    worldfood
GROUP BY country , year
HAVING MAX(apples_production);

# find the country who have maximum apple_production btween year 2000 to 2002
SELECT 
    country, year
FROM
    worldfood where year between 2000 and 2002
GROUP BY country , year
HAVING MAX(apples_production);


# Advanced Sql Queries

#find the maximum apple productions using window functions
select
 country, year ,max(apples_production) 
 over()
 as max_grapes_production 
 from
 worldfood ;
 
select 
country ,max(apples_production)
 over(partition by year )
 as max_grapes_production 
 from
 worldfood ;
 
  # Fetch the query first production of each country with year
 
  select * from ( 
 select
 *, 
 row_number() over(partition by country)
 as rn 
 from 
 worldfood) as x
 where x.rn < 2;
 
 # fetch a query to display the pervious year and the next year consumption of rice and maize productions of each country 
 
 select country , year,maize_production,
 lag(Maize_production, 1 , 0) over (partition by country order by year desc) as Previous_maize_production, 
 lead(Maize_production) over (partition by country order by year desc) as Next_maize_production, rice_production,
 lag(Rice_production, 1 , 0) over (partition by country order by year desc) as Previous_rice_production, 
 lead(Rice_production) over (partition by country order by year desc) as Next_rice_production,
 row_number() over(partition by country) as SNO
 from worldfood ;
 
 # fetch a query to display if the production of rice and maize is higher, lower or equal to the previous year across all countries
 
 select country , year,maize_production,
 lag(Maize_production, 1 , 0) over (partition by country order by year desc) as Previous_maize_production, 
 case when worldfood.maize_production > lag(Maize_production, 1 , 0) over (partition by country order by year desc) then ' Maize_production is higher'
      when worldfood.maize_production < lag(Maize_production, 1 , 0) over (partition by country order by year desc) then ' Maize_production is lower'
      when worldfood.maize_production = lag(Maize_production, 1 , 0) over (partition by country order by year desc) then ' Maize_production is equal'
      end Consumption_range_of_Maize,
      rice_production,
 lag(Rice_production, 1 , 0) over (partition by country order by year desc) as Previous_rice_production, 
  case when worldfood.rice_production > lag(rice_production, 1 , 0) over (partition by country order by year desc) then ' Rice_production is higher'
      when worldfood.rice_production < lag(rice_production, 1 , 0) over (partition by country order by year desc) then ' Rice_production is lower'
      when worldfood.rice_production = lag(rice_production, 1 , 0) over (partition by country order by year desc) then ' Rice_production is equal'
      end Consumption_range_of_rice,
 row_number() over(partition by country) as SNO
 from worldfood ;