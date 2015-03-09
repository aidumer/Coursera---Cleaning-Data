This repo contains my approach to the course project for Coursera’s “Cleaning Data” course.

**Raw Data**:

The raw data referenced is found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
This contains data on 561 variables for 30 subjects, which split into 2 separate datasets, denoted as “Train,” and “Testing.” The 561 variables pertain to 3-axial linear acceleration and 3-axial angular velocity derived from smartphone data. The 30 subjects each perform 6 activities repeatedly. These 6 activities are found in the “activity labels” dataset. 

**Project Objective**:
The attached R script will perform the following:

1. Merge all separate datasets into 1 final dataset.
2. Keep only the variables pertaining to the measurements of mean and standard deviation.
3. Apply the appropriate activity labels to each individual subject’s record.
4. Simplify the existing variable names.
5. Produce a “tidy” dataset that contains the overall means of variables remaining in Step2, grouped by subject and activity. Thus, since each of the 30 subjects perform 6 activities, the final dataset will contain 180 records.
    
    
**The dataset created in Step 5 is written to a text file, named “tidy_data.txt.”**

**Please refer to the CodeBook.md for greater detail regarding the variables and features of the data set.**


