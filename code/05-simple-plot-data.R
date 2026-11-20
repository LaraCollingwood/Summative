## Create a plot of the number of articles per year
##
## Requires: data/clean/articles_per_year.tsv
## Creates: results/articles_per_year_plot.png

# load libraries
library(tidyverse)

# read in article data
articles_per_year <- readr::read_tsv("data/clean/articles_per_year.tsv")

# create plot
articles_per_year |> 
  ggplot(aes(x=YearPublished, y=n)) +
  geom_point()

# save plot
ggsave("results/articles_per_year_plot.png")