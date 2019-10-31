#### 1
scores <- c(45, 80, 83, 78, 75, 77, 79, 83, 83, 100)
  ## a
  m <- mean(scores)
  v <- var(scores)
  ## b
  s <- sd(scores)
  ## c
  q1 <- quantile(scores)[2]
  q3 <- quantile(scores)[4]

#### 2
race <- c("American Indian","Non Hispanic Blacks","Hispanics","Asian Americans","Non Hispanic Whites")
diabet <- c(160 ,130 ,130 ,90 ,80)
nondiabet <- c(840, 870, 870, 910, 920)
total <- c(1000, 1000, 1000, 1000, 1000)
table <- cbind(diabet, nondiabet, total)
dimnames(table) <- list(race, c("Diabetic", "Non Diabetic", "Total"))
  ## a
  pind <- colSums(table)[1] / colSums(table)[3]
  pind
  ## b 
  ## variables: a = american indian & b = not diabetic (we want P(B|A))
  a <- table[1,3]/colSums(table)[3]
  b <- table[1,2]/table[1,3]
  p <- a*b
  p
  ## c
  ## variables a = diabetic american indian | b = non diabetic people
  a <- table[1,1]
  b <- colSums(table)[2]
  p <- (b + a)/colSums(table)[3]
  p
  ## d
  ## variables: a = hispanics & b = diabetic hispanics
  a <- table[3,3]
  b <- table[3,1]
  p <- b/a
  p

#### 3
  ## a
  scores < m
  ## b
  scores[scores<m]
  ## c
  scores[seq(1,length(scores),2)]
  ## d
  scores.matrix <- matrix(scores, nrow=2, ncol=5, byrow=TRUE)
  scores.matrix
  ## e
  scores.matrix[,c(1,length(scores.matrix[1,]))]
  ## f
  colname <- c()
  for(i in c(1:length(scores.matrix[1,]))) colname[i] <- paste(c("Quiz_",i), collapse="")
  rolname <- c()
  for(i in c(1:length(scores.matrix[,1]))) rolname[i] <- paste(c("Student_",i), collapse="")
  dimnames(scores.matrix) <- list(rolname, colname)
  scores.matrix

#### 4
Name = c("Pomana", "Williams","Stanford","Princeton", "Yale")
State = c("CA", "MA", "CA","NJ", "CT")
Cost = c(62632, 64020, 62801, 58965, 63970)
Population = c(1610, 2150, 18346, 8014, 12109)
colleges.info = data.frame(Name, State, Cost, Population)

  ## a
  summary(State)
  summary(Cost)
  ## b
  Population[Population > 5000]
  ## c
  cost5 <- Cost+(Cost*0.05)
  cost5 <- round(cost5)
  colleges.info.2016 <- data.frame(Name, State, cost5, Population)
  colleges.info.2016
  