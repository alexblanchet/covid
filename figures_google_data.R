library(tidyverse)

# Données google par province seulement, pas de sous-régions
df.google <- read_csv("https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv?cachebust=722f3143b586a83f")
df.google <- subset(df.google, country_region_code == "CA" & sub_region_1 == "Quebec" |
                               country_region_code == "CA" & sub_region_1 == "Ontario")
df.google$date <- lubridate::ymd(df.google$date)

df.google <- df.google[, c(3, 5:11)]
colnames(df.google) <- c("Province", "date", "retail", "grocery_pharma", 
                         "parks", "transit", "workplaces", "residential")

#---------------------------- Figures
# Marqueurs
df.google$evenement[df.google$date == "2020-03-02"] <- "Début de la semaine de relâche au Québec"
df.google$evenement[df.google$date == "2020-03-06"] <- "Fin de la semaine de relâche au Québec"
df.google$evenement[df.google$date == "2020-03-13"] <- "État d'urgence au Québec"
df.google$evenement[df.google$date == "2020-03-17"] <- "État d'urgence en Ontario"
df.google$evenement[df.google$date == "2020-04-10"] <- "Legault : Ouverture possible des écoles avant le 4 mai"
df.google$evenement[df.google$date == "2020-04-28"] <- "Québec annonce le plan de déconfinement"

marqueurs <- c(c("2020-03-02", "2020-03-06", "2020-03-13", 
                 "2020-03-17", "2020-04-10", "2020-04-28"))

# Figure vente au détail
ggplot(df.google, aes(y = retail, x = date, color = Province, fill = Province)) +
   geom_smooth(method = "loess", formula = "y ~ x") +
    geom_point(alpha = 0.5) +
    geom_hline(yintercept=0, color= "grey", size=1, linetype = "dashed") +
    geom_vline(xintercept = as.numeric(as.Date(marqueurs)), 
               linetype = 4, colour = "black") +
    geom_text(data=df.google, mapping=aes(x=date, y=-100, label = evenement), 
              size=3, angle=90, vjust=-0.4, hjust=0, colour = "black") +
    labs(title = "Variation des déplacements par rapport à la normale - Vente au détail",
         subtitle = "Données : Google",
         caption = "Alexandre Blanchet (@alex_blanchet),
         GitHub : https://github.com/alexblanchet/covid") +
    xlab("Mois") +
    ylab("Variation des déplacements en %") +
    theme_light()
ggsave("fig_google_retail.jpg", width = 10, height = 5)

# Figure épicerie et pharmacies
ggplot(df.google, aes(y = grocery_pharma, x = date, color = Province, fill = Province)) +
   geom_smooth(method = "loess", formula = "y ~ x") +
    geom_point(alpha = 0.5) +
    geom_hline(yintercept=0, color= "grey", size=1, linetype = "dashed") +
    geom_vline(xintercept = as.numeric(as.Date(marqueurs)), 
               linetype = 4, colour = "black") +
    geom_text(data=df.google, mapping=aes(x=date, y=-100, label = evenement), 
              size=3, angle=90, vjust=-0.4, hjust=0, colour = "black") +
    labs(title = "Variation des déplacements par rapport à la normale - Épiceries & Pharmacies",
         subtitle = "Données : Google",
         caption = "Alexandre Blanchet (@alex_blanchet),
         GitHub : https://github.com/alexblanchet/covid") +
    xlab("Mois") +
    ylab("Variation des déplacements en %") +
    theme_light()
ggsave("fig_google_grocery.jpg", width = 10, height = 5)

# Parcs
ggplot(df.google, aes(y = parks, x = date, color = Province, fill = Province)) +
   geom_smooth(method = "loess", formula = "y ~ x") +
    geom_point(alpha = 0.5) +
    geom_hline(yintercept=0, color= "grey", size=1, linetype = "dashed") +
    geom_vline(xintercept = as.numeric(as.Date(marqueurs)), 
               linetype = 4, colour = "black") +
    geom_text(data=df.google, mapping=aes(x=date, y=-100, label = evenement), 
              size=3, angle=90, vjust=-0.4, hjust=0, colour = "black") +
    labs(title = "Variation des déplacements par rapport à la normale - Parcs",
         subtitle = "Données : Google",
         caption = "Alexandre Blanchet (@alex_blanchet),
         GitHub : https://github.com/alexblanchet/covid") +
    xlab("Mois") +
    ylab("Variation des déplacements en %") +
    theme_light()
ggsave("fig_google_parks.jpg", width = 10, height = 5)

# Transports
ggplot(df.google, aes(y = transit, x = date, color = Province, fill = Province)) +
   geom_smooth(method = "loess", formula = "y ~ x") +
    geom_point(alpha = 0.5) +
    geom_hline(yintercept=0, color= "grey", size=1, linetype = "dashed") +
    geom_vline(xintercept = as.numeric(as.Date(marqueurs)), 
               linetype = 4, colour = "black") +
    geom_text(data=df.google, mapping=aes(x=date, y=-100, label = evenement), 
              size=3, angle=90, vjust=-0.4, hjust=0, colour = "black") +
    labs(title = "Variation des déplacements par rapport à la normale - Transports en commun",
         subtitle = "Données : Google",
         caption = "Alexandre Blanchet (@alex_blanchet),
         GitHub : https://github.com/alexblanchet/covid") +
    xlab("Mois") +
    ylab("Variation des déplacements en %") +
    theme_light()
ggsave("fig_google_transit.jpg", width = 10, height = 5)

# Milieu de travail
ggplot(df.google, aes(y = workplaces, x = date, color = Province, fill = Province)) +
   geom_smooth(method = "loess", formula = "y ~ x") +
    geom_point(alpha = 0.5) +
    geom_hline(yintercept=0, color= "grey", size=1, linetype = "dashed") +
    geom_vline(xintercept = as.numeric(as.Date(marqueurs)), 
               linetype = 4, colour = "black") +
    geom_text(data=df.google, mapping=aes(x=date, y=-100, label = evenement), 
              size=3, angle=90, vjust=-0.4, hjust=0, colour = "black") +
    labs(title = "Variation des déplacements par rapport à la normale - Milieu de travail",
         subtitle = "Données : Google",
         caption = "Alexandre Blanchet (@alex_blanchet),
         GitHub : https://github.com/alexblanchet/covid") +
    xlab("Mois") +
    ylab("Variation des déplacements en %") +
    theme_light()
ggsave("fig_google_workplaces.jpg", width = 10, height = 5)

# Residential
ggplot(df.google, aes(y = residential, x = date, color = Province, fill = Province)) +
   geom_smooth(method = "loess", formula = "y ~ x") +
    geom_point(alpha = 0.5) +
    geom_hline(yintercept=0, color= "grey", size=1, linetype = "dashed") +
    geom_vline(xintercept = as.numeric(as.Date(marqueurs)), 
               linetype = 4, colour = "black") +
    geom_text(data=df.google, mapping=aes(x=date, y=-60, label = evenement), 
              size=3, angle=90, vjust=-0.4, hjust=0, colour = "black") +
    labs(title = "Variation des déplacements par rapport à la normale - Résidentiel",
         subtitle = "Données : Google",
         caption = "Alexandre Blanchet (@alex_blanchet),
         GitHub : https://github.com/alexblanchet/covid") +
    xlab("Mois") +
    ylab("Variation des déplacements en %") +
    theme_light()
ggsave("fig_google_residential.jpg", width = 10, height = 5)
