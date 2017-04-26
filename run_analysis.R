## considering zip file is downloaded and saved under working directory
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

library(data.table)

# train data
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)

# test data
subjectTest = read.table('./test/subject_test.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)

# features and activity
features<-read.table("features.txt")
activity<-read.table("activity_labels.txt")

#Part1: merges train and test data in one dataset (full dataset at the end)
xDataSet <- rbind(xTrain, xTest)
yDataSet <- rbind(yTrain, yTest)
subjectDataSet <- rbind(subjectTrain, subjectTest)

#Dimension of new datasets:
  
  dim(xDataSet)
## [1] 10299   561
dim(yDataSet)
## [1] 10299     1
dim(subjectDataSet)
## [1] 10299     1
 

# part2: Extracts only the measurements on the mean and standard deviation for each measurement.

index<-grep("mean\\(\\)|std\\(\\)", features[,2]) # getting features indeces which contain mean() and std() in their name
length(index)# count of features
## [1] 66

xDataSet<-xDataSet[,index] # getting only variables with mean/stdev
dim(xDataSet)  # checking dim of subset
## [1] 10299    66


# part3: Uses descriptive activity names to name the activities in the data set
yDataSet[,1]<-activity[yDataSet[,1],2] ## replacing numeric values with lookup value from activity.txt; won't reorder Y set
head(yDataSet) 
##         V1
## 1 STANDING
## 2 STANDING
## 3 STANDING
## 4 STANDING
## 5 STANDING
## 6 STANDING


# Part4: Appropriately labels the data set with descriptive variable names.

names<-features[index,2] ## getting names for variables

names(xDataSet)<-names ## updating colNames for new dataset
names(subjectDataSet)<-"SubjectID"
names(yDataSet)<-"Activity"

CleanedData<-cbind(subjectDataSet, yDataSet, xDataSet)
head(CleanedData[,c(1:4)]) ## first 5 columns

##   SubjectID Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y
## 1         2 STANDING         0.2571778       -0.02328523
## 2         2 STANDING         0.2860267       -0.01316336
## 3         2 STANDING         0.2754848       -0.02605042
## 4         2 STANDING         0.2702982       -0.03261387
## 5         2 STANDING         0.2748330       -0.02784779
## 6         2 STANDING         0.2792199       -0.01862040

# Part5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

CleanedData<-data.table(CleanedData)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity'] # features average by Subject and by activity
dim(TidyData)
## [1] 180  68

write.table(TidyData, file = "Tidy.txt", row.names = FALSE)
#First 12 rows and 5 columns in Tidy dataset:
  
head(TidyData[order(SubjectID)][,c(1:4), with = FALSE],12) 
##     SubjectID           Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y
##  1:         1           STANDING         0.2789176      -0.016137590
##  2:         1            SITTING         0.2612376      -0.001308288
##  3:         1             LAYING         0.2215982      -0.040513953
##  4:         1            WALKING         0.2773308      -0.017383819
##  5:         1 WALKING_DOWNSTAIRS         0.2891883      -0.009918505
##  6:         1   WALKING_UPSTAIRS         0.2554617      -0.023953149
##  7:         2           STANDING         0.2779115      -0.018420827
##  8:         2            SITTING         0.2770874      -0.015687994
##  9:         2             LAYING         0.2813734      -0.018158740
## 10:         2            WALKING         0.2764266      -0.018594920
## 11:         2 WALKING_DOWNSTAIRS         0.2776153      -0.022661416
## 12:         2   WALKING_UPSTAIRS         0.2471648      -0.021412113
