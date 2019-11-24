# predicts planet type
# dataset url: http://phl.upr.edu/projects/habitable-exoplanets-catalog/data/database?fbclid=IwAR3Ki4rYHebqEW2Ha_ditXwY0Cj8UIW5Wv0I7OAP51Hp6vqynwoHpzMXOnM

# load data
dt <- read.csv("phl_exoplanet_catalog.csv")
dt[is.na(dt)] <- 0

# get best columns using ginis
library("ineq")
cols <- colnames(dt)
ginis <- c()
for(i in 1:length(cols)) ginis <- c(ginis, abs(ineq(dt[,i], type="Gini")))
mt <- cbind(cols, ginis)
mt <- mt[mt[,2] != "NaN", ]
mt[,2] <- as.numeric(mt[,2])
mt <- mt[order(mt[,2]), ]
print("Best rows for classification using ginis:")
mt <- head(mt)
mt
plot(as.numeric(row(mt)[,1]), mt[,2], xlab="column", ylab="ginis")

# predict planet type using mass and radius
columns <- c("P_TYPE", "P_MASS", "P_RADIUS")
planets <- dt[, columns]
ncol(planets)
planets[is.na(planets)] <- 0
#planets$P_HABITABLE <- as.factor(planets$P_HABITABLE)
planets$P_TYPE <- as.factor(as.numeric(as.factor(planets$P_TYPE)))
sample <- sample.int(n = nrow(planets), size = floor(.60*nrow(planets)), replace = F)
planets.train <- planets[sample, ]
planets.test  <- planets[-sample, ]

# If its a factor: it becomes classification.
# If its numeric: it becomes regression
library("randomForest")
rdf <- randomForest(P_TYPE ~ ., data=planets.train, ntree=800)
# this last line sometimes throws this error idkw
# Error in randomForest.default(m, y, ...) : Can't have empty classes in y.
# Calls: randomForest -> randomForest.formula -> randomForest.default
# Execution halted
ttt <- 0
for(i in 1:nrow(rdf$confusion)) ttt <- ttt+rdf$confusion[i,i]
mtp <- ttt/sum(rdf$confusion) *100
print(paste("RandomForest Train precision:",mtp,"%"))

pre <- predict(rdf, planets.test[,2:ncol(planets.test)])
cm <- table(pre, planets.test$P_TYPE)
tt <- 0
for(i in 1:nrow(cm)) tt <- tt+cm[i,i]
p <- tt/sum(cm) *100
print(paste("RandomForest Test precision:",p,"%"))

## normal decision tree
library("rpart")
tree <- rpart(P_TYPE ~ ., data=planets.train, method="class")

# predict training
tpre <- predict(tree, planets.train[,2:ncol(planets.test)], type="class")
res <- table(tpre, planets.train$P_TYPE)
total <- 0
for(i in 1:nrow(res)) total <- total+res[i,i]
tp <- total/sum(res) *100
print(paste("Decision Tree Training precision:",tp,"%"))

# predict testing
tpre <- predict(tree, planets.test[,2:ncol(planets.test)], type="class")
res <- table(tpre, planets.test$P_TYPE)
total <- 0
for(i in 1:nrow(res)) total <- total+res[i,i]
tp <- total/sum(res) *100
print(paste("Decision Tree Test precision:",tp,"%"))

# run results 10 times and show plot of best precision on test data
# between randomForest and decisionTree
rf <- c()
dt <- c()

for(i in 1:10) {
  # resample
  sample <- sample.int(n = nrow(planets), size = floor(.60*nrow(planets)), replace = F)
  planets.train <- planets[sample, ]
  planets.test  <- planets[-sample, ]

  # model construction
  tree <- rpart(P_TYPE ~ ., data=planets.train, method="class")
  rdf <- randomForest(P_TYPE ~ ., data=planets.train, ntree=800)
  # this last line sometimes throws this error idkw
  # Error in randomForest.default(m, y, ...) : Can't have empty classes in y.
  # Calls: randomForest -> randomForest.formula -> randomForest.default
  # Execution halted

  # decision tree
  tpre <- predict(tree, planets.test[,2:ncol(planets.test)], type="class")
  res <- table(tpre, planets.test$P_TYPE)
  total <- 0
  for(i in 1:nrow(res)) total <- total+res[i,i]
  tp <- total/sum(res) *100
  dt <- c(dt, tp)

  # random forest
  pre <- predict(rdf, planets.test[,2:ncol(planets.test)])
  cm <- table(pre, planets.test$P_TYPE)
  tt <- 0
  for(i in 1:nrow(cm)) tt <- tt+cm[i,i]
  p <- tt/sum(cm) *100
  rf <- c(rf, p)

}
plot(rf, dt)
