# Loading packages by default #

Based on the guide [here](https://www.statmethods.net/interface/customizing.html).

If you're tried of running 
 ```R        
           library(rpackage)
```
every time you make a new script, you can set your `Rprofile.site` file. This is R code that is run every time you open Rstudio. 

It's in R's `etc` folder. Ro find where where the `etc` folder is, run:
```R
    normalizePath(R.home(), winslash = "/", mustWork = FALSE)
    # (If that doesn't work, just do)
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

In Windows, you might be blocked from saving any changes. To get around this, first right-click Notepad (or any othre text-editing app) and click "Run as administrator." Now you should be allowed to make changes.

Here are the lines I added to my `Rprofile.site` file. Now the packages `wooldridge` and `ggplot2` will be loaded by default. I also put a `print()` message to give the user more info. 

```R
print("Running custom Rprofile build by Jane Doe")
library(wooldridge)
library(ggplot2)
```

Now when I open RStudio I see the highlighted message below:

![image](https://user-images.githubusercontent.com/6835110/227623755-3c4d5e08-2112-48f9-8835-df6f438396b7.png)
