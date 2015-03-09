library(dplyr)
library(sqldf)

#Read in features dataset#
features <- read.table("C:/Alex/Coursera/R/UCI HAR Dataset/features.txt", header = FALSE)

#Read in activity labels#
activity_labels <- read.table("C:/Alex/Coursera/R/UCI HAR Dataset/activity_labels.txt", header = FALSE)

#Read in x train, subject train, and y train datasets#
x_train <- read.table("C:/Alex/Coursera/R/UCI HAR Dataset/train/X_train.txt", header = FALSE)
subject_train <- read.table("C:/Alex/Coursera/R/UCI HAR Dataset/train/subject_train.txt",header = FALSE)
y_train <- read.table("C:/Alex/Coursera/R/UCI HAR Dataset/train/y_train.txt",header = FALSE)

#Add row number to x train, y train, and subject_train datasets for merging#
x_train$rownumber <- 1:nrow(x_train)
y_train$rownumber <- 1:nrow(y_train)
subject_train$rownumber <- 1:nrow(subject_train)

#Renaming#
subject_train <- rename(subject_train,subject = V1)

#join -- result is full_training dataset, consisting of subjects, labels,variables#
full_training <- sqldf("SELECT a.subject,b.V1 as activity, c.V2 as activity_label, d.*
              FROM subject_train a join y_train b on a.rownumber = b.rownumber
                      left join activity_labels c on b.V1 = c.V1 
                           join x_train d on a.rownumber = d.rownumber")

#applying features variable names to full_training# 
for (i in 4:565) {
  colnames(full_training)[i] <- as.character(features$V2[i-3])
}

#Read in x test, subject test, and y test datasets#
x_test <- read.table("C:/Alex/Coursera/R/UCI HAR Dataset/test/X_test.txt", header = FALSE)
subject_test <- read.table("C:/Alex/Coursera/R/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
y_test <- read.table("C:/Alex/Coursera/R/UCI HAR Dataset/test/y_test.txt", header = FALSE)


#Add row number to x test, y test, and subject_test datasets for merging#
x_test$rownumber <- 1:nrow(x_test)
y_test$rownumber <- 1:nrow(y_test)
subject_test$rownumber <- 1:nrow(subject_test)

#Renaming#
subject_test <- rename(subject_test,subject = V1)

#join -- result is full_test dataset, consisting of subjects, labels,variables#
full_test <- sqldf("SELECT a.subject,b.V1 as activity, c.V2 as activity_label, d.*
              FROM subject_test a join y_test b on a.rownumber = b.rownumber
                      left join activity_labels c on b.V1 = c.V1 
                           join x_test d on a.rownumber = d.rownumber")

#applying features variable names to full_test# 
for (i in 4:565) {
  colnames(full_test)[i] <- as.character(features$V2[i-3])
}

#combining full_training and full_test datasets#
complete <- rbind(full_training,full_test)

#including only mean() or std() variables#
complete_cut <- complete[grep("-mean()|-std()|subject|activity", names(complete))]

#one more operation to remove variables containing Freq -- not sure how to integrate into above#
full_data <- complete_cut[-grep("Freq",names(complete_cut))]

#now renaming variables to simplify - removing "-","()", and adding "_" - then changing to lower case#
names(full_data) <- gsub("-","_",names(full_data))
names(full_data) <- gsub("\\()","",names(full_data))
names(full_data) <- tolower(names(full_data))

#aggregating summary dataset#
tidy_data <- aggregate(full_data, by=list(subject = full_data$subject, activity = full_data$activity_label), mean, na.rm = TRUE)

names(tidy_data)

#dropping columns 3 - (numeric activity), 4,5 (extraneous columns) since they are no longer necessary#
tidy_data <- tidy_data[ -c(3:5)]

#ordering by subject and activity#
final <- tidy_data[order(tidy_data$subject,tidy_data$activity),]

write.table(final, "C:/Alex/Coursera/R/tidy_data.txt", sep="\t", row.name = FALSE)



