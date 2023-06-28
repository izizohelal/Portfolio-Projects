
SELECT *
FROM EmployeeAttrition

--1# get the details of employees under attrition having +5 years of experience in between the age group of 27-35
SELECT *
FROM EmployeeAttrition
WHERE Attrition = 'Yes' 
AND  Age BETWEEN 27 AND 35 AND TotalWorkingYears > 5 


--2# get the details of employees having maximum and minimum salary working in different departments who received less than 13% salary hike
SELECT department ,
       MAX(MonthlyIncome) max_salary,
	   MIN(MonthlyIncome) min_salary
FROM EmployeeAttrition 
WHERE PercentSalaryHike < 13
GROUP BY department
ORDER BY MAX(MonthlyIncome) DESC



--3# get the average monthly income of all the employees who worked more than 3 years whose education background is medical
SELECT ROUND (AVG(MonthlyIncome),2) avg_income_medical_field
FROM EmployeeAttrition
WHERE TotalWorkingYears > 3 AND EducationField = 'Medical'
GROUP BY EducationField



--4# identify the total no of male and female employees under attrition whose marital status is married 
   --and haven't received promotion in the last 2 years 
SELECT Gender, COUNT(*) num_of_male_female
FROM EmployeeAttrition
WHERE Attrition = 'Yes' AND MaritalStatus = 'Married' AND YearsSinceLastPromotion = 2
GROUP BY Gender
ORDER BY COUNT(*) DESC

--5# employees with max perfomance rating but no promotion for 4 years and above
SELECT *
FROM EmployeeAttrition
WHERE PerformanceRating = (SELECT MAX(PerformanceRating) FROM EmployeeAttrition)  
AND YearsSinceLastPromotion >= 4

--6# get the min and max for salary hike 
SELECT YearsAtCompany,
       PerformanceRating,  
	   YearsSinceLastPromotion,
       MAX(PercentSalaryHike) MaxSalaryHike,
       MIN(PercentSalaryHike) MinSalaryHike
FROM EmployeeAttrition
GROUP BY YearsAtCompany,PerformanceRating,YearsSinceLastPromotion
ORDER BY MAX(PercentSalaryHike) DESC,MIN(PercentSalaryHike) ASC


--7# employees working overtime but given min salary hike and have been at the company for more than 5 years
SELECT *
FROM EmployeeAttrition
WHERE OverTime = 'Yes' 
AND PercentSalaryHike = (SELECT MIN(PercentSalaryHike) FROM EmployeeAttrition)
AND YearsAtCompany > 5 
AND Attrition = 'Yes'


--8# employees working overtime and given max salary hike and have been at the company for less than 5 years
SELECT *
FROM EmployeeAttrition
WHERE OverTime = 'Yes' 
AND PercentSalaryHike = (SELECT MAX(PercentSalaryHike) FROM EmployeeAttrition)
AND YearsAtCompany < 5 


--9# employees with no overtime and given max salary hike and have been at the company for less than 5 years
SELECT *
FROM EmployeeAttrition
WHERE OverTime = 'No' 
AND PercentSalaryHike = (SELECT MAX(PercentSalaryHike) FROM EmployeeAttrition)
AND YearsAtCompany < 5 

--10# getting to know max and min for relation satisfaction grouped by marital status

SELECT MaritalStatus,
       MAX(RelationshipSatisfaction) max_relation_satisfaction,
       MIN(RelationshipSatisfaction) min_relation_satisfaction
FROM EmployeeAttrition
GROUP BY MaritalStatus

--11# getting to know max and min for job satisfaction grouped by marital status
SELECT MaritalStatus,
       MAX(JobSatisfaction) max_job_satisfaction,
       MIN(JobSatisfaction) min_job_satisfaction
FROM EmployeeAttrition
GROUP BY MaritalStatus
      

--quering in OlympicEvents table 
SELECT *
FROM OlympicEvents

--1# in which sport or event Egypt got the highest num of  medals
SELECT Event,COUNT(*) num_of_medals
FROM OlympicEvents
WHERE Team = 'Egypt' 
AND Medal <> 'NA'
GROUP BY Event
ORDER BY COUNT(*) DESC


--2# identify the sport or event which was played most consectuively in the summer olympics games 
SELECT Event,COUNT(*) num_of_events
FROM OlympicEvents
WHERE Season = 'Summer'
GROUP BY Event 
ORDER BY COUNT(*) DESC 


SELECT Event,COUNT(*) num_of_events
FROM OlympicEvents
WHERE Season = 'Winter'
GROUP BY Event 
ORDER BY COUNT(*) DESC 

--2# identify the details of all countries which have won most number of silver and bronze medals and at least one gold medal 

WITH CTE AS (
SELECT *, 
       CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END AS Silver,
       CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END AS Bronze,
	   CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END AS Gold
FROM OlympicEvents
)
SELECT Team,
       SUM(Silver)num_of_silver,
       SUM(Bronze)num_of_bronze,
	   SUM(Gold)num_of_gold
FROM CTE 
GROUP BY Team 
HAVING SUM(Gold) > 0 
ORDER BY SUM(Silver) DESC


--3# which player has won maximum number of gold medals 
WITH CTE AS (
SELECT *, 
       CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END AS Silver,
       CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END AS Bronze,
	   CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END AS Gold
FROM OlympicEvents
)
SELECT Name, SUM(Gold)num_of_gold
FROM CTE
GROUP BY NAME 
ORDER BY  SUM(Gold) DESC

--same query result with an inner or subqery

SELECT Name, SUM(Gold)num_of_gold
FROM
(SELECT *, 
	   CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END AS Gold
 FROM OlympicEvents
 ) t1
GROUP BY NAME 
ORDER BY  SUM(Gold) DESC

--4# which sport has maximum num of events
SELECT Sport,COUNT(Event)num_of_events
FROM OlympicEvents
GROUP BY Sport
ORDER BY COUNT(Event) DESC


--5# which year has maximum num of events
SELECT Year,COUNT(Event)num_of_events
FROM OlympicEvents
GROUP BY Year
ORDER BY COUNT(Event) DESC

SELECT *
FROM OlympicEvents