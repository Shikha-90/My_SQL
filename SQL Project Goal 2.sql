use db_kaggle;

/*Task 2: Segmentation Analysis Based on Drug MarketingStatus*/

/* Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.*/
SELECT * FROM pg2_Product_MktStatus;

/*Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.*/
SELECT * FROM pg2_Mkt_Status_afte_2010;

/*Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.*/
SELECT COUNT(p.ApplNo) AS Total_Appl, p.ProductMktStatus FROM product p LEFT JOIN application a ON p.ApplNo = a.ApplNo LEFT JOIN regactiondate r ON a.ApplNo = r.ApplNo GROUP BY p.ProductMktStatus ORDER BY Total_Appl DESC;
SELECT * FROM pg2_Top_MktStatus_MaxAppl;


/*Detailed Script*/


/*Task 2: Segmentation Analysis Based on Drug MarketingStatus*/

/* Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.*/
CREATE VIEW pg2_Product_MktStatus AS
SELECT COUNT(DISTINCT(p.ApplNo)) AS Total_Appl, p.ProductMktStatus, p.drugname FROM product p LEFT OUTER JOIN application a ON p.ApplNo = a.ApplNo GROUP BY p.ProductMktStatus, p.drugname ORDER BY Total_Appl DESC;
/*To Execute Created View*/
SELECT * FROM pg2_Product_MktStatus;

/*Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.*/
CREATE VIEW pg2_Mkt_Status_afte_2010 AS 
WITH Appls_after_2010 AS (SELECT p.ApplNo, p.ProductMktStatus, LEFT(r.ActionDate,4) AS Year FROM product p LEFT OUTER JOIN application a ON p.ApplNo = a.ApplNo LEFT OUTER JOIN regactiondate r ON a.ApplNo = r.ApplNo ORDER BY p.ApplNo DESC)
SELECT COUNT(ApplNo) AS Total_Appl, ProductMktStatus, Year FROM Appls_after_2010 WHERE Year >= 2010 GROUP BY ProductMktStatus, Year ORDER BY Year, ProductMktStatus;
/*To Execute Created View*/
SELECT * FROM pg2_Mkt_Status_afte_2010;

/*Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.*/
SELECT COUNT(p.ApplNo) AS Total_Appl, p.ProductMktStatus FROM product p LEFT OUTER JOIN application a ON p.ApplNo = a.ApplNo LEFT OUTER JOIN regactiondate r ON a.ApplNo = r.ApplNo GROUP BY p.ProductMktStatus ORDER BY Total_Appl DESC;
CREATE VIEW pg2_Top_MktStatus_MaxAppl AS 
WITH MaxAppls_MktStatus AS (SELECT p.ApplNo, p.ProductMktStatus, LEFT(r.ActionDate,4) AS Year FROM product p LEFT OUTER JOIN application a ON p.ApplNo = a.ApplNo LEFT OUTER JOIN regactiondate r ON a.ApplNo = r.ApplNo ORDER BY p.ApplNo DESC)
SELECT COUNT(ApplNo) AS Total_Appl, ProductMktStatus, Year FROM MaxAppls_MktStatus WHERE ProductMktStatus = 1 GROUP BY Year ORDER BY Year;
/*To Execute Created View*/
SELECT * FROM pg2_Top_MktStatus_MaxAppl;