
-- *****************************************************************************************************************************************************************************
-- *****************************************************************************************************************************************************************************
-- *************************************************************                     *******************************************************************************************
-- *************************************************************   RAILWAY ANALYSIS  *******************************************************************************************
-- *************************************************************                     *******************************************************************************************
-- *****************************************************************************************************************************************************************************
-- *****************************************************************************************************************************************************************************

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create database Learnbay_Placement_Project;

--using newly created database for this roject
use Learnbay_Placement_Project;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- creating table schema to load the data 

create table Railway (
Transaction_ID varchar(max),
Date_of_Purchase varchar(max),
Time_of_Purchase varchar(max),
Purchase_Type varchar(max),
Payment_Method varchar(max),
Railcard varchar(max),
Ticket_Class varchar(max),
Ticket_Type varchar(max),
Price varchar(max),
Departure_Station varchar(max),
Arrival_Destination varchar(max),
Date_of_Journey varchar(max),
Departure_Time varchar(max),
Arrival_Time varchar(max),
Actual_Arrival_Time varchar(max),
Journey_Status varchar(max),
Reason_for_Delay varchar(max),
Refund_Request varchar(max)
);

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from Railway;

-- we can see table is empty now 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- inserting data into the table using bulk insert

Bulk insert Railway
from 'C:\Users\Admin\Documents\LearnBayCourse\Placement Project\railway.csv'
with (fieldterminator = ',',
	  rowterminator = '\n',
	  firstrow = 2);

-- (31653 rows affected) means table contains 31653 rows of data

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- First we will create a backup of the original table to ensure we don't lose any data during the process:

select * into Railway_Backup from Railway;
select * from Railway_Backup;
select * from Railway;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- let's see all the columns and its datatype

select Column_name, Data_type
from Information_schema.columns
where table_name in ('Railway');

--Output:

/*
Column_name			Data_type
Transaction_ID		varchar
Date_of_Purchase	varchar
Time_of_Purchase	varchar
Purchase_Type		varchar
Payment_Method		varchar
Railcard			varchar
Ticket_Class		varchar
Ticket_Type			varchar
Price				varchar
Departure_Station	varchar
Arrival_Destination	varchar
Date_of_Journey		varchar
Departure_Time		varchar
Arrival_Time		varchar
Actual_Arrival_Time	varchar
Journey_Status		varchar
Reason_for_Delay	varchar
Refund_Request		varchar
*/

-- Here we can see we have 18 columns, out of which Price should be in decimal datatype and columns with date and time values should be of date and time datatypes respectiely.
-- Remaining 11 columns can be kept as varchar as they contain categorical values..

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- We will start with data cleaning and data validation for the above columns. 

-- I am starting with Price column since we have only single column with integer values.

-- Find rows with invalid values in Price column
SELECT  Price
FROM Railway
WHERE ISNUMERIC(Price) = 0;

-- above query gave 5 values as invalid data, so we will correct them
/*
Price
31&^
3--
4ú
3$
16A
*/

update Railway
set Price = '31' where Price  = '31&^';

-- similarly we will corerect other values as well.
update Railway
set Price = '3' where Price  = '3--';

update Railway
set Price = '4' where Price  = '4ú';

update Railway
set Price = '3' where Price  = '3$';

update Railway
set Price = '16' where Price  = '16A';

--- let's cross verify for any remaining invalid data

SELECT  Price
FROM Railway
WHERE ISNUMERIC(Price) = 0;

-- it it's returning 0 rows , hence all data is correct, so we will change the datatype now

alter table Railway
alter column Price decimal(10,2);

-- revalidate the datatype of Price column
select Price from Railway;

-- it is now showing price with 2 decimal places for vales so all good

-- let's check Price coluimn for its datatype
select Column_name, Data_type
from Information_schema.columns
where table_name in ('Railway');

-- it is now showing as decimal so all good.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Let's analyse the date and time columns now-- we have below columns with date and time values
-- Date columns: Date_of_Purchase , Date_of_Journey 
-- Time columns: Time_of_Purchase, Departure_Time , Arrival_Time , Actual_Arrival_Time

-- let's check the date columns first, starting with Date_of_Purchase

-- first let's check for null values

select * from Railway
where Date_of_Purchase is null;

-- it is returning 0 rows means no null values

-- Find rows with invalid Date_of_Purchase
-- let's check the non-date values in Date_of_Purchase

select Date_of_Purchase from Railway
where ISDATE(Date_of_Purchase)=0;

-- this query gives 17,866 rows having values in the format dd-mm-yyyy.
-- We need all the date in this column to be in the correct date format so that this can be converted into correct date datatype.
-- we need all dates in the format yyyy-mm-dd

-- we can also see this column values 

select Date_of_Purchase
from Railway;

-- since most values are in the format dd-mm-yyyy, so we will check for any value not following the same pattern

select Date_of_Purchase
from Railway
where Date_of_Purchase not like '__-__-____';

-- we found below value not following the pattern so we have to correct the data
/*

Date_of_Journey
31-12%2023

*/

update Railway
set Date_of_Purchase = '31-12-2023'
where Date_of_Purchase = '31-12%2023';

-- let's revalidate for any missing invalid format or whether above code worked fine or not

select Date_of_Purchase
from Railway
where Date_of_Purchase not like '__-__-____';

-- it is returning 0 rows means data conversion worked fine.

