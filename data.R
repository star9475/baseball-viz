# Load required libraries
#require(data.table)
# library(sqldf)
library(dplyr)
library(stringr)
#library(DT)
#library(rCharts)
library(caret)
library(randomForest)

topKzone <- 3.5
botKzone <- 1.6
inKzone <- -.95
outKzone <- 0.95

# Read data, courtesy from baseballsavant.com
#data <- read.csv("data/baseball_savant0.csv")
data_raw <- read.csv("data/baseball_savant0.csv", stringsAsFactors = FALSE)

## tidy the data
data_raw$name <- str_trim(data_raw$name)
datatodisplay <- data_raw[c(1,3:5)]
data_tidy <- data_raw %>% 
          group_by(name) %>% 
          tally() %>% 
          arrange(desc(n)) %>% 
          filter(n > 100)
     
     
players <- data_tidy$name

data2raw <- read.csv("data/savant_data_2016_05_01.csv") 
data2_tidy <- data2raw %>%
     filter(hit_angle != "null") %>%
     #select(batter_name,hit_angle,hit_speed, events) %>%
     select(hit_angle,hit_speed, events) %>%
     mutate_each(funs(as.numeric(levels(hit_speed)[hit_speed])), hit_speed ) %>%
     mutate_each(funs(as.numeric(levels(hit_angle)[hit_angle])), hit_angle ) %>%
     filter(events %in% c("Single", "Double", "Flyout", "Groundout", "Home Run", "Lineout", "Pop Out", "Sac Fly", "Triple"))
data2_tidy$events <- factor(data2_tidy$events)
#data2_tidy$id <- as.integer(data2_tidy$events)

model.RF <- train(events~.,data=data2_tidy,method="rf",trControl=trainControl(method="cv",number=5),prox=TRUE)

## to plot this
# plot_ly(data = data2_tidy, x = hit_speed, y = hit_angle, mode = "markers", color=events)
# p <- plot_ly(data2_tidy, x = hit_speed, y = hit_angle, group = events,
#              xaxis = paste0("x", id), mode = "markers")
# p2 <- subplot(p, nrows = 3)
# p2


getDatabyPlayer <- function(dt, player) {
     cat("detdata")
     result <- dt %>%
          filter(name==player) %>% 
          filter(!is.na(batted_ball_velocity))
     return(result)
}

modeling <- function(hit_angle, hit_speed) {
     #model.RF <- train(events~.,data=df,method="rf",trControl=trainControl(method="cv",number=5),prox=TRUE)
     df = data.frame(hit_angle, hit_speed)
     colnames(df) <- c("hit_angle", "hit_speed")
     predict.RF <- predict(model.RF, df)
     
     return(predict.RF)

}

