#========================================================
# Project: Overwatch Exploratory Data Analysis with R
# Script Name: test.R
# Author: ddxbugs
# Date: 2024-01-21
# Last Modified: 2024-01-21
# Version: 1.0.0-alpha.1+001
#========================================================
# Description: This script performs statistical analysis, 
# data visualization, confidence interval and hypothesis testing
#========================================================
# Usage:
# Install the necessary packages to run this script
#========================================================
# Notes:
# [Any additional notes, warnings, dependencies, or other relevant information]
#========================================================

# Print session info
sessionInfo()

# Set working directory
setwd("data/")

#========================================================
# Import Data
#========================================================

# Read csv data into data frame
df <- read.csv("mystery.csv", header=TRUE)

#========================================================
# Tidy Data
#========================================================

library(naniar)

# Check missing NA values
gg_miss_var(df)

# Count NA values
sum(is.na(df))

# Find missing NA values
which(is.na(df$final_score))

# Omit final_score NA values 
df <- na.omit(df)

#========================================================
# Transform Data
#========================================================

library(tidyverse)
library(GGally)

# Examine data frame data types
str(df)

# Factor variables
df$map_name <- factor(df$map_name)
df$comp <- factor(df$comp)
df$result <- factor(df$result)
df$game_mode <- factor(df$game_mode)
df$team <- factor(df$team)

# Separate and factor final_score as integer into A, B
df <- df %>%
  separate(final_score, sep="-", into=c("a_score","b_score"), convert=TRUE, extra="drop")

# Separate and factor game_length as integer into min, sec
df <- df %>%
  separate(game_length, sep=":", into=c("min","sec"),convert=TRUE, extra="drop")

# Filter ranked and group by match result victory
df_group_victory <- df %>%
  filter (comp == "no", result == "victory")

# Filter ranked and group by match result defeat
df_group_defeat <- df %>%
  filter (comp == "no", result == "defeat")
#========================================================
# Model Data
#========================================================

# Sample size n
n1 <- 50
n2 <- 50

# Perform statistical analysis on group victory
population1 <- sample(df_group_victory$damage, 1000)
mean(population1)
sd(population1)
hist(population1)

# Perform statistical analysis on group defeat
population2 <- sample(df_group_defeat$damage, 1000)
mean(population2)
sd(population2)
hist(population2)

# # Simulations in experiment 
simulations <- 1000

# Create xbar vectors for n simulations
xbar_holder1 = numeric(simulations)
xbar_holder2 = numeric(simulations)
diffOfXbars = numeric(simulations)

# Run the simulation

#========================================================
# Confidence Intervals: 95%, alpha = 0.05
#========================================================

# One-sample t-test elimination, assist, death (ead)
elim <- t.test(df$elimination)
asst <- t.test(df$assist)
dead <- t.test(df$death)
# One-sample t-test damage, heal, mitigation (dhm)
dmg <- t.test(df$damage)
heal <- t.test(df$heal)
mit <- t.test(df$mitigation)

# Two-sample t-test
t.test(df_mean_ead$meanElim, df_mean_dhm$meanDmg)
# Correlation test mean elimination and mean damage
cor(df_mean_ead$meanElim, df_mean_dhm$meanDmg)

#========================================================
# Hypothesis Testing
#========================================================

# Hypothesis Test: 

# 1) State the Null and Alternative Hypothesis
# 2) Draw and shade region and find critical value
# 3) Find the test statistic
# 4) Find the probability value, p-val
# 5) Make a decision
# 6) Conclusion