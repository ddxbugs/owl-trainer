#========================================================
# Project: Overwatch Exploratory Data Analysis with R
# Script Name: test.R
# Author: ddxbugs
# Date: 2024-01-21
# Last Modified: 2024-02-01
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
# Permutation test
#========================================================

samplesize = 10

number_of_permutations = 10000;

xbarholder = c();

# the observed difference in sample means observed
observed_diff = mean(subset(df, result == "victory")$sumDHM) - mean(subset(df, result == "defeat")$sumDHM);

counter = 0;

# this loop runs all the permutations and generates and stores the difference of sample means for each permutation
for(i in 1:number_of_permutations) {
  scramble = sample(df$sumDHM, samplesize);
  one = scramble[1:(samplesize/2)];
  two = scramble[(samplesize/2+1):samplesize];
  diff = mean(one) - mean(two);
  xbarholder[i] = diff;
  
  if (abs(diff) > abs(observed_diff))
    counter = counter + 1
}

hist(xbarholder);
pvalue = counter /number_of_permutations;
# the pvalue is a percentage of the differences in sample means that were generated under the assumption of equal means that exceed what we observed
pvalue
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

#' Credit: Volodymyr Orlov
#' modified by MSDS SMU
#' https://github.com/VolodymyrOrlov/MSDS6371/blob/master/shade.r
#' Draws a t-distribution curve and shades rejection regions
#' 
#' @param df degrees of freedom.
#' @param alpha significance level
#' @param h0 null hypothesis value
#' @param sides one of: both, left, right
#' @param t_calc calculated test statistics
#' @examples
#' shade(49, 0.05, 0, t_calc=1.1)
#' shade(91, 0.05, 0, t_calc=NULL, sides = 'right')
#' shade(7, 0.05, 0, t_calc=1.5, sides = 'left')
#' shade(7, 0.05, 0, t_calc=1.5, sides = 'both')

shade <- function(df, alpha, h0 = 0, sides='both', t_calc=NULL) {
  e_alpha = alpha
  if(sides == 'both'){
    e_alpha = alpha / 2
  }
  cv = abs(qt(e_alpha, df))
  curve(dt(x, df), from = -4, to = 4, ylab='P(x)', xaxt='n') 
  abline(v = 0, col = "black", lwd = 0.5)
  labels = h0
  at = 0
  if(sides == 'both' | sides == 'left'){
    x <- seq(-4, -abs(cv), len = 100) 
    y <- dt(x, df)
    polygon(c(x, -abs(cv)), c(y, min(y)), col = "blue", border = NA)
    lines(c(-cv, -cv), c(0, dt(-cv, df)), col = "black", lwd = 1)
    text(-cv - (4 - cv) / 2, 0.05, e_alpha)
    labels = c(round(-cv, 3), labels)
    at = c(-cv, at)
  }
  if(sides == 'both' | sides == 'right'){
    x <- seq(abs(cv), 4, len = 100)
    y <- dt(x, df)
    polygon(c(abs(cv), x), c(min(y), y), col = "blue", border = NA)
    lines(c(cv, cv), c(0, dt(cv, df)), col = "black", lwd = 1)
    text(cv + (4 - cv) / 2, 0.05, e_alpha)
    labels = c(labels, round(cv, 3))
    at = c(at, cv)
  }
  if(is.numeric(t_calc)){
    abline(v = t_calc, col = "red", lwd = 2)
    text(t_calc + 0.5, 0.2, t_calc, col = "red")
  }
  axis(1, at=at, labels=labels)
}
#The above defines the function shade. To use it, you must call it. More examples are in the comments above.
shade(49, 0.05, 0, t_calc=1.1)