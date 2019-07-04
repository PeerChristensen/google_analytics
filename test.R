library(googleAnalyticsR)

id = "92259405339-rfnodtfcodpp2f2hbrsqf7vr5boskli0.apps.googleusercontent.com"

secret = "7Qal44fdjXflhYUYJ2nGIrQc"

options(googleAuthR.client_id = id)
options(googleAuthR.client_secret = secret)
options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/analytics")
options(httr_oob_default=TRUE)

# authorize the connection with Google Analytics servers
ga_auth()

## get your accounts
account_list <- ga_account_list()

## account_list will have a column called "viewId"
account_list$viewId

## View account_list and pick the viewId you want to extract data from. 
ga_id <- 170221508

## simple query to test connection
df <-google_analytics(ga_id,
                 date_range = c("2017-01-01", "2019-03-01"),
                 metrics = "sessions",
                 dimensions = "date")

df <-google_analytics(ga_id,
                      date_range = c("2017-01-01", "2019-03-01"),
                      metrics = "sessions",
                      dimensions = "country")

df <-google_analytics(ga_id,
                      date_range = c("2018-01-01", "2019-07-01"),
                      metrics = c("sessions","pageViews","timeOnPage","avgTimeOnpage"),
                      dimensions = c("country","source","pageTitle","landingPagePath","secondPagePath"))
