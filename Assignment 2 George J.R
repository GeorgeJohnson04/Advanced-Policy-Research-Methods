#install packages
install.packages("haven")
install.packages('tidyverse')
install.packages('MatchIt')
install.packages('cem')
install.packages("readxl")
install.packages("dplyr")
#load packages
library(tidyverse)
library(haven)
library(MatchIt)
library(cem)
library(readxl)
library(dplyr)

#RDD Syntax

  #cutoff
  cutoff <- c

  #distance from cutoff
  x_cent <- x - cutoff

  #Treatment effect est
  model <- lm(y ~ d + x_cent + d:x_cent)

  summary(model)


#DiD Syntax

  #include fixed effects
  dt$district <- as.factor(dt$district)
  dt$year <- as.factor(dt$year)

  # Estimate model
  model <- lm(y ~ x * year + district + year, data = dt)
  summary(model)
  
#Missing Data
  #3. Simulation 
 
   #a.Generate data
      set.seed(123)
      alpha <- -10
      beta <- 5
  
      X <- rnorm(500, mean = 3, sd = 2)
      epsilon <- rnorm(500, mean = 0, sd = 5)
      Y <- alpha + beta * X + epsilon
    
    #b. Create missing data
      M <- as.numeric(abs(X) > 4)
      y_s <- ifelse(M == 1, NA, Y)
  
    #c. Hist and means
  
      #means
      mean(Y)
      mean_y <- mean(Y)
  
      mean(y_s, na.rm = TRUE)
      mean_y_star <- mean(y_s, na.rm = TRUE)
  
      #histograms
      ggplot() +
        geom_histogram(aes(x = Y), bins = 30, fill = "blue", alpha = 0.5) +
        geom_vline(xintercept = mean_y, color = "blue", linetype = "dashed") +
        xlim(-35, 35) +
        ggtitle(paste("Histogram of Y with Mean =", round(mean_y, 2)))
  
      ggplot() +
        geom_histogram(aes(x = y_star), bins = 30, fill = "red", alpha = 0.5) +
        geom_vline(xintercept = mean_y_star, color = "red", linetype = "dashed") +
        xlim(-35, 35) +
        ggtitle(paste("Histogram of y_star with Mean =", round(mean_y_star, 2)))
  
  #4. Partial Identification 
      
      lower_b <- mean(y_star, na.rm = TRUE)
      upper_b <- mean(Y)
      bounds <- c(lower_b, upper_b)
      bounds
  
  #5. Multiple Imputation 
      
      #Complete data regression
      lm_model <- lm(y_star ~ X, na.action = na.exclude)
      alpha_est <- coef(lm_model)[1]
      beta_est <- coef(lm_model)[2]
      
      # Draw alpha and beta
      alpha_draw <- rnorm(1, mean = alpha_est, sd = summary(lm_model)$coefficients[1, 2])
      beta_draw <- rnorm(1, mean = beta_est, sd = summary(lm_model)$coefficients[2, 2])
      
      # Impute missing data from drawings
      mu_imp <- alpha_draw + beta_draw * X
      y_imp <- ifelse(is.na(y_star), rnorm(sum(is.na(y_star)), mean = mu_imp[is.na(y_star)], sd = 5), y_star)
      mean_y_imp <- mean(y_imp)
      
      # Compare both means
      mean_y
      mean_y_imp
      mean_y - mean_y_imp
