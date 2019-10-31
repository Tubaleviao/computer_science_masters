x<-10
mode(x)
x
2^5
8%%3
15%%4
(5<=8)&(4>=9)
(5<=8)|(4>=9)
v <- 2:8
v
y<-5
print(y %in% v)

firstname <- 'Donald'
lastname <- 'Trump'
fullname <- paste(firstname, lastname)
fullname <- paste(firstname, lastname, sep = ", ")

names <- c('joe','andy','bob')
ages <- c(25, 45, 34)

namesAndages <- c(names, ages)
length(namesAndages)

hs.year <- c("Senior", "Freshman","Junior", "Senior", "Sophmore", "Freshman")
h <- factor(hs.year)
summary(h)

data <- c(90,95,92,78,46,51,77,98,90,85,78,61,100,89,87)
i <- 1
repeat{
  if(data[i] > 80) {
    print(data[i])
    i <- i+1
  } 
  else
    break
}

grades <- matrix(data, nrow = 5, ncol = 3, byrow = TRUE)
grades


dimnames(grades) <- list(c("bob", "joe", "andy", "mary","alice"), c("English", "Math", "Science"))
grades


name <- c("Jennifer", "Alex", "Wes", "Ryan")
sex <- c("Female", "Male","Male","Male")
age.diagnosis <- c(49, 57,69,75)
year.diagnosis <- c(10, 5,2,12)
hosp.info <- data.frame(name,sex,age.diagnosis, year.diagnosis)
hosp.info
hosp.info $new.age <- hosp.info$age.diagnosis + hosp.info$year.diagnosis

a <- c(100, 81, 64, 49, 36, 25, 16, 9, 4, 1)
for (i in a) {
  print(paste("square root of ", i, "is ", sqrt(i)))
}
dec <- function(x){
  return (x-1)
}
dec(6)