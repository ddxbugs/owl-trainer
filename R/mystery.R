#========================================================
# Project: Overwatch Exploratory Data Analysis with R
# Script Name: mystery.R
# Author: ddxbugs
# Date: 2023-12-26
# Last Modified: 2024-01-10
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
df <- read.csv("mystery.csv")

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

# Check missing NA values
gg_miss_var(df)

#========================================================
# Transform Data
#========================================================

library(tidyverse)
library(GGally)

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

# Filter ranked matches and summarize mean elimination, assist, death by group_id, team w/r/t match result
df_mean_ead <- df %>%
  filter(comp == "no") %>%
  group_by(group_id, team, result) %>%
  summarize(meanElim=mean(elimination), meanAsst=mean(assist), meanDeath=mean(death), .groups="keep") %>%
  print(n = 100)

# Plot ggpairs meanEAD by match result
ggpairs(df_mean_ead, columns=4:6, ggplot2::aes(color=result))

# Filter ranked matches and summarize mean damage, heal, mitigation by group_id, team w/r/t match result
df_mean_dhm <- df %>%
  filter(comp == "no") %>%
  group_by(group_id, team, result) %>%
  summarize(meanDmg=mean(damage), meanHeal=mean(heal), meanMit=mean(mitigation, .groups="keep")) %>%
  print(n = 100)

# Plot ggpairs meanDHM by match result
ggpairs(df_mean_dhm, columns=4:6, ggplot2::aes(color=result))

# Filter ranked matches and summarize sum elimination, assist, death by group_id, team w/r/t match result
df_sum_ead <- df %>%
  filter(comp == "no") %>%
  group_by(group_id, team, result) %>%
  summarize(teamElim=sum(elimination), teamAsst=sum(assist), teamDeath=sum(death), .groups="keep")

df %>%
  filter(comp == "no") %>%
  select(elimination, damage, result) %>%
  ggplot(aes(elimination, damage, color=result)) + 
  geom_point(position="jitter") + geom_smooth() +
  ggtitle(paste("Elimination~Damage by Match Result, n=", dim(df[df$comp=="no",])))

df %>%
  ggplot(aes(elimination, fill=result)) + geom_histogram(binwidth=2) + facet_grid(vars(result))
df %>%
  ggplot(aes(assist, fill=result)) + geom_histogram(binwidth=2) + facet_grid(vars(result))
df %>%
  ggplot(aes(death, fill=result)) + geom_histogram(binwidth=2) + facet_grid(vars(result))

#========================================================
# Visualize Data
#========================================================

# Histogram of EAD, DHM
par(mfrow=c(2,3))
hist(df$elimination, main="Histogram of Elimination", xlab="# of Eliminations")
hist(df$assist, main="Histogram of Assist", xlab="# of Assists")
hist(df$death, main="Histogram of Death", xlab="# of Deaths")
hist(df$damage, main="Histogram of Damage", xlab="Total Damage")
hist(df$heal, main="Histogram of Heal", xlab="Total Healing")
hist(df$mitigation, main="Histogram of Mitigation", xlab="Total Mitigation")
# Boxplot of EAD, DHM
par(mfrow=c(2,3))
boxplot(df$elimination, main="Boxplot of Elimination", xlab="# of Eliminations")
boxplot(df$assist, main="Boxplot of Assists", xlab="# of Assists")
boxplot(df$death, main="", xlab="")
boxplot(df$damage, main="", xlab="")
boxplot(df$heal, main="", xlab="")
boxplot(df$mitigation, main="", xlab="")
# Scatterplot of EAD and DHM
par(mfrow=c(2,3))
plot(df$elimination, main="", xlab="")
plot(df$assist, main="", xlab="")
plot(df$death, main="", xlab="")
plot(df$damage, main="", xlab="")
plot(df$heal, main="", xlab="")
plot(df$mitigation, main="", xlab="")
# Scatterplot of EAD vs DHM
par(mfrow=c(3,3))
plot(df$elimination, df$damage, main="Scatterplot of Elimination vs. Damage", xlab="# of Eliminations", ylab="Total Damage")
plot(df$elimination, df$heal, main="Scatterplot of Elimination vs. Heal", xlab="# of Eliminations", ylab="Total Heal")
plot(df$elimination, df$mitigation, main="Scatterplot of Elimination vs. Mitigation", xlab="# of Eliminations", ylab="Total Mitigation")
plot(df$assist, df$damage, main="Scatterplot of Assist vs. Damage", xlab="# of Assists", ylab="Total Damage")
plot(df$assist, df$heal, main="Scatterplot of Assist vs. Heal", xlab="# of Assists", ylab="Total Heal")
plot(df$assist, df$mitigation, main="Scatterplot of Assist vs. Mitigation", xlab="# of Assists", ylab="Total Mitigation")
plot(df$death, df$damage, main="Scatterplot of Death vs. Damage", xlab="# of Deaths", ylab="Total Damage")
plot(df$death, df$heal, main="Scatterplot of Death vs. Heal", xlab="# of Deaths", ylab="Total Heal")
plot(df$death, df$mitigation, main="Scatterplot of Death vs. Mitigation", xlab="# of Deaths", ylab="Total Mitigation")
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



