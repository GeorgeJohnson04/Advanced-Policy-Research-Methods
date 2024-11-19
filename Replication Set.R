#Used Libraries
library(fixest)
library(sandwich)
library(lmtest)
library(modelsummary)
library(haven)

# Load data
  data_t1 <- "C:/Users/Tommy/OneDrive/Desktop/School/Adv Policy Research Methods/Final Project/AEA2020 T1 DATA.dta"
  data_t2_1 <- "C:/Users/Tommy/OneDrive/Desktop/School/Adv Policy Research Methods/Final Project/AEA2020 T2 DATA1.dta"
  data_t2_2 <- "C:/Users/Tommy/OneDrive/Desktop/School/Adv Policy Research Methods/Final Project/AEA2020 T2 DATA2.dta"

  data_t1 <- haven::read_dta(data_t1)
  data_t2_1 <- haven::read_dta(data_t2_1)
  data_t2_2 <- haven::read_dta(data_t2_2)

# Table 5 Rep
  # Model 1
    model1 <- feols(crime ~ job + det_befTr + age10 + yschool + male + english + timeus + married + less1y | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_1[data_t2_1$less1y == 1, ], cluster = ~state_cap)

  # Model 2
    model2 <- feols(crime ~ jobd1 + jobd2 + jobd3 + d1 + d2 + d3 + det_befTr + age10 + yschool + male + married + english | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_1[data_t2_1$less1y == 1, ], cluster = ~state_cap)

  # Model 3
    model3 <- feols(timedet ~ job + det_befTr + age10 + yschool + male + english + timeus + married + less1y | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_1[data_t2_1$less1y == 1, ], cluster = ~state_cap)

  # Model 4
    model4 <- feols(timedet ~ jobd1 + jobd2 + jobd3 + d1 + d2 + d3 + det_befTr + age10 + yschool + male + married + english | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_1[data_t2_1$less1y == 1, ], cluster = ~state_cap)

  # Results Table 5
    print(etable(
      "Model 1" = model1,
      "Model 2" = model2,
      "Model 3" = model3,
      "Model 4" = model4
                        ))

# Table 6 Rep
  # Model 5
    model5 <- feols(crime ~ job + timeusa + age10 + yschool + male + english + married | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_2, cluster = ~state_cap)

  # Model 6
    model6 <- feols(crime ~ jobd4 + jobd5 + jobd6 + jobd7 + d4 + d5 + d6 + age10 + yschool + male + married + english | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_2, cluster = ~state_cap)
  # Model 7 
    model7 <- feols(timedet ~ job + timeusa + age10 + yschool + male + english + married | state_cap + state_f + year, 
                    weights = ~weights, data = data_t2_2, cluster = ~state_cap)
    
  # Model 8 
    model8 <- feols(timedet ~ jobd4 + jobd5 + jobd6 + jobd7 + d4 + d5 + d6 + age10 + yschool + male + married + english | state_cap + state_f + year, 
                    weights = ~weights, data = data_t2_2, cluster = ~state_cap)
    

  # Results Table 6 
    print(etable(
      "Model 5" = model5,
      "Model 6" = model6,
      "Model 7 (Months Detained)" = model7,
      "Model 8 (Months Detained)" = model8
                        ))
  
    
    