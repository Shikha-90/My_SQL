use db_kaggle;
/*Task 3 - Analyzing Products*/

/*Categorize Products by dosage form and analyze their distribution.*/
SELECT * FROM pg3_Product_DosageForm_Distribution;


/*Calculate the total number of approvals for each dosage form and identify the most successful forms. 
- Along with Drugname & sponsor wise analysis*/
SELECT * FROM pg3_Total_Approvals_By_DosageForm;
SELECT * FROM pg3_Total_Approvals_By_DosageForm_In_Depth_Analysis;


/*Investigate yearly trends related to successful forms - Top 3 are TABLET, INJECTABLES & CAPSULE */
SELECT * FROM pg3_Approval_Trends_Tablet;
SELECT * FROM pg3_Approval_Trends_Injectable;
SELECT * FROM pg3_Approval_Trends_Capsule;


/* Application Distribution by Dosage Form*/
SELECT * FROM pg3_Appl_Dist_By_DosageForm;


/*Comparision of Application v/s Approval for all Dosage Forms*/
SELECT * FROM pg3_SuccessFul_Dosage_Form;


/* Detailed Script*/

/*Task 3 - Analyzing Products*/


/*Categorize Products by dosage form and analyze their distribution.*/
CREATE VIEW pg3_Product_DosageForm_Distribution AS
SELECT COUNT(ApplNo) AS Appl_Nos, drugname, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Form,';',1),',',1),'/',1) AS DRUG_Form FROM product GROUP BY drugname, DRUG_Form ORDER BY Appl_Nos DESC;


/*Calculate the total number of approvals for each dosage form and identify the most successful forms. 
- Along with Drugname & sponsor wise analysis*/

CREATE VIEW pg3_Total_Approvals_By_DosageForm AS 
WITH Approvals AS (SELECT a.ApplNo, a.ApplType, a.SponsorApplicant, drugname, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Form,';',1),',',1),'/',1) AS DOSAGE_Form, r.DocType FROM application a INNER JOIN regactiondate r ON r.ApplNo = a.ApplNo INNER JOIN product p ON p.ApplNo = a.ApplNo)
SELECT COUNT(DISTINCT(ApplNo)) AS Total_Appl, DOSAGE_Form FROM Approvals Where DocType = "N" GROUP BY DOSAGE_Form ORDER BY Total_Appl DESC;


CREATE VIEW pg3_Total_Approvals_By_DosageForm_In_Depth_Analysis AS 
WITH Approvals AS (SELECT a.ApplNo, a.ApplType, a.SponsorApplicant, drugname, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Form,';',1),',',1),'/',1) AS DOSAGE_Form, r.DocType FROM application a INNER JOIN regactiondate r ON r.ApplNo = a.ApplNo INNER JOIN product p ON p.ApplNo = a.ApplNo)
SELECT COUNT(DISTINCT(ApplNo)) AS Total_Appl, COUNT(DISTINCT(SponsorApplicant)) AS Total_Sponsor, drugname, DOSAGE_Form FROM Approvals Where DocType = "N" GROUP BY DOSAGE_Form, drugname ORDER BY Total_Appl DESC;


/*Investigate yearly trends related to successful forms - Top 3 are TABLET, INJECTABLES & CAPSULE */
CREATE VIEW pg3_Approval_Trends_Tablet AS
WITH Approvals AS (SELECT a.ApplNo, a.ApplType, a.SponsorApplicant, drugname, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Form,';',1),',',1),'/',1) AS DOSAGE_Form, r.DocType, LEFT(r.ActionDate,4) AS Year FROM application a INNER JOIN regactiondate r ON r.ApplNo = a.ApplNo INNER JOIN product p ON p.ApplNo = a.ApplNo)
SELECT COUNT(DISTINCT(ApplNo)) AS Total_Appl, DOSAGE_Form, Year FROM Approvals Where DocType = "N" AND DOSAGE_Form = "TABLET" GROUP BY DOSAGE_Form, YEAR ORDER BY Total_Appl DESC;

CREATE VIEW pg3_Approval_Trends_Injectable AS
WITH Approvals AS (SELECT a.ApplNo, a.ApplType, a.SponsorApplicant, drugname, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Form,';',1),',',1),'/',1) AS DOSAGE_Form, r.DocType, LEFT(r.ActionDate,4) AS Year FROM application a INNER JOIN regactiondate r ON r.ApplNo = a.ApplNo INNER JOIN product p ON p.ApplNo = a.ApplNo)
SELECT COUNT(DISTINCT(ApplNo)) AS Total_Appl, DOSAGE_Form, Year FROM Approvals Where DocType = "N" AND DOSAGE_Form = "INJECTABLE" GROUP BY DOSAGE_Form, YEAR ORDER BY Total_Appl DESC;

CREATE VIEW pg3_Approval_Trends_Capsule AS
WITH Approvals AS (SELECT a.ApplNo, a.ApplType, a.SponsorApplicant, drugname, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Form,';',1),',',1),'/',1) AS DOSAGE_Form, r.DocType, LEFT(r.ActionDate,4) AS Year FROM application a INNER JOIN regactiondate r ON r.ApplNo = a.ApplNo INNER JOIN product p ON p.ApplNo = a.ApplNo)
SELECT COUNT(DISTINCT(ApplNo)) AS Total_Appl, DOSAGE_Form, Year FROM Approvals Where DocType = "N" AND DOSAGE_Form = "CAPSULE" GROUP BY DOSAGE_Form, YEAR ORDER BY Total_Appl DESC;


/* Application Distribution by Dosage Form*/
CREATE VIEW pg3_Appl_Dist_By_DosageForm AS
WITH DRUG_TYPE AS (SELECT COUNT(ApplNo) AS Appl_Nos, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Form,';',1),',',1),'/',1) AS DOSAGE_Form FROM product GROUP BY DOSAGE_Form)
SELECT * FROM DRUG_TYPE GROUP BY DOSAGE_Form ORDER BY Appl_Nos DESC;

/*Comparision of Application v/s Approval for all Dosage Forms*/
CREATE VIEW pg3_SuccessFul_Dosage_Form AS 
SELECT Total_Appl.DOSAGE_Form, Appl_nos, Total_Appl FROM pg3_Total_Approvals_By_DosageForm AS Total_Appl INNER JOIN pg3_Appl_Dist_By_DosageForm AS Total_Aprovls ON Total_Appl.DOSAGE_Form = Total_Aprovls.DOSAGE_Form;