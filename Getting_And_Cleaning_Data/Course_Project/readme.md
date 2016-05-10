# Course Project Overview

The instructions for this project were:

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data 
> set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by 
> your peers on a series of yes/no questions related to the project. You will be required to submit: 
>
>  1) a tidy data set as described below,
>  2) a link to a Github repository with your script for performing the analysis, and 
>  3) a code book that describes the variables, the data, and any transformations or work that you 
>     performed to clean up the data called CodeBook.md. 
>
> You should also include a README.md in the repo with your scripts. This repo explains how all
> of the scripts work and how they are connected.
>
> One of the most exciting areas in all of data science right now is wearable computing - see for 
> example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the 
> most advanced algorithms to attract new users. The data linked to from the course website 
> represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full
> description is available at the site where the data was obtained:
>       
>      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
>
> Here are the data for the project:
>        
>      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
>
> You should create one R script called run_analysis.R that does the following.
>
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names.
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of
>    each variable for each activity and each subject.

# OVERVIEW

Based on the way the data is given to us, I am going to accomplish the goals, but not in the order suggested by the outline.  If you read the documentation, you'll find that there  is a dataset with the label names.  It's actually easier to start with the label names, clean them up, and then to deal with the actual data.  The activity names are already provided, so it's relatively trivial to clreat activity names.  Extraction of names is very simply if you clean the column labels in advance.                                     

# Steps

1. The first thing I did was download the data using R studio
2. The data file was in a zip format, so I unpacked the entire folder (UCI HAR Dataset)
3. I read the readme.txt and features_info files
4. I read in and cleaned activity_labels.txt.  This provides a mapping between an activity identifier and an activity name.  activitiy_labels.txt is a 6 row by 2 column dataset.
5. I read in and cleaned features.txt.  features.txt is a 561 row by 2 column dataset that numbers and lists the column names in the test and training datasets do be described later.  I cleaned the features data so that we would have tidier column names.
6. For both the test and the training data, I
        + Read in the observations (X), the subject data, and the activity data (y)
        + I clean the data (apply the column names from the features file to X and keep only the relevant columns)
        + Column bind the data (so that I have subject, activity, and data)
        + Merge in clean activies labels and remove the activity numbers from the dataset (redundant)
7. I then row binded the test and training data and converted the subject number and activity to factors
8. I then calculated the mean of each variable by the subject number and activity
9. I output the data into a dataset called "means_by_subject_and_activity.txt" as specified by the instructions

My code is fully commented, which may make it appear long.  I also created far too many data sets, but this is a learning exercise (and making the additional data sets helped me visualize the data)

# Additional improvements that could be made

1. The commands for extracting the testing and training data were identical.  Next steps would be to turn these instructions into a function and call the function
2. The code could be cleaned to write over intermediate data steps and to reduce the number of steps using more expressive code.
