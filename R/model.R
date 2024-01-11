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

#========================================================
# Model Data
#========================================================

library(caret)
library(class)

# Check data frame dimensions
dim(df)

# 70/30 train test split
testSplit = nrow(df)*0.7
trainIndex = sample(seq(1, nrow(df)), testSplit)
train = df[trainIndex,]
test = df[-trainIndex,]

dim(train)
dim(test)

# TODO group by control_no, team
# TODO sum EAD, DHM 
# TODO knn classification victory/defeat