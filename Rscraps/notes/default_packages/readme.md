# Loading packages by default #

If you're tried of running 
 ```R       
library(rpackage)
```
every time you make a new script, you can set your `Rprofile.site` file. **This is R code that runs every time you open Rstudio.** 

It's in R's `etc` folder. To find where where the `etc` folder is, run:
```R
normalizePath(R.home())
```
In Windows, it's in this folder (or one like it):

        C:\Program Files\R\R-4.2.3\etc
 
Now you need to find the `Rprofile.site` file and edit it. The top of my `Rprofile.site` file looks like this:

    # Things you might want to change
    # options(papersize="a4")
    # options(editor="notepad")
    # options(pager="internal")
    ...

In Windows, you might be blocked from saving any changes. To get around this, first right-click Notepad (or any other text-editing app) and click "Run as administrator" and then open `Rprofile.site`. Now you should be allowed to make changes.

## A faster way to edit .Rprofile ## 

[This site](https://rstats.wtf/r-startup.html) shows that you can also edit the `.Rprofile` file with the `usethis` package. If you first install `usethis` with 

```R
install.packages("usethis")
library(usethis)
```

Then the command `usethis::edit_r_profile()` will open up the `.Rprofile` file in RStudio. Note that you may need administrator priviledge to save changes so this could throw some issues.

# What to put in the file #

Here are the lines I added to my `Rprofile.site` file. Now the packages `wooldridge`, `ggplot2`, etc will be loaded by default. And it won't show scientific notation.

```R
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print("Running custom Rprofile")
options(scipen = 999)

### Put packages here ##########################

# List of packages 
packages <- c("ggplot2","foreign",
	          "wooldridge","stargazer")

# Load packages 
for (package in packages) {
	cat("Loading package:", package, "\n")
	library(package, character.only = TRUE)
}
print("Finished running custom Rprofile")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
```
To see if it worked, close RStudio and open it again. The `print()` command confirms that my new additions to `Rprofile.site` have run, because I see it in the RStudio console:

<img src="https://user-images.githubusercontent.com/6835110/227623755-3c4d5e08-2112-48f9-8835-df6f438396b7.png" width="700">

* Note: always put a `print()` command at the very bottom! This tells you that no errors were encountered. If it doesn't reach the last print command, you'll know there was a bug.

If you're sharing your code with others, you can run this command at the top of your code. It will show all the packages you've loaded:
```R
print((.packages()))
```
The output:
```
[1] "estimatr"   "sandwich"   "lmtest"     "zoo"        "stargazer"  "stats"      "graphics"   "grDevices" 
 [9] "utils"      "datasets"   "wooldridge" "foreign"    "ggplot2"    "methods"    "base"      
 ```

Based on the guide [here](https://www.statmethods.net/interface/customizing.html).
