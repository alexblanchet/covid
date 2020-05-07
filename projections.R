source("data_prep.R") 

#------------------------------------- Cleaning
df.l <- df.l[,-5]
colnames(df.l) <- c("mois", "annee", "deces", "ordre")
df.l$mois <- factor(df.l$mois)
df.l$annee <- as.numeric(df.l$annee) + 2009

# Ajout manuel de mars et avril (source : Journal de Montréal)
df.l$deces[df.l$annee == 2020 & df.l$mois == "Mars"] <- 6349
df.l$deces[df.l$annee == 2020 & df.l$mois == "Avril"] <- 7660

#------------------------------------- Modèle
# Créer le sample d'estimation avant la covid allant de janvier 2010 à février 2020
df.l_training <- df.l[1:122,] 

# Un simple modèle linéaire
m <- lm(deces ~ mois + scale(annee, scale = FALSE), df.l_training)
summary(m)

# Extraire les prédictions pour l'année 2020
pred <- data.frame(mois =  c("Mars", "Avril", "Mai", "Juin", "Juillet",
                             "Août", "Septembre", "Octobre", "Novembre", "Décembre"),
                   annee = 2020
                   )

pred <- cbind(pred, predict(m, pred, interval = "prediction"))

#------------------------------------- Data prep
pred$annee <- 2020
pred$ordre <- c(3:12)
df.l$lwr <- 0
df.l$upr <- 0
colnames(pred) <- c("mois", "annee", "deces_pred", "lwr", "upr", "ordre")
colnames(df.l) <- c("mois", "annee", "deces", "ordre", "lwr", "upr")
pred$deces <- NA
df.l$deces_pred <- NA

df.l <- subset(df.l, !is.na(deces))
df.l <- rbind(df.l, pred)

df.l$annee <- factor(df.l$annee)
df.l$source <- ifelse(df.l$lwr == 0, "Réel", "Projection")
df.l$couleur[df.l$annee == 2020 & df.l$source == "Projection"] <- "a"
df.l$couleur[df.l$annee == 2020 & df.l$source == "Réel"] <- "b"
df.l$couleur[df.l$annee != 2020] <- "c"
  
#------------------------------------- Figure
couleur <- c("red", "red4", "grey")

ggplot(df.l) +
  geom_path(aes(y = deces, x = reorder(mois, ordre), 
                 group = annee, colour = couleur, fill = couleur)) +
  geom_point(aes(y = deces, x = reorder(mois, ordre), 
                 group = annee, colour = couleur)) +
  geom_smooth(method = "loess", formula = "y ~ x", 
              aes(y=deces_pred, x = reorder(mois, ordre),
                  group = annee, colour = couleur, fill = couleur),
              alpha = 0.15) +
  scale_color_manual("Années", 
                     labels = c("2020 projections", "2020 réel", "2010 à 2019"),
                     values = couleur) +
  scale_fill_manual("Années", 
                     labels = c("2020 projections", "2020 réel", "2010 à 2019"),
                     values = couleur) +  
  labs(title = "Nombre de décès mensuels au Québec de 2010 à 2020",
       subtitle = "Données : Gouvernement du Québec",
       caption = "Alexandre Blanchet (@alex_blanchet),
       GitHub : https://github.com/alexblanchet/covid") +
  xlab("Mois") +
  ylab("Nombre de décès") +
  theme_bw() 
ggsave("predictions.jpg", width = 10, height = 5)