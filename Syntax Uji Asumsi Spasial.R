cat("=================== UJI ASUMSI SPASIAL ====================\n")
library(base)
library(zoo)
library(lmtest)
library(spgwr)
library(ape)
library(readxl)

# Read the Excel file
data <- read_excel("D://02_Work/06_Portfolio/04_GWNBR Kusta/Data Kusta.xlsx")
View(data)

D=dist(cbind(data$Lat,data$Long))
min(D)
max(D)
library("csv")
library("ape")
library("lmtest")
skripsi=function()
{
  data.dist=as.matrix(dist(cbind(data$Long,data$Lat)))
  data.dist.inv=1/data.dist
  diag(data.dist.inv)=0
  data.dist.inv[1:5,1:5]
  Dependensi=Moran.I(data$Y,data.dist.inv)
  cat("=========   Dependensi  ==========\n")
  print(Dependensi)
  
  lm.fit=lm(Y~X1+X2+X3+X4+X5,data)
  anova(lm.fit)
  summary(lm.fit)
  Heterogenitas=bptest(lm.fit)
  cat("========= Heterogenitas ==========\n")
  print(Heterogenitas)
  
}
skripsi()
