# Covid
Les fichiers de ce répertoire contiennent le code nécessaire pour reproduire différentes figures sur la mortalité au Québec dans le contexte de la crise du Covid-19. 

Le code du fichier _data_prep.R_ charge les données depuis le site du gouvernement du Québec et les prépare de sorte à les rendre utilisables. Le code pourra être roulé lorsque les données récentes de 2020 seront disponibles (si le lien vers le fichier Excel à la ligne 3 du code ne change pas). Si le lien URL change, alors il faudra le mettre à jour. Les données ont été mises à jour le 6 mai et le mois de février a été ajouté, le lien vers les données n'a alors pas changé et il est donc peu probable que le lien change dans l'avenir. 

Le code du fichier _deces_desc.R_ permet de faire la figure suivant le nombre de décès au Québec en 2020 par rapport aux autres années depuis 2010. 

## Données
Les données sont disponibles à cette page : https://www.stat.gouv.qc.ca/statistiques/population-demographie/naissance-fecondite/i210.htm

Les données pour les mois de mars et avril 2020 n'ont pas été officiellement rendues publiques pour l'instant. Cependant, un article du Journal de Montréal nous informe que le Québec aurait connu 6349 décès en mars et 7660 en avril. Ces chiffres ont été ajoutés pour tenir compte de ces informations.

L'article est disponible par là : https://www.journaldemontreal.com/2020/05/06/le-nombre-de-morts-pourrait-etre-sous-estime-au-quebec


## Projections
Le code projections.R produit des prédictions mensuelles pour l'année 2020 basée sur une simple régression linéaire prenant la forme suivante : 

$$\gamma = \alpha + \beta_{i}MOIS_i + \beta_2(ANNÉE-2010) + \epsilon $$

et où

$\alpha$ correspond à la constante, $\beta_{i}MOIS_i$ une série de variables dichotomiques correspondant au mois $i$, $\beta_2(ANNÉE-2010)$ à l'année concerné - 2010 afin de faire en sorte que l'année 2010 soit l'année 0 et $\epsilon$ est un simple terme d'erreur. 