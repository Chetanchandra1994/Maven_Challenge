# Maven Rail Challenge

Welcome to the Maven Rail Challenge! In this project, I played the role of a BI Developer for National Rail, a company providing business services to passenger train operators in England, Scotland, and Wales. My task was to create an exploratory dashboard to help the management team gain insights into various aspects of their operations.

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
