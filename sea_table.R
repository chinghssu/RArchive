library(seasonal)
library(readxl)
library(ggplot2)
library(data.table)
### Chinese New Year

### data(seasonal) providing sample data to try codings.
holiday<-data(holiday)  # dates of Chinese New Year, Indian Diwali and Easter
path <- "C://gcloud5/Work/sea/sea_R.xlsx"
cny.ts <- genhol(cny, start = -1, end = 6, center = "calendar")
# de facto holiday length: http://en.wikipedia.org/wiki/Chinese_New_Year


dataT <- read_xlsx(path, sheet = "emp", col_types = "numeric")
k1 <- data.frame(dataT)
i <- 1
while(i <20) {
  dataTi <- ts(dataT[[paste0("a",i)]],start = c(2005,1), end = c(2020,6),frequency = 12)
  mTi<- seas(dataTi, xreg = cny.ts, regression.usertype = "holiday", x11 = "",regression.aictest = c("td"))
  mmTi <- data.frame(mTi)
  if(nrow(mmTi)==186){
    k1[[paste0("a",i)]]<- mmTi$seasonaladj
  }else{
    z1<-data.frame("seasonaladj" = matrix(NA, nrow = 48, ncol = 1))
    ins1<-data.frame("seasonaladj" = matrix(mmTi$seasonaladj, nrow = 138, ncol = 1))
    try1<-rbind.data.frame(z1,ins1)
    k1[[paste0("a",i)]]<- try1
  }
  i=i+1
}
#####################################################################
dataW <- read_xlsx(path, sheet = "wage", col_types = "numeric")
k2 <- data.frame(dataW)
k2$a6 <-NULL
i <- 1
while(i <20) {
  dataWi <- ts(dataW[[paste0("a",i)]],start = c(2005,1), end = c(2020,6),frequency = 12)
  mWi1<- seas(dataWi, regression.usertype = "holiday", x11 = "",regression.aictest = c("td")) #if xreg = cny.ts, there is a regression singularity problem
  #mWi2<- seas(dataWi, xreg = cny.ts)
  mmWi <- data.frame(mWi1)
  if(nrow(mmWi)==186){
    k2[[paste0("a",i)]]<- mmWi$seasonaladj
  }else{
    z2<-data.frame("seasonaladj" = matrix(NA, nrow = 48, ncol = 1))
    ins2<-data.frame("seasonaladj" = matrix(mmWi$seasonaladj, nrow = 138, ncol = 1))
    try2<-rbind.data.frame(z2,ins2)
    k2[[paste0("a",i)]]<- try2
  }
  i=i+1
}
dataWi <- ts(dataW$a6,start = c(2005,1), end = c(2020,6),frequency = 12)
mWi1<- seas(dataWi, regression.usertype = "holiday", x11 = "",regression.aictest = c("td"))
mmWi <- data.frame(mWi1)
#####################################################################
dataH <- read_xlsx(path, sheet = "hour", col_types = "numeric")
k3 <- data.frame(dataH)
i <- 1
while(i <20) {
  dataHi <- ts(dataH[[paste0("a",i)]],start = c(2005,1), end = c(2020,6),frequency = 12)
  mHi<- seas(dataHi, xreg = cny.ts, regression.usertype = "holiday", x11 = "",regression.aictest = NULL)
  mmHi <- data.frame(mHi)
  if(nrow(mmHi)==186){
    k3[[paste0("a",i)]]<- mmHi$seasonaladj
  }else{
    z3<-data.frame("seasonaladj" = matrix(NA, nrow = 48, ncol = 1))
    ins3<-data.frame("seasonaladj" = matrix(mmHi$seasonaladj, nrow = 138, ncol = 1))
    try3<-rbind.data.frame(z3,ins3)
    k3[[paste0("a",i)]]<- try3
  }
  i=i+1
}
#####################################################################
dataE <- read_xlsx(path, sheet = "turnover", col_types ="numeric")
k4 <- data.frame(dataE)
i <- 1
while(i <40) {
  dataEi <- ts(dataE[[paste0("a",i)]],start = c(2005,1), end = c(2020,6),frequency = 12)
  mEi<- seas(dataEi, xreg = cny.ts, regression.usertype = "holiday", x11 = "",regression.aictest = c("td"))
  mmEi <- data.frame(mEi)
  if(nrow(mmEi)==186){
    k4[[paste0("a",i)]]<- mmEi$seasonaladj
  }else{
    z4<-data.frame("seasonaladj" = matrix(NA, nrow = 48, ncol = 1))
    ins4<-data.frame("seasonaladj" = matrix(mmEi$seasonaladj, nrow = 138, ncol = 1))
    try4<-rbind.data.frame(z4,ins4)
    k4[[paste0("a",i)]]<- try4
  }
  i=i+1
}
p1<-as.data.table(k1)
p2<-as.data.table(k2)
p3<-as.data.table(k3)
p4<-as.data.table(k4)
p22<-as.data.table(mmWi)
rio::export(p22,"D://sea_wage2.csv")
rio::export(p1,"D://sea_emp.csv")
rio::export(p2,"D://sea_wage.csv")
rio::export(p3,"D://sea_hour.csv")
rio::export(p4,"D://sea_turnover.csv")
