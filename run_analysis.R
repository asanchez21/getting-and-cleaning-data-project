library(data.table)
library(plyr)

setwd("C:/Users/asancheza/Dropbox/Coursera/03 Cleaning Data/Course Project")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "Dataset.zip")
unzip("Dataset.zip")


# Part 1
features <- read.table("./UCI HAR Dataset/features.txt")

test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(test_x) <- as.character(features[,2])
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
test_subjet <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "ID")
test <- cbind(test_subjet, test_y, test_x)

train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(train_x) <- as.character(features[,2])
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
train_subjet <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "ID")
train <- cbind(train_subjet, train_y, train_x)

dataset <- rbind(test, train)

# Part 2
mean_std <- grep("mean\\(\\)|std\\(\\)",features[,2],value=TRUE)
mean_std <- union(c("ID","Activity"), mean_std)
dataset <- dataset[,mean_std]

# Part 3
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Activity","ActivityName"))
dataset <- merge(dataset, activity, by = "Activity")

# Part 4
names(dataset)<-gsub("^t", "time", names(dataset))
names(dataset)<-gsub("^f", "frequency", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))

# Part 5
dataset_avg <- ddply(dataset,
                     c("ActivityName","ID"),
                     function(x) colMeans(x[,-which(names(x) %in% "ActivityName")]))

write.table(dataset_avg, "TidyData.txt", row.name=FALSE)

# Codebook
