library(googleAnalyticsR)
library(lubridate)
library(tidyverse)
library(ggthemes)
library(ggridges)

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
         mutate(dayOfWeek2 = fct_recode(dayOfWeek,
                                       "Monday"    = "1",
                                       "Tuesday"   = "2",
                                       "Wednesday" = "3",
                                       "Thursday"  = "4",
                                       "Friday"    = "5",
                                       "Saturday"  = "6",
                                       "Sunday"    = "7"))

# write data for heatmap
write_csv(df,"data/session_heatmap_july_2019.csv")

df <- read_csv("data/session_heatmap_july_2019.csv")

a <- df %>%
  ggplot() +
  geom_tile(aes(reorder(dayOfWeek2,dayOfWeek),reorder(hour,rev(hour)),fill=n_sessions)) +
  #geom_pointdensity(aes(reorder(dayOfWeek2,dayOfWeek),reorder(hour,rev(hour))),size=1, adjust=0.1)  +
  scale_fill_gradient_tableau("Classic Red") +
  theme_minimal() +
  themeval

library(ggpointdensity)
library(rayshader)

themeval = theme(panel.border = element_blank(), 
                 panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(), 
                 axis.line = element_blank(), 
                 axis.ticks = element_blank(),
                 axis.text.x = element_blank(), 
                 axis.text.y = element_blank(), 
                 axis.title.x = element_blank(), 
                 axis.title.y = element_blank(),
                 legend.key = element_blank(),
                 plot.margin = unit(c(0.5, 0, 0, 0), "cm"))

ggheight = plot_gg(a, multicore = TRUE, raytrace=TRUE, shadow_intensity = 0.3,
                   width=8,height=7, soliddepth = -100, save_height_matrix = TRUE,
                   background = "#f5e9dc", shadowcolor= "#4f463c",windowsize=c(1000,1000))


