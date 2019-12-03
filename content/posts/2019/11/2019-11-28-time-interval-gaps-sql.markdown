title: Finding gaps in time intervals in SQL
date: 2019-11-27 23:00
Category: Computers
Tags: SQL, WindowFunctions

I have a table in a relational database (PostgreSQL) that contains time intervals. In this post I'll show you how to find gaps in those intervals. 

<!-- more -->

Those of you who follow me on Twitter know that for some time now I've been the head of security at my local mosque. Because I'm also a nerd I decided to create a website that allows security volunteers to sign up for events. Sometimes a volunteer may not be available for the entire duration of the event, so we need two or more people to sign up for the event. For every event it is important that I know whether or not there are gaps in coverage. For example, if an event lasts from 10:00 to noon, and volunteer A signs up from 10:00 to 11:00 and volunteer B signs up from 11:15 to noon, I want to know that there is a gap in coverage from 11:00 to 11:15. I'll show you how to do this in this blog post. 

Given the tables `event` and `signup` I want to create a function called `find_gaps_for_event` that returns a list of all gaps in coverage for that event. Let's look at the final result first, and then I'll show you how it's done. Keep in mind that these tables are simplified for the purposes of this post. For example, I'm not using foreign keys into a volunteer table, but just including the volunteer's name as a column in the `signup` table. 

## Final Result

    :::sql
    db=> CREATE TABLE event (
          id SERIAL UNIQUE PRIMARY KEY NOT NULL
        , name VARCHAR (256) NOT NULL
        , start_dt TIMESTAMP WITH TIME ZONE NOT NULL
        , end_dt TIMESTAMP WITH TIME ZONE NOT NULL
    );
    
    db=> CREATE TABLE signup (
          id SERIAL UNIQUE PRIMARY KEY NOT NULL
        , event_id INT NOT NULL REFERENCES event(id)
        , person VARCHAR(8)
        , start_dt TIMESTAMP WITH TIME ZONE NOT NULL
        , end_dt TIMESTAMP WITH TIME ZONE NOT NULL
    );
    
    db=> INSERT INTO event (name, start_dt, end_dt) 
         VALUES ('E1'
               , '2019-11-28 10:00MST'
               , '2019-11-28 10:15MST');
    
     INSERT INTO signup (event_id, person, start_dt, end_dt) 
         VALUES (1
               , 'Ali'
               , '2019-11-28 10:02MST'
               , '2019-11-28 10:10MST');
    
     INSERT INTO signup (event_id, person, start_dt, end_dt) 
         VALUES (1
               , 'Bob'
               , '2019-11-28 10:03MST'
               , '2019-11-28 10:08MST');
    
     INSERT INTO signup (event_id, person, start_dt, end_dt) 
         VALUES (1
               , 'Carol'
               , '2019-11-28 10:11MST'
               , '2019-11-28 10:13MST');
    
     INSERT INTO signup (event_id, person, start_dt, end_dt) 
         VALUES (1
               , 'Dave'
               , '2019-11-28 10:13MST'
               , '2019-11-28 10:14MST');
    
    db=> SELECT * FROM event;
     id | name |        start_dt        |         end_dt         
    ----+------+------------------------+------------------------
      1 | E1   | 2019-11-28 10:00:00-07 | 2019-11-28 10:15:00-07
    (1 row)
    
     id | event_id | person |        start_dt        |         end_dt         
    ----+----------+--------+------------------------+------------------------
      8 |        1 | Ali    | 2019-11-28 10:02:00-07 | 2019-11-28 10:10:00-07
      9 |        1 | Bob    | 2019-11-28 10:03:00-07 | 2019-11-28 10:08:00-07
     10 |        1 | Carol  | 2019-11-28 10:11:00-07 | 2019-11-28 10:13:00-07
     11 |        1 | Dave   | 2019-11-28 10:13:00-07 | 2019-11-28 10:14:00-07
    (4 rows)
    
    db=> SELECT * FROM find_gaps_for_event(1);
     id |        start_dt        |         end_dt         
    ----+------------------------+------------------------
      1 | 2019-11-28 10:00:00-07 | 2019-11-28 10:02:00-07
      1 | 2019-11-28 10:10:00-07 | 2019-11-28 10:11:00-07
      1 | 2019-11-28 10:14:00-07 | 2019-11-28 10:15:00-07
    (3 rows)
    
    db=> 

