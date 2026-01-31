# Online-Retail

## 1. Project Overview
This project performs customer segmentation based on historical online retail transaction data from 2011.

The goal is to support the development of a more differentiated customer management framework by identifying distinct purchasing behavior patterns, rather than treating all customers as a homogeneous group.

The analysis is descriptive in nature and does not attempt to predict future customer behavior.

## 2. Business Context
Historical transaction data indicates that customers exhibit heterogeneous purchasing behaviors in terms of frequency, monetary value, and engagement duration.

Without segmentation, applying uniform engagement or retention strategies risks underutilizing high-value customers while over-investing in low-engagement segments.

This project explores whether unsupervised learning can reveal meaningful behavioral segments that align with observed sales dynamics.

## 3. Dataset Description
The dataset consists of transaction-level online retail records from 2011, including invoice information, product quantities, prices, and customer identifiers.

Data was aggregated to the customer level to support behavioral analysis and segmentation.

## 4. Methodology Overview
* Data quality checks and cleaning using SQL
* Exploratory data analysis (EDA)
* Feature engineering at the customer level
* Unsupervised customer segmentation (K-Means)
* Cluster profiling and business interpretation

## 5. Customer Segments
* Cluster 0 & 3 - One-off / Inactive Customers
  * Moderate spenders with irregular purchasing patterns.
* Cluster 1 - Core Loyal Customers
  * High-frequency, moderate monetary, long engagement period with low refund rate.
* Cluster 2 - One-time High-Value Customers
  * High-monetary but one-time purchase.
* Cluster 4 - Burst Purchase Customers
  * High-monetary, low frequency with short activity spans.

## 6. Business Implications
* Core loyal customers may benefits from personalized communication and loyal-oriented initiatives
* Inactive Customers could be targeted with proper reactivation measures.
* High friction customers may be collected for anlyzing product or order features related to returns.

## 7. Limitations
This analysis is based solely on historical transaction data from 2011 and does not incorporate customer demographics or external factors.

As an unsupervised and descriptive approach, the model does not predict future customer behavior or causal relationships.

## 8. Tech Stack
**Tools:** SQL, Python (Pandas, NumPy, Scikit-learn), Jupyter Notebook
