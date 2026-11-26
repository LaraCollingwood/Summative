## Create line plot of how topics changed over time
##
## Requires: data/intermediates/pubdategr_topics.tsv
## Creates: results/trends_plot.png

library(tidyverse)

# Prevent Rplots.pdf from being generated
pdf(NULL) 

# Read in data
pubdategr_topics <- readr::read_tsv("data/intermediates/pubdategr_topics.tsv")

# Add labels to topics
pubdategr_topics <- pubdategr_topics |> 
    mutate(topic_label = case_when(
        topic==1 ~ "1: Livestock",
        topic==2 ~ "2: Biological\nmechanisms",
        topic==3 ~ "3: Water and\nthe environment",
        topic==4 ~ "4: Genomics",
        topic==5 ~ "5: Patients",   
))

# Define colour palette
colour_palette = c("#FF1F3DFF","#1F6BFFFF","#00D45AFF","#FFB000FF","#B200FFFF")

# Plot a line plot
pubdategr_topics |>
    # Plot the points with lines between them
    ggplot(aes(x=PubDateGr, y=gamma, colour=topic_label, shape=topic_label, fill=topic_label)) +
    geom_line() +
    geom_point() +
    # Make the labels readable
    scale_x_continuous(
        breaks = sort(unique(pubdategr_topics$PubDateGr)),
        labels = sort(unique(pubdategr_topics$PubDateGr_label))) +
    labs(
        title="Proportions of E. Coli AMR Articles Associated with Each Topic Over Time",
        y="Topic proportion",
        x="Publication year",
        colour="Topic", shape="Topic", fill="Topic") +
    # Improve aesthetics
    scale_colour_manual(values = colour_palette) +
    scale_fill_manual(values = colour_palette) +
    scale_shape_manual(values = c(21,22,23,24,25)) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

# Save plot
ggsave("results/trends_plot.png", width = 10, height = 7) 