Here is a graphical representation of this data: 

<!-- img SQLGap png 1 Gaps in time spans, illustrated -->

[^1]: (AijazCC)

## Constructing the Solution

The first thing that came to my mind was to use window functions to find the `lag` between events. The `lag` window function accesses the value from a previous row. 

For example, if you have a table `t` with one `INT` column named `v`: 

```sql
db=> SELECT * FROM t;
 v  
----
  1
  2
  4
  7
  8
  8
 20
 30
  2
  3
(10 rows)

db=> SELECT v, v - LAG(v) OVER () AS lag FROM t;
 v  | lag 
----+-----
  1 |    
  2 |   1
  4 |   2
  7 |   3
  8 |   1
  8 |   0
 20 |  12
 30 |  10
  2 | -28
  3 |   1
(10 rows)

db=> 
```

You can see that for every row (other than the first) the value of the `lag` column is the value of the `v` column minus the value of the `v` column from the _previous_ row. 

If we want, we can order the columns with the `OVER` clause: 

```sql
db=> SELECT v, v - LAG(v) OVER (ORDER by v) AS lag FROM t;
 v  | lag 
----+-----
  1 |    
  2 |   1
  2 |   0
  3 |   1
  4 |   1
  7 |   3
  8 |   1
  8 |   0
 20 |  12
 30 |  10
(10 rows)
```

You can learn a lot more about window functions [here][w1], [here][w2] and from Julia Evans [here][b0rk] and [here][bork2]. 

Now, knowing this, we can try using `lag` on our dataset:

```sql
db=> SELECT signup.start_dt
 , signup.end_dt 
 , start_dt - LAG(signup.end_dt) OVER (ORDER BY start_dt, end_dt) AS lag
 FROM signup
 WHERE signup.event_id = 1
 ORDER BY signup.start_dt, signup.end_dt
 ;
        start_dt        |         end_dt         |    lag    
------------------------+------------------------+-----------
 2019-11-28 10:02:00-07 | 2019-11-28 10:10:00-07 | 
 2019-11-28 10:03:00-07 | 2019-11-28 10:08:00-07 | -00:07:00
 2019-11-28 10:11:00-07 | 2019-11-28 10:13:00-07 | 00:03:00
 2019-11-28 10:13:00-07 | 2019-11-28 10:14:00-07 | 00:00:00
(4 rows)

db=> 
```

Almost, but not quite. There are a few problems with this query: First, it doesn't recognize the gaps that occur at the beginning or the end of a time span. We want the query to recognize the gap from 10:00 to 10:02 and from 10:14 to 10:15. 

The second issue is that the query overestimates the gap before 10:11. It should report a one-minute gap from 10:10 to 10:11, but it instead reports a three-minute gap from 10:08 to 10:11. This is because of the sort order that we're using (sorting by the start date).  

Furthermore, we see a lag of -7 minutes in the second row. That's because the second time slot starts before the first one ends. There is an overlap in time slots. We need to find a way to work with these kinds of overlaps.  

Finally, we don't wanna see lags of zero length. That's what happens when we have two adjacent intervals. 

We could fix the first problem by creating two zero-length intervals, one at the start, and one at the end of the required time span. 

