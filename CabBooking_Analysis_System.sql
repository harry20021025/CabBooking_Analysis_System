/* ============================================================
   CAR BOOKING SYSTEM – SQL ANALYSIS QUERIES WITH EXPLANATIONS
   Created by: Hariom Dixit
   ============================================================ */


/* 1. Find all customers who have made more than one booking */
SELECT c.name, COUNT(b.booking_id) AS total_bookings
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id
HAVING COUNT(b.booking_id) > 1;
/*
Explanation:
Displays customers who have booked more than once using GROUP BY and HAVING.
*/


/* 2. Retrieve customer details who never completed any booking */
SELECT c.name
FROM Customers c
LEFT JOIN Bookings b ON c.customer_id = b.customer_id AND b.status = 'Completed'
WHERE b.booking_id IS NULL;
/*
Explanation:
Uses LEFT JOIN to find customers with no completed bookings.
*/


/* 3. Show each customer’s latest booking date and status */
SELECT c.name, MAX(b.booking_time) AS last_booking, b.status
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
GROUP BY c.name;
/*
Explanation:
Shows each customer’s most recent booking time along with its status.
*/


/* 4. List all drivers along with their cab type and license plate */
SELECT d.name AS driver_name, c.vehicle_type, c.license_plate
FROM Drivers d
JOIN Cabs c ON d.driver_id = c.driver_id;
/*
Explanation:
Displays each driver’s name with their vehicle type and registration number.
*/


/* 5. Find the driver(s) who have the highest rating */
SELECT name, rating
FROM Drivers
WHERE rating = (SELECT MAX(rating) FROM Drivers);
/*
Explanation:
Finds the driver(s) whose rating equals the maximum rating value.
*/


/* 6. Count how many bookings each driver completed */
SELECT d.name, COUNT(b.booking_id) AS completed_rides
FROM Drivers d
JOIN Cabs c ON d.driver_id = c.driver_id
JOIN Bookings b ON c.cab_id = b.cab_id
WHERE b.status = 'Completed'
GROUP BY d.name;
/*
Explanation:
Counts completed rides for each driver by joining Drivers, Cabs, and Bookings.
*/


/* 7. Find drivers who never completed any trip */
SELECT d.name
FROM Drivers d
WHERE d.driver_id NOT IN (
  SELECT c.driver_id
  FROM Cabs c
  JOIN Bookings b ON c.cab_id = b.cab_id
  WHERE b.status = 'Completed'
);
/*
Explanation:
Displays drivers who have no completed trips using a NOT IN subquery.
*/


/* 8. Find average fare, total distance, and total completed trips */
SELECT 
  COUNT(*) AS total_trips,
  SUM(distance_km) AS total_distance,
  AVG(fare) AS avg_fare
FROM TripDetails;
/*
Explanation:
Provides summary statistics for trips using aggregate functions.
*/


/* 9. Calculate total earnings for each driver */
SELECT d.name, SUM(t.fare) AS total_earnings
FROM Drivers d
JOIN Cabs c ON d.driver_id = c.driver_id
JOIN Bookings b ON c.cab_id = b.cab_id
JOIN TripDetails t ON b.booking_id = t.booking_id
GROUP BY d.name;
/*
Explanation:
Joins multiple tables to calculate total earnings per driver.
*/


/* 10. Identify which day had the highest number of bookings */
SELECT DAYNAME(booking_time) AS day, COUNT(*) AS total_bookings
FROM Bookings
GROUP BY DAYNAME(booking_time)
ORDER BY total_bookings DESC
LIMIT 1;
/*
Explanation:
Counts bookings per weekday and sorts to find the busiest day.
*/


/* 11. Find trips where fare per km was less than ₹15/km */
SELECT trip_id, distance_km, fare, (fare / distance_km) AS fare_per_km
FROM TripDetails
WHERE (fare / distance_km) < 15;
/*
Explanation:
Calculates fare per kilometer for each trip and filters those under ₹15/km.
*/


/* 12. Show number of bookings per month */
SELECT MONTHNAME(booking_time) AS month, COUNT(*) AS total_bookings
FROM Bookings
GROUP BY MONTHNAME(booking_time);
/*
Explanation:
Displays how many bookings were made each month.
*/


/* 13. Find how many rides were cancelled by each customer */
SELECT c.name, COUNT(b.booking_id) AS cancelled_rides
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
WHERE b.status = 'Cancelled'
GROUP BY c.name;
/*
Explanation:
Shows total number of cancelled rides for each customer.
*/


/* 14. List customers who cancelled more than 1 ride and reasons */
SELECT c.name, f.cancel_reason, COUNT(f.booking_id) AS times_cancelled
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
JOIN Feedback f ON b.booking_id = f.booking_id
WHERE f.cancel_reason IS NOT NULL
GROUP BY c.name, f.cancel_reason
HAVING COUNT(f.booking_id) > 1;
/*
Explanation:
Displays customers who cancelled rides multiple times with their reasons.
*/


/* 15. Show average customer rating per driver */
SELECT d.name AS driver_name, AVG(f.rating) AS avg_rating
FROM Drivers d
JOIN Cabs c ON d.driver_id = c.driver_id
JOIN Bookings b ON c.cab_id = b.cab_id
JOIN Feedback f ON b.booking_id = f.booking_id
WHERE f.rating IS NOT NULL
GROUP BY d.name;
/*
Explanation:
Calculates the average feedback rating received by each driver.
*/


/* 16. List top 3 highest-rated trips */
SELECT f.booking_id, f.rating, f.comments
FROM Feedback f
WHERE f.rating IS NOT NULL
ORDER BY f.rating DESC
LIMIT 3;
/*
Explanation:
Retrieves top 3 rides with the highest customer ratings and comments.
*/


/* 17. Find all cancel reasons and how many times each occurred */
SELECT cancel_reason, COUNT(*) AS total_occurrences
FROM Feedback
WHERE cancel_reason IS NOT NULL
GROUP BY cancel_reason;
/*
Explanation:
Groups all cancellation reasons and counts their occurrences.
*/


/* 18. Show customer name, driver name, cab type, fare, and distance for all completed trips */
SELECT 
  cu.name AS customer_name,
  d.name AS driver_name,
  c.vehicle_type,
  t.distance_km,
  t.fare
FROM Customers cu
JOIN Bookings b ON cu.customer_id = b.customer_id
JOIN Cabs c ON b.cab_id = c.cab_id
JOIN Drivers d ON c.driver_id = d.driver_id
JOIN TripDetails t ON b.booking_id = t.booking_id
WHERE b.status = 'Completed';
/*
Explanation:
Displays full details of completed trips with customer and driver info.
*/


/* 19. Identify the customer who spent the most money overall */
SELECT c.name, SUM(t.fare) AS total_spent
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
JOIN TripDetails t ON b.booking_id = t.booking_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;
/*
Explanation:
Calculates total money spent per customer and shows the top spender.
*/


/* 20. Show percentage of Completed vs Cancelled bookings */
SELECT 
  status,
  COUNT(*) AS total,
  ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Bookings)), 2) AS percentage
FROM Bookings
GROUP BY status;
/*
Explanation:
Calculates percentage share of each booking status type.
*/