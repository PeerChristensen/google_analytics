library(googleAnalyticsR)
library(lubridate)
library(tidyverse)
library(ggthemes)
library(tmap)
library(raster)
library(maptools)
library(sp)

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
                      metrics = "sessions",
                      dimensions = "country")

write_csv(df,"data/country_sessions_july_2019.csv")

df <- read_csv("data/country_sessions_july_2019.csv")

df <- df %>%
  filter(country != "(not set)") %>%
  mutate(country = factor(country),
         log_sessions = log(sessions))

data(wrld_simpl)

myMap <- wrld_simpl

df_map  <- sp::merge(myMap,df,by.x = "NAME",by.y= "country")

tmap_mode("view")  # for an interactive leaflet map
#tmap_mode("plot") # for a static map

tm_shape(df_map) +
  tm_polygons("log_sessions",palette="Greens",
              popup.vars=c("sessions")) +
  tm_layout(title = "Sessions by country",
            title.position = c("center","top")) +
  tm_style("cobalt")
#+  tm_text("NAME", auto.placement = TRUE,size = .7)

