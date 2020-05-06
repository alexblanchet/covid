# Covid
Les fichiers de ce répertoire contiennent le code nécessaire pour reproduire différentes figures sur la mortalité au Québec dans le contaxte de la crise du Covid-19. 

Le code du fichier _data_pred.R_ charge les données depuis le site du gouvernement du Québec et les préparer de sorte à les rendre utilisables. Le code pourra être roulé lorsque les données récentes de 2020 seront disponible (si le lien vers le fichier excel à la ligne 3 du code ne change pas). Si le lien url change, alors il faudra le mettre à jour. Les données ont été mises à jour le 6 mai et le mois de février a été ajouté, le lien vers les données n'a alors pas changé et il est donc peu probable que le lien change dans l'avenir. 

Le code du fichier _deces_desc.R_ permet de faire la figure suivant le nombre de décès au Québec en 2020 par rapport aux autres années depuis 2010. 

## Données
Les données sont disponibles à cette page : https://www.stat.gouv.qc.ca/statistiques/population-demographie/naissance-fecondite/i210.htm