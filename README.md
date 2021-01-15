# Covid
Les fichiers de ce répertoire contiennent le code nécessaire pour reproduire différentes figures sur la mortalité au Québec dans le contexte de la crise du Covid-19. Il contient également le code nécessaire pour produire les figures de mobilité à partir des données de Google et Apple. Toute autre analyse produite dans le cadre de ce projet sera ajoutée à ce répertoire. 

Les analyses produites sont faites à temps perdu au gré de mes intérêts. Je suis toujours disposé à recevoir des commentaires et des suggestions __constructives__, mais je ne peux pas consacrer énormément de temps à ces analyses qui demeurent donc forcément un peu préliminaires. Les personnes qui ont des améliorations à suggérer sont invitées à les proposer.

# Utilisation du code

Les fichiers _data_prep.R_ et _data_prep_hebdo.R_ chargent les données sur les décès depuis le site du gouvernement du Québec et les préparent de sorte à les rendre utilisables.  

Le fichier _fig_cavabienaller.R_ permet de faire les prédictions de décès et de faire la figure colorée aux couleurs de l'arc-en-ciel utilisées à des fins d'enseignement et de loufoque. Cette figure est fondée sur le même modèle simple que la précédente et utilise aussi les données mensuelles. 


## Données
Les données sur les décès au Québec sont disponibles le [site du gouvernement du Québec](https://www.stat.gouv.qc.ca/statistiques/population-demographie/naissance-fecondite/i210.htm)

Les données pour les mois de mars et avril 2020 n'ont pas été officiellement rendues publiques pour l'instant. Cependant [un article du Journal de Montréal](https://www.journaldemontreal.com/2020/05/06/le-nombre-de-morts-pourrait-etre-sous-estime-au-quebec) nous informe que le Québec aurait connu 6349 décès en mars et 7660 en avril. Ces chiffres ont été ajoutés pour tenir compte de ces informations. 

L'ISQ a rendu public des [données _hebdomadaires](https://www.stat.gouv.qc.ca/statistiques/population-demographie/deces-mortalite/DecesSemaine_QC_2010-2020_GrAge.xlsx). 

Des données sur la mobilité ont été rendues publiques par [Google](https://www.google.com/covid19/mobility/) et [Apple](https://www.apple.com/covid19/mobility). 

## Projections de décès

### Projections simples avec les données mensuelles
Le fichier _predictions.R_ utilise les données _mensuelles_ pour créer une projection du nombre de décès en 2020 en utilisant un modèle linéaire simple. Le code predictions.R produit des projections mensuelles pour l'année 2020 basée sur une simple régression linéaire prenant la forme suivante : 

<a href="https://www.codecogs.com/eqnedit.php?latex=\gamma&space;=&space;\alpha&space;&plus;&space;\beta_{i}MOIS_{i}&space;&plus;&space;\beta_{2}ANNEE-2010&space;&plus;&space;\epsilon" target="_blank"><img src="https://latex.codecogs.com/svg.latex?\gamma&space;=&space;\alpha&space;&plus;&space;\beta_{i}MOIS_{i}&space;&plus;&space;\beta_{2}ANNEE-2010&space;&plus;&space;\epsilon" title="\gamma = \alpha + \beta_{i}MOIS_{i} + \beta_{2}ANNEE-2010 + \epsilon" /></a>
 
### Projections bayésiennes avec les données hebdomadaires
Le fichier _deces_hebdo_bayes_poisson.R_ estime le nombre de décès attendus en 2020 à parties des données de décès hebdomadaires de 2009 à 2019 et compare ce nombre de décès attendus au nombre observé. Le modèle bayésien utilise une distribution de poisson et utilise la distance par rapport au solstice d'été pour modéliser la variation temporelle du nombre de décès attendus dans l'année. Les commentaires et suggestions sont les bienvenus.

Le modèle prend la forme suivante :

<a href="https://www.codecogs.com/eqnedit.php?latex=deces&space;\sim&space;Poisson(\lambda)&space;\\&space;\lambda&space;=&space;\alpha_{age[i]}&space;&plus;&space;\beta_1_{age[i]}Temps&space;&plus;&space;\beta_2_{age[i]}Delta&space;Solstice&space;&plus;&space;\beta_3_{age[i]}Delta&space;Solstice^2&space;\\&space;\alpha_{age}&space;\sim&space;Normal(\bar{a},&space;\sigma_a)&space;\\&space;\beta_1&space;\sim&space;Normal(1,&space;0)&space;\\&space;\beta_2&space;\sim&space;Normal(1,&space;0)&space;\\&space;\beta_13&space;\sim&space;Normal(1,&space;0)&space;\\&space;\bar{a}&space;\sim&space;LogNormal(5.5,&space;1)&space;\\&space;\sigma_a&space;\sim&space;Exponential(1)" target="_blank"><img src="https://latex.codecogs.com/svg.latex?deces&space;\sim&space;Poisson(\lambda)&space;\\&space;\lambda&space;=&space;\alpha_{age[i]}&space;&plus;&space;\beta_1_{age[i]}Temps&space;&plus;&space;\beta_2_{age[i]}Delta&space;Solstice&space;&plus;&space;\beta_3_{age[i]}Delta&space;Solstice^2&space;\\&space;\alpha_{age}&space;\sim&space;Normal(\bar{a},&space;\sigma_a)&space;\\&space;\beta_1&space;\sim&space;Normal(1,&space;0)&space;\\&space;\beta_2&space;\sim&space;Normal(1,&space;0)&space;\\&space;\beta_13&space;\sim&space;Normal(1,&space;0)&space;\\&space;\bar{a}&space;\sim&space;LogNormal(5.5,&space;1)&space;\\&space;\sigma_a&space;\sim&space;Exponential(1)" title="deces \sim Poisson(\lambda) \\ \lambda = \alpha_{age[i]} + \beta_1_{age[i]}Temps + \beta_2_{age[i]}Delta Solstice + \beta_3_{age[i]}Delta Solstice^2 \\ \alpha_{age} \sim Normal(\bar{a}, \sigma_a) \\ \beta_1 \sim Normal(1, 0) \\ \beta_2 \sim Normal(1, 0) \\ \beta_13 \sim Normal(1, 0) \\ \bar{a} \sim LogNormal(5.5, 1) \\ \sigma_a \sim Exponential(1)" /></a>
