##  R script called run_analysis.R  does the following.
##
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("C:/Users/Riina/Documents/R/Data_cleaning/Smartphone_data")
print(getwd())
## Downloading the source file (.zip), just first time
setInternet2(use = TRUE)
if(!file.exists("FUCI_HAR_Dataset.zip"))
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","FUCI_HAR_Dataset.zip")
else
  print("Warning: zip-file was already downloaded!")

## unzip zip-file to extract raw data
unzip("FUCI_HAR_Dataset.zip")
## the result is subfolder and several txt-files
list.files()

## let's look into subfolder list as well (when needed)
setwd("UCI HAR Dataset")
list.files()

## LETS LOAD "training-data" details into R
##  subjects for X_train and Y_train (i.e. activity) and train-data 
subject_train <- read.table("train/subject_train.txt")
## add labels to subject column
names(subject_train)[1] <- c("subject")

## Load Training set 
X_train <- read.table("train/X_train.txt")

## > str(X_train)
## 'data.frame':  7352 obs. of  561 variables:
## $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
## $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...

## 561 lines of NAMES for X_train and X_test variables
X_Labels <-read.delim("features.txt", header = FALSE, sep=" ")       

## add labels to training data
names(X_train) <- X_Labels[,2]

## Training labels (coded featres.txt) - training activities
Y_train <- read.table("train/y_train.txt")
names(Y_train) <- c("activity")

## > str(Y_train)   ## 
## 'data.frame':  7352 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

## Activity labels (V1: coded 1-6; V2: Names of activities
A_Labels <- read.table("activity_labels.txt")
A_Labels$V1 <- as.factor(as.character(A_Labels$V1))

## add activity labels to next column
Y_train$activity_label <- factor(Y_train$activity,labels = A_Labels$V2)

## merge TRAIN_data = subject + activity + traing data
train_data <- cbind(subject_train, Y_train, X_train)

## CURRENTLY NOT IN USE
## Train x-files have 7352 obs with 128 variables  (Y + Z)
## train_Tot_signals <- read.table("train/Inertial Signals/total_acc_x_train.txt")
## train_body_signals <- read.table("train/Inertial Signals/body_acc_x_train.txt")
## train_body_g_signals <- read.table("train/Inertial Signals/body_gyro_x_train.txt")



##===========================================================
## composition of test dataset (like with training-set above)
setwd("../test")
## the TEST-data files are located in "test"-folder

## LETS LOAD NECCESSARY ITEMS into R
##  subjects for X_test and Y_test (i.e. activity) and train-data 
subject_test <- read.table("test/subject_test.txt")
## add labels to subject column
names(subject_test)[1] <- c("subject")

## Load Test set 
X_test <- read.table("test/X_test.txt")

#> str(X_test)
# 'data.frame':  2947 obs. of  561 variables:
# $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
# $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
# $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
#...

## 561 lines of NAMES for X_train and X_test variables
## (were loaded for train-data)
## X_Labels <-read.delim("features.txt", header = FALSE, sep=" ")       

## add labels to training data
names(X_test) <- X_Labels[,2]

## Training labels (coded featres.txt) - training activities
Y_test <- read.table("test/y_test.txt")
names(Y_test) <- c("activity")

## > str(Y_test)
## 'data.frame':  2947 obs. of  1 variable:
##  $ activity: int  5 5 5 5 5 5 5 5 5 5 ...

## Activity labels (V1: coded 1-6; V2: Names of activities
## A_Labels <- read.table("activity_labels.txt")
## A_Labels$V1 <- as.factor(as.character(A_Labels$V1))

## add activity labels to next column
Y_test$activity_label <- factor(Y_test$activity,labels = A_Labels$V2)

## merge TEST_data = subject + activity + traing data
TEST_data <- cbind(subject_test, Y_test, X_test)

## CURRENTLY NOT IN USE
## Test x-files have 2947 obs with 128 variables (Y + Z)
train_Tot_signals <- read.table("test/Inertial Signals/total_acc_x_test.txt")
train_body_signals <- read.table("test/Inertial Signals/body_acc_x_test.txt")
train_body_g_signals <- read.table("test/Inertial Signals/body_gyro_x_test.txt")

##============================================
## 1.Merges the training and the test sets to create one data set.
##============================================
## creates TIDY_data by merging train-data and test-data
TIDY_data <- rbind(train_data,TEST_data)

## 1. write the tidied data into txt-file 
## a) as txt-file with " "-separator 
write.table(TIDY_data, file="tidy_Samsung.txt", row.name=FALSE)

## b) as csv-file with ","-separator 
write.table(TIDY_data, file="tidy_Samsung.csv", sep = ",", row.name=FALSE)

##============================================
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##============================================
mean_vector <- TIDY_data[,506]       ## TIDY_data$fBodyAccMag-mean
mean_vector <- TIDY_data[,204]       ## TIDY_data$tBodyAccMag-mean()
deviation_vector <- TIDY_data[,507]  ## TIDY_data$fBodyAccMag-std
deviation_vector <- TIDY_data[,205]   ## TIDY_data$"tBodyAccMag-std()"
##============================================
## 3.Uses descriptive activity names to name the activities in the data set
##============================================

##============================================
## 4.Appropriately labels the data set with descriptive variable names. 
##============================================
## done above
##============================================
## 5.From the data set in step 4, creates a second, independent 
## tidy data set with the average of each variable 
## for each activity and each subject.

library(dplyr)
gby_act_subj <- group_by(TIDY_data, activity, subject) 
## returns the mean values of each group
TIDY_by_act_subj <- summarize(gby_act_subj, mean(4:564)) 
