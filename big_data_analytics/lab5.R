library(readxl)
library(ggplot2)
movies <- read_excel("BigDataAnalytics/5000movies.xlsx", sheet=1)

# qualitative univariate
## the most produced movies are drama, comedy and action
t <- table(movies$genre)
barplot(tail(sort(t), 3), 
        main="3 most produced movie genres", 
        col="blue", xlab="genre", ylab="quantity")
filtered_movies <- movies[movies$genre %in% names(tail(sort(t), 3)),]
ggplot(filtered_movies, aes(x = filtered_movies$genre))+geom_bar()+labs(x="genre")

# quantitative univariate
summary(movies$revenue)
quantile(movies$revenue, c(0,0.25,0.5,0.75,1), na.rm = TRUE, type=2)
IQR(movies$revenue, na.rm = TRUE, type=2)
?IQR
hist(x = movies$revenue,
     breaks = 20,
     main = "Distribution of revenue",
     xlab = "Revenue")
qplot(movies$revenue, main="Distribution of revenue", geom="histogram", 
      xlab="Revenue", ylab="Quantitity", bins="20")
length(movies$revenue[movies$revenue == 0])
## 1427 movies has no revenues

# qualitative bivariate
  filtered_movies <- filtered_movies[filtered_movies$spoken_languages %in% c("en","es","fr"),]
data <- table(filtered_movies$genre, filtered_movies$spoken_languages)
summary(data)
barplot(data, col=c("green", "blue", "red"), 
        beside=TRUE, 
        legend.text=TRUE)
mosaicplot(data,
           main = "Survival By Gender",
           xlab ="Genre",
           ylab="Language",
           color = c("green", "blue", "red")) 
## most of movies are in english

# quantitative bivariate
plot(movies$revenue, movies$budget, main="Revenue by Budget",
     xlab="Revenue", ylab="Budget")
ggplot(movies, aes(x = movies$revenue, y = movies$budget)) +
  geom_point(alpha = 0.5) +
  labs(x="Revenue", y="Budget")
## The more budget a movie has, bigger are the chances to get a better revenue

# quantitative and qualitative bivariate
filtered_movies$spoken_languages <- as.factor(filtered_movies$spoken_languages)
plot(filtered_movies$spoken_languages, filtered_movies$revenue,
     main="Revenue per Spoken Languages", xlab="Languages", ylab="Revenue")
filtered_movies <- movies[movies$genre %in% names(tail(sort(t), 3)),]
ggplot(filtered_movies, aes(x = filtered_movies$popularity, y = filtered_movies$revenue)) + 
  geom_point(aes(color = filtered_movies$genre, size = filtered_movies$budget), alpha = 0.4) +
  labs(x="Popularity", y="Revenue", colour="Genre", size="Budget", title="Movies Overlook") +
  scale_size(range = c(0.5, 10))
  ## The most popular and more well-payed movies are the action ones


if(FALSE){
  head(data %in% data[,tail(sort(data), 3)])
  n <- length(data)
  sort(data,partial=n-1)[n-1]
  names(head(t, 3))
  movies$genre[movies$genre %in% names(head(t, 3))]
  count.fields(movies)
  subset(movies, genre %in% t)
  head(movies$genre, 3)
  movies$genre <- as.factor(movies$genre)
  movies$revenue <- as.factor(movies$revenue)
  movies$production_country <- as.factor(movies$production_country)
  ##ggplot(movies, aes(x=genre, y=popularity, size=revenue)) + geom_point(alpha=0.7)
  ##plot(x=movies$revenue)
}