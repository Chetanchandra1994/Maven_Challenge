# UK Railway Analysis

In this project, I played the role of a BI Developer for National Rail, a company providing business services to passenger train operators in England, Scotland, and Wales. My task was to create an exploratory dashboard to help the management team gain insights into various aspects of their operations.

![Revenue_Analysis](https://github.com/Chetanchandra1994/Maven_Challenge/assets/71788058/629f0829-89f1-43ab-857e-65c13026b5cf)


![Performance_Analysis](https://github.com/Chetanchandra1994/Maven_Challenge/assets/71788058/3f0e1734-6533-49ca-a9b2-7294b38f98cd)


![Journey Analysis](https://github.com/Chetanchandra1994/Maven_Challenge/assets/71788058/6566a34d-2553-41c1-875f-f7deb417ba3b)


![Travelers Analysis](https://github.com/Chetanchandra1994/Maven_Challenge/assets/71788058/a81bfec3-cf2e-461d-b707-19d5c22136f5)

## Railway Data Dictionary 

### Fields and Descriptions

- **Transaction ID**: Unique identifier for an individual train ticket purchase.
- **Date of Purchase**: Date the ticket was purchased.
- **Time of Purchase**: Time the ticket was purchased.
- **Purchase Type**: Whether the ticket was purchased online or directly at a train station.
- **Payment Method**: Payment method used to purchase the ticket (Contactless, Credit Card, or Debit Card).
- **Railcard**: Whether the passenger is a National Railcard holder (Adult, Senior, or Disabled) or not (None). Railcard holders get 1/3 off their ticket purchases.
- **Ticket Class**: Seat class for the ticket (Standard or First).
- **Ticket Type**: Type of ticket purchased:
  - **Advance**: Tickets purchased at least a day prior to departure, at a discount.
  - **Off-Peak**: Tickets used outside of peak hours, at a discount.
  - **Anytime**: Full-price tickets that can be used at any time during the day.
- **Price**: Final cost of the ticket.
- **Departure Station**: Station where the passenger boards the train.
- **Arrival Destination**: Station where the passenger exits the train.
- **Date of Journey**: Date the train departed.
- **Departure Time**: Time the train departed.
- **Arrival Time**: Scheduled time the train was supposed to arrive at its destination (can be on the day after departure).
- **Actual Arrival Time**: Time the train actually arrived at its destination (can be on the day after departure).
- **Journey Status**: Whether the train was on time, delayed, or cancelled.
- **Reason for Delay**: Reason provided for the delay or cancellation.
- **Refund Request**: Whether the passenger requested a refund after a delay or cancellation.


## Objectives of the Report

### 1. Customer Loyalty and Retention Analysis

Analyze customer loyalty and retention by identifying repeat customers, measuring their purchase frequency, and evaluating their impact on revenue over time.

### 2. Impact of Journey Time on Customer Satisfaction

Analyze how the actual journey time (from departure to actual arrival) impacts customer satisfaction, assuming delays reduce satisfaction levels (where satisfaction decreases as delay increases (e.g., -1 satisfaction point per 10 minutes of delay).

### 3. Profitability Analysis Based on Ticket Type and Class

Perform a profitability analysis based on ticket type and class, with dynamic filtering to show insights for different periods or stations (consider 55% of the ticket price is the cost of a ticket).

### 4. Frequent Traveler Analysis with Dynamic Segmentation

Identify and analyze frequent travelers dynamically segmented by the number of journeys they made.

### 5. Analyzing Delays to Optimize Train Schedule

Optimize train schedules to minimize delays. To achieve this, you need to analyze the average delay for trains by the hour of the day, considering that delays can vary based on the time of departure.

### 6. Analysis Based on Revenue, Performance, Journey, and Travelers

Identifying revenue, profit, cost generated, train performance and routes, customer payment methods, services etc 


## Data Preparation and Transformation

#### Data Cleaning

The dataset underwent thorough cleaning using Power Query Editor and M code to ensure accuracy and consistency:

- Duplicate columns were removed, invalid characters were corrected, and errors were resolved.
- Null values were handled meticulously to maintain data integrity.
- Data types and formats were standardized, including setting date columns to YYYY-MM-DD format and correcting decimal values for uniformity.
- Sorting and filtering techniques were applied to align the dataset with project requirements, enhancing data usability and relevance.

#### Data Transformation

The transformation process involved implementing DAX measures and calculated columns to derive crucial metrics essential for railway performance analysis:

- Multiple measures were created to quantify revenue, operational efficiency, route performance, and the impact of delays on customer satisfaction.
- These calculated metrics provided actionable insights into patterns, trends, and areas for improvement within the dataset.
- Stakeholders were empowered with the ability to make informed decisions based on these insights.

## Report Layout

The report is structured across four main pages to facilitate comprehensive analysis:

- Revenue Analysis: Focuses on sales trends, revenue generation, and performance metrics.
- Performance Analysis: Provides insights into operational efficiency, route performance, and factors affecting service reliability.
- Journey Analysis: Analyzes the best and worst-performing routes based on various metrics, enabling optimization strategies.
- Travelers Analysis: Examines traveler demographics, satisfaction levels, and preferences to enhance customer experience and service offerings.

By organizing the report in this manner, key stakeholders gain a holistic view of National Rail's operations, enabling strategic decision-making and continuous improvement efforts.

## Key Measures Created

```DAX
1. Most Unsatisfied Customers = 
   CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Customer Satisfaction Score] <= -6))

2. Refunds = 
   CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Refund_Request] = "Yes"))

3. Satisfied Customers = 
   CALCULATE(COUNTROWS(Railway), FILTER(Railway, Railway[Journey_Status] = "On Time"))

4. Total no of Trains Cancelled = 
   CALCULATE(COUNTROWS(Railway), Railway[Journey_Status] = "Cancelled")

5. Total no of Trains Delayed = 
   CALCULATE(COUNTROWS('Railway'), 'Railway'[Journey_Status] = "Delayed")

6. Total no of Trains On-Time = 
   CALCULATE(COUNTROWS(Railway), Railway[Journey_Status] = "On Time")

7. Total no. of Journeys/Customers = 
   COUNTROWS(Railway)

8. Users with RailCard = 
   CALCULATE(COUNTROWS(Railway), Railway[Railcard] <> "None")

9. Users without RailCard = 
   CALCULATE(COUNTROWS(Railway), Railway[Railcard] = "None")

10. % of Trains Delayed = 
    DIVIDE([# Total no of Trains Delayed], [# Total no. of Journeys/Customers], 0)

11. % of Trains On-Time = 
    DIVIDE([# Total no of Trains On-Time], [# Total no. of Journeys/Customers], 0)

12. % Tickets Refunded = 
    DIVIDE([# Refunds], [# Total no. of Journeys/Customers])

13. % Trains Cancelled = 
    DIVIDE([# Total no of Trains Cancelled], [# Total no. of Journeys/Customers])

14. % Users With RailCard = 
    DIVIDE(CALCULATE(COUNTROWS(Railway), Railway[Railcard] <> "None"), COUNTROWS(Railway))

15. % Users Without RailCard = 
    DIVIDE(CALCULATE(COUNTROWS(Railway), Railway[Railcard] = "None"), COUNTROWS(Railway))

16. CurrentMonthBooking = 
    CALCULATE ( COUNT('Railway'[Transaction_ID]), DATESMTD('Calendar'[Date]))

17. £ CurrentMonthRevenue = 
    CALCULATE ( SUM(Railway[Price]), DATESMTD('Calendar'[Date]))

18. Customer_Gain_Loss = 
    [CurrentMonthBooking] - [PreviousMonthBooking]

19. £ Net Revenue = 
    [Total Revenue] - [Revenue from Refunds]

20. PreviousMonthBooking = 
    CALCULATE( COUNT('Railway'[Transaction_ID]), PREVIOUSMONTH('Calendar'[Date]))

21. £ PreviousMonthRevenue = 
    CALCULATE( SUM('Railway'[# Revenue]), PREVIOUSMONTH('Calendar'[Date]))

22. £ Revenue from Refunds = 
    CALCULATE(SUM(Railway[Price]), FILTER(Railway, Railway[Refund_Request] = "Yes"))

23. £ Revenue_Gain_Loss = 
    [CurrentMonthRevenue] - [PreviousMonthRevenue]

24. Tickets Sold = 
    COUNTROWS('Railway')

25. £ Total Cost = 
    SUM(Railway[Cost])

26. £ Total Profit = 
    SUM(Railway[Profit])

27. £ Total Revenue = 
    SUM('Railway'[Price])
```

## Insights on Revenue Analysis

- Total Revenue generated by Booking is £7,41,921. Although Total Refunds amount to £38,702, hence Net Revenue generated is £7,03,219.
- Total Cost incurred in Booking is £4,08,057.
- 8,400 Customers were gained in January, generating the highest revenue gain of £2,04,399, and 1,097 customers were reduced in February. March gained 763 customers, and April again lost 352 customers.

#### Profits Made:

- Overall Profit made on Bookings is £3,34,864.
- Most by Ticket Type: £1,39,173 by Advance.
- Most by Ticket Class: £2,66,634 by Standard.

#### Out of 31,653 Journeys:

- 86.82% of the trips ended On-Time.
- 7.24% of the trains were delayed.
- 5.94% were cancelled.
- 3.5% of tickets were refunded.

#### Most revenue generated:

- By Month: January generated the most revenue £1,99,618, although there is a sudden drop noticed in the next month, February, which only generated £1,59,374.
- By Route: £1,83,193 by London Kings Cross – York.
- By Ticket Type: £3,09,274 by Advance.
- By Ticket Class: £5,92,552 by Standard.
- By Rail-Card: £86,330 in Adult category, without Rail-Card £5,73,697.
- By Purchase Type: Online bookings £3,82,754 generated more revenue than Offline bookings (£3,59,167).
- By Payment Method: £4,69,511 by Credit Cards.

## Insights on Performance Analysis

- Most Refund requests are raised in March (306).
- Most Delays and Cancellations also happened in the month of March (1,137 instances).
- Weather conditions are the primary cause of delays (927 out of 1,372 instances), while Signal Failure (519 out of 970 instances) and Staff Shortage (454 out of 809 instances) are the main reasons for train    
  cancellations. Signal Failures and Staffing are the reasons of concerns which can be looked into for service optimization and improving customer satisfaction.
- Route "Liverpool Lime Street - London Euston" has the most number of delays (780) and the most number of refund requests raised (171).
- Route "Manchester Piccadilly- Liverpool Lime Street" has the most number of bookings (4,628), but it also has the most cancellations (290) as well as the most number of On-Time Trips (3,984).
- Highest Average Delay by Time is 116 minutes at 9AM.

## Insights on Journey Analysis

- Most number of bookings are done Online in Advance using Credit Cards.
- Peak-Hours for ticket booking: 6 AM to 8 AM (8,086 tickets were booked) in the morning and then again 4 PM to 6 PM in the evening (8,302 tickets were booked). This indicates that most passengers book tickets to travel 
  to their workplaces or offices in the morning and return home in the evening.
- There are 12 Departure Stations and 32 Arrival Destinations with overall 65 Routes.
- January has the highest bookings (8,434) followed by March (8,100), but most number of advance bookings are done in February (5,328).
- In Weeks, Sunday and Wednesday have the most bookings (4,692), followed by Tuesday (4,607), Sunday, and Thursday (4,580).
- Most Popular Route: The route from Manchester Piccadilly to Liverpool Lime Street is the most popular in terms of travels.

## Insights on Travelers Analysis

- 27,499 Trips are found under 0 Min Delay i.e., On-Time. However, as per Journey Status, only 27,481 Trips are On-Time. This means 18 Trip Statuses are not provided properly or incorrect data, which needs to be looked into.
- 66.09% (20,918 out of 31,653) of travelers do not have a Rail-Card, only 33.91% (10,735 out of 31,653) travelers hold a Rail-Card.
- In the Top 5 routes, travelers with no Rail-Card have the most bookings. Senior Rail-Card Holder is the 2nd highest travelers in the first route but gradually shifted to the last position in the remaining routes.
- In Rail-Card, Adult category has the most holdings (4,846) followed by Disabled (3,089) and Senior (2,800).
- Out of 31,653 travelers, 27,481 are satisfied with On-Time Trips, and 353 travelers faced a delay between 1 hour to 3 hours and are extremely unsatisfied.
- Highest Delay in minutes is 180 minutes, which corresponds to the least satisfaction score of -18.
- When Departure Time is more than 5 PM or less than 7 AM, Avg Delay is decreased. Also, when Departure Time is between 7 AM to 11 AM, Avg Delay is increased.
- Avg satisfaction score increases when the sum of Delay decreases, which is expected.
- Avg satisfaction score increases when the journey time is 110 Mins or less, whereas decreases when the journey time is between 150 Min to 225 Min.




![Example Image]("Home page.png")
