This is a Code Book for tidyData.txt file.

Variables:

"subject" is the id for 1 of 30 volunteers within an age bracket of 19-48 years.
"activity" is 1 of 6 activies the volunteer was doing during data collection. WALKING WALKING_UPSTAIRS
WALKING_DOWNSTAIRS SITTING
STANDING
LAYING
"variable" is name of the measured feature. "value" is the actual value of the measured feature.

Data

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window,vector of features was obtained by calculating variables from the time and frequency domain.

Transformations/Work to Clean Up the Data

Input files:

"./UCI HAR Dataset/activity_labels.txt" - Describes the number 1-6 to text WALKING, WALKING_UPSTAIRS etc transformation for activity.

"./UCI HAR Dataset/train/subject_train.txt" - Provides the subject id for the training set. "./UCI HAR Dataset/train/X_train.txt" - Provides the feature measurements for the training set.
"./UCI HAR Dataset/train/y_train.txt" - Provides the activity as numbers 1-6 for the training set.
"./UCI HAR Dataset/test/subject_test.txt" - Provides the subject id for the test set. "./UCI HAR Dataset/test/X_test.txt" - Provides the feature measurements for the test set.
"./UCI HAR Dataset/test/y_test.txt" - Provides the activity as numbers 1-6 for the test set. "./UCI HAR Dataset/features.txt") - Provides the header for the measurements.

Work:

Add feature header to feature measurements

colnames(X_train) = features[,2] colnames(X_test) = features[,2]

Concatenate subject ids to activity to measurments

train = cbind(subject_train,activity_train,X_train) test = cbind(subject_test,activity_test,X_test)

1. Merge the training and the test sets to create one data set.

d = rbind(train,test)

Add subject and activity labels

names(d)[1:2] = c('subject','activity')

Extract only the measurements on the mean and standard deviation for each measurement.

d = d[,grepl("subject|activity|.[Mm]ean.|.[Ss]td.",names(d))]

Uses descriptive activity names to name the activities in the data set

d[,'activity']=recode_factor(as.character(d[,'activity']), '1' = as.character(activity_labels[1,2]), '2' = as.character(activity_labels[2,2]), '3' = as.character(activity_labels[3,2]), '4' = as.character(activity_labels[4,2]), '5' = as.character(activity_labels[5,2]), '6' = as.character(activity_labels[6,2]))

Appropriately labels the data set with descriptive variable names.

names(d) = sub("\(\)","",names(d)) names(d) = gsub("\-","_",names(d))

From the data set in step 4, creates a second, independent tidy data set

with the average of each variable for each activity and each subject.

library(reshape2) actmelt = melt(d,id=c('subject','activity'),measure.var=names(d)[ 4 :35])

write.table(actmelt,"tidyDataSet.txt", row.name=FALSE)

Output: "tidyDataSet.txt"