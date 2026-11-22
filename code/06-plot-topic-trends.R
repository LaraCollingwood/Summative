## Create line plot of trends
##
## Requires: data/clean/decade_topics.tsv
## Creates: results/trends_plot.png

library(tidyverse)

# prevent Rplots.pdf from being generated
pdf(NULL) 

# Read in data
decade_topics <- readr::read_tsv("data/clean/decade_topics.tsv")

# Plot
decade_topics |>
    ggplot(aes(x=Decade, y=gamma, colour=as.factor(topic))) +
    geom_line() +
    geom_point() +
    scale_x_continuous(
        breaks = sort(unique(decade_topics$Decade)),
        labels = sort(unique(decade_topics$Decade_label))
    ) +
    labs(
        title="Changes in Research Topics in AMR",
        y="Proportion of text assosiated with each topic",
        colour="Topic"
    ) +
    theme_minimal()

# save plot
ggsave("results/trends_plot.png") 