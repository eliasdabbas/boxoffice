library(tidyverse)
library(advertools)
library(ggrepel)
load("data/boxoffice.Rda")
boxoffice_sum <- boxoffice %>% group_by(studio_name, year) %>% 
  summarise(n = n(), gross = sum(lifetime_gross, na.rm = TRUE)) %>% 
  mutate(gross_permovie = round(gross / n))

theme_elias <- theme(axis.text = element_text(size = 20), 
                     legend.position = "bottom", 
                     rect = element_rect(fill = "#ebebeb", colour = NA), 
                     title = element_text(size = 22), 
                     legend.title = element_blank(), 
                     legend.text = element_text(size = 20), 
                     plot.background = element_rect(color = NA), 
                     strip.text = element_text(size = 24))