
  ##################################################
## Title: NBA Team Table
## Description: Make Table for Ranking Analysis
## Input(s):
## Output(s):
##################################################

#read in original NBA table
nba2018 <- read.table("data/nba2018.csv", header = TRUE, sep = ",")
nba2018

## Preprocessing columns salary, experience and position 

# remove R's and change to integer values 

nba2018$experience[nba2018$experience == "R"] <- 0
nba2018$experience <- as.integer((nba2018$experience))
nba2018

#convert salary to millions 
nba2018$salary <- nba2018$salary/1000000
