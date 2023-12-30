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

# Filter NA missing final_score value, ranked matches
df <- df %>%
  filter(!is.na(df$final_score) & comp == "no")

# Check missing NA values
gg_miss_var(df)

#========================================================
# Transform Data
#========================================================

# TODO final_score : chr
# TODO comp : factor
# TODO result : factor
# TODO game_mode : factor
# TODO game_length : time
# TODO team : factor

library(tidyverse)
  
