## Creates a line plot of how topics changed over time.
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
        topic==1 ~ "\n1: AMR E.coli\nwithin livestock\n",
        topic==2 ~ "\n2: Biological\nmechanisms\nfor resistance\n",
        topic==3 ~ "\n3: Detection and\nremoval from the\nenvironment\n",
        topic==4 ~ "\n4: Tracing\ntransmission\nacross hosts\n",
        topic==5 ~ "\n5: AMR E.coli\nwithin humans\n",   
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
        title="Research topic trends in E. coli antimicrobial resistance, 1980-2024",
        y="Mean topic proportion",
        x="Publication year",
        colour="Topic", shape="Topic", fill="Topic",
        caption="Disclosure: Topic labels are human-written after inspecting the topic_info files; labels may not be accurate if input data is changed.") +
    # Improve aesthetics
    scale_colour_manual(values = colour_palette) +
    scale_fill_manual(values = colour_palette) +
    scale_shape_manual(values = c(21,22,23,24,25)) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

# Save plot
ggsave("results/trends_plot.png", width = 10, height = 7) 