library(readr)
library(caTools)
library(rpart.plot)
library(rpart)
library(FSelector)
library(xgboost)
library(ROCR)
library(xlsx)

#Reading the data .

train = read.csv("G:/intern/new folder/train.csv")
features = read.csv("G:/intern/new folder/features.csv")
stores = read.csv("G:/intern/new folder/stores.csv")
test = read.csv("G:/intern/new folder/test.csv")

#Pre - processing the data .

features$IsHoliday = as.numeric(features$IsHoliday)
train$IsHoliday = as.numeric(train$IsHoliday)
train$Date = as.numeric(train$Date)
features$Date = as.numeric(features$Date)

#merging the datasets .

new = merge(train , features , by.train = train$Store , by.features = features$Store)
new_test = merge(test , features , by.test = test$Store , by.features = features$Store)

#Splitting the dataset .

split = sample.split( new$IsHoliday , SplitRatio = 0.75)
mtrain = subset( new , split == TRUE)
mtest = subset( new ,  split == FALSE)

#Base model with linaer regression .

model = lm(Sales ~ Store + Date + Dept + Temperature + Fuel_Price + CPI + Unemployment , data = mtrain)
prediction = predict( model, newdata = mtest )

#information gain .

weights = information.gain(Sales ~ . , mtrain )

mtrain = as.matrix(mtrain)
mtest =as.matrix(mtest)
new = as.matrix(new)
new_test$Date = as.numeric(new_test$Date)

#applying XGboost.
ntest = new_test[,-5]
ntest = as.matrix(faf)

bst = xgboost(data = new[,-5] , label = new[,5] , nrounds = 500)
pred = predict( bst , ntest )  


#gives test error and train error of every round ,this is used to find the optimum number of roundes .

dtrain <- xgb.DMatrix(data = mtrain[,-5], label=mtrain[,5])
dtest <- xgb.DMatrix(data = m[,-5], label=mtest[,5])
watchlist = list(train=dtrain, test=dtest)
bstt = xgb.train(data=dtrain , nrounds=1000,watchlist=watchlist )

pred = data.frame(pred)
test = merge( test , pred)

#filling the column .
test[,5]=pred

#exporting the final file .
write.csv( test , "G:/test.csv")





