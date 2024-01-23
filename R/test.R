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
  separate(game_length, sep=":", into=c("min","sec"), convert=TRUE, extra="drop")

# Mutate data frame to add sumEAD and sumDHM columns, Note: negative -death penalty score
df <- df %>%
  rowwise() %>%
  mutate(sumEAD = sum(c(elimination,assist,-death)), sumDHM=sum(c(damage,heal,mitigation)))

# Filter ranked and group by match result victory
df_group_victory <- df %>%
  filter(comp == "no", result == "victory")

# Filter ranked and group by match result defeat
df_group_defeat <- df %>%
  filter(comp == "no", result == "defeat")

#========================================================
# Descriptive Statistics
#========================================================

mean(df$sumDHM)
mean(df_group_victory$sumDHM)
mean(df_group_defeat$sumDHM)
sd(df$sumDHM)
sd(df_group_victory$sumDHM)
sd(df_group_victory$sumDHM)

par(mfrow=c(3,1))
hist(df$sumDHM, breaks=30, main=paste("Dist. of sums damage, heal & mitigation, n=", nrow(df)), xlab="D.H.M.")
hist(df_group_victory$sumDHM, breaks=30, main=paste("Dist. of sums damage, heal & mitigation (victory), n=", nrow(df_group_victory)),xlab="D.H.M.")
hist(df_group_defeat$sumDHM, breaks=30, main=paste("Dist. of sums damage, heal & mitigation (defeat), n=", nrow(df_group_defeat)),xlab="D.H.M.")

par(mfrow=c(1,3))
boxplot(df$sumDHM, main=paste("Boxplot of DHM, n =", nrow(df)), xlab="All", ylab="D.H.M.")
boxplot(df_group_victory$sumDHM, main=paste("Boxplot of DHM, n =", nrow(df_group_victory)), xlab="Victory", ylab="D.H.M.")
boxplot(df_group_defeat$sumDHM, main=paste("Boxplot of DHM, n =", nrow(df_group_defeat)), xlab="Defeat", ylab="D.H.M.")

#========================================================
# Statistical Sampling
#========================================================

# Sample size n = 10
n1 <- 10
n2 <- 10

# Simulations in experiment 
simulations <- 10000

# Create x bar vectors of size n simulations
xbar_holder1 = numeric(simulations)
xbar_holder2 = numeric(simulations)
diffOfXbars = numeric(simulations)

# Run the simulation
for (i in simulations) {
  sample1 = sample(df_group_victory$sumDHM, n1)
  sample2 = sample(df_group_defeat$sumDHM, n2)
  xbar1 = mean(sample1)
  xbar2 = mean(sample2)
  xbar_holder1[i] = xbar1
  xbar_holder2[i] = xbar2
  diffOfXbars[i] = xbar1 - xbar2
}

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