```sql
db=> WITH T1 as (
    SELECT start_dt, end_dt FROM signup WHERE event_id = 1
    UNION
    SELECT '2019-11-28 10:00MST' AS start_dt, '2019-11-28 10:00MST' AS end_dt
    UNION
    SELECT '2019-11-28 10:15MST' AS start_dt, '2019-11-28 10:15MST' AS end_dt
    )
    SELECT T1.start_dt
 , T1.end_dt 
 , T1.start_dt - LAG(T1.end_dt) OVER (ORDER BY T1.start_dt, T1.end_dt) AS lag
 FROM T1
 ORDER BY T1.start_dt, T1.end_dt
 ;
        start_dt        |         end_dt         |    lag    
------------------------+------------------------+-----------
 2019-11-28 10:00:00-07 | 2019-11-28 10:00:00-07 | 
 2019-11-28 10:02:00-07 | 2019-11-28 10:10:00-07 | 00:02:00
 2019-11-28 10:03:00-07 | 2019-11-28 10:08:00-07 | -00:07:00
 2019-11-28 10:11:00-07 | 2019-11-28 10:13:00-07 | 00:03:00
 2019-11-28 10:13:00-07 | 2019-11-28 10:14:00-07 | 00:00:00
 2019-11-28 10:15:00-07 | 2019-11-28 10:15:00-07 | 00:01:00
(6 rows)

db=> 
```

Better. We're using the `WITH` keyword to use Common Table Expressions to create temporary tables. We do this so that we don't end up with one very complicated SQL statement. (To learn more about Common Table Expressions, see [the PostgreSQL documentation][cte].) Now we're correctly recognizing the two-minute gap at the start and the one-minute gap at the end. If we limit ourselves to positive lags, we get closer to the correct results:

```sql
db=> WITH T1 AS (
    SELECT start_dt, end_dt FROM signup WHERE event_id = 1
    UNION
    SELECT '2019-11-28 10:00MST' AS start_dt, '2019-11-28 10:00MST' AS end_dt
    UNION
    SELECT '2019-11-28 10:15MST' AS start_dt, '2019-11-28 10:15MST' AS end_dt
    ),
T2 AS (
     SELECT T1.start_dt
   , T1.end_dt 
   , T1.start_dt - lag(T1.end_dt) over (ORDER BY T1.start_dt, T1.end_dt) AS lag
   FROM T1
 )
SELECT * FROM T2
 WHERE lag > '00:00:00'
 ORDER BY T2.start_dt, T2.end_dt
 ;
        start_dt        |         end_dt         |   lag    
------------------------+------------------------+----------
 2019-11-28 10:02:00-07 | 2019-11-28 10:10:00-07 | 00:02:00
 2019-11-28 10:11:00-07 | 2019-11-28 10:13:00-07 | 00:03:00
 2019-11-28 10:15:00-07 | 2019-11-28 10:15:00-07 | 00:01:00
(3 rows)

db=> 
```

Much better. Now we just need to fix that issue of overlapping signups that exaggerate the size of gaps. The easiest way to fix this is to prevent the possibility of an overlap by deconstructing each signup into its most basic components: signups one-minute in length. So, if we have a signup of three minutes from 10:02 to 10:05, we would replace that with a signup from 10:02 to 10:03, a signup from 10:03 to 10:04, and a signup from 10:04 to 10:05. How do we do this?

There is a function called `generate_series` that can be used to generate a series of rows, each with one value:

```sql
db=> SELECT generate_series(1, 9, 2);
 generate_series 
-----------------
               1
               3
               5
               7
               9
(5 rows)

db=> 
```

Here we're generating a series of integers from 1 to 9, with a step of 2. It turns out, we can also do this with timestamps! 

```sql
db=> SELECT generate_series('2019-11-28 10:02:00-07'::TIMESTAMP
                          , '2019-11-28 10:10:00-07'::TIMESTAMP
                          , '1 minute'::INTERVAL);
    generate_series     
------------------------
 2019-11-28 10:02:00-07
 2019-11-28 10:03:00-07
 2019-11-28 10:04:00-07
 2019-11-28 10:05:00-07
 2019-11-28 10:06:00-07
 2019-11-28 10:07:00-07
 2019-11-28 10:08:00-07
 2019-11-28 10:09:00-07
 2019-11-28 10:10:00-07
(9 rows)

db=> 
```

For an interval from 10:02 to 10:10 we don't want to create 9 rows as shown above, but rather create 8 rows. This is because we want the last row to have a start time of 10:09 and an end time of 10:10. So we subtract one minute from the end time:

