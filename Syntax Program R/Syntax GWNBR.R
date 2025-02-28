library(readxl)
library(fields)
library(spam)
library(viridisLite)

library(MASS)
bineg = glm.nb(Y~X1+X2+X3+X4+X5, data=data)
summary(bineg)

library(MASS)
library(car)
pois = glm(Y~X1+X2+X3+X4+X5, family=poisson, data=data)
summary(pois)
vif(pois)

#Heterogenitas Spasial
library(zoo)
library(lmtest)
bptest(bineg)

#Dependensi Spasial
library(ape)
matriks=as.matrix(dist(cbind(data$Long, data$Lat)))
matriks.inv = 1/matriks
diag(matriks.inv)=0
MI=Moran.I(data$Y, matriks.inv)
I=MI$observed
E=MI$expected
SD=MI$sd
Z=(I-E)/SD
cat("\n Moran's I Test (Dependensi Spasial)\n")
cat("ZI = ",Z,"\n")
cat("P-Value = ",MI$p.value)

data <- read_excel("D://02_Work/06_Portfolio/04_GWNBR Kusta/Data Kusta.xlsx")
View(data)

#Jarak Euclidean
u = data[,8]
u = as.matrix(u) 
n = nrow(u)
v = data[,9]
v = as.matrix(v) 
library(fields)
jarak = matrix(nrow=35,ncol=35) 
for(i in 1:n)
{
  for(j in 1:n)
  {
    jarak[i,j] = sqrt((u[i,]-u[j,])**2+(v[i,]-v[j,])**2)
  }
}
write.table(jarak, file="D://02_Work/06_Portfolio/04_GWNBR Kusta/Data/jarak euclidean.csv", sep=",")


#Adaptive Bisquare
library(spgwr) 
bbis=ggwr.sel(Y~X1+X2+X3+X4+X5,data=data,coords=cbind(data$Long, data$Lat),adapt=TRUE,gweight=gwr.bisquare)
banbis=ggwr(Y~X1+X2+X3+X4+X5,data=data,coords=cbind(data$Long,data$Lat),adapt=bbis,gweight=gwr.bisquare)
banbis$bandwidth
bbis

#Adaptive Gaussian
library(spgwr) 
bgaus=ggwr.sel(Y~X1+X2+X3+X4+X5,data=data,coords=cbind(data$Long,data$Lat),adapt=TRUE,gweight=gwr.Gauss) 
bangaus=ggwr(Y~X1+X2+X3+X4+X5,data=data,coords=cbind(data$Long,data$Lat),adapt= bgaus,gweight=gwr.Gauss)
bangaus$bandwidth
bgaus

#Fixed Bisquare
library(spgwr) 
bfixgaus=ggwr.sel(Y~X1+X2+X3+X4+X5,data=data,coords=cbind(data$Long,data$Lat),adapt=FALSE,gweight=gwr.Gauss)
bfixgaus

#Fixed Gaussian
library(spgwr) 
bfixbis=ggwr.sel(Y~X1+X2+X3+X4+X5,data=data,coords=cbind(data$Long,data$Lat),adapt=FALSE,gweight=gwr.bisquare)
bfixbis

#Matriks Pembobot
bobot = matrix(nrow=35,ncol=35) 
for(i in 1:35)
{
  for(j in 1:35)
  {
    bobot[i,j] = (exp(-1/2*(jarak[i,j]/(bfixgaus)**2)))
  }
}
write.table(jarak, file="D://02_Work/06_Portfolio/04_GWNBR Kusta/Data/Matriks Pembobot Fix Gaussian.csv", sep=",")

