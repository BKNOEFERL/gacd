# The goal is to prepare tidy data that can be used for later analysis

# You will be required to submit: 

# 1) a tidy data set as described below
# 2) a link to a Github repository with your script for performing the analysis
# 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md

# You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected


run_analysis <- function(){

setwd("C:\\Users\\bknoeferl\\Desktop\\UCI HAR Dataset")

# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set

## read test data
subject_test <- read.table("test\\subject_test.txt")
X_test <- read.table("test\\X_test.txt")
Y_test <- read.table("test\\y_test.txt")

## read train data
subject_train <- read.table("train\\subject_train.txt")
X_train <- read.table("train\\X_train.txt")
Y_train <- read.table("train\\y_train.txt")


## load lookup information 
features <- read.table("features.txt", col.names=c("featureId", "featureLabel")) 
activities <- read.table("activity_labels.txt", col.names=c("activityId", "activityLabel")) 

# replace all "_" in the labels of activities
activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))

# 2.Extracts only the measurements on the mean and standard deviation for each measurement
# -> get all the featureLabels which contain mean or std in their name
includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)  # gives the index of those features$featureLabel which have mean or std in their names 

# merge test and training data and then name them 
subject <- rbind(subject_test, subject_train) 

# rename "V1" into subjectId
names(subject) <- "subjectId"

X <- rbind(X_test, X_train) 
# just those which contain mean and sd in their name -> just the columns with indices includedFeatures
X <- X[, includedFeatures] 
# allocate the correct names using again features
names(X) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures]) 

Y <- rbind(Y_test, Y_train) 
# rename "V1" into activityId
names(Y) = "activityId" 

# merging Y & activites by the ID
activity <- merge(Y, activities, by="activityId")$activityLabel 

# columnbind subject & X & activity
dat <- cbind(subject, X, activity) 
# write the table 
write.table(dat, "merged_tidy_data.txt") 

# Now we want to calculate average and std and average of each variable for each activity and each subject
library(data.table) # contains function data.table
dataDT <- data.table(dat) 
Final <- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")] 
write.table(Final, "Final_tidy_data.txt") 

}

# test
run_analysis()
