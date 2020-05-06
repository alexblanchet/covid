# Load data
source("data_prep.R")

# Plot
library(ggplot2)

ggplot(df.l, aes(y = value, x = reorder(mois, ordre), 
                 group = variable, colour = couleur)) +
  geom_path(na.rm=F) +
  geom_point(na.rm=F) +
  scale_color_manual("Années", 
                     labels = c("2020", "2010 à 2019"),
                     values = c("red", "grey")) +
  labs(title = "Nombre de décès mensuels au Québec de 2010 à 2020",
       subtitle = "Données : Gouvernement du Québec",
       caption = "Alexandre Blanchet (@alex_blanchet),
       GitHub : https://github.com/alexblanchet/covid") +
  xlab("Mois") +
  ylab("Nombre de décès") +
  theme_bw()
ggsave("fig_deces.jpg", width = 10, height = 5)

