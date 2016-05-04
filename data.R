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
data <- read.csv("data/baseball_savant0.csv", stringsAsFactors = FALSE)

#data2raw <- read.csv("data/savant_data_2016_05_01.csv", stringsAsFactors = FALSE)
data2raw <- read.csv("data/savant_data_2016_05_01.csv") 
#data2raw$hit_speed <-as.numeric(levels(data2raw$hit_speed)[data2raw$hit_speed])
#data2raw$hit_angle <-as.numeric(levels(data2raw$hit_angle)[data2raw$hit_angle])
data2_tidy <- data2raw %>%
     filter(hit_angle != "null") %>%
     #select(batter_name,hit_angle,hit_speed, events) %>%
     select(hit_angle,hit_speed, events) %>%
     mutate_each(funs(as.numeric(levels(hit_speed)[hit_speed])), hit_speed ) %>%
     mutate_each(funs(as.numeric(levels(hit_angle)[hit_angle])), hit_angle ) %>%
     filter(events %in% c("Single", "Double", "Flyout", "Groundout", "Home Run", "Lineout", "Pop Out", "Sac Fly", "Triple"))
data2_tidy$events <- factor(data2_tidy$events)

model.RF <- train(events~.,data=data2_tidy,method="rf",trControl=trainControl(method="cv",number=5),prox=TRUE)

## to plot this
# plot_ly(data = data2_tidy, x = hit_speed, y = hit_angle, mode = "markers", color=events)
# p <- plot_ly(data2_tidy, x = hit_speed, y = hit_angle, group = events,
#              xaxis = paste0("x", id), mode = "markers")
# p2 <- subplot(p, nrows = 3)
# p2

## tidy the data
data$name <- str_trim(data$name)
datatodisplay <- data[c(1,3:5)]

players <- sort(unique(as.character(data$name)))
head(data)

getDatabyPlayer <- function(dt, player) {
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