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
# Check missing NA values
gg_miss_var(df)
# Count NA values
sum(is.na(df))

# Find missing NA final_score values
which(is.na(df$final_score))
df[191:210,]

# Find missing NA mitigation values
which(is.na(df$mitigation))
df[175,]

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

