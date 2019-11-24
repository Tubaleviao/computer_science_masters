# code to detect if a planet is habitable or not
library("randomForest")
planets_dataset <- read.csv("phl_exoplanet_catalog.csv")

# choosed colums from the exoplanets dataset
columns <- c("P_HABITABLE", "S_HZ_OPT_MIN", "S_HZ_OPT_MAX", "S_HZ_CON_MIN", "S_HZ_CON_MAX", "S_HZ_CON0_MIN", "S_HZ_CON0_MAX", "S_HZ_CON1_MIN", "S_HZ_CON1_MAX", "P_RADIUS_EST", "P_MASS_EST", "P_ESI", "P_FLUX_MIN", "P_FLUX_MAX", "P_TEMP_EQUIL", "P_TEMP_EQUIL_MIN", "P_TEMP_EQUIL_MAX", "P_FLUX", "P_DISTANCE_EFF", "P_APASTRON", "P_PERIASTRON", "P_GRAVITY", "P_DENSITY", "S_AGE", "S_MASS", "S_RADIUS", "S_TEMPERATURE", "P_MASS", "P_RADIUS", "P_PERIOD", "P_ECCENTRICITY", "P_GEO_ALBEDO", "P_ESCAPE", "P_POTENTIAL", "P_DISTANCE", "P_HABZONE_OPT", "P_HABZONE_CON", "P_TYPE_TEMP", "P_TYPE", "P_DETECTION")

planets <- planets_dataset[, columns]
planets[is.na(planets)] <- 0
planets$P_HABITABLE <- as.factor(planets$P_HABITABLE)
# planets$P_TYPE <- as.factor(planets$P_TYPE)
#planets$P_TYPE <- as.factor(as.numeric(as.factor(planets$P_TYPE)))
#planets$P_TYPE <- as.factor(planets$P_TYPE)
sample <- sample.int(n = nrow(planets), size = floor(.75*nrow(planets)), replace = F)
planets.train <- planets[sample, ]
planets.test  <- planets[-sample, ]

# If its a factor: it becomes classification.
# If its numeric: it becomes regression
rdf <- randomForest(P_HABITABLE ~ ., data=planets.train, importance=TRUE,
            proximity=TRUE, ntree=500, mtry=7)
ttt <- 0
for(i in 1:nrow(rdf$confusion)) ttt <- ttt+rdf$confusion[i,i]
mtp <- ttt/sum(rdf$confusion) *100
print(paste("Random Forest Train precision:",mtp,"%"))

pre <- predict(rdf, planets.test[,2:ncol(planets.test)])
cm <- table(pre, planets.test$P_HABITABLE)
tt <- 0
for(i in 1:nrow(cm)) tt <- tt+cm[i,i]
p <- tt/sum(cm) *100
print(paste("Random Forest Test precision:",p,"%"))

## normal decision tree
library("rpart")
tree <- rpart(P_HABITABLE ~ ., data=planets.train, method="class")

# predict training
tpre <- predict(tree, planets.train[,2:ncol(planets.test)], type="class")
res <- table(tpre, planets.train$P_HABITABLE)
total <- 0
for(i in 1:nrow(res)) total <- total+res[i,i]
tp <- total/sum(res) *100
print(paste("Decision Tree training data precision:",tp,"%"))

# predict testing
tpre <- predict(tree, planets.test[,2:ncol(planets.test)], type="class")
res <- table(tpre, planets.test$P_HABITABLE)
total <- 0
for(i in 1:nrow(res)) total <- total+res[i,i]
tp <- total/sum(res) *100
print(paste("Decision Tree test data precision:",tp,"%"))

# plot precision graph over mtry variable (take some time)
b <- c()
for(val in 1:13){
  rdf <- randomForest(P_HABITABLE ~ ., data=planets.train, importance=TRUE,
                          proximity=TRUE, ntree=200, mtry=val)
  cf <- rdf$confusion
  modeltotalprecision <- (cf[1,1]+cf[2,2]+cf[3,3])/sum(cf) * 100
  b[val] <- modeltotalprecision
}
mat <- cbind(c(1:13), b)
plot(mat, main="Random Forest Precision", ylab="Precision", xlab="mtry", type="b")

## The unsupervised case:
rdf <- randomForest(planets.train[,2:ncol(planets.train)])
MDSplot(rdf, planets$P_HABITABLE)
