# Luvuyo Dlamini



rm(list=ls(all=TRUE))

#Read activity labels
activity_labels= read.table("./UCI HAR Dataset/activity_labels.txt")

#Read training subject ids, feature measurements and corralated activity numbers.
subject_train= read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
X_train = read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
activity_train = read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)

#Read test subject ids, measurements and corralated activity numbers.
subject_test= read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
X_test = read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
activity_test = read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)

#Read feature headers
features = read.table( "./UCI HAR Dataset/features.txt")

#add feature header to feature measurements
colnames(X_train) = features[,2]
colnames(X_test) = features[,2]

#concatenate subject ids to activity to measurments
train = cbind(subject_train,activity_train,X_train)
test = cbind(subject_test,activity_test,X_test)

# 1. Merge the training and the test sets to create one data set.
d = rbind(train,test)
# add subject and activity labels
names(d)[1:2] = c('subject','activity')

        


# Extracts only the measurements on the mean and standard deviation for each measurement.
d = d[,grepl("subject|activity|.*[Mm]ean.*|.*[Ss]td.*",names(d))]
#Uses descriptive activity names to name the activities in the data set
library(dplyr)
d[,'activity']=recode_factor(as.character(d[,'activity']),
                             '1' = as.character(activity_labels[1,2]),
                             '2' = as.character(activity_labels[2,2]),
                             '3' = as.character(activity_labels[3,2]),
                             '4' = as.character(activity_labels[4,2]),
                             '5' = as.character(activity_labels[5,2]),
                             '6' = as.character(activity_labels[6,2]))
#Appropriately labels the data set with descriptive variable names.
names(d) =  sub("\\(\\)","",names(d))
names(d) =  gsub("\\-","_",names(d))

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
library(reshape2)
actmelt = melt(d,id=c('subject','activity'),measure.var=names(d)[ 4 :35])
write.table(actmelt,"tidyDataSet.txt", row.name=FALSE)
subjectTable = dcast(actmelt, subject~variable, mean)
activityTable = dcast(actmelt, activity~variable, mean)

