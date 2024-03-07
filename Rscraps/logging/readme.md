# Logging in R #

R doesn't have any innate ways to make a Stata-style log (that is, capturing the comments, commands, and output). Here are two ways to do it.

**Warning for RStudio users**: By default it indents the `.Rmd` code when you copy and paste it. The solution is to uncheck [Auto-indent code after paste](https://raw.githubusercontent.com/pithymaxim/teaching/main/Rscraps/logging/uncheck.png) in Tools > Global Options.

## 1. R Markdown ##

The R markdown code in [`markdown_example.Rmd`](https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/markdown_example.Rmd) makes [this html file](https://htmlpreview.github.io/?https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/markdown_example_output.html). The strengths are that this makes a beautiful HTML or PDF file. (Windows machines have trouble making the PDF.) The downside is that it requires more syntax to delimit code vs. text.

### Slick R Markdown ###

For a very slick template for .Rmd code, [`slick_markdown.Rmd`](https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/slick_markdown.Rmd) makes this [HTML output](https://pithymaxim.github.io/slick_markdown.html) with a beautiful table of contents. 



### Inline code in Markdown ###

In general, you should avoid typing out your numeric results by hand. Markdown makes this easy. You can run R code inside your text by putting \`r \[your code here\] \`. So just the two ticks and the lowercase "r" at the beginning. Here is some example Rmd code:

      ```{r}
      myreg = lm(gear ~ mpg + disp, data = mtcars)
      print(myreg)
      ```

      The coefficient on **miles per gallon** in my regression is `r myreg$coefficients["mpg"]`.

      The rounded coefficient is `r round(myreg$coefficients["mpg"], digits=4)`.

      To provide more interpretation, I'll say that if miles per gallon increases by 10, the outcome **gear** is predicted to increase by `r round(myreg$coefficients["mpg"] * 10, digits=3)`.

      How many observations were there in my regression? I'm glad you asked. There were `r dim(myreg$model)[1]` observations in the regression.

Here is the output:

<img width="594" alt="image" src="https://user-images.githubusercontent.com/6835110/230498280-42ce9dc4-6891-4683-993b-0f071ba9d98e.png">


## 2. Using source() and sink() ## 

Say you have an R script saved as [`test_script.r`](https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/test_script.r). Then if you run that code using `source()` and enclose it in a `sink()` command, you will get the desired log output. `sink()` is R's "log" command. `source()` is a way to run entire R scripts using their filename.

      sink("mylog.txt")
      source('test_script.r', echo = TRUE, max.deparse.length=Inf)
      sink()
      
This makes [`mylog.txt`](https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/mylog.txt). Note that it's still just a simple text file, but it shows all the comments, commands, and output. Comments (###) are used to put the title at the top and to demarcate the questions. Note that with this option you cannot show plots, although Markdown can.
