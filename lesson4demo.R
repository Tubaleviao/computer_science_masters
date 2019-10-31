#logistic regression
#Example - Risk of Coronary Event

#read in data
library("readxl")
data<-read_excel(".\\demoData\\risk-of-coronary.xlsx",1)
data

#simple logistic regression model 
m<-glm(data$event ~ data$chol, family = binomial)
summary(m)


#increase in odds per 1 unit increase in cholesterol
m$coefficients[2]
exp(m$coefficients[2])

#increase in odds per 10 unit increase in cholesterol
exp(m$coefficients[2]*10)


#predicted risk for each patient (prob of having event)
risk<-predict(m,type=c("response"))
risk

#predicted risk for patient with chol of 190:
1/(1+exp(-(m$coefficients[1] + m$coefficients[2]*190)))

#compute McFadden's pseudo-R squared
#y ~ 1 means "fit an intercept only", same as mean(y)
nullm <- glm(data$event ~ 1, family="binomial")
rsquare = 1-logLik(m)/logLik(nullm)
rsquare


#show R squared hard to get too big
data2<-read_excel(".\\demoData\\risk-of-coronary.xlsx",2)
data2
m<-glm(data2$Y ~ data2$X, family = "binomial")
nullm <- glm(data2$Y ~ 1, family="binomial")
rsquare = 1-logLik(m)/logLik(nullm)
rsquare

#multiple logistic regression model
#create a column - male that has value 1 or 0
data$male<-ifelse(data$sex == "M", 1, 0) 
data$male
m<-glm(data$event ~ data$chol + data$male + data$age, family = binomial)
summary(m)

#compute McFadden's pseudo-R squared
nullm <- glm(data$event ~ 1, family="binomial")
rsquare = 1-logLik(m)/logLik(nullm)
rsquare