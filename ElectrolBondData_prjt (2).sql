SELECT * FROM bankdata;
SELECT * FROM bonddata;
SELECT * FROM donordata;
SELECT * FROM receiverdata;
----------- Questions On Electoral Bonds ------------------------
------------------------------------------------------------------------------------------
-- 1.Find out how much donors spent on bonds
WITH TOTAL_DENOMINATION AS(SELECT  sum(DENOMINATION) AS total_amount
           FROM donordata as d 
           join bonddata as b
           on d.Unique_key = b.Unique_key)
SELECT * FROM TOTAL_DENOMINATION;
-- 2.Find out total fund politicians got
SELECT SUM(Denomination) AS total_fund
FROM bonddata b
JOIN donordata d
on b.Unique_key=d.Unique_key;
-- 3.Find out the total amount of unaccounted money received by parties
SELECT SUM(Denomination) AS unaccounted_money
FROM bonddata b
JOIN receiverdata r
ON b.Unique_key=r.Unique_key
left
 JOIN donordata d
ON r.Unique_key=d.Unique_key
where d.purchaser is null;
-- 4.Find year wise how much money is spend on bonds
SELECT SUM(Denomination),year(purchasedate) as y
FROM bonddata b
JOIN donordata d 
ON b.Unique_key=d.Unique_key
group by y ;
-- 5.In which month most amount is spent on bonds
SELECT SUM(Denomination),monthname(purchasedate) AS monthname
FROM bonddata b 
JOIN donordata d
ON b.Unique_key=d.Unique_key
GROUP BY monthname;
-- 6.Find out which company bought the highest number of bonds.
SELECT COUNT(Urn),Purchaser
FROM donordata
GROUP BY purchaser
ORDER BY COUNT(Urn) desc
LIMIT 1;
-- 7.Find out which company spent the most on electoral bonds.
SELECT Purchaser,SUM(Denomination) AS Total_spent
FROM donordata d 
JOIN bonddata b 
ON d.Unique_key=b.Unique_key
GROUP BY Purchaser
ORDER BY Total_spent desc
LIMIT 1;
-- 8.List companies which paid the least to political parties.
with least_paid as(
SELECT Purchaser,SUM(Denomination) AS companies_paid
FROM donordata d 
JOIN bonddata b 
ON d.Unique_key=b.Unique_key
GROUP BY Purchaser
ORDER BY companies_paid) select purchaser from least_paid where companies_paid = (select min(companies_paid) from least_paid);
-- 9.Which political party received the highest cash?
SELECT Partyname,SUM(Denomination) AS highest_cash
FROM receiverdata r
JOIN bonddata b
ON r.Unique_key = b.Unique_key
GROUP BY PartyName
ORDER BY highest_cash DESC
LIMIT 1;
-- 10.Which political party received the highest number of electoral bonds?
SELECT partyname,COUNT(Urn) AS highest_bonds
FROM receiverdata r 
JOIN donordata d 
ON r.Unique_key = d.Unique_key
GROUP BY Partyname
ORDER BY highest_bonds DESC
LIMIT 1;
-- 11.Which political party received the least cash?
SELECT Partyname,SUM(Denomination) AS least_cash
FROM receiverdata r
JOIN bonddata b 
ON r.Unique_key = b.Unique_key
GROUP BY PartyName
ORDER BY least_cash
LIMIT 1;
-- 12.Which political party received the least number of electoral bonds?
SELECT PartyName,COUNT(Urn) AS least_bonds
FROM receiverdata r 
JOIN donordata d
ON r.Unique_key = d.Unique_key
GROUP BY PartyName
ORDER BY least_bonds
LIMIT 1; 
-- 13.Find the 2nd highest donor in terms of amount he paid? 
SELECT Purchaser, SUM(Denomination) AS `2nd highest donor`
FROM donordata d 
JOIN bonddata b
ON d.Unique_key = b.Unique_key
GROUP BY Purchaser
ORDER BY `2nd highest donor` DESC
LIMIT 1,1;
-- 14.Find the party which received the second highest donations?
SELECT r.PartyName, SUM(Denomination) AS `second highest donation`
FROM receiverdata r
JOIN bonddata b
ON r.Unique_key = b.Unique_key
GROUP BY r.PartyName
ORDER BY `second highest donation` DESC
LIMIT 1,1;
-- 15.Find the party which received the second highest number of bonds?
SELECT r.PartyName,COUNT(PartyName) AS `second highest bonds`
FROM receiverdata r
GROUP BY PartyName
ORDER BY `second highest bonds` DESC
LIMIT 1,1;
-- 16.In which city were the most number of bonds purchased? 
SELECT b.CITY,COUNT(d.Purchaser) AS `bonds purchased`
FROM bankdata b 
JOIN donordata d
ON d.PayBranchCode = b.branchCodeNo
GROUP BY b. CITY
ORDER BY `bonds purchased` DESC
LIMIT 1;
-- 17.In which city was the highest amount spent on electoral bonds?
SELECT b.CITY,SUM(bo.Denomination) AS `highest bonds`
FROM donordata d 
JOIN bonddata bo 
ON d.Unique_key = bo.Unique_key
JOIN bankdata b
ON b.branchCodeNo = d.PayBranchCode
GROUP BY b.CITY
ORDER BY `highest bonds` DESC
LIMIT 1;
-- 18.In which city were the least number of bonds purchased?
SELECT ba.CITY,COUNT(Urn) AS `lest bonds purchased`
FROM bankdata ba
JOIN donordata d
ON ba.branchCodeNo = d.PayBranchCode
GROUP BY ba.CITY 
ORDER BY `lest bonds purchased` DESC
LIMIT 1;
-- 19.In which city were the most number of bonds enchased?
SELECT ba.CITY,COUNT(PayTeller) AS `high bonds enchased`
FROM bankdata ba  
JOIN receiverdata r 
ON ba.branchCodeNo = r.PayBranchCode
GROUP BY ba.CITY
ORDER BY `high bonds enchased` DESC
LIMIT 1;
-- 20.In which city were the least number of bonds enchased?
SELECT ba.CITY,COUNT(Unique_Key) AS `least bonds enchased`
FROM bankdata ba
JOIN receiverdata r
ON ba.branchCodeNo = r.PayBranchCode
GROUP BY ba.CITY
ORDER BY `least bonds enchased`
LIMIT 1;
-- 21.List the branches where no electoral bonds were bought; if none, mention it as null.
SELECT ba.CITY
FROM bankdata ba 
LEFT JOIN donordata d 
ON ba.branchCodeNo = d.PayBranchCode
WHERE d.PayBranchCode IS NULL;
-- 22.Break down how much money is spent on electoral bonds for each year.
SELECT YEAR(d.PurchaseDate),SUM(b.Denomination) AS `bonds spent on each year`
FROM bonddata b
JOIN donordata d 
ON b.Unique_key = d.Unique_key
GROUP BY d.PurchaseDate
ORDER BY `bonds spent on each year` desc;
-- 23.Break down how much money is spent on electoral bonds for each year and provide the year and the amount. Provide values for the highest and least year and amount.
 WITH bonds AS ( 
 SELECT YEAR(d.PurchaseDate) as ye,SUM(b.Denomination) AS MN
 FROM bonddata b
 JOIN donordata d
 ON b.Unique_key = d.Unique_key
 GROUP BY YE
 ORDER BY YE ) 
 SELECT *
 FROM bonds
 WHERE MN IN ((SELECT MAX(MN) FROM BONDS),(SELECT MIN(MN) FROM BONDS))
 ;
 
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
 -- 24.Find out how many donors bought the bonds but did not donate to any political party?
 SELECT COUNT(Unique_key)
 FROM donordata
 where Unique_key not in (select Unique_key from receiverdata)
 group by Purchaser;
 -- 25.Find out the money that could have gone to the PM Office, assuming the above question assumption (Domain Knowledge)
 SELECT SUM(b.Denomination) AS `money gone to PM office`
 FROM bonddata b 