#Estimasi Parameter Model GWNBR
g=function(X,y,W,phi,b)
{
  betalama=c(phi,b) 
  beta=matrix(0,27,7,byrow=T) 
  beta[1,]=betalama 
  epsilon=0.00000001
  i=2 
  repeat
  {
    phi=betalama[1] 
    bxx=betalama[-1] 
    satu=rep(1,35) 
    X=cbind(satu,data[,3:7])
    Xb=as.matrix(X)%*%as.matrix(bxx) 
    miu=exp(Xb)
    delta1=((log(1+phi*miu)-digamma(y+(1/phi))+digamma(1/phi))/phi^2)+((y- miu)/((1+phi*miu)*phi))
    delta1=as.matrix(delta1) 
    p1=t(satu)%*%W%*%delta1 
    delta2=(y-miu)/(1+phi*miu) 
    delta2=as.matrix(delta2)
    p2=t(X)%*%as.matrix(W)%*%delta2 
    p2=as.matrix(p2)
    gt=rbind(p1,p2)
    delta3=((trigamma(y+(1/phi))-trigamma(1/phi))/phi^4)+((2*digamma(y+(1/phi))-2*digamma(1/phi)- 2*log(1+phi*miu))/phi^3)+((2*miu)/(phi^2*(1+phi*miu)))+(((y+(1+phi))*miu^2)/(1+phi*miu)^2)-(y/phi^2)
    delta3=as.matrix(delta3) 
    p3=t(satu)%*%W%*%delta3 
    p3=as.matrix(p3)
    delta4=miu*(miu-y)/(1+phi*miu)^2 
    delta4=as.matrix(delta4) 
    p4=t(X)%*%W%*%delta4 
    p4=as.matrix(p4)
    h1=rbind(p3,p4) 
    delta5=miu*(phi*y+1)/(1+phi*miu)^2 
    delta5=t(delta5)
    delta5=c(delta5) 
    delta5=as.matrix(diag(delta5))
    p5=t(X)%*%as.matrix(W)%*%delta5%*%as.matrix(X) 
    p5=-1*p5
    p5=as.matrix(p5) 
    h2=rbind(t(p4),p5) 
    H=cbind(h1,h2)
    
    delta6=miu*(phi*y+1)/(1+phi*miu)^2 
    delta6=t(delta6)
    delta6=c(delta6) 
    delta6=as.matrix(diag(delta6))
    p6=t(X)%*%as.matrix(W)%*%delta6%*%as.matrix(X) 
    p6=-1*p6
    p6=as.matrix(p6) 
    h3=rbind(t(p5),p6) 
    
    
    HI=ginv(H)
    betabaru=betalama-(HI%*%gt) 
    beta[i,]=betabaru 
    eror=betabaru-betalama
    if(max(abs(eror))<=epsilon|i>=35) break; 
    betalama=betabaru
    i=i+1
  }
  beta=beta[1:i,] 
  return(list(beta=beta,hessian=H))
}
gwnbr=function(x,y,W,teta)
{
  beta=as.matrix(bineg$coefficients) 
  p=matrix(c(0),nrow(x),ncol(x)+1,byrow=T)
  zhit=matrix(c(0),nrow(x),ncol(x),byrow=T) 
  for(i in 1:35)
  {
    w=as.matrix(diag(W[i,])) 
    hit=g(x,y,w,teta,beta) 
    parameter=hit$beta 
    n=nrow(parameter) 
    p[i,]=parameter[n,]
    write.csv(hit$hessian,file=paste("matriks hessian",i,".csv")) 
    invh=-ginv(as.matrix(hit$hessian))
    for(j in 1:ncol(x))
    {
      zhit[i,j]=p[i,j+1]/invh[j+1,j+1]
    }
  }
  return(list(koefisien=p,zhitung=zhit,parameter=parameter))
}

# Debugging prints
cat("Iteration:", i, "\n")
cat("Dimensions of p[i, ]:", length(p[i, ]), "\n")
cat("Dimensions of parameter[n, ]:", length(parameter[n, ]), "\n")

#Memanggil Program GWNBR
w=bobot 
x=data[,3:7] 
y=data[,2] 
satu=rep(1,35)
x=as.matrix(cbind(satu,x)) 
phi=bineg$theta
est=gwnbr(x,y,w,phi) 
est$zhitung
est$koefisien
write.table(est$zhitung, file="D://02_Work/06_Portfolio/04_GWNBR Kusta/Data/Z.csv", sep=",")
write.table(est$koefisien, file="D://02_Work/06_Portfolio/04_GWNBR Kusta/Data/Koef.csv", sep=",")

#Menghitung Nilai Likelihood Ratio (Uji Serentak) 
datay=as.matrix(data[,2]) 
datax=as.matrix(cbind(satu,data[,3:7])) 
tetagw=as.matrix(est$koefisien[,1]) 
betagw=as.matrix(est$koefisien[,2:7]) 
slr=matrix(0,nrow(data),1)
for(i in 1:nrow(data))
{
  slr[1]=0
  for(r in 0:(datay[i]-1))
  {slr[i]=slr[i]+log(r+(1/tetagw[i]))}
}
muwgw=as.matrix(exp(est$koefisien[,2])) 
muogw=as.matrix(exp(apply(datax*betagw,1,sum))) 
Lwgw=sum(slr-lgamma(datay+1)+datay*log(tetagw*muwgw)-(datay+(1/tetagw))*log(1+tetagw*muwgw))
Logw=sum(slr-lgamma(datay+1)+datay*log(tetagw*muogw)-(datay+(1/tetagw))*log(1+tetagw*muogw))
LR=2*(Logw-Lwgw) 
LR

#Menghitung Nilai Devian Model GWNBR 
mutopi=as.matrix(exp(apply(datax*betagw,1,sum))) 
DGW1=matrix(0,nrow(data),1)
for(i in 1:nrow(data))
{
  DGW1[i]=(datay[i]*log(datay[i]/mutopi[i]))-(datay[i]+(1/tetagw[i]))*log((1+tetagw[i]*datay[i])/(1+tetagw[i]*mutopi[i]))
}
DGW=bobot%*%DGW1 
devian=sum(DGW) 
devian
mutopi

#Pengujian Kesesuaian Model 
df=nrow(data)-(ncol(datax)+1) 
fhit=(bineg$deviance/df)/(devian/df) 
fhit
qf(0.95,29,29)

#Menghitung Nilai AIC Model GWNBR 
ssegw=sum((datay-muogw)^2) 
n=nrow(data)
k=ncol(datax)+2 
a=log(ssegw/n) 
b=2*k 
aicgw=(n*a)+b 
aicgw
