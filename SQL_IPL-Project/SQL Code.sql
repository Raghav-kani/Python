# Creating table

USE SYS;

CREATE TABLE `IPL Matches` (`ID` INT,`City` VARCHAR(100), `Date` INT, `Player of match` VARCHAR(100), `Venue` VARCHAR(100),	`Neutral venue` INT, 
`team1` VARCHAR(100), `Team2` VARCHAR(100), `Toss winner` VARCHAR(100), `Toss decision` VARCHAR(100), `Winner` VARCHAR(100), `Result` VARCHAR(100),	
`Result margin` INT, `Eliminator` VARCHAR(100),	`Method` VARCHAR(100), `Umpire1` VARCHAR(100), `Umpire2` VARCHAR(100));

LOAD DATA INFILE 'E:/Learning SQL/Final Project/IPL Matches.csv'
INTO TABLE `IPL Matches`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE `IPL Balls` (`ID` INT,	`Inning` INT, `over` INT,`Ball` INT,`Batsman` VARCHAR(100),`Non striker` VARCHAR(100),`Bowler` VARCHAR(100), 
`Batsman runs` INT, `Extra runs` INT, `Total runs` INT,`wicket` INT, `Dismissal kind` VARCHAR(100),	`Player dismissed` VARCHAR(100),
`Fielder` VARCHAR(100), `Extras type` VARCHAR(100), `Batting team` VARCHAR(100), `Bowling team`VARCHAR(100));

LOAD DATA INFILE 'E:/Learning SQL/Final Project/IPL Balls.csv'
INTO TABLE `IPL Balls`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


# Sorting runs

SELECT `Total runs`,
CASE 
WHEN `Total Runs`=4 THEN 'boundary'
WHEN `Total Runs`=0 THEN 'dot'
WHEN `Total Runs`=6 THEN 'six'
ELSE 'other'
END AS Ball_result
FROM `IPL Balls`;


# Calculating total boundaries of each batting team

SELECT Batting_team, 
COUNT(*) 
FROM `IPL Balls` 
WHERE Balls_result='boundaries' 
GROUP BY Batting_team
ORDER BY COUNT DESC;


# Batsmen dismissal

SELECT `Dismissal Kind`, 
COUNT(*)
FROM `IPL Balls`
WHERE `Dismissal Kind`<> 'NA'
GROUP BY `Dismissal Kind`
ORDER BY COUNT DESC;


# Sum total runs in each venue

SELECT M.Venue,
SUM(B.Total_runs) AS Runs
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
GROUP BY Venue
ORDER BY Runs DESC;


# Calculating total boundaries of Batting team

SELECT Batting_team, 
COUNT(*) 
FROM `IPL Balls` 
WHERE Balls_result='boundaries' 
GROUP BY Batting_team
ORDER BY COUNT DESC;


# Sum total '4s' in every matches by every player

SELECT B.ID, B.Batsman, 
COUNT(B.`Total runs`) AS Total_4s
FROM `IPL Balls` B
LEFT JOIN `IPL Matches` M
USING (ID)
WHERE B.`Batsman runs`=4 
GROUP BY B.Batsman
ORDER BY Total_4s DESC;


# Sum total '6s' in every matches by every player

SELECT B.ID, B.Batsman, 
COUNT(B.`Total runs`) AS Total_6s
FROM `IPL Balls` B
LEFT JOIN `IPL Matches` M
USING (ID)
WHERE B.`Batsman runs`=6 
GROUP BY B.Batsman
ORDER BY Total_6s DESC;


# Sum of total balls faced by batsman

SELECT B.Batsman, 
COUNT(Ball) AS `Total Balls`
FROM `IPL Balls` B
GROUP BY Batsman
ORDER BY Ball DESC;


# Calculating dot balls faced by batsman

SELECT Batsman,
COUNT(`Batsman runs`) AS `Dot Balls`
FROM `IPL Balls`	
WHERE `Batsman runs`=0
GROUP BY Batsman;


# Calculating total runs scored in total balls

SELECT Batsman,
COUNT(`Batsman runs`) AS `Total Balls`
FROM `IPL Balls`	
GROUP BY Batsman;


# Counting total runs gave by bowler in 2018

SELECT B.Bowler, 
SUM(B.`Total runs`) 
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID)
WHERE B.Wicket=0 AND M.Date LIKE '%2018'
GROUP BY B.Bowler 
ORDER BY B.Bowler ASC; 


