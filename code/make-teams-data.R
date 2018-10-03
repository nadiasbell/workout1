
  ##################################################
## Title: NBA Team Table
## Description: Make Table for Ranking Analysis
## Input(s): NBA plater data table
## Output(s):
##################################################
  
library(dplyr)
library(readr)
  
#set working directory 

#read in original NBA table
nba2018 <- read_csv(file = "../data/nba2018.csv",  col_types = cols(.default = col_integer(), player = col_character(), team = col_character(), height = col_character(), birth_date = col_character(), country = col_character(), experience = col_character(), college = col_character(), position = col_factor(levels = c("C", "PF", "PG", "SF", "SG")), salary = col_double(), field_goals_perc = col_double(), points3_perc = col_double(), points2_perc = col_double(), points1_perc = col_double(), effective_field_goal_perc = col_double()))

nba2018

## Preprocessing columns salary, experience and position 

# remove R's and change to integer values 
nba2018$experience[nba2018$experience == "R"] <- 0
nba2018$experience <- as.integer((nba2018$experience))
nba2018
#convert salary to millions 
nba2018$salary <- nba2018$salary/1000000

#give factor levels more descriptive names 
levels(nba2018$position) <- list(Center= "C", power_fwd = "PF", point_guard = "PG", small_fwd = "SF", shoot_guard = "SG")
nba2018

#add columns to nba2018 

nba2018 <- mutate(nba2018, missed_fg =nba2018$field_goals_atts - nba2018$field_goals)
nba2018 <- mutate(nba2018, missed_ft =nba2018$points1_atts - nba2018$points1)
nba2018 <- mutate(nba2018, rebounds =nba2018$off_rebounds + nba2018$def_rebounds)
nba2018 <- mutate(nba2018, efficiency = (nba2018$points + nba2018$rebounds + nba2018$assists +nba2018$steals + nba2018$blocks - nba2018$missed_fg -nba2018$missed_ft - nba2018$turnovers)/nba2018$games)

#send R output of summary on efficiency 

sink("../output/efficiency-summary.txt")
summary(nba2018 $ efficiency)
sink()

#creating nba2018_teams.csv 

teams <- summarise(group_by(nba2018, team), experience = sum(experience), salary = sum(salary), points3 = sum(points3), points2 = sum(points2), points1 = sum(points1), points=sum(points), off_rebounds = sum(off_rebounds), def_rebounds = sum(def_rebounds), assists = sum(assists), steals = sum(steals), blocks = sum(blocks), turnovers = sum(turnovers), fouls = sum(fouls), efficiency = sum(efficiency))
teams
str(nba2018)
       
#send R output of summary on teams

sink("../output/teams-summary.txt")
summary(teams)
sink()

#write teams table to a csv 

write.csv(teams, file = '../data/nba2018-teams.csv')
