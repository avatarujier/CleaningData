 CodeBook - Getting and Cleaning Data Course Project

 This document describes run_analysis.R file and the transformation/process used to get
 tidyDataAvg.txt

 Forewords

 Human Activity Recognition database built from the recordings of 30 subjects performing    
 activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded 
 inertial sensor 
 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

 The data set used can be downloaded from    
 http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip 

 Assestment 
 
 The following directory structure is assumed for script execution
 /
 |-- run_analysis.R
 |-- UCI HAR Dataset
   |-- test
   |-- train
   |-- README.txt

 Based on README.txt each record provides: Triaxial acceleration, 
 Triaxial Angular velocity, feature vector, activity, subject identifier.
 
 Important: Accelaration & angular velocity signals are stored in Inertial Signals folder
 which should be excluded because are not in the scope.
 
 All data sets listed in test & train folders does not contain a relational
 column to use merge (dtA,dtB, by) function, therefore cbind or rbind for
 merging will be used.

 Training set       - UCI HAR Dataset/train/X_train.txt
 Test set           - UCI HAR Dataset/test/X_test.txt
 Training labels    - UCI HAR Dataset/train/y_train.txt
 Test labels        - UCI HAR Dataset/test/y_test.txt
 Subject identifier - UCI HAR Dataset/train/subject_train.txt
 Subject_test       - UCI HAR Dataset/test/subject_test.txt
 
 Transformation
 
 The aim is to build a tidy data set well-formed to describe
  - Training/Test sets features 
      >> X_train,X_test =  X_features
  - Activity labels 
      >> y_train, y_test = y_labels
  - Subject identifier
      >> subject_train, subject_test = subject_identifier
      
 Because features names for Training/Test are sotored in features files will be used and
 placed as header for Trainig/Test sets
  >> features <- read.table("UCI HAR Dataset/features.txt")
  >> colnames(X_features) <- features[,2]
 
 Tidy data has some principles that must be obey, thats why name column must be attached on 
 activity and subject identifiers
  >> colnames(y_labels) <- "ActivityID"
  >> colnames(subject_identifier) <- "Subject"

 As soon all is bind, row numbers should match and can be get by using:

 nrow(X_features)
 > [1] 10299
 nrow(y_labels)
 > [1] 10299
 nrow(subject_identifier)
 > [1] 10299

 Right after a column binding tidy data set can be created 
  >> tidyData = (X_features, y_labels, subject_identifier )

 To extract only the measurements on the mean and standard deviation for each measurement
 regular expression must be address 
  >> measurementsMeanStd grep "*mean.*|.*std.*

 In order to link id activity labels in tidy set with their activity description a merge
 conducted via data.table will be applied
   >> colnames(activity_labels) <- c("ActivityID","Activity")
   >> tidyDataAvg = dt1[dt2]
   
 Optional is ordered by Subject for nice presentantion
   >> tidyDataAvg = arrange(dt1[dt2], dt1$Subject)
 
 Descriptive column name can be replaced by more comprenhensive description as follows
   >> "Acc" by "Accelerometer"
   >> "Gyro" by "Gyroscope"
   >> "BodyBody" by "Body"
   >> "Mag" by "Magnitude"
   >> "everything tha starts wit t" by "time"
   >> "everything tha starts wit f" by "frequency"
   >> "-mean()" by "Mean"
   >> "-std()" by "Std"
   >> "-freq()" by "Frequency"
   
  The easiest way to get the average of each var is via aggregate function because it can
  apply a function to each row aggregated by subject + activity (remember to use names 
  assigned on each column via data.table)
   >> tidyDataAvg = ~Subject + Activity mean

  The output data tidyDataAvg.txt contains the mean and standard deviation values of the data
  aggregated and sorted by Subject and Activity
  >> arrange(Subject,Activity)
  