# Sum of total wickets by bowler in 2018

INSERT INTO BowlerRuns (Bowler, Wickets)
SELECT B.Bowler, 
COUNT(B.Wicket) 
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID)
WHERE B.Wicket=1 AND M.Date LIKE '%2018'
GROUP BY B.Bowler
ORDER BY B.Bowler ASC; 


# Calculating total runs given by bowler in total balls

SELECT BTB.Bowler, BTB.`Total Balls`, BTR.`Total runs`
FROM (SELECT B.Bowler,
COUNT(B.Ball) AS `Total Balls`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
#WHERE M.Date LIKE '%2018'
GROUP BY B.Bowler) AS BTB

JOIN (SELECT B.Bowler,
SUM(B.`Total runs`) AS `Total Runs`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
#WHERE M.Date LIKE '%2018'
GROUP BY B.Bowler) AS BTR

ON (BTB.Bowler = BTR.Bowler)
ORDER BY BTB.Bowler ASC;


# Sum of total wickets and total runs by bowler

SELECT *
FROM (SELECT Bowler, Wicket
FROM `IPL Balls`) AS BW
JOIN (SELECT Bowler, `Total runs`
FROM `IPL Balls`) AS BR
ON (BW.Bowler = BR.Bowler);


# Sum of total '4s' and '6s' by batsman

SELECT B.Batsman, B.Total_4s, M.Total_6s
FROM `Total 4s` B
INNER JOIN `Total 6s` M
USING (ID)
GROUP BY Batsman
ORDER BY ID ASC;


# Sum of total wickets in total balls by bowler

SELECT BTB.Bowler, BTR.`Total Wickets`, BTB.`Total Balls`
FROM (SELECT B.Bowler,
COUNT(B.Ball) AS `Total Balls`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE M.Date LIKE '%2018'
GROUP BY B.Bowler) AS BTB

JOIN (SELECT B.Bowler,
SUM(B.Wicket) AS `Total Wickets`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE B.Wicket=1 AND M.Date LIKE '%2018'
GROUP BY B.Bowler) AS BTR

ON (BTB.Bowler = BTR.Bowler)
ORDER BY BTR.`Total Wickets` DESC; 


# Calculating Total 'balls', 'runs', 'wickets' by bowler

SELECT B.Bowler, B.`Total Balls`, B.`Total Runs`, W.`Total Wickets`
FROM `Total Runs B` B
INNER JOIN `Total Runs W` W 
USING (Bowler)
GROUP BY `Total Wickets`
ORDER BY `Total Wickets` DESC LIMIT 10;


# Calculating batsmen total runs at every match in 2018

 SELECT BTB.Batsman, BTR.`Total runs`, BTB.`Total Match`
FROM (SELECT B.Batsman,
COUNT(M.`Over`) AS `Total Overs`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE M.Date LIKE '%2018'
GROUP BY B.Batsman) AS BTB

JOIN (SELECT B.Batsman,
SUM(B.`Total runs`) AS `Total Runs`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE M.Date LIKE '%2018'
GROUP BY B.Batsman) AS BTR

ON (BTB.Batsman = BTR.Batsman)
ORDER BY BTR.`Total Runs` DESC;  


# Calculating batsmen total '4s' at every match in 2018

SELECT BTB.Batsman, BTR.`Total runs`, BTB.`Total 4s`
FROM (SELECT B.Batsman,
COUNT(B.`Total runs`) AS `Total 4s`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE `Total runs`=6 AND M.Date LIKE '%2018'
GROUP BY B.Batsman) AS BTB

JOIN (SELECT B.Batsman,
SUM(B.`Total runs`) AS `Total Runs`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE M.Date LIKE '%2018'
GROUP BY B.Batsman) AS BTR

ON (BTB.Batsman = BTR.Batsman)
ORDER BY BTR.`Total Runs` DESC;


# Calculating batsmen total '6s' at every match in 2018

SELECT BTB.Batsman, BTR.`Total runs`, BTB.`Total 6s`
FROM (SELECT B.Batsman,
COUNT(B.`Total runs`) AS `Total 6s`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE `Total runs`=6 AND M.Date LIKE '%2018'
GROUP BY B.Batsman) AS BTB

JOIN (SELECT B.Batsman,
SUM(B.`Total runs`) AS `Total Runs`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE M.Date LIKE '%2018'
GROUP BY B.Batsman) AS BTR

