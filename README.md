# Geographically Weighted Negative Binomial Regression Modeling on Affecting Leprosy Cases in Central Java Province in 2023
This project performs spatial assumption tests on a **Geographically Weighted Negative Binomial Regression (GWNBR)** model using R. It analyzes spatial dependencies, heteroscedasticity, and spatial heterogeneity of the data, applying various statistical models to the dataset related to leprosy research in Central Java Province.

## Table of Contents

- [File Structures](#file-structures)
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Features](#features)
- [Libraries Used](#libraries-used)
- [Installation](#installation)
- [Model Outputs](#model-outputs)
- [Conclusion](#conclusion)
- [Recommendations](#recommendations)

## File Structures
```
├── data
|   └── Data Kusta.xlsx
├── Map
|   ├── 01_Peta Kasus Kusta (Y).png
|   ├── 02_Peta Kepadatan Penduduk (X1).png
|   ├── 03_Peta Rumah Sehat (X2).png
|   ├── 04_Peta Air Minum Aman (X3).png
|   ├── 05_Peta Tempat dan Fasilitas Umum (X4).png
|   └── 06_Peta Sanitasi Layak (X5).png
├── Output
│   ├── Koef.csv
│   ├── Matriks Pembobot Fix Gaussian fixx.csv
│   ├── Output dari Syntax
│   ├── Z.csv
|   └── jarak euclidean fix.csv
├── README.md
├── Syntax GWNBR.R
├── Syntax Statistika Deskriptif.R
└── Syntax Uji Asumsi Spasial.R
```

## Project Overview
This project utilizes **Geographically Weighted Negative Binomial Regression (GWNBR)** to analyze factors influencing leprosy cases in Central Java Province, Indonesia. Leprosy, a complex infectious disease, is influenced by various spatial factors such as population density, healthy housing, access to safe drinking water, public facility monitoring, and proper sanitation. Traditional Poisson regression is not suitable for overdispersed count data, which is often the case with leprosy incidence. **GWNBR** is applied to account for overdispersion and spatial heterogeneity, allowing for more accurate modeling of the disease's distribution across different regions.

The goal is to provide a spatially aware analysis that identifies key factors impacting leprosy cases and offers insights for better prevention and control strategies. This research builds on previous studies but introduces a spatial approach, offering a more comprehensive understanding of disease distribution patterns in Central Java Province.

## Data Sources
_Leprosy cases in Central Java Province for the year 2023. Source: [Profil Kesehatan Jawa Tengah 2023](https://dinkesjatengprov.go.id/v2018/dokumen/1Profil_Kesehatan_2023/files/downloads/Profil%20Kesehatan%20Jawa%20Tengah%202023.pdf)_
- Y: Leprosy Cases
  - Definition: This dependent variable represents the number of registered leprosy cases, both old and new, in Central Java Province. The data is used to analyze the factors influencing the number of leprosy cases based on independent variables.
  - Data Source: Secondary data from the Profil Kesehatan Jawa Tengah 2023 publication.
  - Data Scale: Ratio (count of cases).
- X1: Population Density
  - Definition: This independent variable measures the number of people per square kilometer in Central Java Province, categorized by district/city. Population density is often used as an indicator to analyze the spread of diseases in more densely populated areas.
  - Data Source: Secondary data from the Profil Kesehatan Jawa Tengah 2023 publication.
  - Data Scale: Ratio (people per square kilometer).
- X2: Healthy Housing
  - Definition: This variable measures the percentage of households or Family Cards (Kartu Keluarga, KK) with access to healthy housing in Central Java Province, by district/city. Healthy housing conditions can influence the spread of diseases like leprosy.
  - Data Source: Secondary data from the Profil Kesehatan Jawa Tengah 2023 publication.
  - Data Scale: Ratio (percentage of households with healthy housing).
- X3: Safe Drinking Water
  - Definition: This variable measures the availability of safe drinking water facilities (monitored and/or safe) in Central Java Province, by district/city. Access to safe drinking water is a crucial factor in preventing disease, including leprosy.
  - Data Source: Secondary data from the Profil Kesehatan Jawa Tengah 2023 publication.
  - Data Scale: Ratio (percentage of access to safe drinking water).
- X4: Safe Public Places and Facilities (TFU)
  - Definition: This variable represents the number of public places and facilities (TFU) in Central Java Province that have been properly monitored and meet safety and hygiene standards, categorized by district/city. Proper monitoring of public places is essential to reduce the risk of disease transmission.
  - Data Source: Secondary data from the Profil Kesehatan Jawa Tengah 2023 publication.
  - Data Scale: Ratio (number of public places and facilities under safety inspection).
- X5: Adequate Sanitation
  - Definition: This variable measures the percentage of households or Family Cards (Kartu Keluarga, KK) with access to adequate sanitation facilities in Central Java Province, by district/city. Proper sanitation is critical in preventing the spread of diseases like leprosy.
  - Data Source: Secondary data from the Profil Kesehatan Jawa Tengah 2023 publication.
  - Data Scale: Ratio (percentage of households with access to adequate sanitation).

## Features
- Spatial dependency testing using Moran's I
- Heterogeneity testing using Breusch-Pagan test
- Fitting Negative Binomial and Poisson regression models
- Adaptive and Fixed Bisquare and Gaussian GWR models
- Model diagnostics including Likelihood Ratio, Deviance, and AIC calculation

## Libraries Used
- `lmtest`: For heteroscedasticity tests and regression diagnostics.
- `spgwr`: For Generalized Weighted Regression models.
- `ape`: For spatial data processing and Moran's I test.
- `MASS`: For fitting Negative Binomial and Poisson regression models.
- `readxl`: To read Excel data.
- `zoo`, `car`: For additional data manipulation and statistical analysis.

## Installation
Ensure you have R installed and the required libraries by running the following commands in your R console:
R
```
install.packages("base")
install.packages("zoo")
install.packages("lmtest")
install.packages("spgwr")
install.packages("ape")
install.packages("readxl")
install.packages("csv")
install.packages("fields")
install.packages("spam")
install.packages("viridisLite")
install.packages("MASS")
install.packages("car")

```

## Model Outputs
The script outputs the results of the Moran's I test, heteroscedasticity tests, and regression model summaries. It generates CSV files with computed distances, spatial weight matrices, and model coefficients:

- jarak euclidean.csv: Euclidean distance matrix.
- Matriks Pembobot Fix Gaussian.csv: Fixed Gaussian spatial weight matrix.
- Z.csv: Moran's I Z-values.
- Koef.csv: Model coefficients.
  
## Conclusion
Based on the analysis outlined in this research, the following conclusions can be drawn:
- The distribution of leprosy cases in Central Java Province shows significant variation, with the standard deviation of 65.9 indicating that case numbers can vary widely from the average. The range of cases (1-281) suggests areas with both very low and very high case counts, indicating significant disparities in the prevalence of leprosy across the province.
- The Geographically Weighted Negative Binomial Regression (GWNBR) model with Adaptive Gaussian kernel function proved to be the optimal model, as it had the lowest Cross Validation (CV) value of 43,877.24. GWNBR also performed better in model diagnostics, with an Akaike’s Information Criterion (AIC) of 244.2, which is lower compared to Poisson and Negative Binomial regressions.
- All five independent variables showed significant effects across all locations, with improvements in access to healthy housing, safe drinking water facilities, and public facility monitoring significantly reducing leprosy cases. However, the variables for population density and proper sanitation showed contradictory results.

## Recommendations
Based on the findings and conclusions of this study, the following recommendations are suggested to improve leprosy prevention and control efforts in Central Java Province:
- Future research should include additional variables and explore alternative spatial models, such as Geographically Weighted Regression (GWR), to achieve more accurate and consistent results.
- Collaboration between the government and academic institutions in biostatistics is essential to strengthen data analysis and develop more accurate predictive models. This collaboration could result in better data-driven policies and more effective interventions.
- The synergy between the government and academia will significantly contribute to leprosy prevention efforts, improving public health outcomes.