-- cross verifying for null values
select Date_of_Purchase from Railway
where Date_of_Purchase is null;


-- now we will try to convert all values to correct date format(yyyy-mm-dd) using try_convert function and check it using select statement
select
Date_of_Purchase,
TRY_CONVERT(date, Date_of_Purchase, 105) as converted_date
from Railway;

-- since it is not giving any error we will upate the date values using update command.
update Railway
set Date_of_Purchase = TRY_CONVERT(date, Date_of_Purchase, 105);

--Output: (31653 rows affected) means all rows of data are converted to correct date format

-- finally we will alter the table and column to change to date format.
alter table Railway
alter column Date_of_Purchase date;

select * from Railway;

select Column_name, Data_type
from Information_schema.columns
where table_name in ('Railway');
-- We can see the datatype is now showing as Date for the column Date_of_Purchase
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- similary we will check for the date column Date_of_Journey

-- first let's check for null values

select * from Railway
where Date_of_Journey is null;

-- it is returning 0 rows means no null values

select Date_of_Journey
from Railway;

-- it is returning rows where values is in format dd-mm-yyyy, so we will check for any values not following the same pattern

select Date_of_Journey
from Railway
where Date_of_Journey not like '__-__-____';


-- we found below two values not following the pattern so we updated the value manually

/*

Date_of_Journey
04*02-2024
06--02-2024

*/

update Railway
set Date_of_Journey = '04-02-2024'
where Date_of_Journey = '04*02-2024';

update Railway
set Date_of_Journey = '06-02-2024'
where Date_of_Journey = '06--02-2024';

-- let's revalidate for any missing invalid format or whether above code worked fine or not

select Date_of_Journey
from Railway
where Date_of_Journey not like '__-__-____';

-- it is returning 0 rows means data conversion worked fine.

-- now we will try to convert all values to correct date format using try_convert function and check it using select statement

select
Date_of_Journey,
TRY_CONVERT(date, Date_of_Journey, 105) as converted_date
from Railway;


-- this time we will create a function called 'fn_ConvertDateFormat' to update the values for the column Date_of_Journey

CREATE FUNCTION dbo.fn_Convert_Date_Format (@Date VARCHAR(10))
RETURNS DATE
AS
BEGIN
    DECLARE @ConvertedDate DATE;
    SET @ConvertedDate = TRY_CONVERT(date, @Date, 105);
    RETURN @ConvertedDate;
END;
GO


/*
1. The purpose of this function is to convert the values in the Date_of_Journey column from dd-mm-yyyy format to a DATE type.
2. "@Date VARCHAR(10)" takes a single input parameter named @Date of type VARCHAR(10)
3. the function will return a value of type DATE
4. here we have declared a local variable "@ConvertedDate" of DATE datatype. This variable will hold the result of the conversion.
5. TRY_CONVERT attempts to convert the input parameter(@Date) to the specified data type(Date).
*/

-- we will now use the created function 'dbo.fn_ConvertDateFormat' to update the values for the column Date_of_Journey

UPDATE Railway
SET Date_of_Journey = dbo.fn_Convert_Date_Format(Date_of_Journey);

-- output: (31653 rows affected)
-- Means the values are converted to the Date datatype

-- let's revalidate for any missing invalid format or whether above code worked fine or not

select Date_of_Journey from Railway
where ISDATE(Date_of_Journey)=0;

-- it is returning 0 rows means data conversion worked fine.

-- finally we will alter the table and column to change to date format.
alter table Railway
alter column Date_of_Journey date;

--revalidating for null values during conversion
select * from Railway
where Date_of_Journey is null;

-- no nulls so all good

select * from Railway;

select Column_name, Data_type
from Information_schema.columns
where table_name in ('Railway');

-- We can see the datatype is now showing as Date for the column Date_of_Journey

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Let's analyse the time columns now-- we have below columns with time values
-- Time columns: Time_of_Purchase, Departure_Time , Arrival_Time , Actual_Arrival_Time

--i am starting with Time_of_Purchase

-- first let's check for null values

select Time_of_Purchase
from Railway
where Time_of_Purchase is null;

-- it returned 0 rows so no null values

-- lets check its column values

select Time_of_Purchase from Railway;

-- all values are in format hh:mm:ss

-- we will cross check if any value is not following the pattern

select * from Railway
where Time_of_Purchase not like '__:__:__';

-- it is returning 0 rows so all values are good to be converted

-- lets convert to standard time format before converting the datatype to time.

select
Time_of_Purchase,
TRY_CONVERT(time, Time_of_Purchase, 108) as converted_time
from Railway;
-- we can see all values are converted with no error

-- changing the values to correct format 
update Railway
set Time_of_Purchase = TRY_CONVERT(time, Time_of_Purchase, 108);

-- output: (31653 rows affected)
-- Means the values are converted to the correct Time format successfully

-- updating datatype from varchar to time

alter table Railway
alter column Time_of_Purchase time;

-- 
select Column_name, Data_type
from Information_schema.columns
where table_name in ('Railway');

-- We can see the datatype is now showing as Time for the column Time_of_Purchase

-------------------------------------------------------------------------------------------------------------------------------------------------


-- similary we will check for the other time columns as well: Departure_Time , Arrival_Time , Actual_Arrival_Time

-- first let's check for null values

select Departure_Time
from Railway
where Departure_Time is null;

-- it returned 0 rows so no null values

