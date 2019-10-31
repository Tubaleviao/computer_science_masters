# 1
library(readxl)
occupations <- read.csv("lab3-data.csv")
occupations
# 2
plot(occupations$PrestigeScore, occupations$EducationLevel, 
     main="Prestige by Eduucation", xlab="Prestige", ylab="Education", col="blue")
## the data has positive increase, it's has a strong assosciation 
xy_cor = cor(occupations$PrestigeScore, occupations$EducationLevel)
# 3
linear_regression_prestige <- lm(occupations$PrestigeScore ~ 
                                   occupations$EducationLevel + 
                                   occupations$Income + 
                                   occupations$PercentOfWomen)
# 4
x_mean <- mean(occupations$EducationLevel) # x
y_mean <- mean(occupations$PrestigeScore) # y
total_precise_squares <- sum((occupations$PrestigeScore - y_mean) ^ 2)
residual_precise_squares <- sum((y_mean - fitted(linear_regression_prestige)) ^ 2)
regression_precise_squares <- sum((fitted(linear_regression_prestige) - y_mean) ^ 2)

regression_precise_squares / total_precise_squares # = R2

if(FALSE){ ## this show the R^2 using only education level to predict prestige score
  x_mean <- mean(occupations$PrestigeScore) # x
  y_mean <- mean(occupations$EducationLevel) # y
  x_deviation <- sd(occupations$PrestigeScore)
  y_deviation <- sd(occupations$EducationLevel)
  beta_1 <- xy_cor * x_deviation/y_deviation
  beta_0 <- y_mean - beta_1 * x_mean
  linear_r <- lm(occupations$EducationLevel ~ occupations$PrestigeScore) # lm( y ~ x )
  total_squares <- sum((occupations$EducationLevel - y_mean) ^ 2)
  residual_squares <- sum((y_mean - fitted(linear_r)) ^ 2)
  regression_squares <- sum((fitted(linear_r) - y_mean) ^ 2)
  abline(linear_r, col="red")
  regression_squares / total_squares
}
# r2 is more precise when using all the values to predict prestige

