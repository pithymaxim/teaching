# Install the bcuse package

The `bcuse` package has a lot of useful example datasets. [List of datasets](http://fmwww.bc.edu/ec-p/data/wooldridge/datasets.list.html).

Run this line to install `bcuse`
```
ssc install bcuse
```
To check if it worked, load a dataset:
```
bcuse mlb1, clear
```
This loads a baseball dataset. If you type `sum` you should see

```
 sum

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
      salary |        353     1345672     1407352     109000    6329213
     teamsal |        353    3.08e+07     8722411    8854000   4.29e+07
          nl |        353    .4759207    .5001287          0          1
       years |        353    6.325779    3.880142          1         20
       games |        353    648.4249    538.6975          7       2729
-------------+---------------------------------------------------------
...
```