-- lets check its column values
select Departure_Time from Railway;

-- all values are in format hh:mm:ss

-- we will cross check if any value is not following the pattern

select Departure_Time from Railway
where Departure_Time not like '__:__:__';

/*

Output: It returned 1 row with invalid data
Departure_Time
18:45::00

*/

-- correcting invalid data using update command

update Railway
set Departure_Time = '18:45:00'
where Departure_Time = '18:45::00';

-- revalidating for invalid characters
select Departure_Time from Railway
where Departure_Time not like '__:__:__';

-- it is returning 0 rows so all values are good to be converted

-- lets convert to standard time format before converting the datatype to time.

select
Departure_Time,
TRY_CONVERT(time, Departure_Time, 108) as converted_time
from Railway;
-- we can see all values are converted with no error

-- changing the values to correct format 
update Railway
set Departure_Time = TRY_CONVERT(time, Departure_Time, 108);

-- output: (31653 rows affected)
-- Means the values are converted to the correct Time format successfully

-- updating datatype from varchar to time

alter table Railway
alter column Departure_Time time;

--revalidating for null values during conversion
select * from Railway
where Departure_Time is null;

-- no nulls so all good

-- see column values
select Departure_Time from Railway;

select Column_name, Data_type
from Information_schema.columns
where table_name in ('Railway');

-- We can see the datatype is now showing as Time for the column Departure_Time


-------------------------------------------------------------------------------------------------------------------------------------------------

-- now we are left with 2 other time columns: Arrival_Time , Actual_Arrival_Time

-- first let's check for null values for the column Arrival_Time

select Arrival_Time
from Railway
where Arrival_Time is null;

-- it returned 0 rows so no null values

-- lets check its column values
select Arrival_Time from Railway;

-- all values are in format hh:mm:ss

-- we will cross check if any value is not following the pattern

select Arrival_Time from Railway
where Arrival_Time not like '__:__:__';

-- it is returning 0 rows so all values are good 

-- lets convert to standard time format before converting the datatype to time.

select
Arrival_Time,
TRY_CONVERT(time, Arrival_Time, 108) as converted_time
from Railway;
-- we can see all values are converted with no error

-- this time we will create a function called 'fn_Convert_Time_Format' to update the values for the column Arrival_Time

create function fn_Convert_Time_Format (@Time Varchar(8))
returns Time
as
begin
	declare @Converted_Time Time;
	set @Converted_Time = try_convert(time, @Time, 108);
	return @Converted_Time;
end;
go


/*
1. The purpose of this function is to convert the values in the Date_of_Journey column from dd-mm-yyyy format to a DATE type.
2. "@Date VARCHAR(10)" takes a single input parameter named @Date of type VARCHAR(10)
3. the function will return a value of type DATE
4. here we have declared a local variable "@ConvertedDate" of DATE datatype. This variable will hold the result of the conversion.
5. TRY_CONVERT attempts to convert the input parameter(@Date) to the specified data type(Date).
*/

-- we will now use the created function 'dbo.fn_Convert_Time_Format' to update the values for the column Arrival_Time

update Railway
set Arrival_Time = dbo.fn_Convert_Time_Format (Arrival_Time);

-- output: (31653 rows affected)
-- Means the values are converted to the correct Time format successfully

-- updating datatype from varchar to time

alter table Railway
alter column Arrival_Time time;

--revalidating for null values during conversion
select * from Railway
where Arrival_Time is null;

-- no nulls so all good

-- see column values
select Arrival_Time from Railway;

select Column_name, Data_type
from Information_schema.columns
where table_name in ('Railway');

-- We can see the datatype is now showing as Time for the column Arrival_Time

-------------------------------------------------------------------------------------------------------------------------------------------------

-- now last column: Actual_Arrival_Time

-- first let's check for null values for column Actual_Arrival_Time

select Actual_Arrival_Time
from Railway
where Actual_Arrival_Time is null;

-- Output: (1880 rows affected)
-- means we have 1880 null values

-- lets analyse the column Actual_Arrival_Time

select Actual_Arrival_Time
from Railway;

-- all values are in format hh:mm:ss

-- we will cross check if any value is not following the pattern

select Actual_Arrival_Time from Railway
where Actual_Arrival_Time not like '__:__:__';

/*

Output:
Actual_Arrival_Time
21:15::00
19:15::00

*/

-- we got 2 invalid values so we will correct them

update Railway
set Actual_Arrival_Time = '21:15:00'
where Actual_Arrival_Time = '21:15::00';

update Railway
set Actual_Arrival_Time = '19:15:00'
where Actual_Arrival_Time = '19:15::00';


-- we will cross check if any value is not following the pattern

select Actual_Arrival_Time from Railway
where Actual_Arrival_Time not like '__:__:__';

-- it is returning 0 rows so all values are good 

-- lets convert to standard time format before converting the datatype to time.

select
Actual_Arrival_Time,
TRY_CONVERT(time, Actual_Arrival_Time, 108) as converted_time
from Railway;
-- we can see all values are converted with no error

-- we will now use the created function 'dbo.fn_Convert_Time_Format' to update the values for the column Actual_Arrival_Time

update Railway
set Actual_Arrival_Time = dbo.fn_Convert_Time_Format (Actual_Arrival_Time);

-- output: (31653 rows affected)
-- Means the values are converted to the correct Time format successfully

