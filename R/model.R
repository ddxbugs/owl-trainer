#========================================================
# Project: Overwatch Exploratory Data Analysis with R
# Script Name: model.R
# Author: ddxbugs
# Date: 2024-01-10
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

# Print session info
sessionInfo()

# Set working directory
setwd("data/")

#========================================================
# Import Data
#========================================================

# Read csv data as data frame 
df = read.csv("mystery.csv")

# Print first five rows
head(df, n=5)
# Print last five rows
tail(df, n=5)

# Print summary data frame
summary(df)

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

# Filter and summarize mean elim, assist, death by group_id, team, result
df_mean_ead <- df %>%
  filter(comp == "no") %>%
  group_by(group_id, team, result) %>%
  summarize(meanElim=mean(elimination), meanAsst=mean(assist), meanDeath=mean(death), .groups="drop")

#========================================================
# Model Data
#========================================================

library(caret)
library(class)

# 70/30 train test split
testSplit = nrow(df_mean_ead)*0.7
trainIndex = sample(seq(1, nrow(df_mean_ead)), testSplit)
trainMystery = df_mean_ead[trainIndex,]
testMystery = df_mean_ead[-trainIndex,]

# KNN classification: Actual, Predicted Result=Victory/Defeat
classification = knn(train=trainMystery[,4:6], test=testMystery[,4:6], cl=trainMystery$result, prob=TRUE, k=5)
table(classification, testMystery$result)
confusionMatrix(table(classification, testMystery$result), mode="everything")

# Internal Leave One Out Cross-Validation: train mystery data set
classification = knn.cv(trainMystery[,4:6], trainMystery$result, k=5)
table(classification, trainMystery$result)
confusionMatrix(table(classification, trainMystery$result), mode="everything")
