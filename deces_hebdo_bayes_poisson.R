source("data_prep_hebdo.R")
library(rethinking)
# Conserver uniquement le total
df.l <- subset(df.l, Age != "Total") # par age
df.l <- subset(df.l, !is.na(Décès)) # Élimine les NA dans les semaines 53 non existantes
df.l$temps <- as.numeric(paste(df.l$Année, sprintf("%02d", df.l$Semaine), sep = ""))
df.l$d_solstice <- sqrt((26 - df.l$Semaine)^2) # Distance absolue du solstice d'été


d <- data.frame(
  age = droplevels(df.l$Age),
  annee =  df.l$Année,
  semaine = df.l$Semaine,
  deces = df.l$Décès,
  temps = as.numeric(factor(rank(df.l$temps))),
  d_solstice = df.l$d_solstice
  )

# Données sans 2020
d2 <- subset(d, d$annee != 2020)

#--------------- Modèle
da.pois <- list(
  age = as.integer(d2$age),
  temps = d2$temps,
  d_solstice = d2$d_solstice,
  d_solstice_2 = d2$d_solstice^2,
  deces = d2$deces
)


#curve(dlnorm(x, 5.5, 1), from = 0, to = 2000, n = 1000) # Test prior pour alpha

ma.poisson <- ulam(
  alist(
   deces ~ dpois(lambda),
    lambda <- a[age] + b1[age]*temps + b2[age]*d_solstice + b3[age]*d_solstice_2,
    a[age] ~ dnorm(mean_a, sigma_a),
    b1[age] ~ dnorm(0, 1),  
    b2[age] ~ dnorm(0, 1),
    b3[age] ~ dnorm(0, 1),
   mean_a ~ dlnorm(5.5, 1), # Réfléchir aux priors 
   sigma_a ~ dexp(1)
  ), data = da.pois, chains = 2, cores = 2, iter = 2e3)
precis(ma.poisson, depth = 2)

#plot
seq.temps <- c((max(da.pois$temps)+1):(max(da.pois$temps)+52))
seq.age <- c(1:3)
seq.d_solstice <- c(c(25:0, 0:25))
seq.d_solstice_2 <- seq.d_solstice^2
seq.semaine <- c(1:52)

pred_dat <- list(temps = rep(seq.temps, times = 3),
                 age = rep(seq.age, each = length(seq.semaine)),
                 d_solstice = rep(seq.d_solstice, times = 3*2),
                 d_solstice_2 = rep(seq.d_solstice_2, times = 3*2)
                 )

mu <- link(ma.poisson, data = pred_dat)
mu.mean <- apply(mu, 2, mean)
mu.PI <- apply(mu, 2, PI, prob = 0.9)
sim.deces <- sim(ma.poisson, data = pred_dat, n = 4e4)
deces.PI <- apply(sim.deces, 2, PI, prob = 0.9)
ycolor <- ifelse(d$annee == 2020, 1, 0)
couleur <- c("#2f4858","#33658a","#86bbd8","#f6ae2d","#f26419")

# Plot
jpeg("fig_deces_age_hebdo_solstice.jpg", width = 1200, height = 675)
plot(deces ~ semaine, d,
     col = c(col.alpha("grey", 0.5), 
             col.alpha("red", 1))[as.factor(ycolor)],
#     col = (couleur[3:5])[age],
     pch = c(1, 16)[as.factor(ycolor)],
     ylab = "Nombre de décès", ylim=c(0, 2000),
     xlab = "Semaine",
    main = "Nombre de décès hebdomadaire depuis 2010 par tranche d'âge")
# Lignes 0-49 ans
lines(seq.semaine, mu.mean[1:52], col = couleur[3])
shade(mu.PI[, 1:52], seq.semaine, col=col.alpha(couleur[3], 0.5))
shade(deces.PI[, 1:52], seq.semaine, col=col.alpha(couleur[3], 0.25))
# Lignes 50-69 ans
lines(seq.semaine, mu.mean[53:104], col = couleur[4])
shade(mu.PI[, 53:104], seq.semaine, col=col.alpha(couleur[4], 0.5))
shade(deces.PI[, 53:104], seq.semaine, col=col.alpha(couleur[4], 0.25))
# Lignes 70 et +
lines(seq.semaine, mu.mean[105:156], col = couleur[5])
shade(mu.PI[, 105:156], seq.semaine, col=col.alpha(couleur[5], 0.5))
shade(deces.PI[, 105:156], seq.semaine, col=col.alpha(couleur[5], 0.25))
# Légende
legend(0.5, 2000, legend=c("Prédictions 0-49 ans", "Prédictions 50-69 ans", "Prédictions 70 ans et +"),
       col= c(couleur[3:5]), lty=1, lwd = 8, cex=0.95, bty='n')
legend(40, 2000, legend=c("Données de 2010 à 2019", "Données de 2020"),
       col=c("grey", "red"), pch=c(1, 16), cex=0.95, 
       bty='n')
mtext("Données : Gouvernement du Québec. Les simulations excluent les données de 2020", side=3)
mtext("Alexandre Blanchet (Twitter : @alex_blanchet),
       GitHub : https://github.com/alexblanchet/covid", 
      side=1, line=3.5, at=55, adj = 1)
legend(18, 1900, legend=c("90 % des simulations dans l'interval"),
       col=col.alpha(couleur[5], 0.5), lty=1, lwd = 25, cex=0.95, bty='n')
dev.off()
