
##### create boxplots of genome size by group #####

### remove missing genome sizes
box_data <- g_data[
  !is.na(g_data$genome_size) & !is.na(g_data$group),
]

### create the boxplot
boxplot(genome_size ~ group, data = box_data, ylab = "Genome size (bp)", xlab = "Major lineage", main = "Genome size by group", las = 2)

### create the boxplot using ggplot2
ggplot(g_data, aes(x = group, y = genome_size)) +
  geom_boxplot() +
  labs(
    title = "Genome size by group",
    x = "Major lineage",
    y = "Genome size (bp)"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
