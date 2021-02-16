library(readr)
library(lubridate)
library(ggplot2)

d <- read_csv("https://raw.githubusercontent.com/alexblanchet/covid-policy-tracker/master/data/OxCGRT_latest.csv", 
    col_types = cols(RegionName = col_character(), 
        RegionCode = col_character()))

d$group <- as.factor(ifelse(is.na(d$RegionName), d$CountryName, d$RegionName))
d$Date <- ymd(d$Date)
d <- subset(d, group %in% c("Quebec", "Ontario", "Australia", "New Zealand"))

ggplot(d, aes(y = StringencyIndex, x = Date, colour = group)) +
  geom_path() +
  scale_color_manual("Endroit", 
                     values =  c("#A8DADC", "Orange", "Red", "Blue" ),
                     labels = c("Australie", "Nouvelle Zélande", "Ontario", "Québec")) +
  labs(y = "Indice de sévérité des mesures", 
       x = "Date",
       title = "Évolution de la sévérité des mesures contre la Covid : Québec, Ontario, Nouv.-Zélande & Australie",
       subtitle = "Données : Oxford COVID-19 Government Response Tracker",
       caption = "Alexandre Blanchet (@alex_blanchet),
       GitHub : https://github.com/alexblanchet/covid") +
  theme_minimal()
ggsave("stringencyindex.jpg", width = 10, height = 5)