LEFT JOIN receiverdata r  
 ON b.Unique_key = r.Unique_key;
 -- 26.Find out how many bonds don't have donors associated with them.
 SELECT COUNT(*) AS `Bonds Without Donors`
FROM bonddata b
LEFT JOIN donordata d ON b.Unique_key = d.Unique_Key
WHERE d.Unique_Key IS NULL;
-- 27.Pay Teller is the employee ID who either created the bond or redeemed it. So find the employee ID who issued the highest number of bonds.
SELECT PayTeller,COUNT(*) AS `highest no of bonds`
FROM donordata
GROUP BY PayTeller
ORDER BY `highest no of bonds` DESC
LIMIT 1;
-- 28.Find the employee ID who issued the least number of bonds.
SELECT PayTeller AS `least bonds`
FROM donordata
GROUP BY PayTeller
ORDER BY Count(*) ASC
LIMIT 1;
-- 29.Find the employee ID who assisted in redeeming or enchasing bonds the most.
SELECT PayTeller,COUNT(*) AS `redeeming bonds` 
FROM receiverdata
GROUP BY PayTeller 
ORDER BY `redeeming bonds` DESC;
-- 30.Find the employee ID who assisted in redeeming or enchasing bonds the least
SELECT PayTeller,COUNT(*) AS `redeeming bonds` 
FROM receiverdata
GROUP BY PayTeller 
ORDER BY `redeeming bonds` ASC;
-----------------------------------------------------------------------------------
-- 1.Tell me total how many bonds are created?
SELECT COUNT(*) AS `Total Bonds`
FROM bonddata;
-- 2.Find the count of Unique Denominations provided by SBI?
SELECT COUNT(Denomination) AS `Unique Denomination`
FROM bonddata;
-- 3.List all the unique denominations that are available?
SELECT DISTINCT(Denomination) 
FROM bonddata;
-- 4.Total money received by the bank for selling bonds
SELECT SUM(Denomination) AS `Money recived`
FROM receiverdata r 
JOIN bonddata b
ON r.Unique_key = b.Unique_key
GROUP BY r.PayBranchCode
ORDER BY `Money recived` DESC
LIMIT 1;
-- 5.Find the count of bonds for each denominations that are created.
SELECT Denomination,COUNT(*) AS `bonds`
FROM bonddata
GROUP BY Denomination;
-- 6.Find the count and Amount or Valuation of electoral bonds for each denominations.
SELECT Denomination,COUNT(*) AS `Bond count`,
SUM(Denomination) AS `Total valuation`
FROM bonddata
GROUP BY Denomination;
-- 7.Number of unique bank branches where we can buy electoral bond?
SELECT COUNT(*) AS `Banck Branches`
FROM bankdata;
-- 8.How many companies bought electoral bonds
SELECT COUNT(Purchaser) AS `Total Companies`
FROM donordata;
-- 9.How many companies made political donations
SELECT COUNT(distinct Purchaser) AS `No Of Companies`
FROM donordata;
-- 10.How many number of parties received donations 
SELECT COUNT(DISTINCT PartyName) AS `No Of Parties`
FROM receiverdata;
-- 11.List all the political parties that received donations
SELECT COUNT(PartyName) AS `All Paarties`
FROM receiverdata;
-- 12.What is the average amount that each political party received
SELECT r.PartyName,AVG(Denomination) AS `Amount Recived By Party`
FROM receiverdata r
JOIN bonddata b
ON r.Unique_key = b.Unique_key
GROUP BY r.PartyName;
-- 13.What is the average bond value produced by bank
SELECT AVG(Denomination) AS `Avarage Bond`
FROM bonddata;
-- 14.List the political parties which have enchased bonds in different cities?
SELECT r.PartyName
FROM receiverdata r
JOIN bankdata ba 
ON r.PayBranchcode = ba.branchCodeNo
group by r.PartyName
having count(distinct ba.city)>1;
-- 15.List the political parties which have enchased bonds in different cities and list the cities in which the bonds have enchased as well?
SELECT r.PartyName,ba.CITY
FROM receiverdata r
JOIN bankdata ba
ON r.PayBranchcode = ba.branchCodeNo
GROUP BY r.PartyName
HAVING COUNT(distinct ba.CITY)>1;





 
 












