#========================================================
# Project: Overwatch Exploratory Data Analysis with R
# Script Name: mystery.R
# Author: ddxbugs
# Date: 2023-12-26
# Last Modified: 2024-02-01
# Version: 1.0.0-alpha.1+001
#========================================================
# Description:
# This script performs data cleaning, data transformation, and
# statistical analysis.
#========================================================
# Usage:
# Install the necessary packages to run this script
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
df <- read.csv("mystery.csv", header=TRUE)

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
boxplot(df$assist, main="Boxplot of Assist", xlab="# of Assists")
boxplot(df$death, main="Boxplot of Death", xlab="# of Deaths")
boxplot(df$damage, main="Boxplot of Damage", xlab="Total Damage")
boxplot(df$heal, main="Boxplot of Heal", xlab="Total Heal")
boxplot(df$mitigation, main="Boxplot of Mitigation", xlab="Total Mitigation")
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
# 
#========================================================


