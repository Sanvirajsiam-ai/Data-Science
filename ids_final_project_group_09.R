
install.packages("rvest")
install.packages("httr")
install.packages("xml2")
install.packages("dplyr")
install.packages("stringr")


library(rvest)
library(httr)
library(xml2)
library(dplyr)
library(stringr)




categories <- list(
  "World" = "https://edition.cnn.com/world",
  "Business" = "https://edition.cnn.com/business",
  "Health" = "https://edition.cnn.com/health",
  "Entertainment" = "https://edition.cnn.com/entertainment",
  "Sport" = "https://edition.cnn.com/sport"
)

get_article_links <- function(category_url) {
  page <- read_html(category_url)
  

  links <- page %>%
    html_nodes("a") %>%
    html_attr("href") %>%
    unique()
  
  article_links <- links[grepl("^/\\d{4}/\\d{2}/\\d{2}/", links)]
  
  full_links <- paste0("https://edition.cnn.com", article_links)
  
  return(unique(full_links))
}




extract_news_details <- function(url, category_name) {
  tryCatch({
    page <- read_html(url)
    
    title <- page %>%
      html_node("h1") %>%
      html_text(trim = TRUE)
    
    date <- page %>%
      html_node('meta[itemprop="datePublished"]') %>%
      html_attr("content")
    
    description <- page %>%
      html_node('meta[name="description"]') %>%
      html_attr("content")
    
    if (is.na(description) || description == "") {
      description <- page %>%
        html_nodes("p") %>%
        html_text() %>%
        paste(collapse = " ") %>%
        str_squish()
    }
    
    author <- page %>%
      html_node('meta[name="author"]') %>%
      html_attr("content")
   
    return(data.frame(
      title = title,
      description = description,
      date = date,
      category = category_name,
      author = author,
      url = url,
      stringsAsFactors = FALSE
    ))
    
  }, error = function(e) {
 
    return(NULL)
  })
}





all_news <- data.frame()

for (category in names(categories)) {
  cat("Processing category:", category, "\n")
  
  category_url <- categories[[category]]
  article_urls <- get_article_links(category_url)
  
  article_urls <- unique(article_urls)[1:150]
 
  category_news <- list()
  count <- 0
  
  for (link in article_urls) {
    news_data <- extract_news_details(link, category)
    
    if (!is.null(news_data)) {
      category_news[[length(category_news) + 1]] <- news_data
      count <- count + 1
      cat("Collected:", count, "articles for", category, "\n")
    }
    
    if (count >= 100) {
      break
    }
    
    Sys.sleep(1) 
  }

  category_df <- do.call(rbind, category_news)
  all_news <- rbind(all_news, category_df)
}

cat("Total articles collected:", nrow(all_news), "\n")

news_data <- read.csv("ids_final_project_group_09_news_raw.csv", stringsAsFactors = FALSE)

head(news_data)

View(news_data)

write.csv(all_news, "E:/Data Science/ids_final_project_group_09_news_raw.csv", row.names = FALSE)

