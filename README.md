#Maven Rail Challenge

Welcome to the Maven Rail Challenge! In this project, I played the role of a BI Developer for National Rail, a company providing business services to passenger train operators in England, Scotland, and Wales. My task was to create an exploratory dashboard to help the management team gain insights into various aspects of their operations.

Dataset contains Mock train ticket data for National Rail in the UK, from Dec 2023 to Apr 2024, including details on the type of ticket, the date & time for each journey, the departure & arrival stations, the ticket price and
more.

This exploratory analysis will provide insights which will further aid into making better decisions.

#Below are the few objectives of the report:

1. Customer Loyalty and Retention Analysis
   Analyze customer loyalty and retention by identifying repeat customers, measuring their purchase frequency, and evaluating their impact on revenue over time.
   
2. Impact of Journey Time on Customer Satisfaction
   Analyze how the actual journey time (from departure to actual arrival) impacts customer satisfaction, assuming delays reduce satisfaction levels (where satisfaction decreases as delay increases (e.g., -1 satisfaction point per 10 minutes of delay).
   
3. Profitability Analysis Based on Ticket
   Type and Class Perform a profitability analysis based on ticket type and class, with dynamic filtering to show insights for different periods or stations (consider 55% of the ticket price is the cost of a ticket.
   
4. Frequent Traveler Analysis with Dynamic Segmentation
   Identify and analyze frequent travelers dynamically segmented by the number of journeys they made.
   
5. Analyzing Delays to Optimize Train Schedule
   Optimize train schedules to minimize delays. To achieve this, you need to analyze the average delay for trains by the hour of the day, considering that delays can vary based on the time of departure.

6. Analysis based on Revenue, Performance, Journey anmd Travelers.


#Key Measures created as part of the analysis:

1.	Most Unsatisfied Customers = 
	  CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Customer Satisfaction Score] <= -6))

2.	Refunds = 
	  CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Refund_Request] = "Yes"))

3.	Satisfied Customers = 
	  CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Journey_Status] = "On Time"))

4.	Total no of Trains Cancelled = 
  	CALCULATE(
  	COUNTROWS(Railway), 
  	Railway[Journey_Status] = "Cancelled")

5.	Total no of Trains Delayed = 
  	CALCULATE(
  	COUNTROWS('Railway'),
  	'Railway'[Journey_Status] = "Delayed")


6.	Total no of Trains On-Time = 
  	CALCULATE(
  	COUNTROWS(Railway),
  	Railway[Journey_Status] = "On Time")

7.	Total no. of Journeys/Customers = 
  	COUNTROWS(Railway)

8.	Users with RailCard = 
	  CALCULATE(COUNTROWS(Railway), Railway[Railcard] <> "None")

9.	Users without RailCard = 
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


16.	CurrentMonthBooking = 
  	CALCULATE (
  	COUNT('Railway'[Transaction_ID]),
  	DATESMTD('Calendar'[Date]))

17.	£ CurrentMonthRevenue = 
  	CALCULATE (
  	SUM(Railway[Price]),
  	DATESMTD('Calendar'[Date]))

18.	Customer_Gain_Loss = 
  	[CurrentMonthBooking] - [PreviousMonthBooking]


19.	£ Net Revenue = 
  	[Total Revenue]- [Revenue from Refunds]

20.	PreviousMonthBooking = 
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

24.	Tickets Sold = COUNTROWS('Railway')

25.	£ Total Cost = SUM(Railway[Cost])

26.	£ Total Profit = SUM(Railway[Profit])

27.	£ Total Revenue = SUM('Railway'[Price])


#Insights on Revenue Analysis:

1.	Total Revenue generated by Booking is £7,41,921. Although Total Refunds amounts to £38,702, hence Net Revenue generated is £7,03,219.
2. 	Total Cost incurred in Booking is £4,08,057.
3.	 8,400 Customers are gained in January Month generating a highest revenue gain of £2,04,399 and 1,097 of the customers were reduced in February, March has gained 763 and April again lost 352 customers.
4.	Profits Made:
	Overall Profit made on Bookings is £3,34,864
		•	Most by Ticket Type - £1,39,173 by Advance.
		•	Most by Ticket Class - £2,66,634 by Standard.
