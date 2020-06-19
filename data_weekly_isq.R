# Load data
library(readxl)
url <- "https://www.stat.gouv.qc.ca/statistiques/population-demographie/deces-mortalite/DecesSemaine_QC_2010-2020_GrAge.xlsx"
destfile <- "DecesSemaine_QC_2010_2020_GrAge.xlsx"
curl::curl_download(url, destfile)
df <- read_excel(destfile)
head(df)

# Clean les rangées et colones 
df <- df[7:nrow(df), -2]
colnames(df) <- c("Année", "Age", 1:ncol(df))

# df en format longitudinal
library(reshape2)
df.l <- melt(df, id.vars = c("Année", "Age"))
colnames(df.l) <- c("Année", "Age", "Semaine", "Décès")
df.l$Décès <- as.numeric((df.l$Décès))
df.l$Age <- as.factor(df.l$Age)
df.l$Année <- as.numeric(df.l$Année)
# Retirer le total
df.l <- subset(df.l, Age != "Total")
# Créer subset des données avant le confinement (~ semaine 10 en 2020), mais on va prendre avant 2020 par sécurit.
df.l_training <- subset(df.l, df.l$Année != 2020 | as.numeric((df.l$Semaine)) < 10)
#df.l_training <- subset(df.l, df.l$Année != 2020) # uniquement sur année avant 2020

# Modèle linéraire simple
m1 <- lm(Décès ~ scale(Année, scale = FALSE) + Age * Semaine, df.l_training)
summary(m1)

pred <- data.frame(Semaine = rep(as.factor(1:53), times = 3),
                   Année = 2020,
                   Age = c("0-49 ans", "50-69 ans", "70 ans et plus")
                   )

pred <- cbind(pred, predict(m1, pred, interval = "prediction"))

df.l$lwr <- NA
df.l$upr <- NA
df.l$fit <- NA
df.l$source <- "Décès réels"

pred$source <- "Décès prédits"
pred$Décès <- NA

t.fig <- rbind(pred, df.l)
t.fig$Semaine <- as.numeric(t.fig$Semaine)
t.fig$Année <- as.factor(t.fig$Année)

t.fig$couleur[t.fig$Année == 2020 & t.fig$source == "Décès prédits"] <- "a"
t.fig$couleur[t.fig$Année == 2020 & t.fig$source == "Décès réels"] <- "b"
t.fig$couleur[t.fig$Année != 2020] <- "c"

ggplot(t.fig) +
  facet_wrap(~ Age) +
 geom_path(aes(y = Décès, x = Semaine, 
                 group = Année, colour = couleur , fill = couleur)) +
  geom_point(aes(y = Décès, x = Semaine, 
                 group = Année, colour = couleur)) +
  geom_smooth(method = "loess", formula = "y ~ x", 
              aes(y=fit, x = Semaine,
                  group = Année, colour = couleur, fill = couleur),
              alpha = 0.15) +
  scale_color_manual("Années", 
                     labels = c("2020 projections", "2020 réel", "2010 à 2019"),
                     values = couleur) +
  scale_fill_manual("Années", 
                     labels = c("2020 projections", "2020 réel", "2010 à 2019"),
                     values = couleur) +
  labs(title = "Nombre de décès hebdomadaire au Québec de 2010 à 2020, par tranche d'âge",
       subtitle = "Données : Institut de la statistique du Québec",
       caption = "Alexandre Blanchet (@alex_blanchet),
       GitHub : https://github.com/alexblanchet/covid") +
  xlab("Mois") +
  ylab("Nombre de décès") +
  theme_bw() 
ggsave("predictions_hebdo.jpg", width = 10, height = 5)