-- updating datatype from varchar to time

alter table Railway
alter column Actual_Arrival_Time time;

--revalidating for null values during conversion
select * from Railway
where Actual_Arrival_Time is null;

-- same 1880 null vales as expected since no data is supplied for them

-- see column values
select Actual_Arrival_Time from Railway;

select Column_name, Data_type
from Information_schema.columns
where table_name in ('Railway');

-- We can see the datatype is now showing as Time for the column Actual_Arrival_Time

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Final Column names and their data types

/*

Table: Railway

Column_name			Data_type
Transaction_ID		varchar
Date_of_Purchase	date
Time_of_Purchase	time
Purchase_Type		varchar
Payment_Method		varchar
Railcard			varchar
Ticket_Class		varchar
Ticket_Type			varchar
Price				decimal
Departure_Station	varchar
Arrival_Destination	varchar
Date_of_Journey		date
Departure_Time		time
Arrival_Time		time
Actual_Arrival_Time	time
Journey_Status		varchar
Reason_for_Delay	varchar
Refund_Request		varchar

*/
-------------------------------------------------------------------------------------------------------------------------------------------------
-- Time for analysing categorical columns

select distinct(Purchase_Type) from Railway;

-- Output: 
/*

Purchase_Type
Online
Station

*/

-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Payment_Method) from Railway;

-- Output: 
/*

Payment_Method
Debit Card
Credit Card
Contactless

*/
-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Railcard) from Railway;

-- Output: 
/*

Railcard
None
Disabled
Senior
Adult

*/
-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Ticket_Class) from Railway;

-- Output: 
/*

Ticket_Class
First Class
Standard

*/

-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Ticket_Type) from Railway;

-- Output: 
/*

Ticket_Type
Anytime
Advance
Off-Peak

*/

-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Departure_Station) from Railway;

-- Output: 
/*

Departure_Station
Reading
Manchester Piccadilly
London Paddington
Oxford
Edinburgh Waverley
York
Liverpool Lime Street
London Kings Cross
Birmingham New Street
Bristol Temple Meads
London St Pancras
London Euston
*/
-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Arrival_Destination) from Railway;

-- Output: 
/*

Arrival_Destination
Reading
Manchester Piccadilly
Wolverhampton
Peterborough
Swindon
Doncaster
London Paddington
Oxford
Edinburgh Waverley
Stafford
Leeds
Didcot
Leicester
York
Liverpool Lime Street
Wakefield
Durham
Warrington
Nuneaton
Edinburgh
London Kings Cross
Birmingham New Street
Bristol Temple Meads
Tamworth
Coventry
Sheffield
Cardiff Central
Crewe
Nottingham
London Waterloo
London St Pancras
London Euston

*/
-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Journey_Status) from Railway;

-- Output: 
/*

Journey_Status
On Time
Delayed
Cancelled

*/
-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Reason_for_Delay) from Railway;

-- Output: 
/*

Reason_for_Delay
Staffing
NULL
Weather
Staff Shortage
Weather Conditions
Signal Failure
Traffic
Technical Issue

*/
-- Here we can see "Weather" and "Weather Conditions" both given as Reason_for_Delay, since both are same, updating the date

update Railway
set Reason_for_Delay = 'Weather'
where Reason_for_Delay = 'Weather Conditions';

-- rechecking the values
select distinct(Reason_for_Delay) from Railway;

/*

Output:
Reason_for_Delay
Staffing
NULL
Weather
Staff Shortage
Signal Failure
Traffic
Technical Issue
*/

-- "Staffing" and "Staff Shortage" is the same.

update Railway
set Reason_for_Delay = 'Staff Shortage'
where Reason_for_Delay = 'Staffing';

-- Output: (410 rows affected)

-- rechecking the values
select distinct(Reason_for_Delay) from Railway;
-- OUTPUT:
/*
Reason_for_Delay
NULL
Weather
Staff Shortage
Signal Failure
Traffic
Technical Issue
*/

-- Replacing NULL with NA since no reasons is supplied means either no delay or data is not abailable for delay.

update Railway
set Reason_for_Delay = 'NA'
where Reason_for_Delay is null;

-- (27481 rows affected)

-- rechecking the values
select distinct(Reason_for_Delay) from Railway;

-- OUTPUT:
/*
Reason_for_Delay
Weather
NA
Staff Shortage
Signal Failure
Traffic
Technical Issue
*/

-- now it is okay

-------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(Refund_Request) from Railway;

-- Output: 
/*

Refund_Request
Yes
No

*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------  WE HAVE REFINED OUR DATA AND DONE WITH OUR DATA VALIDATION AND DATA MANIPULATION, IT'S TIME FOR SOME DATA ANALYSIS NOW -----------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM Railway;

/*
Table: Railway

Column_name			Data_type
Transaction_ID		varchar
Date_of_Purchase	date
Time_of_Purchase	time
Purchase_Type		varchar
Payment_Method		varchar
Railcard			varchar
Ticket_Class		varchar
Ticket_Type			varchar
Price				decimal
Departure_Station	varchar
Arrival_Destination	varchar
Date_of_Journey		date
Departure_Time		time
Arrival_Time		time
Actual_Arrival_Time	time
Journey_Status		varchar
Reason_for_Delay	varchar
Refund_Request		varchar
*/

--***********************************************  Part A-The SQL Analysis case study  ******************************************************************************************

