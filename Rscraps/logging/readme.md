# Logging in R #

R doesn't have any innate ways to make a Stata-style log (that is, capturing the comments, commands, and output). Here are two ways to do it.

## 1. R Markdown ##

The R markdown code in [`markdown_example.Rmd`](https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/markdown_example.Rmd) makes [this html file](https://htmlpreview.github.io/?https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/markdown_example_output.html). The strengths are that this makes a beautiful HTML or PDF file. The downside is that it requires more syntax to delimit code vs. text.

### Inline code in Markdown ###

In general, you should avoid typing out your numeric results by hand. Markdown makes this easy. You can run R code inside your text by putting \`r

## 2. Using source() and sink() ## 

Say you have an R script saved as [`test_script.r`](https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/test_script.r). Then if you run that code using `source()` and enclose it in a `sink()` command, you will get the desired log output. `sink()` is R's "log" command. `source()` is a way to run entire R scripts using their filename.

      sink("mylog.txt")
      source('test_script.r', echo = TRUE, max.deparse.length=Inf)
      sink()
      
This makes [`mylog.txt`](https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/mylog.txt). Note that it's still just a simple text file, but it shows all the comments, commands, and output. Comments (###) are used to put the title at the top and to demarcate the questions. Note that with this option you cannot show plots, although Markdown can.
