/*No. of jobs reviewed in November 2020*/
SELECT ds, round(SUM(time_spent) / COUNT(*), 2) AS avg_time_spent FROM lang 
WHERE ds BETWEEN '01-11-2020' AND '30-11-2020' 
GROUP BY ds ORDER BY ds

/*Calculating weekly throughput*/
SELECT ds, event_per_day,
AVG(event_per_day)OVER(ORDER BY ds ROWS BETWEEN 6 PRECEDING AND  CURRENT ROW) 
AS 7_day_rolling_avg FROM
(SELECT ds, COUNT(DISTINCT event) AS event_per_day FROM lang 
WHERE ds BETWEEN '01-11-2020' and '30-11-2020'  GROUP BY ds  ORDER BY ds)a

/*Calculating percentage share of each language*/
select language, count(lang.language) as total_of_each_language,
((count(lang.language)/(select count(*) from lang))*100)percentage_share_of_each_language
from lang 
group by lang.language

/*Displaying the duplicates*/
select * from lang
where job_id in(
select job_id from lang 
group by job_id 
having count(*) > 1)

/*Calculate weekly user engagement*/
select week(occured_at) as Week,
count(distinct user_id) as Weekly_User_Engagement
from events
group by week(occured_at)
order by week(occured_at)

/*Calculate weekly retention of users- signup cohort*/
select user_id, occured_at
from users
where occured_at > '2014-05-01'
order by user_id;

/*Calculate weekly engagement per device*/
SELECT week(occured_at) as Weeks,
device,
count(distinct user_id)as User_engagement
FROM events
GROUP BY device,
week(occured_at)
ORDER BY week(occured_at);

/*Calculate email engagement metrics*/
SELECT week(occured_at) as Week,
count( DISTINCT ( CASE WHEN action = "sent_weekly_digest"
THEN user_id end )) as weekly_digest,
count( distinct ( CASE WHEN action = "sent_reengagement_email"
THEN user_id end )) as reengagement_mail,
count( distinct ( CASE WHEN action = "email_open"
THEN user_id end )) as opened_email,
count( distinct ( CASE WHEN action = "email_clickthrough"
THEN user_id end )) as email_clickthrough
FROM email
GROUP BY week(occured_at)
ORDER BY week(occured_at);