Samsung Galaxy analysis for Getting and Cleaning data class
=============

#Data:
data archive: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
data description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones")

#Running the script:
Clone this repository
Download the data set and extract. 
Change current directory with setws() to the /UCI HAR Dataset folder.
data files from the \"UCI HAR Dataset\" are availale in the current directory with the same structure as in the zip file 
source run_analysis.R
The raw dataset will be created in the current directory as samsung_raw.txt
The tidy dataset will be created in the current directory as samsung_tidy.txt

#Notes:
Measurements are present in X_<dataset>.txt file
Subject information is present in subject_<dataset>.txt file
Activity codes are present in y_<dataset>.txt file
All activity codes and their labels are in a file named activity_labels.txt.
Names of all measurements taken are present in file features.txt ordered and indexed as they appear in the X_<dataset>.txt files.
All columns representing means contain ...mean() in them.
All columns representing standard deviations contain ...std() in them.
