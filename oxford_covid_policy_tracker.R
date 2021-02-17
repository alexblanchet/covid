library(readr)
library(lubridate)
library(ggplot2)

d <- read_csv("https://raw.githubusercontent.com/alexblanchet/covid-policy-tracker/master/data/OxCGRT_latest.csv", 
    col_types = cols(RegionName = col_character(), 
        RegionCode = col_character()))

d$group <- as.factor(ifelse(is.na(d$RegionName), d$CountryName, d$RegionName))
d$Date <- ymd(d$Date)
d <- subset(d, group %in% c("Quebec", "Ontario", "Australia", "New Zealand"))
d$group <- droplevels(d$group)
d <- subset(d, Date < Sys.Date()-2) # drop les 2 derniers jours pour lesquels les données semblent incomplètes

# Nouveaux cas par 100k 
d <- d[order(d$group, d$Date),]
d$ConfirmedCases[is.na(d$ConfirmedCases)] <- 0 # Assume qu'un NA = 0 cas. 
f.lag <- function(x)c(0, x[1:(length(x)-1)])
d$lag_ncas <- unlist(tapply(d$ConfirmedCases, d$group, f.lag))
d$daily_new_cases <- d$ConfirmedCases - d$lag_ncas
f.ma <- function(x, n = 7){filter(x, rep(1 / n, n), sides = 2)}
d$mov.avg <- unlist(tapply(d$daily_new_cases, d$group, f.ma))

d$per100k <- NA
d$per100k[d$group == "Quebec"] <- 85e5 / 1e5
d$per100k[d$group == "Ontario"] <- 146e5  / 1e5
d$per100k[d$group == "Australia"] <- 25e6  / 1e5
d$per100k[d$group == "New Zealand"] <- 49e5  / 1e5
d$mov.avg_100k <- d$mov.avg / d$per100k

d <- d[c(1, 2, 6, 38, 40, 50:55)]

# Plot
ggplot(d) +
  geom_path(aes(y = StringencyIndex, x = Date, colour = group), linetype = "longdash") +
  geom_line(aes(y = mov.avg_100k, x = Date, colour = group), alpha = 0.5) +
  scale_color_manual("Endroit", 
                     values =  c("#2b3770", "Orange", "Red", "Blue"),
                     labels = c("Australie", "Nouvelle Zélande", "Ontario", "Québec")) +
  scale_y_continuous(name = "Indice de sévérité des mesures (lignes pointillées)",
                     sec.axis = sec_axis( trans=~.*1, name="Nouveaux cas par 100k habitants (lignes pleines)")) +
  labs(x = "Date",
       title = "Évolution de la sévérité des mesures contre la Covid : Québec, Ontario, Nouv.-Zélande & Australie",
       subtitle = "Données : Oxford COVID-19 Government Response Tracker
       Lignes pointillées : Sévérité des mesures
       Lignes pleines : Moyenne roulante sur 7 jours des nouveaux cas de Covid par 100k habitants",
       caption = "Alexandre Blanchet (@alex_blanchet),
       GitHub : https://github.com/alexblanchet/covid") +
  theme_minimal() +
  theme(axis.title.y = element_text(color = "black"), 
        axis.title.y.right = element_text(color = "grey")) 
ggsave("stringencyindex.jpg", width = 10, height = 5)

# Zoom in... 
p.z <- ggplot(subset(d, Date > "2020-08-01" & Date < "2020-10-15")) +
  geom_path(aes(y = StringencyIndex, x = Date, colour = group), linetype = "longdash") +
  geom_line(aes(y = mov.avg_100k, x = Date, colour = group), alpha = 0.5) +
  scale_color_manual("Endroit", 
                     values =  c("#2b3770", "Orange", "Red", "Blue"),
                     labels = c("Australie", "Nouvelle Zélande", "Ontario", "Québec")) +
  scale_y_continuous(name = "Indice de sévérité des mesures (lignes pointillées)",
                     sec.axis = sec_axis( trans=~.*1, name="Nouveaux cas par 100k habitants (lignes pleines)")) +
  labs(x = "Date",
       title = "Évolution de la sévérité des mesures contre la Covid : Québec, Ontario, Nouv.-Zélande & Australie",
       subtitle = "Données : Oxford COVID-19 Government Response Tracker
       Lignes pointillées : Sévérité des mesures
       Lignes pleines : Moyenne roulante sur 7 jours des nouveaux cas de Covid par 100k habitants",
       caption = "Alexandre Blanchet (@alex_blanchet),
       GitHub : https://github.com/alexblanchet/covid") +
  theme_minimal() +
  theme(axis.title.y = element_text(color = "black"), 
        axis.title.y.right = element_text(color = "grey")) 
p.z
ggsave("stringencyindex_zoom.jpg", width = 10, height = 5)

p.z + ylim(0, 4)
ggsave("stringencyindex_zoom2.jpg", width = 10, height = 5)
