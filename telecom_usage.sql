---- creating table---
DROP TABLE IF EXISTS telecom_usage
CREATE TABLE telecom_usage (
  user_id SERIAL PRIMARY KEY,
  customer_id INT,
  region VARCHAR(30),
  plan_type VARCHAR(30) CHECK (plan_type in ( 'Postpaid', 'Prepaid')),
  call_minutes INT,
  sms_count INT,
  data_mb INT,
  charge_amount NUMERIC(10,2),
  usage_date DATE

);



---- Insert_data-----
INSERT INTO telecom_usage (customer_id,region,plan_type,call_minutes,sms_count,data_mb,charge_amount,usage_date)
VALUES
(101, 'Dhaka', 'Prepaid', 12, 5, 300, 45.00, '2025-01-01'),
(101, 'Dhaka', 'Prepaid', 20, 2, 500, 60.00, '2025-01-02'),
(102, 'Chittagong', 'Postpaid', 50, 10, 1000, 120.00, '2025-01-01'),
(103, 'Dhaka', 'Prepaid', 5, 0, 150, 20.00, '2025-01-01'),
(104, 'Sylhet', 'Prepaid', 30, 20, 800, 75.00, '2025-01-03'),
(105, 'Barishal', 'Postpaid', 70, 15, 2000, 200.00, '2025-01-02'),
(101, 'Dhaka', 'Prepaid', 15, 3, 450, 55.00, '2025-01-03'),
(102, 'Chittagong', 'Postpaid', 40, 5, 900, 100.00, '2025-01-03'),
(103, 'Dhaka', 'Prepaid', 10, 1, 300, 35.00, '2025-01-02'),
(104, 'Sylhet', 'Prepaid', 20, 10, 600, 50.00, '2025-01-02'),
(105, 'Barishal', 'Postpaid', 65, 20, 1500, 180.00, '2025-01-03'),
(106, 'Dhaka', 'Postpaid', 80, 25, 2500, 250.00, '2025-01-02');


---- SEE the table---

SELECT * FROM telecom_usage

---Q1.Calculate total call minutes per customer--

SELECT customer_id , SUM(call_minutes) AS total_call
FROM telecom_usage
GROUP BY customer_id

--- Q2.Count total usage records per region --
SELECT region , COUNT(*) as total_usage
FROM telecom_usage
GROUP BY region

---Q3.Find total SMS sent per plan type (Prepaid vs Postpaid). --

SELECT plan_type, SUM(sms_count)
FROM telecom_usage
GROUP BY plan_type
--Q4.Compute total charge amount per customer.
 SELECT customer_id, SUM(charge_amount) as total_charge
 FROM telecom_usage
 GROUP BY customer_id


--Q5.Group by date: total data consumption per day ---
 SELECT usage_date, sum(data_mb) as total_data_consumption
 FROM telecom_usage
 GROUP BY usage_date

-----
--Q6.Find average call minutes per region.
     SELECT region, ROUND (AVG(call_minutes),2)  AS average_call_minutes
	 FROM telecom_usage
	 GROUP BY region
--Q7.Compute total revenue generated from each plan type.
      SELECT plan_type, SUM( charge_amount ) as total_revenue
	  FROM telecom_usage
	  GROUP BY plan_type
--Q8.For each customer, calculate the average MB of data consumed.
    SELECT customer_id, ROUND(AVG(data_mb),2) as average_data_usage
	FROM telecom_usage
	GROUP BY customer_id
--Q9. Find the number of days each customer used the network.
      select customer_id, count(usage_date) total_day_of_usage
	  from telecom_usage
	  group by customer_id 

	  SELECT customer_id, COUNT(DISTINCT usage_date) AS active_days
      FROM telecom_usage
      GROUP BY customer_id;

--Q10.Group by (region, plan_type) and compute total data usage.
      select region,plan_type, sum(data_mb) as total_data_usage
	  from telecom_usage
	  group  by region,plan_type
--Q11. Find customers whose total charge exceeds 200 (use HAVING).
       select customer_id, sum(charge_amount)
	   from telecom_usage
	   group by customer_id
	   having sum(charge_amount) > 200
--Q12. For each region, calculate maximum daily charge collected.

	  select region, max(charge_amount) as daily_charge_collected
	  from telecom_usage
	  group by region 
-- Q13. Identify top 3 regions with highest total revenue (GROUP BY + ORDER BY + LIMIT).
       SELECT region, sum(charge_amount) as total_revenue
	   FROM telecom_usage
	   GROUP BY region 
	   ORDER BY total_revenue DESC
	   LIMIT 3
--Q14. For each plan type, compute the percentage contribution to total revenue.
       SELECT plan_type, sum(charge_amount) as total_revenue,
	   ROUND(SUM(charge_amount)*100 / (SELECT sum(charge_amount) from telecom_usage),2)
	   FROM telecom_usage
	   GROUP BY plan_type
--Q15. For each customer, find total call minutes and categorize heavy callers (HAVING SUM(call_minutes) > 100).
       select customer_id ,sum(call_minutes) as total_call_minutes
	   from telecom_usage
	   group by customer_id
	   having sum(call_minutes) > 100
--Q16. Compute per-day ARPU (Average Revenue Per User): total charge per day / number of unique customers.
        select usage_date , ROUND((sum(charge_amount)/ count(distinct(customer_id))),2)  as total_charge_per_day
		from telecom_usage
		group by usage_date
		
--Q17. Find average SMS per day for each region.
        select region,usage_date,avg(sms_count)
		from telecom_usage
		group by region,usage_date

		SELECT region, sum(sms_count) AS total_sms
        FROM telecom_usage
        GROUP BY region;



SELECT region,
       AVG(daily_sms) AS avg_sms_per_day
FROM (
        SELECT region, usage_date, SUM(sms_count) AS daily_sms
        FROM telecom_usage
        GROUP BY region, usage_date
     ) AS daily_data
GROUP BY region;

--Q18. Identify which region consumes the highest average data per customer.
      
--Q19. For each customer, compute: total_calls, total_sms, total_data, total_charge — using GROUP BY customer_id.

--Q20. Determine monthly revenue by grouping usage_date using DATE_TRUNC('month', usage_date).

SELECT * FROM telecom_usage



