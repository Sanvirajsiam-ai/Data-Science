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
library(infotheo)
library(stats)
library(FSelectorRcpp)

correlation_matrix <- cor(df %>% select_if(is.numeric), use="complete.obs")
print("Pearson Correlation Coefficients:")
print(correlation_matrix)
anova_results <- list()
for (cat_col in categorical_cols) {
  for (num_col in numerical_cols) {
    formula <- as.formula(paste(num_col, "~", cat_col))
    aov_res <- summary(aov(formula, data=df))
    anova_results[[paste(num_col, "vs", cat_col)]] <- aov_res
  }
}
print("ANOVA Results:")
print(anova_results)

print("Chi-squared Test between Pclass and Sex:")
print(chisq.test(table(df$Pclass, df$Sex)))


df_mi <- df
for (col in numerical_cols) {
  df_mi[[col]] <- infotheo::discretize(df_mi[[col]], disc="equalfreq")
  
}


print("Mutual Information:")
mi_scores <- information_gain(Sex ~ ., data = df_mi)
print(mi_scores)