/*
1.	Identify Peak Purchase Times and Their Impact on Delays: This query determines the peak times for ticket purchases and analyzes if there is any correlation with journey delays.
2.	Analyze Journey Patterns of Frequent Travelers: This query identifies frequent travelers (those who made more than three purchases) and analyzes their most common journey patterns.
3.	Revenue Loss Due to Delays with Refund Requests: This query calculates the total revenue loss due to delayed journeys for which a refund request was made.
4.	Impact of Railcards on Ticket Prices and Journey Delays: This query analyzes the average ticket price and delay rate for journeys purchased with and without railcards.
5.	Journey Performance by Departure and Arrival Stations: This query evaluates the performance of journeys by calculating the average delay time for each pair of departure and arrival stations.
6.	Revenue and Delay Analysis by Railcard and Station
This query combines revenue analysis with delay statistics, providing insights into journeys' performance and revenue impact involving different railcards and stations.
7.	Journey Delay Impact Analysis by Hour of Day
This query analyzes how delays vary across different hours of the day, calculating the average delay in minutes for each hour and identifying the peak hours for delays.

*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1.	Identify Peak Purchase Times and Their Impact on Delays: 
-- This query determines the peak times for ticket purchases and analyzes if there is any correlation with journey delays.

-- first, based on the columns we have, creating a view to have only columns we need for this analysis.
-- adding a new column to identify the time of day like morning, noon, evening and night.

/*
4am to  8am : early morning
8am to  12pm : morning
12pm to  4pm : afternoon
4pm to  8pm : evening
8pm to  12am : night
12am to  4am : Midnight
*/

create view Peak_Time_Delay_Analysis as (
	select 
		DATEPART(HOUR, Time_of_Purchase) AS Purchase_Hour,
		CASE
			WHEN DATEPART(HOUR, Time_of_Purchase) >= 4 AND DATEPART(HOUR, Time_of_Purchase) < 8 THEN 'Early Morning'
			WHEN DATEPART(HOUR, Time_of_Purchase) >= 8 AND DATEPART(HOUR, Time_of_Purchase) < 12 THEN 'Morning'
			WHEN DATEPART(HOUR, Time_of_Purchase) >= 12 AND DATEPART(HOUR, Time_of_Purchase) < 16 THEN 'Afternoon'
			WHEN DATEPART(HOUR, Time_of_Purchase) >= 16 AND DATEPART(HOUR, Time_of_Purchase) < 20 THEN 'Evening'
			WHEN DATEPART(HOUR, Time_of_Purchase) >= 20 AND DATEPART(HOUR, Time_of_Purchase) < 24 THEN 'Night'
			WHEN DATEPART(HOUR, Time_of_Purchase) >= 0 AND DATEPART(HOUR, Time_of_Purchase) < 4 THEN 'Midnight'
			ELSE 'NA'
		END as purchase_time_slot,
		Journey_Status,
		DATEPART(HOUR, Arrival_Time) AS Arrival_Hour,
		DATEPART(HOUR, Actual_Arrival_Time) AS Actual_Arrival_Hour,
		CASE
		    WHEN DATEPART(HOUR, Actual_Arrival_Time) >= 4 AND DATEPART(HOUR, Actual_Arrival_Time) < 8 THEN 'Early Morning'
			WHEN DATEPART(HOUR, Actual_Arrival_Time) >= 8 AND DATEPART(HOUR, Actual_Arrival_Time) < 12 THEN 'Morning'
			WHEN DATEPART(HOUR, Actual_Arrival_Time) >= 12 AND DATEPART(HOUR, Actual_Arrival_Time) < 16 THEN 'Afternoon'
			WHEN DATEPART(HOUR, Actual_Arrival_Time) >= 16 AND DATEPART(HOUR, Actual_Arrival_Time) < 20 THEN 'Evening'
			WHEN DATEPART(HOUR, Actual_Arrival_Time) >= 20 AND DATEPART(HOUR, Actual_Arrival_Time) < 24 THEN 'Night'
			WHEN DATEPART(HOUR, Actual_Arrival_Time) >= 0 AND DATEPART(HOUR, Actual_Arrival_Time) < 4 THEN 'Midnight'
			ELSE 'NA'
		END AS Delay_time_slot
	from Railway);

select * from Peak_Time_Delay_Analysis;
select * from Peak_Time_Delay_Analysis order by Purchase_Hour;

-- drop view Peak_Time_Delay_Analysis;

WITH PurchaseTimes AS (
    SELECT 
        purchase_time_slot, 
        COUNT(*) AS Number_of_Purchases 
    FROM Peak_Time_Delay_Analysis        
    GROUP BY purchase_time_slot      
),
DelayTimes AS (
    SELECT 
        Delay_time_slot, 
        COUNT(*) AS Delayed_Journeys 
    FROM Peak_Time_Delay_Analysis        
    WHERE Journey_Status = 'Delayed'       
    GROUP BY Delay_time_slot    
)
SELECT 
    PT.purchase_time_slot, 
    PT.Number_of_Purchases, 
    ISNULL(DT.Delayed_Journeys, 0) AS Delayed_Journeys 
FROM PurchaseTimes PT   
LEFT JOIN DelayTimes DT  
ON PT.purchase_time_slot = DT.Delay_time_slot 
ORDER BY 
    Number_of_Purchases DESC, 
    Delayed_Journeys DESC;

