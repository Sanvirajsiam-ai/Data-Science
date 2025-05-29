install.packages("readr")
install.packages("tm")
install.packages("SnowballC")

install.packages("topicmodels")
install.packages("tidytext")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("reshape2")
install.packages("tidyr")




library(readr)
library(tm)
library(SnowballC)

library(topicmodels)
library(tidytext)
library(dplyr)
library(ggplot2)
library(reshape2)
library(tidyr)

file_path <- "E:/Data Science/ids_final_project_group_09_news_clean1.csv"
data <- read_csv(file_path)

if (!"clean_description" %in% colnames(data)) {
  stop("Column 'clean_description' not found in the dataset.")
}

corpus <- Corpus(VectorSource(data$clean_description))


dtm <- DocumentTermMatrix(corpus)

inspect(dtm[1:5, 1:10]) 

dtm_matrix <- as.matrix(dtm)
write.csv(dtm_matrix, "E:/Data Science/clean_description_dtm.csv", row.names = FALSE)

cat("DTM Dimensions: ", dim(dtm)[1], "documents x", dim(dtm)[2], "terms\n")


dtm <- removeSparseTerms(dtm, 0.95)

lda_model <- LDA(dtm, k = 5, control = list(seed = 1234))

lda_terms <- tidy(lda_model, matrix = "beta")


top_terms <- lda_terms %>%
  filter(topic %in% 1:5) %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  arrange(topic, -beta) %>%
  ungroup()

for (i in 1:5) {
  cat(paste0("\n===== Topic ", i, " =====\n"))
  terms <- top_terms %>%
    filter(topic == i) %>%
    select(term, beta)
  print(terms)
}

doc_topics %>%
  filter(document %in% as.character(1:5)) %>%  # documents 1 to 5
  pivot_wider(
    names_from = topic,
    values_from = gamma,
    names_prefix = "Topic_"
  ) %>%
  arrange(as.numeric(document)) -> doc_topic_wide

print(doc_topic_wide)


doc_topics <- tidy(lda_model, matrix = "gamma")

dominant_topic <- doc_topics %>%
  group_by(document) %>%
  slice_max(gamma) %>%
  ungroup()

topic_distribution <- dominant_topic %>%
  count(topic, sort = TRUE)


cat("\n\n=========== Topic Distribution Across Documents ===========\n")
print(topic_distribution)

ggplot(topic_distribution, aes(x = factor(topic), y = n, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Number of Documents Dominated by Each Topic",
    x = "Topic",
    y = "Document Count"
  )

most_common <- topic_distribution %>% slice_max(n, n = 1)
cat(paste0(
  "Topic ", most_common$topic, 
  " appears as the dominant topic in the highest number of documents (", 
  most_common$n, " documents).\n"
))



write.csv(doc_topics, "E:/Data Science/topic_proportions_per_document.csv", row.names = FALSE)

top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered() +
  labs(title = "Top 10 Terms per Topic", x = "Terms", y = "Probability")
