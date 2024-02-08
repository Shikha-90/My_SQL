use db_kaggle;

/* Task 4: Exploring Therapeutic Classes and Approval Trends */

/* Analyze drug approvals based on therapeutic evaluation code (TE_Code)*/
SELECT * FROM pg4_Approval_Based_TECode;

/*Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.*/
SELECT * FROM pg4_TE_Ranking_by_Year;
/* TECode that has the Rank 1 for maximum number of years */
SELECT * FROM pg4_TECode_with_MAXYrs_Rank1;




/* Detailed Script */

/* Task 4: Exploring Therapeutic Classes and Approval Trends */

/* Analyze drug approvals based on therapeutic evaluation code (TE_Code)*/
CREATE VIEW pg4_Approval_Based_TECode AS
SELECT COUNT(DISTINCT(p.ApplNo)) AS Total_Appl, pt.TECode FROM product p INNER JOIN regactiondate r ON r.ApplNo = p.ApplNo INNER JOIN product_tecode pt ON pt.ApplNo = p.ApplNo WHERE r.DocType = "N" GROUP BY pt.TECode ORDER BY Total_Appl DESC;


/*Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.*/
CREATE VIEW pg4_TE_Ranking_by_Year AS
WITH Rank_Approval_TECode_Trend AS 
(SELECT COUNT(DISTINCT(p.ApplNo)) AS Total_Appl, LEFT(r.ActionDate,4) AS Year, pt.TECode, (RANK() OVER (PARTITION BY LEFT(r.ActionDate,4) ORDER BY COUNT(DISTINCT(p.ApplNo)) DESC)) AS Top_Rank FROM product p INNER JOIN regactiondate r ON r.ApplNo = p.ApplNo INNER JOIN product_tecode pt ON pt.ApplNo = p.ApplNo WHERE r.DocType = "N" GROUP BY Year, pt.TECode)
SELECT Total_Appl, Year, TECode, Top_Rank FROM Rank_Approval_TECode_Trend WHERE Top_Rank = 1 ORDER BY Total_Appl DESC;

/* TECode that has the Rank 1 for maximum number of years */
CREATE VIEW pg4_TECode_with_MAXYrs_Rank1 AS 
SELECT SUM(Total_Appl) AS Total_Approvals, COUNT(Year) AS No_of_Rank1_yrs, TECode FROM pg4_te_ranking_by_year GROUP BY TECode ORDER BY No_of_Rank1_yrs DESC;