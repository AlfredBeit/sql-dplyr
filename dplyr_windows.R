require(dplyr)
require(lubridate)


data <-
  read.csv(
    '/Users/abittaraev/Desktop/test_task_mail_ru/sql_dplyr.csv',
    stringsAsFactors = FALSE,
    header = TRUE
  )

print(data)


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
