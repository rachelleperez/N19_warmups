-- Get a list of the 3 long-standing customers for each country

** TRIAL 1 - DIDNT WORK ***

Select c.country, c.customerid, o.orderdate, rank () over (partition by c.country order by o.orderdate asc) as rank
From customers c inner join orders o using(customerid)
having rank in (1,2,3)
Order by c.country, c.customerid, rank;


** QUERY ***

WITH longest_standing_by_country AS (
    Select c.country, c.customerid, o.orderdate, rank () over (partition by c.country order by o.orderdate asc) as rank
    From customers c inner join orders o using(customerid)
    Order by c.country, c.customerid, rank

)

SELECT *
FROM longest_standing_by_country 
WHERE rank in (1, 2, 3) 
ORDER BY country,rank, customerid;


*** ANSWER ***

   country   | customerid |      orderdate      | rank
-------------+------------+---------------------+------
 Argentina   | OCEAN      | 2015-01-09 08:00:00 |    1
 Argentina   | RANCH      | 2015-02-17 10:00:00 |    2
 Argentina   | CACTU      | 2015-04-29 17:00:00 |    3
 Austria     | ERNSH      | 2014-07-17 00:00:00 |    1
 Austria     | ERNSH      | 2014-07-23 10:00:00 |    2
 Austria     | ERNSH      | 2014-11-11 06:00:00 |    3
 Belgium     | SUPRD      | 2014-07-09 01:00:00 |    1
 Belgium     | SUPRD      | 2014-09-10 17:00:00 |    2
 Belgium     | SUPRD      | 2015-02-26 00:00:00 |    3
 Brazil      | HANAR      | 2014-07-08 15:00:00 |    1
 Brazil      | HANAR      | 2014-07-10 08:00:00 |    2
 Brazil      | WELLI      | 2014-07-15 22:00:00 |    3
 ...




-- Modify the previous query to get the 3 newest customers in each each country.

*** QUERY ***

WITH newest_customer_by_country AS (
    Select c.country, c.customerid, o.orderdate, rank () over (partition by c.country order by o.orderdate desc) as rank
    From customers c inner join orders o using(customerid)
    Order by c.country, c.customerid, rank

)

SELECT *
FROM newest_customer_by_country 
WHERE rank in (1, 2, 3) 
ORDER BY country,rank, customerid;

*** ANSWER ***

   country   | customerid |      orderdate      | rank
-------------+------------+---------------------+------
 Argentina   | CACTU      | 2016-04-28 13:00:00 |    1
 Argentina   | RANCH      | 2016-04-13 09:00:00 |    2
 Argentina   | OCEAN      | 2016-03-30 00:00:00 |    3
 Austria     | ERNSH      | 2016-05-05 15:00:00 |    1
 Austria     | PICCO      | 2016-04-27 06:00:00 |    2
 Austria     | ERNSH      | 2016-04-13 12:00:00 |    3
 Belgium     | SUPRD      | 2016-04-21 18:00:00 |    1
 Belgium     | SUPRD      | 2016-04-20 15:00:00 |    2
 Belgium     | MAISD      | 2016-04-07 19:00:00 |    3
 Brazil      | QUEEN      | 2016-05-04 16:00:00 |    1
 Brazil      | RICAR      | 2016-04-29 05:00:00 |    2
 Brazil      | HANAR      | 2016-04-27 02:00:00 |    3
 Canada      | BOTTM      | 2016-04-24 13:00:00 |    1
 Canada      | BOTTM      | 2016-04-23 21:00:00 |    2
 Canada      | BOTTM      | 2016-04-16 09:00:00 |    3
...


-- Get the 3 most frequently ordered products in each city

*** QUERY ***

WITH products_by_country AS (
Select c.country, c.city, od.productid, sum(quantity) over (partition by c.country, c.city, od.quantity), 
rank() over(partition by country,city order by sum(quantity) desc)
From customers c inner join orders o using(customerid) inner join orderdetails od using(orderid)
GROUP BY c.country, c.city, od.productid, od.quantity
Order by c.country, c.city, od.productid)

SELECT * FROM products_by_country WHERE rank IN (1,2,3) ORDER BY country, city, rank, productid;

*** ANSWER ***

   country   |      city       | productid | sum | rank
-------------+-----------------+-----------+-----+------
 Argentina   | Buenos Aires    |        11 |  30 |    1
 Argentina   | Buenos Aires    |         5 | 120 |    2
 Argentina   | Buenos Aires    |        34 | 120 |    2
 Argentina   | Buenos Aires    |        40 | 120 |    2
 Argentina   | Buenos Aires    |        57 | 120 |    2
 Argentina   | Buenos Aires    |        67 | 120 |    2
 Argentina   | Buenos Aires    |        75 | 120 |    2
 Austria     | Graz            |        39 | 260 |    1
 Austria     | Graz            |        64 | 260 |    1
 Austria     | Graz            |        51 | 240 |    3
 Austria     | Graz            |        61 | 240 |    3
 Austria     | Salzburg        |        38 | 150 |    1
 Austria     | Salzburg        |        69 | 150 |    1
 Austria     | Salzburg        |        76 | 150 |    1
...






