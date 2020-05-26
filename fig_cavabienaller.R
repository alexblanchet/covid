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

ggplot(pred.2) +
  geom_smooth(aes(y=fit, x = reorder(mois, ordre),
                  group = annee, colour = annee, fill = annee),
              alpha = 0.15) +
    geom_point(aes(y = deces, x = reorder(mois, ordre), 
                 group = annee, colour = annee)) +
  scale_fill_discrete("Années") +
  scale_colour_discrete("Années") +
  xlab("Mois") +
  ylab("Nombre de décès") +
  ggtitle("Figure «Ça va bien aller»") +
  theme_bw() 
ggsave("/Users/alexandreblanchet/Desktop/TEMP/predictions.jpg", width = 10, height = 5)
