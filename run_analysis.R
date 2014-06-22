## Getting and cleaning data course project
## The script will
## 1) Merge the training and the test sets to create one data set.
## 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3) Use descriptive activity names to name the activities in the data set
## 4) Appropriately labels the data set with descriptive variable names. 
## 5) Create a second, independent tidy data set with the average of each variable for each 
##   activity and each subject and write it to the local disc. 



run_analysis <- function(){
        
        ## Part 1. a)Download the zip file and expand it on the local disk
        
        URL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        projectZip=".\\UCI_HAR_Dataset.zip"
        if(!file.exists(projectZip)){
                download.file(URL, projectZip)
                unzip(projectZip)
        }
        
        ## Part 1 b) read the required files to memory (skip all inertial as they are not required)
        activityLabels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", sep="",header=FALSE)
        features <- read.table("UCI HAR Dataset\\features.txt", sep="",header=FALSE)
        subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt", sep=",",header=FALSE)
        X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt", sep="",header=FALSE)
        Y_train <- read.table("UCI HAR Dataset\\train\\Y_train.txt", sep=",",header=FALSE)
        subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt", sep=",",header=FALSE)
        X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt", sep="",header=FALSE)
        Y_test <- read.table("UCI HAR Dataset\\test\\Y_test.txt", sep=",",header=FALSE)
        
        ## Part 1 c) combine test and train to one data set
        DF<- rbind(cbind(X_train,Y_train,subject_train),cbind(X_test,Y_test,subject_test))
        
        ## part 2) Extracts only the measurements on the mean and standard deviation for 
        ##              each measurement. Interpreted as if 'mean(' or 'std(' is part of column
        ##              name it is to be kept. 
        ##      only the column names with "mean" or "std" 
        ## improve the names in general as '-', ',' and '(' and ')' creates problems in R 
        ## (eg DF$a-b is not a working column name
        ## replace all '-',',' and '() with '_' making it readable by both people and R functions
        modFeatures <- unlist(lapply(features[,2], gsub, pattern = '["-]+|[",]+|["()]+', replacement = '_', features[,2]))
                
        names(DF) <- c(as.character(modFeatures[1:561]),"Activity","Subject_ID")
        
        extractCols <- grep("mean|std|Activity|Subject_ID", names(DF))
        DFmsOnly <- DF[,extractCols]
        
        ## 3) Use descriptive activity names to name the activities in the data set
        numberCols <- length(DFmsOnly[1,])
        numberRows <- length(DFmsOnly[,1])
        
        for (i in 1:numberRows) {
                activity <- as.character(activityLabels[DFmsOnly[i,numberCols-1], 2])
                DFmsOnly[i,numberCols-1] <- activity
        }
        ## 4) Appropriately labels the data set with descriptive variable names. 
        ## already did that in 2)
        ## 5) Create a second, independent tidy data set with the average of each variable 
        ##   for each activity and each subject.

        SF <- DFmsOnly[order(DFmsOnly$Subject_ID, DFmsOnly$Activity),]
        TF <- SF[1:180,]
        
        ## i is used loop over all 180(6 activites for 30 subjects) in target fram TF
        ## j is uded to keep track of row number in source frame (SF)
        j <- 1
        i <- 1
        ## k and l are used to find the start and end row (l-1) for each subj/act combination
        ## sumVec <- rep(0,81)
        for(e in 1:30) {
                subj <- SF[j,"Subject_ID"]
                for (a in 1:6){
                        act <- SF[j,"Activity"]
                        k <- j
                        while((j<=numberRows)&(SF[j,"Activity"]==act) &(SF[j,"Subject_ID"]==subj)){
                                j <- j+1
                                
                        }
                        l <- j
                        for(c in 1:79){
                                cellSum <- sum(SF[k:(l-1),c])
                                TF[i,c] <-cellSum/(l-k)
                                TF[i,"Activity"] <- act
                                TF[i,"Subject_ID"] <- e
                                
                        }
                        i <- i+1
                }
                        
        }
        ## write data frame to the disc
        write.table(TF,file="tidy_data_means.txt", row.names=FALSE)
        

        
        
        
}

