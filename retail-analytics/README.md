# Retail Analytics

A comprehensive SQL-based analytics project analyzing customer behavior, transaction patterns, and business metrics using advanced data manipulation and reporting techniques.

## Dataset Source

This project uses the **Online Retail II** dataset from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/datasets/online+retail+ii).

- **License**: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- **Attribution**: Daqing Chen, Sai Liang Chong, Christopher Leather, Pauline Yeung (2023)
- **Description**: Transactional data from an online retail store covering 2009-2011, including product details, quantities, prices, and customer information.

## SQL Techniques Demonstrated

- **Window Functions**: Running totals, ranking, lag/lead analysis
- **Common Table Expressions (CTEs)**: Complex query composition and recursive patterns
- **Cohort Analysis**: Customer retention and lifecycle tracking
- **RFM Segmentation**: Recency, Frequency, Monetary value customer classification
- **Aggregate Functions**: SUM, COUNT, AVG with GROUP BY
- **Date Functions**: DATEPART for temporal analysis

## How to Reproduce

### Prerequisites
- SQL Server 2017 or later (or compatible database)
- [Online Retail II dataset](https://archive.ics.uci.edu/datasets/online+retail+ii) (CSV format)

### Steps

1. **Clone the repository**
   ```bash
   git https://github.com/ShivamMahadik/Portforlio/tree/b8333f50f5635971f45f18620ba4e0f4ced3acf3/retail-analytics
   cd retail-analytics
   ```

2. **Create the database**
   - Open SQL Server Management Studio or your SQL IDE
   - Execute `00_create_table.sql` to create the database and import the dataset
   - Update the file path in the script to match your local dataset location

3. **Run the analysis scripts**
   - Execute scripts in order: `01_data_cleaning.sql` → `02_time_series_analysis.sql` → `03_ranking_analysis.sql ` -> `04_cohort_retention.sql` → `05_rfm_segmentation.sql` -> ` 06_Analytics_View.sql`
   - Each script generates views and/or result sets for analysis

4. **View results**
   - Query the created views or export result sets for visualization
   - Use Power BI, Tableau, or Excel to visualize the output data

### Example Query
```sql
-- View RFM Segmentation results
SELECT * FROM vw_RFM_Segments
ORDER BY Customer_Segment, RFM_Score DESC;
```

## Key Insights Generated

- Customer segmentation into High-Value, Medium-Value, and At-Risk segments
- Product performance rankings and seasonal trends
- Cohort retention rates and customer lifecycle patterns
- Month-over-month revenue growth analysis
- Top products and customers by revenue contribution


## Author

Shivam Mahadik | [GitHub](https://github.com/ShivamMahadik) | [LinkedIn](https://linkedin.com/in/shivammahadik)

## License

This project is licensed under the CC BY 4.0 License - see the [LICENSE](LICENSE) file for details.

The dataset is also provided under the CC BY 4.0 License from the UCI Machine Learning Repository.
