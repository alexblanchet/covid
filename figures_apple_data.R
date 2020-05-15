#----------------------------- Load data
# Le lien URL devra être mis à jour en fonction de la date du jour, malheureusement... 
       
url <- "https://covid19-static.cdn-apple.com/covid19-mobility-data/2008HotfixDev26/v2/en-us/applemobilitytrends-2020-05-13.csv"
df <- read.csv(url)


#----------------------------- Cleaning
# Subset Montréal et Canada
df <- subset(df, region == "Montreal" | region == "Toronto")

# Enlever le X dans le nom des variables de dates
names(df) <- sub("X", "", names(df))

library(reshape2)
df.long <- melt(df, id.vars = c("geo_type", "region", 
                                "transportation_type", "alternative_name") 
               )

#df.long$variable <- ymd(df.long$variable)
df.long$variable <- as.Date(df.long$variable, "%Y.%m.%d")
names(df.long)[5] <- "date"

df.long$transportation_type <- factor(df.long$transportation_type,
                                      labels = c("Voiture", "Transports en commun", "Marche"))

df.long$evenement[df.long$date == "2020-03-02"] <- "Début de la semaine de relâche au Québec"
df.long$evenement[df.long$date == "2020-03-06"] <- "Fin de la semaine de relâche au Québec"
df.long$evenement[df.long$date == "2020-03-13"] <- "État d'urgence au Québec"
df.long$evenement[df.long$date == "2020-03-17"] <- "État d'urgence en Ontario"
df.long$evenement[df.long$date == "2020-04-10"] <- "Legault : Ouverture possible des écoles avant le 4 mai"
df.long$evenement[df.long$date == "2020-04-28"] <- "Québec annonce le plan de déconfinement"

marqueurs <- c(c("2020-03-02", "2020-03-06", "2020-03-13", 
                 "2020-03-17", "2020-04-10", "2020-04-28"))


#----------------------------- Figure
library(ggplot2)
ggplot(df.long, aes(y = value, x = date, colour = region, fill = region)) +
    facet_grid(~ transportation_type) +
    geom_smooth(method = "loess", formula = "y ~ x") +
    geom_point(alpha = 0.5) +
    geom_hline(yintercept=100, color= "grey", size=1, linetype = "dashed") +
    geom_vline(xintercept = as.numeric(as.Date(marqueurs)), 
               linetype = 4, colour = "black") +
    geom_text(data=df.long, mapping=aes(x=date, y=0, label = evenement), 
              size=3, angle=90, vjust=-0.4, hjust=0, colour = "black") +
    labs(title = "Variation des déplacements par rapport à la normale",
         subtitle = "Données : Apple",
         caption = "Alexandre Blanchet (@alex_blanchet),
         GitHub : https://github.com/alexblanchet/covid") +
    xlab("Mois") +
    ylab("Variation des déplacements en %") +
    theme_light()
ggsave("fig_apple_data.jpg", width = 10, height = 5)

