# Load Libraries
library(fixest)
library(modelsummary)
library(haven)
library(gt)
library(webshot2)

# Load Data
data_t1 <- haven::read_dta("C:/Users/Tommy/OneDrive/Desktop/School/Old Classes /Adv Policy Research Methods/Final Project/AEA2020 T1 DATA.dta")
data_t2_1 <- haven::read_dta("C:/Users/Tommy/OneDrive/Desktop/School/Old Classes/Adv Policy Research Methods/Final Project/AEA2020 T2 DATA1.dta")
data_t2_2 <- haven::read_dta("C:/Users/Tommy/OneDrive/Desktop/School/Old Classes/Adv Policy Research Methods/Final Project/AEA2020 T2 DATA2.dta")

# Table 5 Models
model1 <- feols(crime ~ job + det_befTr + age10 + yschool + male + english + timeus + married + less1y | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_1[data_t2_1$less1y == 1, ], cluster = ~state_cap)

model2 <- feols(crime ~ jobd1 + jobd2 + jobd3 + d1 + d2 + d3 + det_befTr + age10 + yschool + male + married + english | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_1[data_t2_1$less1y == 1, ], cluster = ~state_cap)

model3 <- feols(timedet ~ job + det_befTr + age10 + yschool + male + english + timeus + married + less1y | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_1[data_t2_1$less1y == 1, ], cluster = ~state_cap)

model4 <- feols(timedet ~ jobd1 + jobd2 + jobd3 + d1 + d2 + d3 + det_befTr + age10 + yschool + male + married + english | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_1[data_t2_1$less1y == 1, ], cluster = ~state_cap)

# Create Styled Table 5
table5 <- modelsummary(
  list("Model 1 (Crime)" = model1, "Model 2 (Crime)" = model2, "Model 3 (Detention)" = model3, "Model 4 (Detention)" = model4),
  output = "gt",
  stars = TRUE,
  gof_omit = 'IC|Log|F|Adj|RMSE',
  fmt = 3
) %>%
  tab_header(title = "📊 Table 5: Regression Results - Less than 1 Year in U.S.") %>%
  tab_style(style = list(cell_fill(color = "#f0f4f8")), locations = cells_body()) %>%
  tab_options(
    table.font.size = px(13),
    data_row.padding = px(2),
    heading.title.font.size = px(16),
    column_labels.font.weight = "bold"
  )

# Save Table 5
gtsave(table5, "Table_5_Results.png", zoom = 1.25)

# Table 6 Models
model5 <- feols(crime ~ job + timeusa + age10 + yschool + male + english + married | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_2, cluster = ~state_cap)

model6 <- feols(crime ~ jobd4 + jobd5 + jobd6 + jobd7 + d4 + d5 + d6 + age10 + yschool + male + married + english | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_2, cluster = ~state_cap)

model7 <- feols(timedet ~ job + timeusa + age10 + yschool + male + english + married | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_2, cluster = ~state_cap)

model8 <- feols(timedet ~ jobd4 + jobd5 + jobd6 + jobd7 + d4 + d5 + d6 + age10 + yschool + male + married + english | state_cap + state_f + year, 
                weights = ~weights, data = data_t2_2, cluster = ~state_cap)

# Create Styled Table 6
table6 <- modelsummary(
  list("Model 5 (Crime)" = model5, "Model 6 (Crime)" = model6, "Model 7 (Detention)" = model7, "Model 8 (Detention)" = model8),
  output = "gt",
  stars = TRUE,
  gof_omit = 'IC|Log|F|Adj|RMSE',
  fmt = 3
) %>%
  tab_header(title = "📊 Table 6: Regression Results - More than 1 Year in U.S.") %>%
  tab_style(style = list(cell_fill(color = "#f0f4f8")), locations = cells_body()) %>%
  tab_options(
    table.font.size = px(13),
    data_row.padding = px(2),
    heading.title.font.size = px(16),
    column_labels.font.weight = "bold"
  )

# Save Table 6
gtsave(table6, "Table_6_Results.png", zoom = 1.25)

    
