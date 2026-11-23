## Create line plot of how topics changed over time
##
## Requires: data/clean/pubdategr_topics.tsv
## Creates: results/trends_plot.png

library(tidyverse)

# Prevent Rplots.pdf from being generated
pdf(NULL) 

# Read in data
pubdategr_topics <- readr::read_tsv("data/clean/pubdategr_topics.tsv")

# Add labels to topics
pubdategr_topics <- pubdategr_topics |> 
    mutate(topic_label = case_when(
        topic==1 ~ "1: label",
        topic==2 ~ "2: label",
        topic==3 ~ "3: label",
        topic==4 ~ "4: label",
        topic==5 ~ "5: label",
        topic==6 ~ "6: label",
        
    ))

# Define colour palette
colour_palette = c("#FF1F3DFF","#1F6BFFFF","#00D45AFF","#FFB000FF","#B200FFFF","#00D1E0FF")

# Plot a line plot
pubdategr_topics |>
    ggplot(aes(x=PubDateGr, y=gamma, colour=topic_label)) +
    geom_line() +
    geom_point() +
    scale_x_continuous(
        breaks = sort(unique(pubdategr_topics$PubDateGr)),
        labels = sort(unique(pubdategr_topics$PubDateGr_label))) +
    labs(
        title="Proportions of E. Coli AMR Articles Associated with Each Topic Over Time",
        y="Topic proportion",
        x="Publication year",
        colour="Topic") +
    scale_colour_manual(values = colour_palette) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

# Save plot
ggsave("results/trends_plot.png") 