-- OUTPUT:

/*

purchase_time_slot	Number_of_Purchases	Delayed_Journeys
Early Morning					6446	190
Evening							6381	621
Morning							6008	1002
Afternoon						5116	334
Night							3996	114
Midnight						3706	31

*/

-- conclusion:
/*
-- Regarding Purchases:
-- peak times for ticket purchases : Early Morning, Evening and Morning
-- We could see most Number_of_Purchases is in the Early Morning(6446) i.e. 4am to  8am  (early office going people or returning to home after doing night shift)
-- followed by Evening(6381) i.e.(4pm to  8pm) (returning from office, schools or any work, most people go out in evening for outing)
-- and then Morning(6008) i.e. 8am to  12pm (this is alos ideal time for going to school or work)
-- least purchases is at night and midnight which is expected since most people will be sleeping that time and not travelling.

-- Regarding Delay:
-- Impact of purchases on Delay: None (Both columns are independent of each other)
-- Most delayed journeys are during the nmorning time(1002) i.e. 4am to  8am 
-- 2nd most delayed numbers are spotted in the Evening time(621) i.e.(4pm to  8pm)
-- 3rd most delayed slot is found in the Afternoon(334) 12pm to  4pm
-- least delays are during the night and midnight 
-- overall there is no correlation found bewtween the number of tickets purchased and number of delays.

*/
---------------------------------------- ALTERNATE SOLUTION -------------------------------------------------------------------------------

WITH PurchaseTimes AS (
    SELECT 
        DATEPART(HOUR, Time_of_Purchase) AS Purchase_Hour,
        COUNT(*) AS Number_of_Purchases
    FROM 
        Railway
    GROUP BY 
        DATEPART(HOUR, Time_of_Purchase)
),
DelayImpact AS (
    SELECT 
        DATEPART(HOUR, Actual_Arrival_Time) AS Arrival_Hour,
        COUNT(*) AS Delayed_Journeys
    FROM 
        Railway
    WHERE 
        Journey_Status = 'Delayed'
    GROUP BY 
        DATEPART(HOUR, Actual_Arrival_Time)
)
SELECT 
    PT.Purchase_Hour,
    ISNULL(PT.Number_of_Purchases, 0) AS Number_of_Purchases,
    ISNULL(DI.Delayed_Journeys, 0) AS Delayed_Journeys
FROM 
    PurchaseTimes PT
LEFT JOIN 
    DelayImpact DI
ON
	PT.Purchase_Hour = DI.Arrival_Hour
ORDER BY  Number_of_Purchases DESC, Delayed_Journeys desc;

-- OUTPUT:

/*

Purchase_Hour	Number_of_Purchases	Delayed_Journeys
	17						2740	101
	20						2239	114
	9						2070	35
	7						2046	25
	8						2008	77
	6						1910	45
	14						1869	39
	5						1566	93
	15						1468	10
	18						1425	196
	10						1187	434
	19						1160	278
	3						1107	0
	16						1056	46
	1						1032	0
	12						1025	194
	0						925		0
	4						924		27
	13						754		91
	11						743		456
	23						726		0
	2						642		31
	21						573		0
	22						458		0

*/

-- CONCLUSION:

-- Peak Purchase Hours are :	5pm, 8pm, 9am, 7am , 8am and 6am.
-- Most delays during the hours:  11am, 10am, 7pm, 6pm, 12pm and 8pm.
-- no correlation of purchasing hours with journey delays.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*

2.	Analyze Journey Patterns of Frequent Travelers: This query identifies frequent travelers (those who made more than three purchases) and analyzes their most common journey patterns.

*/

WITH UpwardJourneys AS (
    SELECT 
        count(Transaction_ID) AS total_journey,
		SUM(Price) AS Revenue,
        Departure_Station,
        Arrival_Destination
    FROM 
        Railway
	group by Departure_Station, Arrival_Destination
),
	DownwardJourneys AS (
		SELECT 
			count(Transaction_ID) AS total_journey,
			Departure_Station,
			Arrival_Destination
		FROM 
			Railway
		group by Departure_Station, Arrival_Destination
	)

SELECT 
	Revenue,
	UpwardJourneys.total_journey,
	UpwardJourneys.Departure_Station AS Departure_Station,
	DownwardJourneys.Departure_Station AS Arrival_Station
FROM 
	UpwardJourneys
JOIN 
	DownwardJourneys 
ON 
	UpwardJourneys.Departure_Station = DownwardJourneys.Arrival_Destination
	AND 
	UpwardJourneys.Arrival_Destination = DownwardJourneys.Departure_Station
order by total_journey	desc;


-- OUTPUT:

/*

total_journey	Departure_Station	Arrival_Station
	4628	Manchester Piccadilly	Liverpool Lime Street
	4209	London Euston			Birmingham New Street
	3873	London Paddington		Reading
	3471	London St Pancras		Birmingham New Street
	3002	Liverpool Lime Street	Manchester Piccadilly
	712		London Euston			Manchester Piccadilly
	702		Birmingham New Street	London St Pancras
	345		Manchester Piccadilly	London Euston
	175		Birmingham New Street	Liverpool Lime Street
	163		London Kings Cross		Edinburgh Waverley
	148		Reading					London Paddington
	144		Manchester Piccadilly	London Paddington
	125		Birmingham New Street	London Euston
	65		Birmingham New Street	York
	51		Edinburgh Waverley		London Kings Cross
	47		Birmingham New Street	Reading
	44		London Paddington		Liverpool Lime Street
	32		Reading					Birmingham New Street
	30		London Paddington		Manchester Piccadilly
	27		Liverpool Lime Street	London Paddington
	16		York					Birmingham New Street
	14		Liverpool Lime Street	Birmingham New Street

*/

