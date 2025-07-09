# 🌿 Eco-Tourism Data Analytics — SQL & Dashboard

This repository contains the complete **BigQuery SQL solution** for a **real-world project** delivered to an eco-tourism company.  
The company requested an end-to-end data analysis to help teams monitor financial performance, customer behavior, experience quality and sustainability practices on the platform.

All requirements were answered with **clean, reusable SQL scripts**. The next step: an interactive **Power BI dashboard** (currently under development).

---

## ✅ Business Questions

After a business workshop, **9 key questions** were identified to guide the analysis:

1️⃣ **Total Revenue**  
> _How much is the company earning per period?_  
**Metric:** Total Revenue by Month, to track growth and seasonality.

2️⃣ **Average Spend per Customer**  
> _What is the average amount spent per customer per booking, considering the spend per person?_  
**Metric:** Average and Median Spend per Person, to analyze economic vs. premium choices.

3️⃣ **Most Popular Offers**  
> _Which offer types are most popular among travelers?_  
**Metric:** Bookings & Travelers Distribution by Offer Type (activity or accommodation).

4️⃣ **Customer Repeat Rate**  
> _What is the percentage of customers who make repeat bookings?_  
**Metric:** Customer Repeat Rate (% of customers with more than one booking).

5️⃣ **Top Performing Offers**  
> _Which offers have the highest performance based on customer ratings?_  
**Metric:** Average Offer Ratings (only offers with at least 2 reviews).

6️⃣ **Sustainability Index**  
> _How many offers include sustainable practices?_  
**Metric:** Sustainable Practices Adoption Index = (# of offers with practices) / (total offers).

7️⃣ **Most Common Sustainable Practices**  
> _Which sustainable practices appear most frequently in booked experiences?_  
**Metric:** Top Sustainable Practices by number of bookings.

8️⃣ **Average Interval Between Bookings**  
> _What is the average time between bookings for returning customers?_  
**Metric:** Average Days Between Bookings for repeat customers, to support CRM re-engagement.

9️⃣ **Operator Performance by Offer Category**  
> _How do operators perform on average by offer type (activity or accommodation)?_  
**Metric:** Average Operator Rating by Offer Type, to identify top partners for rewards and training.

---

## ✅ What’s Included

- 📁 Well-structured **BigQuery SQL scripts**, ready to run.
- 🗂️ Clean `CREATE VIEW` structures for easy BI integration.
- 📝 Clear business logic explained in code comments.
- 📊 Dashboard connection in progress (**Power BI**).

---

## ✅ Context

The company operates an **eco-tourism booking platform** that connects travelers with unique, sustainable experiences.  
The analysis supports strategic decisions for the **finance**, **pricing**, **curation**, **quality**, **CRM** and **marketing** teams.

---

## ✅ Next Steps

- Deliver the final **Power BI dashboard**
- Add filters, sustainability breakdowns and interactive visuals

---

## ✅ How to Use

- This repository shares the **SQL logic** and final queries used to answer the business questions.
- The dataset itself is **private** and is not published due to confidentiality agreements.
- Feel free to **review the scripts**, **adapt the structure**, and use them as a **reference** for similar analytics challenges.
- The queries are designed for **BigQuery**, but the logic can be adapted for any SQL-compatible data warehouse.
