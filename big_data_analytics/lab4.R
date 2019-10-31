# 1
  library(readxl)
  treatments <- read.csv("lab4-data.csv")
  table(treatments$Treatment, treatments$Pain)

# 2
  treatments$Treatment<-ifelse(treatments$Treatment == "New Treatment", 1, 0) 
  tail(treatments)
  model <- glm(treatments$Pain ~ treatments$Treatment, family="binomial")
  ## come up with the logistic model equation p in terms of treatment variable

# 3
  nullmod <- glm(treatments$Pain ~ 1, family="binomial")
  1-logLik(model)/logLik(nullmod)

# 4
  model_precise <- glm(treatments$Pain ~ treatments$Treatment + 
                 treatments$Age + treatments$Severe, family="binomial")
  summary(model_precise)
  ## increase in odds per 1 unit increase in treatment
  model_precise$coefficients[2]
  exp(model_precise$coefficients[2])
  
  ## increase in odds per 10 unit increase in age
  model_precise$coefficients[3]
  exp(model_precise$coefficients[3] * 10)
  
  ## increase in odds per 1 unit increase in severity
  model_precise$coefficients[4]
  exp(model_precise$coefficients[4])

# 5
  totalss <-sum((treatments$Pain -mean(treatments$Pain, na.rm=TRUE))^2)
  regre_ss <-sum((fitted(model) -mean(treatments$Pain, na.rm=TRUE))^2)
  resid_ss <-sum((treatments$Pain-fitted(model))^2)
  regre_ss/totalss ## 0.042
  
  regre_precise_ss <-sum((fitted(model_precise) -mean(treatments$Pain, na.rm=TRUE))^2)
  resid_precise_ss <-sum((treatments$Pain-fitted(model_precise))^2)
  regre_precise_ss/totalss ## 0.439
  
  ## the precision of the second model (the one whitch includes all fields) is slightly more precise  
  ## than the first model containing only the treatment field (0.397 more precise).
  
  