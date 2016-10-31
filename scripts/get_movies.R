mojo_1stpage <- "http://www.boxofficemojo.com/alltime/domestic.htm"

movietable <- xml2::read_html(mojo_1stpage) %>%
  rvest::html_nodes("tr+ tr table") %>%
  rvest::html_table(header = T)

# http://www.boxofficemojo.com/alltime/domestic.htm?page=2&p=.htm

for(i in 2:145) {
  pageurl <- paste0("http://www.boxofficemojo.com/alltime/domestic.htm?page=",
                    i, "&p=.htm")
  movietable_i <- xml2::read_html(pageurl) %>%
    rvest::html_nodes("tr+ tr table") %>%
    rvest::html_table(header = T)
  movietable[[1]] <- rbind(movietable[[1]], movietable_i[[1]])
}

box_office_14469 <- movietable[[1]]
box_office_14469$`Lifetime Gross` <- readr::parse_number(box_office_14469$`Lifetime Gross`)
box_office_14469$`Year^` <- gsub("\\^", "", box_office_14469$`Year^`)

names(box_office_14469)[2] <- "Title"
names(box_office_14469)[5] <- "Year"
names(box_office_14469) <- tolower(names(box_office_14469))
names(box_office_14469)[4] <- "lifetime_gross"
box_office_14469$year <- as.integer(box_office_14469$year)

box_office_14469$title[6282] <- "A Prophet (Un Prophete)"
box_office_14469$title[9555] <- "Rams"
box_office_14469$title[10998] <- "Le Combat dans l'ile 1962"

boxoffice <- box_office_14469
write_csv(boxoffice, "~/Google Drive/boxoffice mojo final oct 2016.csv")
