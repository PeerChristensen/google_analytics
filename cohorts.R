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

df1 <-google_analytics(ga_id,
                      date_range = c(start_date, as.character(today())),
                      metrics = c("1dayUsers"),
                      dimensions = c("date"),
                      max = 5000)

df2 <-google_analytics(ga_id,
                       date_range = c(start_date, as.character(today())),
                       metrics = c("7dayUsers"),
                       dimensions = c("date"),
                       max = 5000)

df3 <-google_analytics(ga_id,
                       date_range = c(start_date, as.character(today())),
                       metrics = c("14dayUsers"),
                       dimensions = c("date"),
                       max = 5000)

df4 <-google_analytics(ga_id,
                       date_range = c(start_date, as.character(today())),
                       metrics = c("30dayUsers"),
                       dimensions = c("date"),
                       max = 5000)

df <- df1 %>%
  add_column("7dayUsers" = df2$`7dayUsers`,
             "14dayUsers" = df3$`14dayUsers`,
             "30dayUsers" = df4$`30dayUsers`)

ggplot(df) +
  geom_line(aes(date,`1dayUsers`)) +
  geom_line(aes(date,`7dayUsers`,colour="red")) +
  geom_line(aes(date,`14dayUsers`,colour="blue")) 
  

write_csv(df,"data/page_session_rank_july_2019.csv")

df <- read_csv("data/page_session_rank_july_2019.csv")
