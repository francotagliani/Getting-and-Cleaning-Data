The run_analysis.R script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition.

    Download the dataset: Dataset downloaded and extracted under the folder called UCI HAR Dataset (inside the data folder)

    Assign each data to variables
        features <- features.txt : 561 rows, 2 columns
                The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.
        activities <- activity_labels.txt : 6 rows, 2 columns
                List of activities performed when the corresponding measurements were taken and its codes (labels)
        subject_test <- test/subject_test.txt : 2947 rows, 1 column
                contains test data of 9/30 volunteer test subjects being observed
        x_test <- test/X_test.txt : 2947 rows, 561 columns
                contains recorded features test data
        y_test <- test/y_test.txt : 2947 rows, 1 columns
                contains test data of activities’code labels
        subject_train <- test/subject_train.txt : 7352 rows, 1 column
                contains train data of 21/30 volunteer subjects being observed
        x_train <- test/X_train.txt : 7352 rows, 561 columns
                contains recorded features train data
        y_train <- test/y_train.txt : 7352 rows, 1 columns
                contains train data of activities’code labels

    Using rbind() function the training and datasets for each (X,Y,subject) structure are merged, obtaining:
        - X (10299 rows, 561 columns).
        - Y (10299 rows, 1 column).
        - subject (10299 rows, 1 column).
        
    Finally, in order to obtain a unique dataset, the cbind() function is used to merge all three previously presented datasets (X,Y,subject):
        dataset (10299 rows, 563 column)

    It was requested to extract only the mean and standard deviation for each measurement, this is achieved by subsetting "dataset" using the select function.
        tidy_dataset (10299 rows, 88 columns) is created.
    
    Further on it was requested to change the activity code number with the corresponding activity name from the activity_labels.txt. This was achieved with the following command:
        tidy_dataset$code <- activities[tidy_dataset$code, 2]

    In order to appropriately name each column the next substitutions were done for the names(tidy_dataset)
        Acc             -->     Accelerometer
        Gyro            -->     Gyroscope
        BodyBody        -->     Body
        Mag             -->     Magnitude
        starts with f   -->     Frequency
        starts with t   -->     Time
        mean            -->     Mean
        std             -->     STD
        Freq            -->     Frequency
        Activity_Name
        Subject_Id
        
        Finally, the words were separated with a "_"

    It was requested to create a second dataset based on the previous one with the average of each variable for each activity and each subject, this can be found in:
        FinalData (180 rows, 88 columns)

