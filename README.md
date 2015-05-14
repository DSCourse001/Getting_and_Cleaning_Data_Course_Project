## Getting and Cleaning Data Course Project

### Description
This a root document for "Getting and Cleaning Data" Course Project set of documents.
The goal of "Getting and Cleaning Data" Course Project is to write a program on R language that reads Source Data from text files and produces one text file with tidy data. 

General principles of tidy data is explained in [this paper](http://vita.had.co.nz/papers/tidy-data.pdf) by Hadley Wickham.

This documents also contain information about other documents related to "Getting and Cleaning Data" Course Project and steps to execute R program.

### Related Documents

1. [README.md](README.md) - This file. The root document.
1. [CodeBook.md](CodeBook.md) - Code Book which describes Source Data and steps to clear up data.
1. [run_analysis.R](run_analysis.R) - R Program which do all work.

### How to Execute R Program
The best way to execute R Programs is to use [RStudio IDE](http://www.rstudio.com). [This is direct link to download page] (http://www.rstudio.com/products/rstudio/download/).

* After you have installed R environment on your box you need to set up Working Directory.
Navigation in RStudio:
      Menu -> Session -> Set Working Directory -> Choose Directory
  Or you can execute setwd() function in the R Console.
```{r}
setwd("<Path_To_Your_Working_Directory>")
```

* Now this is a time to prepare Source Data manually by downloading from [this link] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and extracting in the Working Directory. Actually, R Program will try to download and extract archive with Source Data to your working directory (if it is not exists), but to be sure you can do this manually.

* Just source the R Program file.

```{r}
source("run_analysis.R")
```

* Script should produce "tidy_data.txt" text file in your Working Directory.