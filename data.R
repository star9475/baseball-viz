# Load required libraries
#require(data.table)
# library(sqldf)
library(dplyr)
library(stringr)
library(randomForest)
#library(DT)
#library(rCharts)
library(caret)
library(e1071)

topKzone <- 3.5
botKzone <- 1.6
inKzone <- -.95
outKzone <- 0.95

# Read data, courtesy from baseballsavant.com
#data <- read.csv("data/baseball_savant0.csv")
## 
## here is the url for this data.  Future udpates i should automatically load data, or put the data
## in a google sheet
##
# https://baseballsavant.mlb.com/statcast_search?hfPT=&hfZ=&hfGT=R%7C&hfPR=&hfAB=&stadium=&hfBBT=&hfBBL=&hfC=&season=2016&player_type=batter&hfOuts=&pitcher_throws=&batter_stands=&start_speed_gt=&start_speed_lt=&perceived_speed_gt=&perceived_speed_lt=&spin_rate_gt=&spin_rate_lt=&exit_velocity_gt=&exit_velocity_lt=&launch_angle_gt=&launch_angle_lt=&distance_gt=&distance_lt=&batted_ball_angle_gt=&batted_ball_angle_lt=&game_date_gt=&game_date_lt=&team=SEA&position=&hfRO=&home_road=&hfInn=&min_pitches=0&min_results=0&group_by=name&sort_col=pitches&sort_order=desc&min_abs=0&px1=&px2=&pz1=&pz2=#results

data_raw <- read.csv("data/savant_data_mariners_2016_05_05.csv", stringsAsFactors = FALSE)

## tidy the data
#data_raw$name <- str_trim(data_raw$name)
#datatodisplay <- data_raw[c(1,3:5)]
data_tidy <- data_raw %>% 
          group_by(player_name) %>% 
          tally() %>% 
          arrange(desc(n)) %>% 
          filter(n > 100)
     
     
players <- data_tidy$player_name

#data2raw <- read.csv("data/savant_data_2016_05_01.csv") 
data2_tidy <- data_raw %>%
     filter(hit_angle != "null") %>%
     #select(batter_name,hit_angle,hit_speed, events) %>%
     select(player_name, px, pz, hit_angle,hit_speed, events) %>%
     mutate(hit_speed = as.numeric(hit_speed)) %>%
     mutate(hit_angle = as.numeric(hit_angle)) %>%
     mutate(px = as.numeric(px)) %>%
     mutate(pz = as.numeric(pz)) %>%
     #     mutate_each(funs(as.numeric(levels(hit_speed)[hit_speed])), hit_speed ) %>%
     #mutate_each(funs(as.numeric(levels(hit_angle)[hit_angle])), hit_angle ) %>%
     filter(events %in% c("Single", "Double", "Flyout", "Groundout", "Home Run", "Lineout", "Pop Out", "Sac Fly", "Triple"))
data2_tidy$events <- factor(data2_tidy$events)
#data2_tidy$id <- as.integer(data2_tidy$events)

data4model <- data2_tidy %>% select( hit_angle,hit_speed, events)
     
model.RF <- train(events~.,data=data4model,method="rf",trControl=trainControl(method="cv",number=5),prox=TRUE)

## to plot this
# plot_ly(data = data2_tidy, x = hit_speed, y = hit_angle, mode = "markers", color=events)
# p <- plot_ly(data2_tidy, x = hit_speed, y = hit_angle, group = events,
#              xaxis = paste0("x", id), mode = "markers")
# p2 <- subplot(p, nrows = 3)
# p2


getDatabyPlayer <- function(dt, player) {
     cat("detdata")
     result <- dt %>%
          filter(player_name==player) %>% 
          filter(!is.na(hit_speed))
     return(result)
}

modeling <- function(hit_angle, hit_speed) {
     #model.RF <- train(events~.,data=df,method="rf",trControl=trainControl(method="cv",number=5),prox=TRUE)
     df = data.frame(hit_angle, hit_speed)
     colnames(df) <- c("hit_angle", "hit_speed")
     predict.RF <- predict(model.RF, df)
     
     return(predict.RF)

}

