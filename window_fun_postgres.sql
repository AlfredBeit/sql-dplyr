/*Given the structure below
find how many transactions, on average, 
each user executes during a 12 hours timespan 
starting from the first transaction.*/

CREATE TABLE IF NOT EXISTS transactions (
transactions_ts timestamp ,
user_id bigint  NOT NULL,
transaction_id bigint NOT NULL, 
item varchar(200), PRIMARY KEY(transaction_id)
);

 INSERT INTO transactions (transactions_ts, user_id,  transaction_id,item )
VALUES ('2016-06-18 13:46:51.0', 13811335,1322361417, 'glove'),
('2016-06-18 17:29:25.0', 13811335,3729362318, 'hat'),
('2016-06-18 23:07:12.0', 13811335,1322363995,'vase' ),
('2016-06-19 07:14:56.0',13811335,7482365143, 'cup'),	
('2016-06-19 21:59:40.0',13811335,1322369619,'mirror' ),
('2016-06-17 12:39:46.0',3378024101,9322351612, 'dress'),
('2016-06-17 20:22:17.0',3378024101,9322353031,'vase' ),
('2016-06-20 11:29:02.0',3378024101,6928364072,'tie'),
('2016-06-20 18:59:48.0',13811335,1322375547, 'mirror');

/*Answer*/


SELECT 
round((1.0*COUNT(DISTINCT transaction_id))/(1.0*COUNT(DISTINCT user_id)), 1)
AS avg_ts_per_user

FROM (

SELECT *, 
MIN(transactions_ts)
OVER(PARTITION BY user_id ) AS min_ts,
MIN(transactions_ts) 
OVER(PARTITION BY user_id) + '10 hours' AS right_ts
FROM transactions
ORDER BY user_id, transactions_ts ASC

) AS t1
WHERE t1.transactions_ts BETWEEN t1.min_ts AND t1.right_ts;