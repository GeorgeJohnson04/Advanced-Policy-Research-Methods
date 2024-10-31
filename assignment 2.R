#George Johnson
#Advanced Policy Research Methods

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

#Question 4

#load data
MPBJPS <- read_xlsx("C:/Users/Tommy_w7c1d3j/Desktop/School/Current Classes/Adv Policy Reasearch Methods/Assignments/Assignment 2/McCauley and Posner, BJPS.xlsx")
view(MPBJPS)

#percent all
imp_id <- mean(MPBJPS$PrimID == "Religion", na.rm = TRUE) * 100 
top_two <- mean(MPBJPS$Relig1st2nd == 1, na.rm = TRUE) * 100

# percent faso
bf_imp_id <- mean(MPBJPS$PrimID[MPBJPS$Country == "Burkina Faso"] == "Religion", na.rm = TRUE) * 100
bf_top_two <- mean(MPBJPS$Relig1st2nd[MPBJPS$Country == "Burkina Faso"] == 1, na.rm = TRUE) * 100

# percent cote
ci_imp_id <- mean(MPBJPS$PrimID[MPBJPS$Country == "Cote d'Ivoire"] == "Religion", na.rm = TRUE) * 100
ci_top_two <- mean(MPBJPS$Relig1st2nd[MPBJPS$Country == "Cote d'Ivoire"] == 1, na.rm = TRUE) * 100

#fourth column

#difference in means
diff_ci_bf_imp <- ci_imp_id - bf_imp_id
diff_ci_bf_top_two <- ci_top_two - bf_top_two

#ols
MPBJPS$imp_id <- ifelse(MPBJPS$PrimID == "Religion", 1, 0)
MPBJPS$top_two <- ifelse(MPBJPS$Relig1st2nd == 1, 1, 0)
ols_imp <- lm(imp_id ~ Country, data = MPBJPS)
ols_top2 <- lm(top_two ~ Country, data = MPBJPS)
summary(ols_imp)
summary(ols_top2)

# table 1
summary_table <- data.frame(
  Description = c(
    "Lists religion as most important identity",
    "Lists religion among top two identities"
  ),
  Full_Sample = c(imp_id, top_two),  
  Burkina_Faso = c(bf_imp_id, bf_top_two),
  Cote_d_Ivoire = c(ci_imp_id, ci_top_two),  
  Difference_CI_BF = c(diff_ci_bf_imp, diff_ci_bf_top_two)
)
print(summary_table)



#Question 5

#load data
dt_titanic <- read_dta("https://github.com/scunning1975/mixtape/raw/master/titanic.dta")
view(dt_titanic)

balance <- dt_titanic %>%
  group_by(class) %>%
  summarize(mean_age = mean(age), 
            mean_gender = mean(sex),
            count = n())
print(balance)

#Groups based on age and sex
dt_titanic <- dt_titanic %>%
  mutate(age_group = ifelse(age > median(age, na.rm = TRUE), "Old", "Young"),
         gender_group = ifelse(sex == 0, "Female", "Male"))

#stratify
dt_titanic <- dt_titanic %>%
  mutate(age_group = ifelse(age == 1, "Old", "Young"),  
         gender_group = ifelse(sex == 0, "Female", "Male")) 

# cross stratify
dt_titanic$strata <- interaction(dt_titanic$age_group, dt_titanic$gender_group)

# View summary of the stratification
table(dt_titanic$strata)

#Survival
survival <- dt_titanic %>%
  group_by(strata) %>%
  summarize(survival_rate = mean(survived, na.rm = TRUE))
print(survival)

#prop of group
gprop <- dt_titanic %>%
  group_by(strata) %>%
  summarize(prop = n() / nrow(dt_titanic))

print(gprop)

#combine survival prob and weight
dtamerge <- merge(survival, gprop, by = "strata")
survival_weight <- sum(dtamerge$survival_rate * dtamerge$prop)
print(survival_weight)

#naive diff
naive <- dt_titanic %>%
  group_by(class) %>%
  summarize(survival_rate = mean(survived, na.rm = TRUE))
print(n)

#Question 6

#coarsened matching
cem_match <- cem(treatment = "class", data = dt_titanic, drop = c("survived"))

# View the summary of the CEM result
summary(cem_match)

# Extract the matched data
matched_data <- dt_titanic[cem_match$matched, ]

# Calculate the Average Treatment Effect (ATE)
# Assuming 'survived' is the outcome variable you want to analyze
ate <- mean(matched_data$survived[matched_data$class == 1]) - 
  mean(matched_data$survived[matched_data$class == 2])  # Replace '1' and '2' with appropriate treatment/control group codes

# Print the estimated ATE
print(ate)

#neighbor matching

dt_titanic <- dt_titanic %>%
  mutate(class_bi = ifelse(class == 1, 1, 0))

nn_match <- matchit(class_bi ~ age + sex, data = dt_titanic, method = "nearest", replace = FALSE)
summary(nn_match)

matched_data <- match.data(nn_match)
ate_nn <- mean(matched_data$survived[matched_data$class_bi == 1]) - 
  mean(matched_data$survived[matched_data$class_bi == 0])

#ATE Nearest Neighbor
print(ate_nn)


