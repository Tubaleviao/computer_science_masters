# 1
  ## install.packages("readxl")
  library("readxl")
  ym <- read_excel("young-men.xls")
# 2
  mh <- mean(ym$height) # x
  ms <- mean(ym$selfesteem) # y
  sdh <- sd(ym$height)
  sds <- sd(ym$selfesteem)
# 3
  plot(ym$height, ym$selfesteem, main="Mens Selfsteem", xlab="Height", type="p", ylab="Selfsteem", col="red")
# 4
  cc <- cor(ym$height, ym$selfesteem)
  cc
  ## the selfesteem and the height are 65% correlated to each other
# 5
  b1 <- cc * sds/sdh
  b1
  b0 <- ms-b1*mh
  b0
# 6
  ##Linear Regression
  linear_r <- lm(ym$selfesteem~ ym$height)
  ## total sum of squares
  totalss <-sum((ym$selfesteem -ms)^2)
  ## regression sum of squares
  regression_ss <-sum((fitted(linear_r) -ms)^2)
  ## residual sum of squares
  residual_ss <-sum((ms-fitted(linear_r))^2)
  rsquare <- regression_ss/totalss
  rsquare

abline(linear_r, col="blue")
summary(linear_r)

# 7
  ## the estimated for 𝛽1 is 0.063
  ## this value can be interpreted as the expeted change in y (selfsteem) for each unit of x (height)
  ## the estimate for 𝛽0 is -0.38
  ## this value can be interpreted as the value of y (selfsteem) when x (height) is 0