-- OUTPUT

/*
Interpretation:
Most common route is from Manchester Piccadilly to	Liverpool Lime Street with maximum journey 4628.
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3.	Revenue Loss Due to Delays with Refund Requests: This query calculates the total revenue loss due to delayed journeys for which a refund request was made.

SELECT * FROM Railway;

SELECT 
	SUM(Price) as 'total revenue loss due to delayed journeys'
from Railway
where Refund_Request = 'Yes' and Journey_Status = 'Delayed';

-- OUTPUT

/*

total revenue loss due to delayed journeys
26165.00

*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4.	Impact of Railcards on Ticket Prices and Journey Delays: This query analyzes the average ticket price and delay rate for journeys purchased with and without railcards.

SELECT * FROM Railway;

With 
Y_Railcard as (
			SELECT 
				AVG(Price) as average_ticket_price,
				(select count(Journey_Status) FROM Railway where Journey_Status = 'Delayed' and Railcard <> 'None') * 100.0 
				/ 
				(select count(Journey_Status) FROM Railway where  Railcard <> 'None')  as delay_rate
			FROM Railway
			where Railcard <> 'None'),

N_Railcard as (
			SELECT 
				AVG(Price) as average_ticket_price,
				(select count(Journey_Status) FROM Railway where Journey_Status = 'Delayed' and Railcard = 'None') * 100.0 
				/ 
				(select count(Journey_Status) FROM Railway where  Railcard = 'None')  as delay_rate
			FROM Railway
			where Railcard = 'None')
select 
	average_ticket_price,
	delay_rate
FROM Y_Railcard
UNION
SELECT
	average_ticket_price,
	delay_rate
FROM N_Railcard;

-- OUTPUT:

/*


Railcard_Flag	average_ticket_price	delay_rate
With Railcard		15.670610			8.216115510013
Without Railcard	27.425996			6.740606176498

Interpretation:
When customers use a RailCard, average_ticket_price is reduced to 15.670610 where when they don't us a railcard, the  average_ticket_price is increaed to 27.425996.
*/
----------- ALTERNAT SOLUTION   --------------------------------------------------------------------------------------

