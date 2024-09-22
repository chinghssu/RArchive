#install.packages("knitr")
#install.packages("rmarkdown")
#install.packages("glmnet")
library(knitr)
knitr::opts_chunk$set(echo = TRUE)

library(glmnet)
Hitters <- readxl::read_excel("C:/gcloud5/Work/AIECON/postdoc/lasso_20190410.xlsx", sheet="lasso")
#Hitters = read.csv("C:/gcloud5/Work/AIECON/postdoc/lasso reg_words selection/Hitters.csv")
summary(Hitters)
Hitters=na.omit(Hitters)
with(Hitters,sum(is.na(shwpi)))
names(Hitters)


## Find the dimension


dim(Hitters)


x=model.matrix(shwpi~.,Hitters)[,-1] #set salary as a dependent variable in regression
y=Hitters$shwpi
dim(x)
print(x)

#Divide the data set into half training and half testing.
#We first set a random seed so that the results obtained will be reproducible.


set.seed(1)
train=sample(1:nrow(x), nrow(x)/2)
x.train=x[train]
y.train=y[train]
test=(-train)
x.test=x[test]
y.test=y[test]
test.mat=model.matrix(shwpi~.,data=Hitters[test,])
#train=sample(seq(263),180,replace=FALSE)
#train

#Lease square regression model 1 uses the lm command which solves the least squares problem using QR decomposition. Model 2 uses LASSO with lambda = 0. The results (coefficient) are slightly different.

lm.mod1=lm(shwpi~.,data=Hitters[train,])
coef(lm.mod1)


lm.mod2=glmnet(x[train ,],y[train],lambda=0)
coef(lm.mod2)

#get MSE of lm.mod1 on test data

pred1=test.mat[,names(coef(lm.mod1))]%*%coef(lm.mod1)
mean((Hitters$shwpi[test]-pred1)^2)

#get MSE of lm.mod2 on test data

pred2=predict(lm.mod2,s=0,newx=x[test,])
mean((Hitters$shwpi[test]-pred2)^2)


#Lasso
#-------------------------------
#  We will use the package glmnet, which does not use the model formula language, so we will set up an x and y.

library(glmnet)
lasso.mod=glmnet(x[train ,],y[train],alpha=1) 
plot(lasso.mod, xvar="lambda", label=TRUE)


setNames(rownames(lasso.mod$beta), 1:nrow(lasso.mod$beta))


#Perform cross-validation to choose lambda of the LASSO models that have the smallest test error.

set.seed (1)
cv.out=cv.glmnet(x[train ,],y[train],alpha=1)
plot(cv.out)

#choose lambda with the smallest error to run on test data to get MSE

bestlam=cv.out$lambda.min
lasso.pred=predict(lasso.mod,s=bestlam ,newx=x[test,])
mean((lasso.pred-y.test)^2) 

#find the LASSO model coefficient. 12 of the 19 variables have coefficient 0. The model contains 7 variables.
#The model also has smaller MSE than the linear regression model that were built using all 19 variables.

lasso.coef=predict(lasso.mod,type="coefficients",s=bestlam)[1:20,]  
lasso.coef


