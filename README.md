##TidyData


Project assignment in Getting and Cleaning Data course


The script run_analysis() downloads and read experimental data from the Samsung site.


###Input
raw data files located at https://....

###Output
a file called "tidy_data_means.txt" in the R working directory

###Explanation of flow and decisions made
1.	The raw data zip file is downloaded to local disk if it is not already done. The zip file is also expanded under the R workinf directory.
2.	The training and test data files as well as files containing activity labels and subject identities and variable names are read into data frames.
3.	The data frames are combined using cbind and rbind to form a unified data frames with raw data.
4.	Several "feature names" (variable names) contains characters like '(', ')', '-', and ','that need to be removed to form names that are suitable as column names.
5.	A header is added to the data frame using the scrubbed names creating a data frame with names that are human readable and useful for R.
6.	We are only interested in means and standard deviations. Columns with names containing "mean" and "std" are extracted to a new data frame.The activity and subject ID columns are extracted too.
7.	The Activity column is edited so that the numeric value is replaced with a descripive text string.
8.	A new data frame is created for storage of means of each subject/activity combination. As there are 30 subject and 6 activities, it has 180 rows.
9.	The source frame containing all observations is scanned and all rows for the same subject/activity are used to calculate the mean in each column and written to the target data frame
10.	The resulting target data frame is written to local disk as a text file with row names removed

###How to use
1.	Place the script run_analysis() (run_analysis.R file) in the R working directory.
2.	Make sure there is no directory called 'UCI HAR Dataset' or 'tidy_data_set.txt' that could be overwritten
3.	Make sure you have Internet connection
4.	Open the script in R, source it and run it.


