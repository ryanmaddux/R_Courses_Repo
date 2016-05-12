##########################################################
##### STEP 1: Get the data from the source (UCI) #########
##########################################################

## A) set your working directory

setwd("C:/Users/Ryan/Coursera/Getting_and_Cleaning_Data/Week_4/ClassProject")

## B) link to the file location

project_link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## C) Download the data
## Note: this data is largish - it can take a couple of minutes to download

download.file(project_link, "./ACC_Data.zip")

## D) I manually extract each of the files into the same folder
##    There are likely pieces of code that will allow you to extract directly from
##    a zip, but I didn't invest the time to look into it.

setwd("C:/Users/Ryan/Coursera/Getting_and_Cleaning_Data/Week_4/ClassProject/UCI HAR Dataset")

##### STEP 2: Read in the individual raw files and tidy them up

## A) activity_labels.txt

activity_labels_raw <- read.table("activity_labels.txt", header = FALSE, sep = " ")

        ## i) Rename the activity labels table to be more sensible

                ## use dplry

library(dplyr)

                ## dataset has two columns.  Call the first one "activitycode" and the second "activity"

activity_labels <- rename(activity_labels_raw, activitycode = V1, activity = V2)

        ## ii) Convert the actifities to lower case letters

activity_labels <- mutate(activity_labels, activity = tolower(activity))
                
        ## iii) Inspect formats

str(activity_labels)

        ## activity code is saved as an integer and activity is stored as a character

## B) features.txt

features_raw <- read.table("features.txt", header = FALSE, sep = " ")

        ## i) Rename the feature table to be more sensible 

features_01 <- rename(features_raw, featurecode = V1, feature = V2)

        ## ii) Convert the features to be lower case letters

features_01 <- mutate(features_01, feature = tolower(feature))

        ## iii) the feature names are a mess, so we need to clean them up.

                ## Replace all "-" with "_"

features_02 <- mutate(features_01, feature = gsub("-", "_", feature))

                ## remove all instances of "()".  Note: "(" and ")" are reserved
                ## as operators, so we need to tell R to treat them as characters

features_03 <- mutate(features_02, feature = gsub("\\(\\)", "", feature))

                ## Replace all ","'s with "_"'s

features_04 <- mutate(features_03, feature = gsub(",", "_", feature))

                ## Replace all "(" and ")" with "-"

features_05 <- mutate(features_04, feature = gsub("\\(", "_", feature))

features <- mutate(features_05, feature = gsub("\\)", "_", feature))

## C) /test/subject_test.txt

setwd("C:/Users/Ryan/Coursera/Getting_and_Cleaning_Data/Week_4/ClassProject/UCI HAR Dataset/test")

subject_test_raw <- read.table("subject_test.txt", header = FALSE, skip = 2, sep = "")

        ## rename the column name to subject_number

subject_test <- rename(subject_test_raw, subject_number = V1)

table(subject_test)

## 9 of the 30 subjects (or 30%)

## D) /test/X_test.txt

        ## read in the test data.  Note: the first two lines are blanks and need to be skipped.  Do not use any separators
        ## we can use the second column of the features data frame as the column names (yay.  Aren't we glad that we 
        ## cleaned that?)

X_test_raw <- read.table("X_test.txt", header = FALSE, skip=2, col.names = features[,2])

        ## R sucks in the sense that we can't see all of the columns.  Boo.        

        ## Extract only the measurements on the mean and standard deviation for each measurement
        ## good instructions for this here:
        ## http://seananderson.ca/2014/09/13/dplyr-intro.html
        ## didn't use that info, but it's good to know :-)

X_test_01 <- X_test_raw[grepl('mean|std', names(X_test_raw))]

## Note: there is a variable "meanFreq" that isn't necessarly a mean or a standard deviation.  Remove
## these variables

X_test_02 <- X_test_01[!grepl('meanfreq|gravitymean|tbodyaccmean|tbodyaccjerkmean|tbodygyromean|tbodygyrojerkmean', names(X_test_01))]

## E) /test/y_test_raw

        ## read in the data (we know from the documentation that these are the activities.  You can verify this
        ## by creating a table, which I do below.)

