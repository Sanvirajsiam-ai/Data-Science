install.packages("dplyr")
install.packages("ggplot2")
install.packages("reshape2")
install.packages("caretr")
install.packages("infotheo")
install.packages("statsr")
install.packages("FSelectorRcpp")


library(ggplot2)
library(dplyr)
library(reshape2)
library(caret)
library(FSelector)
library(infotheo)
library(stats)

df <- read.csv("E:/titanic.csv")

str(df)

df <- df %>% select(Pclass, Sex, Age, SibSp, Parch, Fare)

df$Pclass <- as.factor(df$Pclass)
df$Sex <- as.factor(df$Sex)

numerical_cols <- c("Age", "Fare")
for (col in numerical_cols) {
  print(ggplot(df, aes_string(col)) + 
          geom_histogram(binwidth=10, fill="skyblue", color="black") + 
          ggtitle(paste("Histogram of", col)))
}

categorical_cols <- c("Pclass", "Sex")
for (col in categorical_cols) {
  print(ggplot(df, aes_string(col)) + 
          geom_bar(fill="lightgreen", color="black") + 
          ggtitle(paste("Bar Chart of", col)))
}

print(ggplot(df, aes(x=Age, y=Fare)) + 
        geom_point(color="darkblue") + 
        ggtitle("Scatter plot: Age vs Fare"))

print(ggplot(df, aes(x=Sex, y=Age)) + 
        geom_violin(fill="orchid") + 
        ggtitle("Violin plot: Age by Sex"))
print(ggplot(df, aes(x=Pclass, y=Fare)) + 
        geom_violin(fill="orange") + 
        ggtitle("Violin plot: Fare by Pclass"))
