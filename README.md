# Covid
Les fichiers de ce répertoire contiennent le code nécessaire pour reproduire différentes figures sur la mortalité au Québec dans le contexte de la crise du Covid-19. Il contient également le code nécessaire pour produire les figures de mobilité à partir des données de Google et Apple. Toute autre analyse produite dans le cadre de ce projet sera ajoutée à ce répertoire. 

Les analyses produites sont faites à temps perdu au gré de mes intérêts. Je suis toujours disposé à recevoir des commentaires et des suggestions __constructives__, mais je ne peux pas consacrer énormément de temps à ces analyses qui demeurent donc forcément un peu préliminaires. Les personnes qui ont des améliorations à suggérer sont invitées à les proposer.

# Utilisation du code

Le code du fichier _data_prep.R_ charge les données sur les décès depuis le site du gouvernement du Québec et les prépare de sorte à les rendre utilisables. Le code pourra être roulé lorsque les données récentes de 2020 seront disponibles (si le lien vers le fichier Excel à la ligne 3 du code ne change pas). Le lien URL vers les données semble fixe et il est donc peu probable que le lien change dans l'avenir. 

Le code du fichier _deces_desc.R_ permet de faire la figure suivant le nombre de décès au Québec en 2020 par rapport aux autres années depuis 2010. 

Le fichier _figures_google_data.R_ permet de faire les figures sur l'évolution de la mobilité comparant l'Ontario et le Québec en utilisant les données de Google. Le fichier _figures_apple_data.R_ fait la même chose en comparant Montréal à l'Ontario avec les données d'Apple. Malheureusement, Apple s'amuse à changer constemment le lien vers leurs données et simplement ajuster la date à la fin du lien ne fonctionne pas parce que d'autres éléments du lien changent. Il faut donc systématiquement mettre à jour le lien URL maneuellement en allant à https://www.apple.com/covid19/mobility. Il n'y a pas ce problème pour les données de Google qui sont systématiquement à jour lorsque le code est roulé.

## Données
Les données sur les décès au Québec sont disponibles le [site du gouvernement du Québec](https://www.stat.gouv.qc.ca/statistiques/population-demographie/naissance-fecondite/i210.htm)

Les données pour les mois de mars et avril 2020 n'ont pas été officiellement rendues publiques pour l'instant. Cependant, [un article du Journal de Montréal](https://www.journaldemontreal.com/2020/05/06/le-nombre-de-morts-pourrait-etre-sous-estime-au-quebec) nous informe que le Québec aurait connu 6349 décès en mars et 7660 en avril. Ces chiffres ont été ajoutés pour tenir compte de ces informations. 

Les données sur la mobilité ont été rendues publiques par [Google](https://www.google.com/covid19/mobility/) et [Apple](https://www.apple.com/covid19/mobility). 

## Projections de décès
Le code predictions.R produit des projections mensuelles pour l'année 2020 basée sur une simple régression linéaire prenant la forme suivante : 

$$\gamma = \alpha + \beta_{i}MOIS_{i} + \beta_{2}(ANNÉE-2010) + \epsilon $$

et où

$\alpha$ correspond à la constante, $\beta_{i}MOIS_{i}$ une série de variables dichotomiques correspondant au mois $i$, $\beta_2(ANNÉE-2010)$ à l'année concernée - 2010 afin de faire en sorte que l'année 2010 soit l'année 0, et $\epsilon$ est un simple terme d'erreur. 

