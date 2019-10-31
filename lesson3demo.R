#Read in data
library("readxl")
data <- read_excel(".\\demoData\\house-price-with-size.xlsx", sheet = 2)
data

#Correlation and Scatterplots
cor(data)
plot(data)


#Multiple Linear Regression
m<-lm(data$HousePrice~data$Size+data$Rooms)
summary(m)


#compute R^2
totalss <-sum((housedata$HousePrice -mean(housedata$HousePrice))^2)
regss <-sum((fitted(m) -mean(housedata$HousePrice))^2)
residss <-sum((housedata$HousePrice-fitted(m))^2)
rsquare <- regss/totalss
rsquare