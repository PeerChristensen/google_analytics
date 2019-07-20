library(googleAnalyticsR)
library(lubridate)
library(tidyverse)
library(ggthemes)


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

df <-google_analytics(ga_id,
                      date_range = c(start_date, as.character(today())),
                      metrics = c("uniquePageViews","TimeOnPage","avgTimeOnPage"),
                      dimensions = c("pageTitle","pagePathLevel2"))


write_csv(df,"data/page_session_rank_july_2019.csv")

df <- read_csv("data/page_session_rank_july_2019.csv")

df <- df %>%
  mutate(page = str_remove_all(pagePathLevel2,"/")) %>%
  select(-pageTitle, -pagePathLevel2) %>%
  group_by(page) %>%
  summarise(uniquePageViews = sum(uniquePageViews),
            timeOnPage = sum(TimeOnPage)) %>%
  mutate(avgTimeOnPage = timeOnPage / uniquePageViews) 

write_csv(df,"data/page_session_rank_july_2019_summarised.csv")

df %>%
  top_n(25,uniquePageViews) %>%
  ggplot(aes(reorder(page,uniquePageViews),uniquePageViews,fill=avgTimeOnPage)) +
  geom_col() +
  coord_flip() +
  scale_fill_continuous_tableau("Blue")

