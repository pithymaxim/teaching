# Logging in R #

R doesn't have any innate ways to make a Stata-style log (that is, capturing the comments, commands, and output). Here are two ways to do it.

## R Markdown ##

The R markdown code in `markdown_example.Rmd` makes [this html file](https://htmlpreview.github.io/?https://github.com/pithymaxim/teaching/blob/main/Rscraps/logging/markdown_example_output.html). The strengths are that this makes a beautiful HTML or PDF file. The downside is that it requires more syntax to delimit code vs. text.

## Using source() and sink() ## 

Say you have an R script saved as `test_script.r`. Then if you run that code using `source()` and enclose it in a `sink()` command, you will get the desired log output.

      sink("mylog.txt")
      source('test_script.r', echo = TRUE)
      sink()
      
This makes `mylog.txt` contain:

        > # Step 1: Some math:
        > 1+2
        [1] 3

So when you're done writing your code, you can run the sink-source-sink chunk above to get log with everything in it. This is less pretty than Markdown but doesn't require additional syntax.