ON (BTB.Batsman = BTR.Batsman)
ORDER BY BTR.`Total Runs` DESC;


# Sum of batsmen total 'balls', 'runs', '4s', '6s'

SELECT R.Batsman, R.`total Balls`, R.`total runs`, R.`Total 4s`, S.`Total 6s` 
FROM `Total runs` R
INNER JOIN `Total 6s` S
USING (Batsman)
GROUP BY Batsman
ORDER BY `Total runs` DESC LIMIT 10;


# Calculating total maidens by bowler in 2018

SELECT B.Bowler, 
COUNT(B.`Total runs`) AS Maidens
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID)
WHERE B.`Total runs`=0 AND M.Date LIKE '%2018'
GROUP BY Bowler
ORDER BY Maidens DESC LIMIT 10;


# Calculating bowlers 'maidens' at every matchs in 2018

SELECT BTR.Bowler, BTB.`Total Matches`, BTR.Maidens 
FROM (SELECT B.Bowler,
COUNT(B.`Total runs`) AS Maidens
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID)
WHERE B.`Total runs`=0 AND M.Date LIKE '%2018'
GROUP BY B.Bowler) AS BTR

JOIN (SELECT B.Bowler,
COUNT(M.Winner) AS `Total Matches`
FROM `IPL Matches` M
INNER JOIN `IPL Balls` B
USING (ID)
WHERE M.Date LIKE '%2018' 
GROUP BY B.Bowler) AS BTB

ON (BTR.Bowler=BTB.Bowler)
ORDER BY BTR.Maidens DESC;


# comparing two team who scored highiest '4s'

SELECT M.Team1, M.Team2,
COUNT(B.`Total Runs`) AS `Total 4s`, M.Venue
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID)
WHERE B.`Total Runs`=4 AND M.Date LIKE '%2018'
GROUP BY B.Batsman
ORDER BY `Total 4s` DESC;


# comparing two team who scored highiest '6s'

 SELECT  M.Team1, M.Team2,  
COUNT(B.`Total Runs`) AS `Total 6s`, M.Venue
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID)
WHERE B.`Total Runs`=6 AND M.Date LIKE '%2019' 
GROUP BY B.Batsman
ORDER BY `Total 6s` DESC;


# Sum of total 'runs', '4s', '6s' by batsmen

SELECT F.Batsman, F.`Total Runs`, F.`Total 4s`, S.`Total 6s`
FROM `Total 4s` F
INNER JOIN `Total 6s` S
USING (Batsman)
GROUP BY Batsman
ORDER BY `Total Runs` DESC;


# calculating total 'balls', 'balls left' by batsmen in 2018

SELECT BTB.Batsman, BTB.`Total Balls`, BTR.`Total Balls Left`
FROM (SELECT B.Batsman,
COUNT(B.Ball) AS `Total Balls`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE  M.Date LIKE '%2018'
GROUP BY B.Batsman) AS BTB

JOIN (SELECT B.Batsman,
COUNT(B.`Total runs`) AS `Total Balls Left`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE `Total Runs`=0 AND M.Date LIKE '%2018'
GROUP BY B.Batsman) AS BTR

ON (BTB.Batsman = BTR.Batsman)
ORDER BY BTB.`Total Balls` DESC;


# Calculating total balls and runs given by bowler in 2018

SELECT BTB.Bowler, BTB.`Total Balls`, BTR.`Total Runs`
FROM (SELECT B.Bowler,
COUNT(B.Ball) AS `Total Balls`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE M.Date LIKE '%2018'
GROUP BY B.Bowler) AS BTB

JOIN (SELECT B.Bowler,
SUM(B.`Batsman Runs`) AS `Total Runs`
FROM `IPL Balls` B
INNER JOIN `IPL Matches` M
USING (ID) 
WHERE M.Date LIKE '%2018'
GROUP BY B.Bowler) AS BTR

ON (BTB.Bowler = BTR.Bowler)
ORDER BY BTR.`Total Runs` DESC;


# Calculating total 'balls', 'wickets', 'runs' by bowler

SELECT B.Bowler, B.`Total Balls`, B.`Total Wicket`, W.`Total Runs`
FROM `Total Runs B` B
INNER JOIN  `Total Runs W` W
USING (Bowler)
GROUP BY Bowler
ORDER BY B.`Total Wicket` DESC;