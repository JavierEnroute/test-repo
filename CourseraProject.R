##Libraries
library(dplyr)
library(reshape2)

##Extract data from txt files
xTest<-read.table("~/Desktop/UCI HAR Dataset/test/X_test.txt", sep="", header = FALSE)
yTest<-read.table("~/Desktop/UCI HAR Dataset/test/y_test.txt", sep="", header = FALSE)
xTrain<-read.table("~/Desktop/UCI HAR Dataset/train/X_train.txt", sep="", header = FALSE)
yTrain<-read.table("~/Desktop/UCI HAR Dataset/train/y_train.txt", sep="", header = FALSE)
subject_train<-read.table("~/Desktop/UCI HAR Dataset/train/subject_train.txt", sep="", header = FALSE)
subject_test<-read.table("~/Desktop/UCI HAR Dataset/test/subject_test.txt", sep="", header = FALSE)
features<-read.table("~/Desktop/UCI HAR Dataset/features.txt", sep="", header = FALSE)
activityLabels<-read.table("~/Desktop/UCI HAR Dataset/activity_labels.txt", sep="", header = FALSE)

## Step 1 - Merges the training and the test sets to create one data set.
mergedXData<-merge(xTest,xTrain,all=TRUE)
mergedYData<-bind_rows(yTest,yTrain) ##Merge did not work for this case so used bind_rows
mergedSubject<-merge(subject_train,subject_test,all=TRUE)


## Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
features2<-grep(".std().|.mean().", features[,2])
names(mergedXData) <- features[, 2]
mergedXData <- mergedXData[,features2]


## Step 3 - Uses descriptive activity names to name the activities in the data set
mergedYData<-rename(mergedYData,activity=V1)
mergedYData$activity<-gsub("1","WALKING",mergedYData$activity)
mergedYData$activity<-gsub("2","WALKING_UPSTAIRS",mergedYData$activity)
mergedYData$activity<-gsub("3","WALKING_DOWNSTAIRS",mergedYData$activity)
mergedYData$activity<-gsub("4","SITTING",mergedYData$activity)
mergedYData$activity<-gsub("5","STANDING",mergedYData$activity)
mergedYData$activity<-gsub("6","LAYING",mergedYData$activity)



##Step 4 - Following lines of code add descriptive variable names. 
mergedSubject<-rename(mergedSubject,subject=V1)
allData<- cbind(mergedYData,mergedSubject,mergedXData)

##Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
write.table(allData.mean, "allDataTidy.txt", row.names = FALSE, quote = FALSE)