```sql
db=> SELECT generate_series('2019-11-28 10:02:00-07'::TIMESTAMP
                          , '2019-11-28 10:10:00-07'::TIMESTAMP - 
                              '1 minute'::INTERVAL
                          , '1 minute'::INTERVAL);
   generate_series   
---------------------
 2019-11-28 10:02:00
 2019-11-28 10:03:00
 2019-11-28 10:04:00
 2019-11-28 10:05:00
 2019-11-28 10:06:00
 2019-11-28 10:07:00
 2019-11-28 10:08:00
 2019-11-28 10:09:00
(8 rows)

db=> 
```

Now, we want to get both the start _and_ end times, so we add another call to generate_series, but this time we add one minute to the first item in the series. This effectively breaks down the larger interval from 10:02 to 10:10 into eight minute-long intervals. Perfect. 

```sql
db=> SELECT 
     generate_series('2019-11-28 10:02:00-07'::TIMESTAMP
                   , '2019-11-28 10:10:00-07'::TIMESTAMP - 
                       '1 minute'::INTERVAL
                   , '1 minute'::INTERVAL) as start_dt
   , generate_series('2019-11-28 10:02:00-07'::TIMESTAMP +
                       '1 minute'::INTERVAL
                   , '2019-11-28 10:10:00-07'::TIMESTAMP
                   , '1 minute'::INTERVAL) as end_dt;
   generate_series   |   generate_series   
---------------------+---------------------
 2019-11-28 10:02:00 | 2019-11-28 10:03:00
 2019-11-28 10:03:00 | 2019-11-28 10:04:00
 2019-11-28 10:04:00 | 2019-11-28 10:05:00
 2019-11-28 10:05:00 | 2019-11-28 10:06:00
 2019-11-28 10:06:00 | 2019-11-28 10:07:00
 2019-11-28 10:07:00 | 2019-11-28 10:08:00
 2019-11-28 10:08:00 | 2019-11-28 10:09:00
 2019-11-28 10:09:00 | 2019-11-28 10:10:00
(8 rows)

db=> 
```

Now, we need to do this for each interval in our `signup` table. We need to expand each interval into multiple minute-long intervals. We need to call our `generate_series` once for each row of matching intervals. We can use Common Table Expressions once again:

```sql
db=> WITH T_SIGNUP AS (
        SELECT s.start_dt, s.end_dt 
        FROM signup s
        WHERE s.event_id = 1
        ORDER BY s.start_dt, s.end_dt
)
-- generate a series of start_times from start to end - 1 minute,
, T_SERIES AS (
    SELECT generate_series(su.start_dt
                         , su.end_dt - '1 minute'::INTERVAL
                         , '1 minute'::INTERVAL
                         ) AS start_dt, 
           generate_series(su.start_dt + '1 minute'::INTERVAL
                         , su.end_dt 
                         , '1 minute'::INTERVAL
                         ) AS end_dt
           FROM T_SIGNUP su
)
SELECT * FROM T_SERIES ORDER BY start_dt;
        start_dt        |         end_dt         
------------------------+------------------------
 2019-11-28 10:02:00-07 | 2019-11-28 10:03:00-07
 2019-11-28 10:03:00-07 | 2019-11-28 10:04:00-07
 2019-11-28 10:03:00-07 | 2019-11-28 10:04:00-07
 2019-11-28 10:04:00-07 | 2019-11-28 10:05:00-07
 2019-11-28 10:04:00-07 | 2019-11-28 10:05:00-07
 2019-11-28 10:05:00-07 | 2019-11-28 10:06:00-07
 2019-11-28 10:05:00-07 | 2019-11-28 10:06:00-07
 2019-11-28 10:06:00-07 | 2019-11-28 10:07:00-07
 2019-11-28 10:06:00-07 | 2019-11-28 10:07:00-07
 2019-11-28 10:07:00-07 | 2019-11-28 10:08:00-07
 2019-11-28 10:07:00-07 | 2019-11-28 10:08:00-07
 2019-11-28 10:08:00-07 | 2019-11-28 10:09:00-07
 2019-11-28 10:09:00-07 | 2019-11-28 10:10:00-07
 2019-11-28 10:11:00-07 | 2019-11-28 10:12:00-07
 2019-11-28 10:12:00-07 | 2019-11-28 10:13:00-07
 2019-11-28 10:13:00-07 | 2019-11-28 10:14:00-07
(16 rows)

db=> 
```

