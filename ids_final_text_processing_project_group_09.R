install.packages("tidytext")
install.packages("readxl")
install.packages("dplyr")
install.packages("tm")
install.packages("stringr")
install.packages("stopwords")
install.packages("textclean")
install.packages("hunspell")



library(readxl)
library(dplyr)
library(tm)
library(stringr)
library(stopwords)
library(textclean)
library(hunspell)
library(tidytext)












file_path <- "D:/ids_final_project_group_09_news_raw.xlsx"
df <- read_excel(file_path)


remove_custom_stopwords <- function(text) {
  words <- unlist(strsplit(text, "\\s+"))
  cleaned_words <- words[!tolower(words) %in% stopwords("en")]
  return(paste(cleaned_words, collapse = " "))
}


cleaned_df <- df %>%
  mutate(description = tolower(description)) %>%                     
  mutate(description = removePunctuation(description)) %>%           
  mutate(description = removeNumbers(description)) %>%               
  mutate(description = str_squish(description)) %>%                  
  mutate(description = sapply(description, remove_custom_stopwords)) 

mutate(description = sapply(description, function(x) {
  
  words <- unlist(strsplit(x, "\\s+"))
  misspelled <- hunspell_check(words)
  corrected <- sapply(words, function(word) {
    if (!hunspell_check(word)) {
      suggestion <- hunspell_suggest(word)[[1]]
      if (length(suggestion) > 0) {
        return(suggestion[1])  
      } else {
        return(word)  
      }
    } else {
      return(word)  
    }
  })
  return(paste(corrected, collapse = " ")) 
})) %>%









 
  mutate(description = wordStem(description)) %>%
  
  mutate(description = remove_emoji(description)) %>%

write.csv(cleaned_df, "D:/ids_final_project_group_09_news_clean.csv", row.names = FALSE)

cat("✅ Cleaned paragraph-level data saved as 'ids_final_project_group_08news_clean.csv'\n")
