require(dplyr)
require(lubridate)

#### 
# Given the structure below
# find how many transactions, on average, 
# each user executes during a 12 hours timespan 
# starting from the first transaction.
####

data <- data.frame(
  transactions_ts = c(
    "2016-06-18 13:46:51",
    "2016-06-18 17:29:25",
    "2016-06-18 23:07:12",
    "2016-06-19 07:14:56",
    "2016-06-19 21:59:40",
    "2016-06-17 12:39:46",
    "2016-06-17 20:22:17",
    "2016-06-20 11:29:02",
    "2016-06-20 18:59:48"
    
  ),
  user_id = c(rep(13811335, 5),
              rep(3378024101, 3),
              13811335),
  transaction_id = c(
    1322361417,
    3729362318,
    1322363995,
    7482365143,
    1322369619,
    9322351612,
    9322353031,
    6928364072,
    1322375547
  ),
  item = c(
    "glove",
    "hat",
    "vase",
    "cup",
    "mirror",
    "dress",
    "vase",
    "tie",
    "mirror"
  )
)

print(data)

# Answer

data %>%
  group_by(user_id) %>%
  mutate(
    transactions_ts = lubridate::ymd_hms(transactions_ts),
    time_first = min(transactions_ts),
    time_right = time_first + hours(10)
  ) %>%
  arrange(user_id, transactions_ts, desc(transactions_ts)) %>%
  filter(transactions_ts >= time_first &
           transactions_ts < time_right)  %>%
  ungroup() %>%
    summarise(avg_per_user = n_distinct(transaction_id) / n_distinct(user_id))