Excellent! Now we have all our signups broken down into one-minute long time spans. Note that we have duplicates for those times when our signups overlap. We could resolve this using `SELECT DISTINCT *`, but we're gonna use the following method instead: Remember that we still need to add a zero-length time span at the start and the end. We can use `UNION` for that. One of the side effects of `UNION` (as opposed to `UNION ALL`) is that it deletes identical rows, so we get the removal of duplicates for free when we `UNION` the tables together:

```sql
db=> WITH T_SIGNUP AS (
        SELECT s.start_dt, s.end_dt 
        FROM signup s
        WHERE s.event_id = 1
        ORDER BY s.start_dt, s.end_dt
)
-- generate a series of start_times from start to end - 1 minute,
-- inserting a zero-length interval at the start and the end
, T_SERIES AS (
    SELECT '2019-11-28 10:00MST' AS start_dt
         , '2019-11-28 10:00MST' AS end_dt
    UNION
    SELECT generate_series(su.start_dt
                         , su.end_dt - '1 minute'::INTERVAL
                         , '1 minute'::INTERVAL
                         ) AS start_dt, 
           generate_series(su.start_dt + '1 minute'::INTERVAL
                         , su.end_dt 
                         , '1 minute'::INTERVAL
                         ) AS end_dt
           FROM T_SIGNUP su
   UNION 
   SELECT '2019-11-28 10:15MST' AS start_dt
        , '2019-11-28 10:15MST' AS end_dt
)
SELECT * FROM T_SERIES ORDER BY start_dt;
        start_dt        |         end_dt         
------------------------+------------------------
 2019-11-28 10:00:00-07 | 2019-11-28 10:00:00-07
 2019-11-28 10:02:00-07 | 2019-11-28 10:03:00-07
 2019-11-28 10:03:00-07 | 2019-11-28 10:04:00-07
 2019-11-28 10:04:00-07 | 2019-11-28 10:05:00-07
 2019-11-28 10:05:00-07 | 2019-11-28 10:06:00-07
 2019-11-28 10:06:00-07 | 2019-11-28 10:07:00-07
 2019-11-28 10:07:00-07 | 2019-11-28 10:08:00-07
 2019-11-28 10:08:00-07 | 2019-11-28 10:09:00-07
 2019-11-28 10:09:00-07 | 2019-11-28 10:10:00-07
 2019-11-28 10:11:00-07 | 2019-11-28 10:12:00-07
 2019-11-28 10:12:00-07 | 2019-11-28 10:13:00-07
 2019-11-28 10:13:00-07 | 2019-11-28 10:14:00-07
 2019-11-28 10:15:00-07 | 2019-11-28 10:15:00-07
(13 rows)

db=>
```
This is exactly what we need to start looking at the lags. Now we can add our SQL that calculates the lag. We're gonna add another temporary table to the bottom of this Common Table Expression chain:

