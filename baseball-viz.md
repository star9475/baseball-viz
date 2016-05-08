
<style>
.small-code pre code {
  font-size: 1em;
}
</style>
Coursera Developing Data Products - baseball-viz
========================================================
author: Josh Starkey
date: 5-8-2016
autosize: true
class: small-code

Baseball Visualization 
========================================================

<small>This project is for the Coursera Developing Data Projects Class.  The project is to create a Shiny Application and a Reproducible pitch.  Specific details about the project are located</p>  <code><https://www.coursera.org/learn/data-products/peer/tMYrn/course-project-shiny-application-and-reproducible-pitch></code>.

The project Shiny app has three tabs:

- About - This gives the user a small description of the project and how to use it.
- Heatmaps - The user can select a player and it plots the batted balls in a strikezone view.
- Hit Type Expectancy - The user can view a players batted balls via launch angle and hit velocity.  At the bottom of this plot is a Hit Expectancy model.  The user can input a launch angle and velocity and an expected hit type is shown. 

Data provided courtesy of <http://baseballsavant.com></small>

Hitter Heatmaps
========================================================
left: 50% 

```r
library(ggplot2)
p <- ggplot(selectedplayer, aes(px, pz, z = hit_speed)) + 
     stat_summary_hex(bins=50) +
     scale_fill_gradientn(colours = c("darkgreen", "gold", "red")) +theme_minimal()+
     labs(x = "Horizontal Axis", y = "Vertical Axis", title = "Exit Velocity Heatmap") +        xlim(-2.5, 2.5) + ylim(0,5)
```
***
![plot of chunk unnamed-chunk-3](baseball-viz-figure/unnamed-chunk-3-1.png)

Exit Velocity / Launch Angle
========================================================
left: 60% 
![plot of chunk unnamed-chunk-4](baseball-viz-figure/unnamed-chunk-4-1.png)
***
<br>Note: in the shiny app, this plot is rendered in plotly. I was getting errors rendering it in the RMD.

The Prediction Model
========================================================
<small>The hit expectancy model is a random forest trained on all Mariners 2016 hit outcomes.

```r
model.RF <- train(events~.,data=data4model,method="rf",
                  trControl=trainControl(method="cv",number=5),prox=TRUE)
```


```
  mtry  Accuracy     Kappa AccuracySD    KappaSD
1    2 0.5679719 0.4561887 0.02265362 0.02879415
```
The model accuracy isn't great.  For future iterations the plan is to add more features like hit locations put into areas.  But for this project, I focused on Shiny and created a basic model for reactivity.

- The shiny app is located here : <https://star9475.shinyapps.io/baseball-viz/><br>
- The github repo for the project is here : <https://github.com/star9475><br>
- Please email questions or comments to <star9475@hotmail.com><br>
</small>

