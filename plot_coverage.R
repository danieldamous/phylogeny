library(tidyverse)
# carregar tabela
cov <- read.table("~/00_tools/cov/depth.txt") %>%  
  rename("position" = V1) %>% rename("coverage" = V2)

# Plot brabo
cov %>%
  ggplot(aes(x = position, y = coverage)) + geom_area() +
  theme_minimal()
#
#
# Plot bonitinho
  cov %>%
    ggplot(aes(x = position, y = coverage)) +
    geom_area(stat = "smooth", method = "loess", span = 0.05, fill = "blue", alpha = 0.4) + 
   #scale_y_continuous(limits = c(0, 500)) +  # Limite do eixo y até 500
    scale_x_continuous(limits = c(0, 12000),  breaks = seq(0, 12000, by = 1000)) + # ajustar conform
    theme_minimal()
  # ajustar o valor de "span" para suavizar a curva.
  # scale_x_continuous = ajustar conforme o tamanho do contig para não omitir a cobertura das regiões terminais.