```sql
db=> WITH T_SIGNUP AS (
        SELECT s.start_dt, s.end_dt 
        FROM signup s
        WHERE s.event_id = 1
        ORDER BY s.start_dt, s.end_dt
)
-- generate a series of start_times from start to end - 1 minute,
-- inserting a zero-length interval at the start and the end
, T_SERIES AS (
    SELECT '2019-11-28 10:00MST' AS start_dt
         , '2019-11-28 10:00MST' AS end_dt
    UNION
    SELECT generate_series(su.start_dt
                         , su.end_dt - '1 minute'::INTERVAL
                         , '1 minute'::INTERVAL
                         ) AS start_dt, 
           generate_series(su.start_dt + '1 minute'::INTERVAL
                         , su.end_dt 
                         , '1 minute'::INTERVAL
                         ) AS end_dt
           FROM T_SIGNUP su
   UNION 
   SELECT '2019-11-28 10:15MST' AS start_dt
        , '2019-11-28 10:15MST' AS end_dt
)
, T_WINDOW AS (
    SELECT 
         TS.start_dt
         , TS.end_dt
         , TS.start_dt - 
            LAG(TS.end_dt) OVER (ORDER BY TS.start_dt, TS.end_dt)
            AS the_lag
    FROM T_SERIES TS
)
SELECT * FROM T_WINDOW;
        start_dt        |         end_dt         | the_lag  
------------------------+------------------------+----------
 2019-11-28 10:00:00-07 | 2019-11-28 10:00:00-07 | 
 2019-11-28 10:02:00-07 | 2019-11-28 10:03:00-07 | 00:02:00
 2019-11-28 10:03:00-07 | 2019-11-28 10:04:00-07 | 00:00:00
 2019-11-28 10:04:00-07 | 2019-11-28 10:05:00-07 | 00:00:00
 2019-11-28 10:05:00-07 | 2019-11-28 10:06:00-07 | 00:00:00
 2019-11-28 10:06:00-07 | 2019-11-28 10:07:00-07 | 00:00:00
 2019-11-28 10:07:00-07 | 2019-11-28 10:08:00-07 | 00:00:00
 2019-11-28 10:08:00-07 | 2019-11-28 10:09:00-07 | 00:00:00
 2019-11-28 10:09:00-07 | 2019-11-28 10:10:00-07 | 00:00:00
 2019-11-28 10:11:00-07 | 2019-11-28 10:12:00-07 | 00:01:00
 2019-11-28 10:12:00-07 | 2019-11-28 10:13:00-07 | 00:00:00
 2019-11-28 10:13:00-07 | 2019-11-28 10:14:00-07 | 00:00:00
 2019-11-28 10:15:00-07 | 2019-11-28 10:15:00-07 | 00:01:00
(13 rows)

db=> 
```

We're almost done. Note that once again `the_lag` in the first row is NULL. This is because there's no previous row. That's okay, because we only care about rows where `the_lag` is greater than zero (and not null). So we can finish up by adding a `WHERE` clause to only show rows with a non-zero lag. We also need to clean up our results a bit. If you noticed, the second row shows us a two-minute lag that _ended_ at 10:02, the `start_dt`. So we need to modify the matching rows to show a time span that starts at `start_dt` - `the_lag` and ends at `start_dt`:

```sql
db=> WITH T_SIGNUP AS (
        SELECT s.start_dt, s.end_dt 
        FROM signup s
        WHERE s.event_id = 1
        ORDER BY s.start_dt, s.end_dt
)
-- generate a series of start_times from start to end - 1 minute,
-- inserting a zero-length interval at the start and the end
, T_SERIES AS (
    SELECT '2019-11-28 10:00MST' AS start_dt
         , '2019-11-28 10:00MST' AS end_dt
    UNION
    SELECT generate_series(su.start_dt
                         , su.end_dt - '1 minute'::INTERVAL
                         , '1 minute'::INTERVAL
                         ) AS start_dt, 
           generate_series(su.start_dt + '1 minute'::INTERVAL
                         , su.end_dt 
                         , '1 minute'::INTERVAL
                         ) AS end_dt
           FROM T_SIGNUP su
   UNION 
   SELECT '2019-11-28 10:15MST' AS start_dt
        , '2019-11-28 10:15MST' AS end_dt
)
, T_WINDOW AS (
    SELECT 
         TS.start_dt
         , TS.end_dt
         , TS.start_dt - 
            LAG(TS.end_dt) OVER (ORDER BY TS.start_dt, TS.end_dt)
            AS the_lag
    FROM T_SERIES TS
)
SELECT tw.start_dt - tw.the_lag AS start_dt
     , tw.start_dt AS end_dt
FROM T_WINDOW tw
WHERE tw.the_lag != '00:00:00';
        start_dt        |         end_dt         
------------------------+------------------------
 2019-11-28 10:00:00-07 | 2019-11-28 10:02:00-07
 2019-11-28 10:10:00-07 | 2019-11-28 10:11:00-07
 2019-11-28 10:14:00-07 | 2019-11-28 10:15:00-07
(3 rows)

db=> 
```

