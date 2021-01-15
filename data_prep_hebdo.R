# Load data
library(readxl)
#url <- "https://www.stat.gouv.qc.ca/statistiques/population-demographie/deces-mortalite/DecesSemaine_QC_2010-2020_GrAge.xlsx" # vieux
url <- "https://statistique.quebec.ca/docs-ken/multimedia/DecesSemaine_QC_2010-2020_GrAge.xlsx"
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
df.l$Semaine <- as.numeric(df.l$Semaine)
df.l$Année <- as.numeric(df.l$Année)

rm(destfile, url)