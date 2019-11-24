# load dataset
dt <- read.csv("2clases.csv")

# pre-processing the data
dt$Z <- as.factor(dt$Z)
head(dt)
set.seed(101)
idx <- sample(1:nrow(dt), 0.70*nrow(dt))
train <- dt[idx, ]
test <- dt[-idx, ]
print(paste("Training rowns:",nrow(train)))
print(paste("Testing rows:",nrow(test)))

# construction of the model
library("rpart")
model <- rpart(Z ~ ., data=train) # , control=rpart.control(minsplit=2, cp=0)
library("rpart.plot")
rpart.plot(model)

# prediction on train data
pred <- predict(model, train[,1:ncol(test)-1], type="class")
confusion <- table(pred, train$Z)
correct <- 0
for(i in 1:nrow(confusion)) correct <- correct+confusion[i,i]
mtp <- correct/sum(confusion) *100
print(paste("Train Precision:",mtp,"%"))

# predction on test data
pred <- predict(model, test[,1:ncol(test)-1], type="class")
confusion <- table(pred, test$Z)
correct <- 0
for(i in 1:nrow(confusion)) correct <- correct+confusion[i,i]
mtp <- correct/sum(confusion) *100
print(paste("Test Precision:",mtp,"%"))

# testing with random forest
library("randomForest")
rdf <- randomForest(Z ~ ., data=train) # ntree=200, mtry=2
cf <- rdf$confusion
cf
correct <- 0
for(i in 1:nrow(cf)) correct <- correct+cf[i,i]
mtp <- correct/sum(cf) *100
print(paste("Train Precision on Forest:",mtp,"%"))

# prediction on test dataset
pred <- predict(rdf, test[,1:ncol(test)-1], type="class")
confusion <- table(pred, test$Z)
correct <- 0
for(i in 1:nrow(confusion)) correct <- correct+confusion[i,i]
mtp <- correct/sum(confusion) *100
print(paste("Test Precision on Forest:",mtp,"%"))
