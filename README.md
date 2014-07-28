Course-Project
==============

Unless there are probably different opinions about what exactly a tidy dataset is, I refer to *Hadley Wickham's* [Tidy Data-Article](http://vita.had.co.nz/papers/tidy-data.pdf). Refering to *Codds* he defines tidy data in three aspects:
- Each variable forms a column.
- Each observation forms a row.
- Each type of observational unit forms a table.
I also did a lot of reading in the [forum](https://class.coursera.org/getdata-005/forum/thread?thread_id=23) with the very helpful hints from *David Hood*. So therefore, I decided for example to leave the features-Variables as in the original dataset (e.g. no further transformation) and only extract those which are mean or standard deviation of a value.
Long story short: I think it's easier to make a "scratch" how the target dataset should look like. According to the above mentioned paper and a lot of reading in our coursera-forum I decided to choose this structure:

| GROUP     | SUBJECT | ACTIVITY  | FEATURE1  | FEATURE2  | ... |
| --------- |:-------:| :--------:| :-------: | :-------: | --- |
| Test      | 1       | Sitting   | 1.435     | -0.344    | ... |
| Training  | 2       | Lying     | 0.565     |  1.344    | ... |
| ...       | ...     | ...       | ...       | ...       | ... |

This datastructure has the same 
Although this dataset has more than one of the same observation in it, I define it as tidy, because the assignment demands just 1 csv-File. So Normalisation (like in relational databases) was out of question here.
So how have I done it?

I started with reading in all relevant files:
- X_test.txt (a)
- X_train.txt (b)
- subject_test.txt (c)
- subject_train.txt (d)
- y_test.txt (e)
- y_train.txt (f)
- features.txt (g)
- activity_labelst.txt (h)

The difficulty here was that the files a, b, e, f had double whitespaces in it, which made it impossible to simply use read.csv or read.table. After some research I found an approach on [stackoverflow](http://stackoverflow.com/a/20807399)  which I used (honestly not really understood, but worked for me). 

Then I renamed the columns in c, d, e and f. This early renaming ensures that these files can be cbinded with the a and b. (Otherwise all files have a Variable V1.)
I then easily cbinded f with b and e with a (the order was not unimportant because it made sure that the Activity and Subject-Variables goes at the beginning and not at the end of 561 variables).

I did the same with the subject-Variables, e.g.: cbinding c, resp. c with the newly merged data.frames above.

I then decided to insert a Group-Variable which saves wether the data were training or test data.

The next two steps were
- Labeling the variable Activity with labels derrived from h and
- Renaming the columns (I decided to choose the original columnnames from g because of their clear meaning.)

The final part was about extracting all the desired columns *(#3: "Extract only the measurements on the mean and standard deviation for each measurement.)* I did this by simply searching for columnnames with the character-sequence *mean()* or *std()* in it. I did this by looping over all 561 Variables with the grepl-Function. But before this I extracted the activity-, subject and group-variable manually (again to made sure that these variables will be at the beginning of the data.frame).

The result was the tidydata set as defined above.

