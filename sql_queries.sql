SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

/*Given the structure below fill in missing dep_id and manager_id*/

CREATE TABLE IF NOT EXISTS `employees` (
  `id` int(6) unsigned NOT NULL,
  `name` varchar(200),
  `Dep_id` int(6) unsigned ,
  `Manager_id` int(6) unsigned,

  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;
INSERT INTO `employees` (`id`, `name`, `Dep_id`, `Manager_id`) VALUES
  ('1', 'John Smith',1,NULL ),
  ('2', 'Jack Smith',NULL,1),
  ('3', 'Becky Smith',1,2),
  ('4', 'Rebecca Smith',2,2),
  ('5', 'Sonny Smith',3,1);


/*Non - unique Answer*/


select e.id, e.name,
max(case when e.dep_id is null then t1.dep_id else e.dep_id end)
 as dep_id_new, 
max(case when e.manager_id is null then t1.manager_id else e.manager_id end)
 as man_id_new
from employees e cross join
(select id, dep_id, manager_id from employees  
where dep_id is not null
and manager_id is not null
) as  t1 
group by e.id,e.name;



/*Given the structure below
find how many transactions, on average, 
each user executes during a 12 hours timespan 
starting from the first transaction.*/

CREATE TABLE IF NOT EXISTS `transactions` (
  `transactions_ts` timestamp ,
  `user_id` int(6) unsigned NOT NULL,
  `transaction_id` bigint, 
  `item` varchar(200)
) DEFAULT CHARSET=utf8;
INSERT INTO `transactions` (`transactions_ts`, `user_id`, `transaction_id`,`item` ) VALUES
  ('2016-06-18 13:46:51.0', 13811335,1322361417, 'glove'),
  ('2016-06-18 17:29:25.0', 13811335,3729362318, 'hat'), 
  ('2016-06-18 23:07:12.0', 13811335,1322363995,'vase' ),
  ('2016-06-19 07:14:56.0',13811335,7482365143, 'cup'),
  ('2016-06-19 21:59:40.0',13811335,1322369619,'mirror' ),
  ('2016-06-17 12:39:46.0',3378024101,9322351612, 'dress'),
  ('2016-06-17 20:22:17.0',3378024101,9322353031,'vase' ),
  ('2016-06-20 11:29:02.0',3378024101,6928364072,'tie'),
  ('2016-06-20 18:59:48.0',13811335,1322375547, 'mirror');



/*Answer*/


select 
round(sum(dist_ts)/count(*),2 ) as avg_trans_num
from 
(select 
count(distinct transaction_id) as dist_ts, 
us_id 
from 
(select 
user_id as us_id, 
min(transactions_ts) as first_trans, 
min(transactions_ts) + interval 12 hour as right_trans 
from transactions group by us_id ) as t1 
inner join 
(select * from transactions ) as t2 
on t1.us_id=t2.user_id
where transactions_ts >= first_trans
and transactions_ts <  right_trans
group by us_id) as t3;













