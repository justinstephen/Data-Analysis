library('xlsx')
library('plyr')
library('gridExtra')

lc_male <- read.xlsx("indicator lung male mortality.xlsx", sheetName = "Data")
lc_female <- read.xlsx("indicator lung female mortality.xlsx", sheetName = "Data")
cd_percapita <- read.xlsx("indicator CDIAC carbon_dioxide_emissions_per_capita.xlsx", sheetName = "Data")

countries <- lc_male$Lung.Male.Mortality
deaths <- lc_male[,"X2002"] + lc_female[,"X2002"]

lung_cancer <- data.frame("Country" = countries, "Deaths" = deaths)
cd_percapita <- cd_percapita[,c("CO2.per.capita","X2002")]
names(cd_percapita) <- c("Country", "CO2")

df <- na.omit(merge(lung_cancer, cd_percapita, by = "Country"))

ggplot(data = df, aes(x = Deaths, y = CO2)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'lm') +
  geom_text(aes(label=ifelse(Deaths>100,as.character(Country),'')),hjust=1.1,just=0) +
  geom_text(aes(label=ifelse(CO2>40,as.character(Country),'')),hjust=1.1,just=0) +
  xlab("Deaths per 1000 people") +
  ylab("CO2 Emissions (Tonnes Per Person)")

lci_male <- read.xlsx("indicator lung male incidence.xlsx", sheetName = "Data")
lci_female <- read.xlsx("indicator lung female incidence.xlsx", sheetName = "Data")

lci_countries <- lci_male$Lung.Male.Incidence
incidents <- lci_male[,"X2002"] + lci_female[,"X2002"]
lung_cancer_incidents <- data.frame("Country" = lci_countries, "Incidents" = incidents)

df <- na.omit(merge(df, lung_cancer_incidents, by = "Country"))

p1 <- ggplot(data = df, aes(x = Deaths, y = CO2)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'lm') +
  xlab("Deaths per 1000 people") +
  ylab("CO2 Emissions (Tonnes Per Person)")
p2 <- ggplot(data = df, aes(x = Incidents, y = CO2)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'lm') +
  xlab("Incidents per 1000 people") +
  ylab("CO2 Emissions (Tonnes Per Person)")

grid.arrange(p1, p2, ncol=2)
