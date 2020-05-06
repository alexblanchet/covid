# Load data
library(readxl)
url <- "https://www.stat.gouv.qc.ca/statistiques/population-demographie/naissance-fecondite/i210.xlsx"
destfile <- "i210.xlsx"
curl::curl_download(url, destfile)
i210 <- read_excel(destfile)

# Data prep
df <- i210[23:34,]
df[, 12][df[, 12] == "..."] <- NA
df$...2 <- as.numeric(df$...2)
df$...12 <- as.numeric(df$...12)
colnames(df) <- c("mois", 2010:2020)

library(reshape2)
df.l <- melt(df, id.vars = "mois")
df.l$ordre <- rep(1:12, times = 11)
df.l$couleur <- ifelse(df.l$variable == 2020, "a", "b")