5.	Out of 31,653 Journeys, 86.82% of the trips ended On-Time,  7.24% of the trains were delayed, 5.94% were cancelled and 3.5% tickets were refunded.
6.	Most revenue generated : 
		•	by Month - January generated the most revenue £1,99,618, although there is a sudden drop noticed in the next month February which only generated £1,59,374.
		•	by Route - £1,83,193 by London Kings Cross – York.
		•	by Ticket Type - £3,09,274 by Advance.
		•	by Ticket Class - £5,92,552 by Standard.
		•	by Rail-Card -  £86,330 in Adult category, without Rail-Card £5,73,697. 
		•	by Purchase Type - Online bookings £3,82,754 generated more revenue than Offline bookings (£3,59,167).
		•	by Payment Method - £4,69,511 by Credit Cards.
7. 	While the Manchester Piccadilly to Liverpool Lime Street route may be the most popular in terms of ticket bookings, the route from London Kings Cross to York emerges as the highest revenue generator and route Liverpool Lime Street - London Euston has the most 	refunds requested.


#Insights on Performance Analysis:

1.	Most Refund requests are raised in March (306).
2.	Most Delays and Cancellations also happened in the month of March (1,137 instances).
3.	Weather conditions are the primary cause of delays (927 out of 1,372 instances), while  Signal Failure (519 out of 970 instances) and Staff Shortage (454 out of 809 instances) are the main reasons for train cancellations. Signal Failures and Staffing are the 	reasons of concerns which can be looked into for service optimization and improving customer satisfaction
4.	Route "Liverpool Lime Street - London Euston" has the most number of delays (780) and most number of refund requests raised (171).
5.	Route "Manchester Piccadilly- Liverpool Lime Street" has the most number of bookings (4,628). but it also has most cancellations, (290) as well as the most number of On-Time Trips (3,984).
6.	Highest Average Delay by Time is 116 minutes at 9AM

	
#Insights on Journey Analysis:

1.	Most number of Bookings are done Online in Advance using Credit Cards.
2.	Peak-Hours for ticket booking: 6 AM to 8AM (8,086 tickets were booked) in the morning and then again 4 PM to 6PM in the evening  (8,302 tickets were booked). This indicates that most passengers book tickets to travel to their workplaces or offices in the 		morning and return home in the evening.
3 	There are 12 Departure Stations and 32 Arrival Destinations with overall 65 Routes.
4.	January has the highest bookings (8,434) followed by March (8,100) but most number of advance bookings are done in February (5,328)
5. 	In Weeks, Sunday  Wednesday has the most bookings (4,692), followed by Tuesday (4,607) and Sunday and Thursday (4,580).
6.  	Most Popular Route: The route from Manchester Piccadilly to Liverpool Lime Street is the most popular in terms of travels.

#Insights on Travelers Analysis:

1.	27,499 Trips are found under 0 Min Delay i.e. On-Time, However as per Journey Status, only 27,481 Trips are On-Time, this means 18 Trip Status are not provided properly or incorrect data, which needs to be looked into.
2.	 66.09% (20,918 out of 31,653) of travelers does not have a Rail-Card, only 33.91% (10,735 out of 31,653) travelers hold a Rail-Card. 
3. 	In the Top 5 routes, travelers with no Rail-Card has the most bookings, Senior Rail-Card Holder is the 2nd highest travelers in the first route but gradually shifted to the last position in the remaining routes,.
4.	In Rail-Card, Adult category has the most holdings (4,846) followed by Disabled (3,089) and Senior (2,800).
5.	Out of 31,653 travelers, 27,481 are satisfied with On-Time Tripes and 353  travelers faced a delay between 1 hour to 3 hours and are extremely unsatisfied.
6. 	Highest Delay In minutes is 180 minutes, which corresponds to least satisfaction score of -18.
7. 	When Departure Time is more than 5PM or less than 7AM, Avg Delay is decreased, also when  Departure Time is between 7AM to 11AM, Avg Delay is increased.
8. 	Avg satisfaction score increases when the sum of Delay decreases, which is expected.
9.  	Avg satisfaction score increases when the journey time is 110 Mins or less, whereas decreases when the  journey time is between 150 Min to 225 Mins.
    

