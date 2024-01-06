#========================================================
# Project: Overwatch Exploratory Data Analysis with R
# Script Name: mystery.R
# Author: ddxbugs
# Date: 2023-12-26
# Last Modified: 2023-12-26
# Version: 1.0.0-alpha.1+001
#========================================================
# Description:
# This script performs [brief description of what the script does, 
# e.g., data cleaning, data visualization, statistical analysis, etc.]
#========================================================
# Usage:
# [Instructions on how to use this script, if necessary]
#========================================================
# Notes:
# [Any additional notes, warnings, dependencies, or other relevant information]
#========================================================

# Print session information
sessionInfo()

# Set working directory to data
setwd("data/")

#========================================================
# Import Data
#========================================================

# Read CSV file
df <- read.csv("mystery.txt")

# Print first 5 rows
head(df, n = 5)

# Print last 5 rows
tail(df, n = 5)

# Examine data frame type
str(df)

# Print summary of data frame
summary(df)

#========================================================
# Tidy Data
#========================================================

library(naniar)

# Count NA values
sum(is.na(df))

# Find missing NA final_score values
sum(is.na(df$final_score))
which(is.na(df$final_score))
df[191:210,]

# Find missing NA mitigation values
sum(is.na(df$mitigation))
which(is.na(df$mitigation))
df[175,]
# Replace missing NA mitigation value with new int value
df[175, "mitigation"] <- as.integer(1)
df[175,]

# Check missing NA values
gg_miss_var(df)

#========================================================
# Transform Data
#========================================================

# TODO game_length : time separate min sec lubridate::ms

library(tidyverse)
library(GGally)

# Factor variables
df$map_name <- factor(df$map_name)
df$comp <- factor(df$comp)
df$result <- factor(df$result)
df$game_mode <- factor(df$game_mode)
df$team <- factor(df$team)

# Separate and factor final_score as integer A, B
df_score <- df %>%
  separate(final_score, sep="-", into=c("A","B"), convert=TRUE, extra="drop")

# Filter ranked matches and summarize mean elimination, assist, death by control_no, team w/r/t match result
df_mean_ead <- df %>%
  filter(comp == "no") %>%
  group_by(control_no, team, result) %>%
  summarize(meanElim=mean(elimination), meanAsst=mean(assist), meanDeath=mean(death), .groups="keep") %>%
  print(n = 100)

# Plot ggpairs meanEAD by match result
ggpairs(df_mean_ead, columns=4:6, ggplot2::aes(color=result))

# Filter ranked matches and summarize mean damage, heal, mitigation by control_no, team w/r/t match result
df_mean_dhm <- df %>%
  filter(comp == "no") %>%
  group_by(control_no, team, result) %>%
  summarize(meanDmg=mean(damage), meanHeal=mean(heal), meanMit=mean(mitigation, .groups="keep")) %>%
  print(n = 100)

# Plot ggpairs meanDHM by match result
ggpairs(df_mean_dhm, columns=4:6, ggplot2::aes(color=result))

#========================================================
# Visualize Data
#========================================================
# Histogram of sum EAD
par(mfrow=c(3,1))
hist(df_sum$sumElim, main="Histogram of Sum Elimination")
hist(df_sum$sumAsst, main="Histogram of Sum Assist")
hist(df_sum$sumDeath, main="Histogram of Sum Death")
# Box plot of mean EAD
par(mfrow=c(1,3))
boxplot(df_mean$meanElim, main="Box plot of Mean Elimination")
boxplot(df_mean$meanAsst, main="Box plot of Mean Assist")
boxplot(df_mean$meanDeath, main="Box plot of Mean Death")

# TODO merge df_mean_ead df_mean_dhm
df %>%
  filter(comp == "no") %>%
  select(elimination, damage, result) %>%
  ggplot(aes(elimination, damage, color=result)) + 
  geom_point(position="jitter") + geom_smooth() +
  ggtitle(paste("Elimination~Damage by Match Result, n=", dim(df[df$comp=="no",])))

# TODO plot control_no sample means vs team sample means
#========================================================
# Model Data
#========================================================

# Hypothesis Test: 
# Correlation test mean elimination and mean damage
cor(df_mean_ead$meanElim, df_mean_dhm$meanDmg)
# T-test 
t.test(df_mean_ead$meanElim, df_mean_dhm$meanDmg)
