## Create a plot of the number of articles per year
##
## Requires: data/clean/articles_per_year.tsv
## Creates: results/articles_per_year_plot.png

decade <- "2010s"

# load libraries
library(tidyverse)

# prevent Rplots.pdf from being generated
pdf(NULL) 

# read in article data
articles_per_year <- readr::read_tsv(paste0("data/clean/articles_per_year_",decade,".tsv"))

# create plot
articles_per_year |> 
  ggplot(aes(x=YearPublished, y=n)) +
  geom_point()

# save plot
ggsave(paste0("results/articles_per_year_plot_",decade,".png"))

cat("Plot created.")
cat(paste0("Decade: ",decade))