y_test_raw <- read.table("y_test.txt", header = FALSE, sep = "", skip=2, col.names = "activitycode")

table(y_test_raw)

## 
        
        ## i) Column bind the X_test_raw, y_test_raw, and subject data frames

test_data_01 <- cbind(subject_test, y_test_raw, X_test_02)

        ## ii) Merge in the activity labels

test_data_02 <- merge(test_data_01, activity_labels, by.x = "activitycode", by.y = "activitycode",all=FALSE)

        ## ii) Rearange the data and drop the activity code (not necessary)

test_data <- test_data_02[,c(2,69,3:68)]

### Note: I inspected the contents of Inertial Signals.  It appears that, like the test data, there are 2945 
### observations in each file.  I assume that these are more granular observations.  Unfortunately, I have
### no idea how to label the data and I am not sure it is relevant to the assignment

## F) /train/subject_train.txt

setwd("C:/Users/Ryan/Coursera/Getting_and_Cleaning_Data/Week_4/ClassProject/UCI HAR Dataset/train")

subject_train_raw <- read.table("subject_train.txt", header = FALSE, skip = 2, sep = "")

## rename the column name to subject_number

subject_train <- rename(subject_train_raw, subject_number = V1)

table(subject_train)

## 21 of the 30 subjects (or 70%)

## D) /train/X_train.txt

## read in the training data.  Note: the first two lines are blanks and need to be skipped.  Do not use any separators
## we can use the second column of the features data frame as the column names (yay.  Aren't we glad that we 
## cleaned that?)

X_train_raw <- read.table("X_train.txt", header = FALSE, skip=2, col.names = features[,2])

## R sucks in the sense that we can't see all of the columns.  Boo.        

## Extract only the measurements on the mean and standard deviation for each measurement
## good instructions for this here:
## http://seananderson.ca/2014/09/13/dplyr-intro.html
## didn't use that info, but it's good to know :-)

X_train_01 <- X_train_raw[grepl('mean|std', names(X_train_raw))]

## Note: there are variables "meanFreq", "gravityMean", "tBodyAccMean", "tBodyAccJerkMean",
## "tBodyGyroMean", and "tBodyGyroJerkMean" that aren't necessarly a mean or a standard deviation.  Remove
## these variables

X_train_02 <- X_train_01[!grepl('meanfreq|gravitymean|tbodyaccmean|tbodyaccjerkmean|tbodygyromean|tbodygyrojerkmean', names(X_train_01))]

names(X_train_02)

## E) /train/y_train_raw

## read in the data (we know from the documentation that these are the activities.  You can verify this
## by creating a table, which I do below.)

y_train_raw <- read.table("y_train.txt", header = FALSE, sep = "", skip=2, col.names = "activitycode")

table(y_train_raw)

## i) Column bind the X_train_raw, y_train_raw, and subject data frames

train_data_01 <- cbind(subject_train, y_train_raw, X_train_02)

## ii) Merge in the activity labels

train_data_02 <- merge(train_data_01, activity_labels, by.x = "activitycode", by.y = "activitycode",all=FALSE)

## ii) Rearange the data and drop the activity code (not necessary)

train_data <- train_data_02[,c(2,69,3:68)]

####################################################################################################
### STEP 3: Combine the Test and Training Data
####################################################################################################

### A) Row bind (rbind) should solve this.

combined_data <- rbind(test_data, train_data)

### B) Now we want to convert the subject_number and activity to factors

combined_data$subject_number <- as.factor(combined_data$subject_number)
combined_data$activity <- as.factor(combined_data$activity)

str(combined_data)

####################################################################################################
### STEP 4: Creates a second, independent tidy data set with the average of
##    each variable for each activity and each subject.
####################################################################################################

means_only <- combined_data %>% group_by(subject_number, activity) %>% summarise_each(funs(mean))

### Export the Data Set as a text file

setwd("C:/Users/Ryan/Coursera/Getting_and_Cleaning_Data/Week_4/ClassProject")

### Per instructions: Please upload your data set as a txt file created with
#### write.table() using row.name=FALSE

write.table(means_only, file = "means_by_subject_and_activity.txt", row.names = FALSE)
