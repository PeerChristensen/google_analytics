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

df <- google_analytics(ga_id, 
                       date_range = c(start_date, as.character(today())),
                       metrics = "sessions", 
                       dimensions = c("dayOfWeek","hour"),
                       max = 5000)

write_csv(df,"data/hour_weekDay_july_2019.csv")

df <- read_csv("data/hour_weekDay_july_2019.csv")

df$dayOfWeek[df$dayOfWeek==0] <- 7

df <- df %>% 
  group_by(dayOfWeek,hour) %>%
  summarise(n_sessions = sum(sessions)) %>%
  ungroup() %>%
  mutate(hour = as.numeric(hour),
         dayOfWeek = factor(dayOfWeek)) %>%
         mutate(dayOfWeek = fct_recode(dayOfWeek,
                                       "Monday"    = "1",
                                       "Tuesday"   = "2",
                                       "Wednesday" = "3",
                                       "Thursday"  = "4",
                                       "Friday"    = "5",
                                       "Saturday"  = "6",
                                       "Sunday"    = "7"))

df %>%
  ggplot(aes(dayOfWeek,reorder(hour,rev(hour)),fill=n_sessions)) +
  geom_tile() +
  scale_fill_gradient_tableau("Classic Red") +
  theme_minimal()
