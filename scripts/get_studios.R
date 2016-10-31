library(lubridate)
library(tidyverse)
table_page <- "http://www.boxofficemojo.com/studio/?view=company&view2=allstudios&view3=detail"

studio_table <- xml2::read_html(table_page) %>%
  rvest::html_nodes("table") %>%
  rvest::html_table(header = TRUE, fill = TRUE)

studio_table_df <- studio_table[[3]]
studio_table_df <- studio_table_df[1:(nrow(studio_table_df) - 1), ]



names(studio_table_df) <- tolower(names(studio_table_df))
names(studio_table_df) <- gsub(" ", "_", names(studio_table_df))
names(studio_table_df)[1] <- "studio_name"
names(studio_table_df)[3] <- "releases"
names(studio_table_df)[4] <- "title"
names(studio_table_df)[5] <- "lifetime_gross"
names(studio_table_df)[6] <- "top_movie_rel_date"


studio_table_df$total_gross <- parse_number(studio_table_df$total_gross)
studio_table_df$lifetime_gross <- parse_number(studio_table_df$lifetime_gross)
studio_table_df$top_movie_rel_date <- gsub("\\*", "", studio_table_df$top_movie_rel_date)
studio_table_df$top_movie_rel_date <- mdy(studio_table_df$top_movie_rel_date)


movies_studios <- left_join(boxoffice_csv, studio_table_df, by = "title")
movies_studios <-  movies_studios[-which(duplicated(movies_studios$title)), ]
movies_studios <- movies_studios[-c(9773), ]

studio_dictionary <- movies_studios %>% 
  arrange(studio_name) %>%  
  select(studio, studio_name) %>%  
  slice(1:min(which(is.na(.[[2]]))-1)) 

missing_movies <- which(!studio_table_df$title %in% boxoffice_csv$title) 
missing_studios <- setdiff(unique(boxoffice_csv$studio), studio_dictionary$studio) 
  
studio_dictionary <- rbind(studio_dictionary, 
                           data_frame(
                             studio = missing_studios,
                             studio_name = missing_studios))

  
  
  
