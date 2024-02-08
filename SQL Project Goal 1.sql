use db_kaggle;

/*Task 1: Identifying Approval Trends - 
Determine the number of drugs approved each year and provide insights into the yearly trends.*/
SELECT * FROM pg1_drugs_approved_each_year;

/*Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.*/
/*Top three years that got the highest approvals in descending order*/
SELECT * FROM pg1_Yrs_Highest_Approval;
/*Top three years that got lowest approvals, in ascending order*/
SELECT * FROM pg1_Yrs_Lowest_Approval;

/*Explore approval trends over the years based on sponsors.*/
SELECT * FROM pg1_Sponsor_wise_approval_Trends;

/*Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.*/
SELECT * FROM pg1_Sponsor_RanK_1939_to_1960;




/*Detailed Script*/



/*Detailed Script of Task 1: Identifying Approval Trends - 

Determine the number of drugs approved each year and provide insights into the yearly trends.*/
CREATE VIEW PG1_Drugs_Approved_Each_Year AS
SELECT COUNT(a.ApplNo) AS Total_App, LEFT(r.ActionDate,4) AS Year FROM application a INNER JOIN regactiondate r ON a.ApplNo = r.ApplNo WHERE r.DocType = "N" GROUP BY Year ORDER BY Year;
/*To Execute Created View*/
SELECT * FROM PG1_Drugs_Approved_Each_Year;

/*Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.*/

/*Top three years that got the highest approvals in descending order*/
CREATE VIEW PG1_Yrs_Highest_Approval AS
WITH highest_approval AS (SELECT Total_App, Year, DENSE_RANK() OVER (ORDER BY Total_App DESC) AS Ranks FROM pg1_drugs_approved_each_year) 
SELECT Total_App, Year, Ranks FROM highest_approval WHERE Ranks < 4;
/*To Execute Created View*/
SELECT * FROM PG1_Yrs_Highest_Approval;

/*Top three years that got lowest approvals, in ascending order*/
CREATE VIEW PG1_Yrs_Lowest_Approval AS
WITH lowest_approval AS (SELECT Total_App, Year, DENSE_RANK() OVER (ORDER BY Total_App ASC) AS Ranks FROM pg1_drugs_approved_each_year) 
SELECT Total_App, Year, Ranks FROM lowest_approval WHERE Ranks < 4;
/*To Execute Created View*/
SELECT * FROM PG1_Yrs_Lowest_Approval;

/*Explore approval trends over the years based on sponsors.*/
CREATE VIEW PG1_Sponsor_wise_approval_Trends AS
SELECT SponsorApplicant, COUNT(a.ApplNo) AS Total_Appl FROM application a INNER JOIN product p ON a.ApplNo = p.ApplNo GROUP BY SponsorApplicant ORDER BY Total_Appl DESC;
/*To Execute Created View*/
SELECT * FROM PG1_Sponsor_wise_approval_Trends;

/*Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.*/
CREATE VIEW PG1_Sponsor_RanK_1939_to_1960 AS
WITH 
Approval_1939to1960 AS (SELECT SponsorApplicant, a.ApplNo AS ApplNo, LEFT(r.ActionDate,4) AS Year FROM product p INNER JOIN application a ON p.ApplNo = a.ApplNo INNER JOIN regactiondate r ON r.ApplNo = a.ApplNo),
Approval_Per_Sponsor AS (SELECT SponsorApplicant, COUNT(ApplNo) AS Total_Appl_1939_to_1960 FROM Approval_1939to1960 WHERE Year < 1961 GROUP BY SponsorApplicant)
SELECT SponsorApplicant, DENSE_RANK() OVER(ORDER BY Total_Appl_1939_to_1960 DESC) AS Ranking, Total_Appl_1939_to_1960 FROM Approval_Per_Sponsor;
/*To Execute Created View*/
SELECT * FROM PG1_Sponsor_RanK_1939_to_1960;