And that's it! That's exactly the data we were looking for. It's a long SQL statement, but I hope that the way I broke it down helps you understand it. All that's left to do is to make it into a reusable function so that we don't have to hard-code any values in our SQL, and so that we don't have to include this long SQL into our client code:

```sql
db=> CREATE OR REPLACE FUNCTION find_gaps_for_event(p_event_id INT) 
     RETURNS TABLE (start_dt TIMESTAMP WITH TIME ZONE
                  , end_dt TIMESTAMP WITH TIME ZONE) AS
$$
DECLARE

v_event_start_dt TIMESTAMP WITH TIME ZONE;
v_event_end_dt TIMESTAMP WITH TIME ZONE;
arow RECORD;

BEGIN

-- get the start and end timestamps of the event
SELECT INTO arow * FROM event WHERE event.id = p_event_id;
v_event_start_dt = arow.start_dt;
v_event_end_dt = arow.end_dt;

-- This entire function is essentially one long query
RETURN QUERY 

-- first get the start date and end date of all signup interval 
-- records for that event
WITH T_SIGNUP AS (
        SELECT s.start_dt, s.end_dt 
        FROM signup s
        WHERE s.event_id = p_event_id
        ORDER BY s.start_dt, s.end_dt
)
-- generate a series of one-minute intervals
-- inserting a zero-length interval at the start and the end.
--
-- All tables in the UNION should have the same column names
-- for this to work.
, T_SERIES AS (
    SELECT v_event_start_dt AS start_dt
         , v_event_start_dt AS end_dt
    UNION
    SELECT generate_series(su.start_dt
                         , su.end_dt - '1 minute'::INTERVAL
                         , '1 minute'::INTERVAL
                         ) AS start_dt, 
           generate_series(su.start_dt + '1 minute'::INTERVAL
                         , su.end_dt 
                         , '1 minute'::INTERVAL
                         ) AS end_dt
           FROM T_SIGNUP su
    UNION SELECT v_event_end_dt AS start_dt
               , v_event_end_dt AS end_dt
) 
-- get the lag from each row
-- specifically, get this row's start date - the previous row's end date
-- if the lag is null use the start date of the current row (for the
-- first row in the series). This causes the first lag to be 00:00:00
-- COALESCE(a, b) returns a if a is not NULL and returns b if a is NULL.
, T_WINDOW AS (
    SELECT 
         TS.start_dt
         , TS.end_dt
         , TS.start_dt - 
            COALESCE(LAG(TS.end_dt) OVER (ORDER BY TS.start_dt, TS.end_dt)
                   , TS.start_dt) 
            AS the_lag
    FROM T_SERIES TS
) SELECT tw.start_dt - tw.the_lag
       , tw.start_dt FROM T_WINDOW tw
WHERE tw.the_lag != '00:00:00';

END;
$$ LANGUAGE plpgsql;

db=> SELECT * FROM find_gaps_for_event(1);
        start_dt        |         end_dt         
------------------------+------------------------
 2019-11-28 10:00:00-07 | 2019-11-28 10:02:00-07
 2019-11-28 10:10:00-07 | 2019-11-28 10:11:00-07
 2019-11-28 10:14:00-07 | 2019-11-28 10:15:00-07
(3 rows)

db=> 
```

I hope you've found this explanation helpful. If you have any questions about it, please feel free to ask me on [Twitter][twitter], where you can find me as @\_aijaz\_.

## References

- [PostgreSQL documentation of window functions][w1]
- [Vertabelo documentation of window functions][w2]
- [Julia Evans' tweet of window functions][b0rk]
- [Another tweet from Julia Evans about window functions][b0rk2]
- [PostgresQL documentation of Common Table Expressions][cte]



[w1]: https://www.postgresql.org/docs/12/tutorial-window.html
[w2]: https://academy.vertabelo.com/blog/sql-window-functions-examples/
[b0rk]: https://twitter.com/b0rk/status/1180483982288457728?lang=en
[b0rk2]: https://twitter.com/b0rk/status/1193952307941171201
[cte]: https://www.postgresql.org/docs/12/queries-with.html
[twitter]: http://twitter.com/_aijaz_


