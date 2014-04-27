# You should create one R script called run_analysis.R that does the following. => this file
# Merges the training and the test sets to create one data set. => in function mergeData() 
# Extracts only the measurements on the mean and standard deviation for each measurement. => filtered with grep string pattern in readData()
# Uses descriptive activity names to name the activities in the data set => addActivity() funcion pulls from activity_labels.txt file
# Appropriately labels the data set with descriptive activity names.  => addActivity() funcion pulls from activity_labels.txt file
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. => tidy.txt file

# main wrapper function used for program control. 
# Called from the Script Execution section at the bottom of the script.
# Create a tidy data set and save it on to the file name passed in by the main call
mainCreateFile <- function(fname, fnameraw) {
  #main call functions 
  tidy_data <- tidyData(mergeLabeledData())
  
  #   #get rid of padded spaces from activity lables. no longer needed
  #   library(stringr)
  #   tidy_data[,"Activity"] <- str_trim(tidy_data[,"Activity"])
  
  #output data to filename inputed to this function
  #write.table(tidy_data, fname)
  write.table(tidy_data, fname)
}

# wrapper function for adding Activity Labels to main data
# Combine training and test data sets and add the activity label as another column
mergeLabeledData <- function() {
  addActivity(mergeData())
}

# Merge train and test data sets
# and tidy up names with ProperCasing
mergeData <- function() {
  data <- rbind(readTestData(), readTrainData())
  colnames <- colnames(data)
  colnames <- gsub("\\.+mean\\.+", colnames, replacement="Mean")
  colnames <- gsub("\\.+std\\.+",  colnames, replacement="Std")
  colnames(data) <- colnames
  data
}

# wrapper function to read Test data
# read test data set, in a folder named "test", and data file names suffixed with "test"
readTestData <- function() {
  readData("test", "test")
}

# wrapper function to read Train data
# read test data set, in a folder named "train", and data file names suffixed with "train"
readTrainData <- function() {
  readData("train", "train")
}

# Add column of activity names to the main data
addActivity <- function(data,fnameraw) {
  #read activity lables from text file
  activity_labels <- read.table("activity_labels.txt", header=F, as.is=T, col.names=c("ActivityID", "Activity"))
  #make it a factor
  activity_labels$Activity <- as.factor(activity_labels$Activity)
  #add activity lables to main data file
  data_labeled <- merge(data, activity_labels)
  #write out raw data
  #fnameraw
  write.table(data_labeled, "samsung_raw.txt")
  #return merged data
  data_labeled
}

readData <- function(suffix, prefix) {
  fpath <- file.path(prefix, paste0("y_", suffix, ".txt"))
  y_data <- read.table(fpath, header=F, col.names=c("ActivityID"))
  
  fpath <- file.path(prefix, paste0("subject_", suffix, ".txt"))
  subject_data <- read.table(fpath, header=F, col.names=c("SubjectID"))
  
  # read the column names
  data_cols <- read.table("features.txt", header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))
  
  # read the X data file
  fpath <- file.path(prefix, paste0("X_", suffix, ".txt"))
  data <- read.table(fpath, header=F, col.names=data_cols$MeasureName)
  
  # names of subset columns required
  # note: double the \\ to pass the \ to the regexpr, Since \ is the escape character for strings in R
  toMatch <- grep(".*mean\\(\\)|.*std\\(\\)", data_cols$MeasureName)
  #toMatch <- c("mean\\(\\)[-]", "std\\(\\)[-]")
  #finaldata.frame[grep("mean\\(\\)",names(finaldata.frame)]
  
  # subset the data (done early to save memory)
  data <- data[,toMatch]
  
  # append the activity id and subject id columns
  data$ActivityID <- y_data$ActivityID
  data$SubjectID <- subject_data$SubjectID
  
  # return the data
  data
}

# From the merged data, create a tidy data set that has the average of each variable for each activity and each subject.
tidyData <- function(labeled_data) {
  #reshape2 library required for melt(), used to create a molten data fram3
  #Usage: melt(data, ..., na.rm = FALSE, value.name = "value")
  library(reshape2)
  
  # melt the dataset
  #   melt(tidy_test,id=c(names(tidy_test[1]),names(tidy_test[2]),names(tidy_test[3])),measure.vars=n)
  #   where    n  is  the  c( names(  mesaured  variables) 
  #note: try leaving off measure.vars, since the default is all the variables not in the id
  id_vars = c("ActivityID", "Activity", "SubjectID")
  measure_vars = setdiff(colnames(labeled_data), id_vars)
  melted_data <- melt(labeled_data, id=id_vars, measure.vars=measure_vars)
  
  # recast melted data
  dcast(melted_data, Activity + SubjectID ~ variable, mean)    
  
}

#script exection.....
print("Creating tidy dataset as samsung_tidy.txt")
print("data description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones")
print("data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
print("Assumes Working directory is \"UCI HAR Dataset\"")
print("run with: source(\"run_analysis.R\")")
print("start mainCreateFile")
#the folling is the main call of the script
mainCreateFile("samsung_tidy.txt","samsung_raw.txt")
print("stop mainCreateFile")
print("note: you can load data with read.table(\"samsung_tidy.txt\")")

