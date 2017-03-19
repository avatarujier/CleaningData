#
# The following directory structure is assumed for script execution
# /
# |-- run_analysis.R
# |-- UCI HAR Dataset
#   |-- test
#   |-- train
#   |-- README.txt

# Based on README.txt each record provides: Triaxial acceleration, 
# Triaxial Angular velocity, feature vector, activity, subject identifier.
# Important: Accelaration & angular velocity signals are stored in Inertial Signals folder
# which should be excluded

# All data sets listed in test & train folders does not contain a relational
# column to use merge (dtA,dtB, by) function, therefore cbind or rbind for
# merging will be used.

# feature vector
# ncol(X_train)
# [1] 561
# ncol(X_test)
# [1] 561

# Training set
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
# Test set
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_features <- rbind(X_train, X_test)

# activity labels
# Training labels
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
# Test labels
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_labels <- rbind(y_train, y_test)

# subject identifier
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_identifier <- rbind(subject_train, subject_test)

# name of each feature column vector is stored in features variable
# lets  asign it to X_features as colum standar name
# List of all features
features <- read.table("UCI HAR Dataset/features.txt")
colnames(X_features) <- features[,2]

# name for activity labels
colnames(y_labels) <- "ActivityID"

# name for the subject
colnames(subject_identifier) <- "Subject"

# now all the matrix numbers matches!
# nrow(X_features)
# [1] 10299
# nrow(y_labels)
# [1] 10299
# nrow(subject_identifier)
# [1] 10299

# right after a column binding tidy data set will be created
# 1. Merges the training and the test sets to create one data set.
tidyData <- cbind(X_features, y_labels, subject_identifier)
#tidyData

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
measurementsMeanStd <- tidyData[,grep("*mean.*|.*std.*", colnames(tidyData), ignore.case = TRUE)]
#measurementsMeanStd

# 3.Uses descriptive activity names to name the activities in the data set
# Links the class labels with their activity name
if("data.table" %in% rownames(installed.packages()) == FALSE){
  install.packages("data.table")
}
if("plyr" %in% rownames(installed.packages()) == FALSE){
  install.packages("plyr")
}
library("data.table")
library("plyr")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
# name for joining
colnames(activity_labels) <- c("ActivityID","Activity")
# data table for fast process
dt1 <- data.table(tidyData, key = "ActivityID")
dt2 <- data.table(activity_labels, key = "ActivityID") 
# order by subject
tidyData <- arrange(dt1[dt2], dt1$Subject)
#tidyData$Activity

# 4.Appropriately labels the data set with descriptive variable names
#everything that start with t
names(tidyData)<-gsub("^t", "Time", names(tidyData), ignore.case = TRUE)
#everything that start with f
names(tidyData)<-gsub("^f", "Frequency", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("Mag", "Magnitude", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-mean()", "Mean", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std()", "Std", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq()", "Frequency", names(tidyData), ignore.case = TRUE)
#colnames(tidyData)

# 5. From the data set in step 4, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.
# The easiest way to get the averagy of each var is via aggregate function
# Dot function descrbe below
tidyDataAvg <- aggregate(. ~Subject + Activity, tidyData, mean)

# order by subject, activity for nice display
tidyDataAvg <- arrange(tidyDataAvg, tidyDataAvg$Subject, tidyDataAvg$Activity)
#tidyDataAvg
write.table(tidyDataAvg, file = "tidyDataAvg.txt", row.names = FALSE)