SELECT 
        CASE 
            WHEN Railcard <> 'None' THEN 'With Railcard'
            ELSE 'Without Railcard'
        END AS Railcard_Flag,
        AVG(Price) AS average_ticket_price,
        100.0 * SUM(CASE WHEN Journey_Status = 'Delayed' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS delay_rate
FROM 
        Railway
GROUP BY 
        CASE 
            WHEN Railcard <> 'None' THEN 'With Railcard'
            ELSE 'Without Railcard'
		END;



-- OUTPUT:

/*

Railcard_Flag	average_ticket_price	delay_rate
With Railcard		15.670610			8.216115510013
Without Railcard	27.425996			6.740606176498

Interpretation:
When customers use a RailCard, average_ticket_price is reduced to 15.670610 where when they don't us a railcard, the  average_ticket_price is increaed to 27.425996.
*/


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5.	Journey Performance by Departure and Arrival Stations: This query evaluates the performance of journeys by calculating the average delay time for each pair of departure and arrival stations.

SELECT * FROM Railway;
	
WITH JourneyPerformance AS (
    SELECT 
        Departure_Station,
        Arrival_Destination,
        AVG(DATEDIFF(minute, Arrival_Time, Actual_Arrival_Time)) AS average_delay_time
    FROM 
        Railway
    WHERE 
        Journey_Status = 'Delayed' AND
        Actual_Arrival_Time IS NOT NULL
    GROUP BY 
        Departure_Station, Arrival_Destination
)
SELECT 
    Departure_Station,
    Arrival_Destination,
    ISNULL(average_delay_time, 0) AS average_delay_time  -- Handle cases where there's no delay
FROM 
    JourneyPerformance
order by average_delay_time	desc;

--OUTPUT

/*

Departure_Station			Arrival_Destination			average_delay_time
Manchester Piccadilly		Leeds							143
York						Doncaster						68
Manchester Piccadilly		Liverpool Lime Street			67
London Euston				Birmingham New Street			54
Manchester Piccadilly		Nottingham						53
Liverpool Lime Street		London Paddington				38
London Euston				York							36
Liverpool Lime Street		London Euston					36
London Paddington			Reading							35
Birmingham New Street		London Euston					31
York						Durham							30
Birmingham New Street		Manchester Piccadilly			26
Manchester Piccadilly		London Euston					24
Liverpool Lime Street		Manchester Piccadilly			21
Oxford						Bristol Temple Meads			19
London Kings Cross			York							16
Edinburgh Waverley			London Kings Cross				15
York
Wakefield						12

*/

/*
Interpretation:
average_delay_time is maximum when the route is from Manchester Piccadilly to Leeds 143 Minutes.

*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 6.	Revenue and Delay Analysis by Railcard and Station
-- This query combines revenue analysis with delay statistics, providing insights into journeys' performance and revenue impact involving different railcards and stations.

--SELECT * FROM Railway;

SELECT 
	Railcard,
	Arrival_Destination as station,
	SUM(Price) AS total_revenue,
	cast(100.0 * SUM(CASE WHEN Journey_Status = 'Delayed' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0)  as decimal(10,2)) AS delay_rate    
FROM 
	Railway
GROUP BY 
	Railcard,  Arrival_Destination
	order by Railcard, Arrival_Destination;
	 
-- OUTPUT:

/*

Railcard	station	total_revenue	delay_rate
Adult	Birmingham New Street	14950.00	9.14
Adult	Bristol Temple Meads	1323.00	0.00
Adult	Edinburgh	1268.00	0.00
Adult	Leeds	1487.00	40.51
Adult	Leicester	1363.00	0.00
Adult	Liverpool Lime Street	9648.00	5.53
Adult	London Euston	22058.00	54.17
Adult	London Kings Cross	1444.00	0.00
Adult	London Paddington	871.00	100.00
Adult	London St Pancras	630.00	0.00
Adult	Manchester Piccadilly	14409.00	22.47
Adult	Nottingham	140.00	100.00
Adult	Oxford	41.00	0.00
Adult	Reading	3952.00	0.00
Adult	Sheffield	726.00	0.00
Adult	York	12020.00	6.08
Disabled	Birmingham New Street	8703.00	8.22
Disabled	Doncaster	906.00	7.88
Disabled	Durham	982.00	0.00
Disabled	Edinburgh Waverley	6084.00	0.00
Disabled	Liverpool Lime Street	232.00	0.00
Disabled	London Kings Cross	535.00	0.00
Disabled	London Paddington	437.00	0.00
Disabled	London St Pancras	9598.00	0.00
Disabled	Manchester Piccadilly	12226.00	0.49
Disabled	Peterborough	1488.00	0.00
Disabled	Reading	3920.00	9.41
Disabled	Wakefield	148.00	100.00
Disabled	Wolverhampton	2734.00	0.00
Disabled	York	4285.00	0.00
None	Birmingham New Street	80554.00	0.74
None	Bristol Temple Meads	1283.00	0.00
None	Cardiff Central	98.00	0.00
None	Coventry	269.00	0.00
None	Doncaster	405.00	30.43
None	Durham	917.00	17.20
None	Edinburgh	3246.00	0.00
None	Edinburgh Waverley	404.00	0.00
None	Leeds	1227.00	0.00
None	Liverpool Lime Street	20221.00	10.33
None	London Euston	124131.00	72.17
None	London Kings Cross	2093.00	100.00
None	London Paddington	20676.00	0.00
None	London St Pancras	12880.00	0.00
None	London Waterloo	343.00	0.00
None	Manchester Piccadilly	49724.00	0.00
None	Nottingham	2068.00	0.00
None	Nuneaton	2184.00	0.00
None	Oxford	13567.00	0.00
None	Peterborough	9276.00	0.00
None	Reading	55019.00	1.10
None	Sheffield	919.00	0.00
None	Stafford	1365.00	0.00
None	Swindon	3548.00	0.00
None	Tamworth	1726.00	0.00
None	Warrington	53.00	0.00
None	Wolverhampton	60.00	0.00
None	York	165441.00	3.64
Senior	Birmingham New Street	1843.00	0.00
Senior	Bristol Temple Meads	253.00	100.00
Senior	Crewe	1563.00	0.00
Senior	Didcot	212.00	0.00
Senior	Durham	84.00	0.00
Senior	Leicester	5991.00	0.00
Senior	Liverpool Lime Street	3655.00	1.27
Senior	London Euston	4564.00	58.75
Senior	London Paddington	281.00	0.00
Senior	London St Pancras	744.00	0.00
Senior	Manchester Piccadilly	1920.00	0.00
Senior	Oxford	160.00	0.00
Senior	Reading	4689.00	0.57
Senior	York	3657.00	0.88

*/


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7.	Journey Delay Impact Analysis by Hour of Day
-- This query analyzes how delays vary across different hours of the day, calculating the average delay in minutes for each hour and identifying the peak hours for delays.

SELECT * FROM Railway;

-- Step 1: Calculate the delay in minutes for each journey
WITH JourneyDelays AS (
    SELECT
        Transaction_ID,
        DATEPART(HOUR, Arrival_Time) AS Arrival_Hour,
        DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) AS Delay_In_Minutes
    FROM
        Railway
    WHERE
        Journey_Status = 'Delayed'
)

-- Step 2: Analyze delays by hour of the day
SELECT
    Arrival_Hour,
    AVG(Delay_In_Minutes) AS Average_Delay_In_Minutes,
    COUNT(*) AS Number_Of_Delays
FROM
    JourneyDelays
GROUP BY
    Arrival_Hour
ORDER BY
    COUNT(*) DESC;

-- OUTPUT

/*

Arrival_Hour	Average_Delay_In_Minutes	Number_Of_Delays
		10				42						626
		19				15						282
		11				53						255
		9				70						254
		17				49						252
		18				52						150
		12				29						114
		5				23						108
		8				23						47
		16				33						46
		7				48						42
		6				28						37
		4				21						33
		1				36						17
		15				19						15
		2				34						14

*/

/*
Interpretation:
Most Number_Of_Delays is found during 10AM arrival time which is 626, with Average_Delay_In_Minutes around 42 Mionutes.

*/

