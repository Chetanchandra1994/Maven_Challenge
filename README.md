Maven Rail Challenge

Welcome to the Maven Rail Challenge! In this project, I played the role of a BI Developer for National Rail, a company providing business services to passenger train operators in England, Scotland, and Wales. My task was to create an exploratory dashboard to help the management team gain insights into various aspects of their operations.

Dataset contains Mock train ticket data for National Rail in the UK, from Jan to Apr 2024.


Project Overview
The goal of this project is to build a Power BI dashboard that provides valuable insights into the performance and operations of National Rail. The dashboard should be interactive and allow the management team to explore various metrics and trends.

Objectives
The dashboard should help the management team:

Identify the Most Popular Routes:
Visualize the top routes based on passenger numbers.
Highlight the routes with the highest revenue.

Determine Peak Travel Times:
Analyze passenger traffic by time of day, day of the week, and season.
Identify patterns and trends in travel times.

Analyze Revenue from Different Ticket Types & Classes:
Break down revenue by ticket type (e.g., advance, off-peak, anytime).
Compare revenue generated from different ticket classes (e.g., standard, first class).

Diagnose On-Time Performance and Contributing Factors:
Evaluate the punctuality of trains.
Investigate the reasons for delays and their frequency.

Data Sources
The project uses the following data sources (fictional for the purpose of this challenge):
Ticket Sales Data: Contains information about ticket sales, including date, time, route, ticket type, and class.
Passenger Data: Includes data on passenger numbers for different routes and times.
Revenue Data: Details revenue generated from various ticket types and classes.
Performance Data: Provides insights into on-time performance and reasons for delays.

Key Measures created as part of the analysis:

1.	# Most Unsatisfied Customers = 
	  CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Customer Satisfaction Score] <= -6))

2.	# Refunds = 
	  CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Refund_Request] = "Yes"))

3.	# Satisfied Customers = 
	  CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Journey_Status] = "On Time"))

4.	# Total no of Trains Cancelled = 
  	CALCULATE(
  	COUNTROWS(Railway), 
  	Railway[Journey_Status] = "Cancelled")

5.	# Total no of Trains Delayed = 
  	CALCULATE(
  	COUNTROWS('Railway'),
  	'Railway'[Journey_Status] = "Delayed")


6.	# Total no of Trains On-Time = 
  	CALCULATE(
  	COUNTROWS(Railway),
  	Railway[Journey_Status] = "On Time")

7.	# Total no. of Journeys/Customers = 
  	COUNTROWS(Railway)

8.	# Users with RailCard = 
	  CALCULATE(COUNTROWS(Railway), Railway[Railcard] <> "None")

9.	# Users without RailCard = 
	  CALCULATE(COUNTROWS(Railway), Railway[Railcard] = "None")

10.	% of Trains Delayed = 
  	DIVIDE(
  	[# Total no of Trains Delayed],
  	[# Total no. of Journeys/Customers],
  	0)

11.	% of Trains On-Time = 
  	DIVIDE(
  	[# Total no of Trains On-Time],
  	[# Total no. of Journeys/Customers],
  	0) 


12.	% Tickets Refunded = 
	  DIVIDE([# Refunds], [# Total no. of Journeys/Customers])

13.	% Trains Cancelled = 
	  DIVIDE([# Total no of Trains Cancelled], [# Total no. of Journeys/Customers])


14.	% Users With RailCard = 
	  DIVIDE(CALCULATE(COUNTROWS(Railway), Railway[Railcard] <> "None"), COUNTROWS(Railway))


15.	% Users Without RailCard = 
	  DIVIDE(CALCULATE(COUNTROWS(Railway), Railway[Railcard] = "None"), COUNTROWS(Railway))


16.	# CurrentMonthBooking = 
  	CALCULATE (
  	COUNT('Railway'[Transaction_ID]),
  	DATESMTD('Calendar'[Date]))

17.	£ CurrentMonthRevenue = 
  	CALCULATE (
  	SUM(Railway[Price]),
  	DATESMTD('Calendar'[Date]))

18.	# Customer_Gain_Loss = 
  	[CurrentMonthBooking] - [PreviousMonthBooking]


19.	£ Net Revenue = 
  	[Total Revenue]- [Revenue from Refunds]

20.	# PreviousMonthBooking = 
  	CALCULATE(
  	COUNT('Railway'[Transaction_ID]),
  	PREVIOUSMONTH('Calendar'[Date]))
  

21.	£ PreviousMonthRevenue = 
  	CALCULATE(
  	SUM('Railway'[# Revenue]),
  	PREVIOUSMONTH('Calendar'[Date]))


22.	£ Revenue from Refunds = 
  	CALCULATE(SUM(Railway[Price]), FILTER(Railway, Railway[Refund_Request] = "Yes"))


23.	£ Revenue_Gain_Loss = 
  	[CurrentMonthRevenue] - [PreviousMonthRevenue]

24.	# Tickets Sold = COUNTROWS('Railway')

25.	£ Total Cost = SUM(Railway[Cost])

26.	£ Total Profit = SUM(Railway[Profit])

27.	£ Total Revenue = SUM('Railway'[Price])

