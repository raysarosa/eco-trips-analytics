-- 1. Total Monthly Revenue
SELECT
  EXTRACT(YEAR FROM booking_date) AS year,
  FORMAT_DATE('%B', DATE(booking_date)) AS month,
  ROUND(SUM(price * number_of_people),2) AS total_revenue
FROM `carbide-cairn-465215-h6.online_platform.offers` ofr
INNER JOIN `carbide-cairn-465215-h6.online_platform.bookings` b ON ofr.offer_id = b.offer_id
WHERE LOWER(status) = "completed"
GROUP BY 1,2, EXTRACT(MONTH FROM booking_date)
ORDER BY 1 DESC, EXTRACT(MONTH FROM booking_date) DESC;

-- 2.1 Average Amount Spent per Customer: 276.88
SELECT
  ROUND(SUM(price * number_of_people) / SUM(number_of_people), 2) AS avg_price_per_person
FROM `carbide-cairn-465215-h6.online_platform.offers` ofr
INNER JOIN `carbide-cairn-465215-h6.online_platform.bookings` b ON ofr.offer_id = b.offer_id
WHERE LOWER(status) = "completed";

-- 2.2 Median Amount Spent per Customer: 275.36
SELECT
  PERCENTILE_CONT(price, 0.5) OVER() AS median_price_per_person
FROM `carbide-cairn-465215-h6.online_platform.offers` ofr
INNER JOIN `carbide-cairn-465215-h6.online_platform.bookings` b ON ofr.offer_id = b.offer_id
WHERE LOWER(status) = "completed"
LIMIT 1;

-- Considering that Average (sensitive to outliers) and Median (not sensitive to outliers) has almost the same price,
-- it means that the customers are deciding for Offers with similar prices, classifying them  as Economic.

-- 3. Which offers are most popular with travelers?

-- 3.1 Bookings Distribution: Activity = 990 x Accomodation = 1010 | Travellers Distribution: Activity = 2888 x Accomodation = 2956
SELECT
  offer_type,
  COUNT(booking_id) AS total_bookings,
  SUM(number_of_people) AS total_travellers
FROM `carbide-cairn-465215-h6.online_platform.offers` ofr
INNER JOIN `carbide-cairn-465215-h6.online_platform.bookings` b ON ofr.offer_id = b.offer_id
GROUP BY 1;

-- 4. Customer Repeat Rate
-- 4.1 Count bookings per customer
WITH customer_bookings AS(
  SELECT
    customer_id,
    COUNT(*) AS bookings_per_customer
  FROM `carbide-cairn-465215-h6.online_platform.bookings`
  WHERE LOWER(status) = "completed"
  GROUP BY 1
)

-- 4.2 Use the CTE to calculate the repeat rate
SELECT
  COUNTIF(bookings_per_customer > 1) AS repeat_customers,
  COUNT(*) AS total_customers,
  ROUND(
      SAFE_DIVIDE(
      COUNTIF(bookings_per_customer > 1),
      COUNT(*)
    ),3
   ) * 100 AS customer_repeat_percentage
FROM customer_bookings;

-- 5. Best Performing Offers, considering at least 2 reviews
SELECT
  o.offer_id,
  offer_type,
  title,
  COUNT(*) rating_qtt,
  ROUND(AVG(rating),2) AS avg_rating
FROM `carbide-cairn-465215-h6.online_platform.offers` o
INNER JOIN `carbide-cairn-465215-h6.online_platform.bookings` b ON o.offer_id = b.offer_id AND LOWER(status) = "completed"
LEFT JOIN `carbide-cairn-465215-h6.online_platform.reviews` r ON o.offer_id = r.offer_id
GROUP BY 1,2,3
HAVING COUNT(*) > 1
ORDER BY 5 DESC;

-- 5.1 More detailed solution
SELECT
  o.offer_id,
  booking_id,
  offer_type,
  title,
  COUNT(review_id) rating_quantity,
  ROUND(AVG(rating),2) AS avg_rating,
  CASE
    WHEN COUNT(DISTINCT booking_id) = 0 THEN "No completed booking"
    WHEN COUNT(DISTINCT booking_id) > 0 AND COUNT(DISTINCT review_id) = 0 THEN "Completed booking, but no review"
    ELSE "Booking completed and more than 1 review"
  END AS offer_status
FROM `carbide-cairn-465215-h6.online_platform.offers` o
LEFT JOIN `carbide-cairn-465215-h6.online_platform.bookings` b ON o.offer_id = b.offer_id AND LOWER(status) = "completed"
LEFT JOIN `carbide-cairn-465215-h6.online_platform.reviews` r ON o.offer_id = r.offer_id
GROUP BY 1,2,3,4
ORDER BY 6 DESC;

-- 6. Index of Sustainable Practices Adoption: Qnt of Offers with Sustainable Practices / Total Offers
SELECT
  ROUND(COUNT(DISTINCT offer_id)/ (
      SELECT
        COUNT(DISTINCT offer_id) AS total_offer
      FROM `carbide-cairn-465215-h6.online_platform.offers`
  ),2) * 100 AS sustainable_index
FROM `carbide-cairn-465215-h6.online_platform.offer_practice`;

-- 7. Top Sustainable Practices
SELECT
  name,
  COUNT(DISTINCT booking_id) AS total_bookings
FROM `carbide-cairn-465215-h6.online_platform.offer_practice` op
INNER JOIN `carbide-cairn-465215-h6.online_platform.sustainable_practice` s ON op.practice_id = s.practice_id
INNER JOIN `carbide-cairn-465215-h6.online_platform.bookings` b ON b.offer_id = op.offer_id AND LOWER(status) = "completed"
GROUP BY 1
ORDER BY 2 DESC;

-- 8. Average Interval Between Bookings for Returning Customers
WITH filtered_booking AS(
  SELECT
    customer_id,
    booking_date,
  FROM `carbide-cairn-465215-h6.online_platform.bookings`
  WHERE LOWER(status) = "completed" AND
  customer_id IN (
    SELECT  
      customer_id
    FROM `carbide-cairn-465215-h6.online_platform.bookings`
    WHERE LOWER(status) = "completed"
    GROUP BY customer_id
    HAVING COUNT(booking_id) > 1  
  )
),

diff_booking_time AS(
  SELECT
    customer_id,
    DATE_DIFF(
      booking_date,
      LAG(booking_date) OVER (PARTITION BY customer_id ORDER BY booking_date),
      DAY
    ) AS diff_days,
    booking_date
  FROM filtered_booking
)

SELECT
  customer_id,
  ROUND(AVG(diff_days),2) AS avg_booking_days
FROM diff_booking_time
WHERE diff_days IS NOT NULL
GROUP BY 1;

-- 9. Average Performance of the Operators
WITH completed_bookings AS(
  SELECT
    DISTINCT offer_id
  FROM `carbide-cairn-465215-h6.online_platform.bookings`
  WHERE LOWER(status) = "completed"
)

SELECT
  operator_name,
  offer_type,
  ROUND(AVG(rating),2) AS avg_rating
FROM `carbide-cairn-465215-h6.online_platform.operators` op
INNER JOIN `carbide-cairn-465215-h6.online_platform.offers` ofr ON op.operator_id = ofr.operator_id
INNER JOIN `carbide-cairn-465215-h6.online_platform.reviews` r ON ofr.offer_id = r.offer_id
INNER JOIN completed_bookings cb ON cb.offer_id = ofr.offer_id
GROUP BY 1,2
ORDER BY 2,3 DESC;

  
