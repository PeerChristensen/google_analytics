library(googleAnalyticsR)
library(lubridate)
library(tidyverse)

options(googleAuthR.client_id = id)
options(googleAuthR.client_secret = secret)
options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/analytics")
options(httr_oob_default=TRUE)

# authorize the connection with Google Analytics servers
ga_auth(new_user = T)

## get your accounts
account_list <- ga_account_list()

## account_list will have a column called "viewId"
account_list$viewId

## View account_list and pick the viewId you want to extract data from. 
ga_id <- 170221508

start_date <- "2018-02-20"

df <- google_analytics(ga_id, 
                       date_range = c(start_date, as.character(today())),
                       metrics = "sessions", 
                       dimensions = c("date","source"),
                       max = 5000)

write_csv(df,"data/date_sessions_source_july_2019.csv")

df <- read_csv("data/date_sessions_source_july_2019.csv")

# sessions by date

df %>% 
  ggplot(aes(date,sessions)) +
  geom_col()

# source rank
src_rank <- df %>%
  group_by(source) %>%
  count() %>%
  filter(n>1) %>%
  arrange(desc(n)) %>%
  ungroup() %>%
  mutate(row = rev(row_number()))

src_rank %>%
  ggplot(aes(row,n)) +
  geom_col() +
  scale_x_continuous(breaks = src_rank$row,
                     labels = src_rank$source) +
  coord_flip()




