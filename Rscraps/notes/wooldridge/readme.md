# Install the Wooldridge package in R

The Wooldridge package comes with some useful example datasets.

```R
# Install it
install.packages("wooldridge")
# Load it
library(wooldridge)
# Open a specific data set
data(mlb1)
# Now you should be able to see the `mlb1’ data set
head(mlb1)
```

The output of the `head()` command should be:

```
   salary  teamsal nl years games atbats runs hits doubles triples hruns
1 6329213 38407380  1    12  1705   6705 1076 1939     320      67   231
2 3375000 38407380  1     8   918   3333  407  863     156      38    73
3 3100000 38407380  1     5   751   2807  370  840     148      18    46
4 2900000 38407380  1     8  1056   3337  405  816     143      18   107
5 1650000 38407380  1    12  1196   3603  437  928      19      16   124
6  700000 38407380  1    17  2032   7489 1136 2145     270     142    40
  rbis bavg  bb   so sbases fldperc frstbase scndbase shrtstop thrdbase
1  836  289 619  948    314     989        0        1        0        0
2  342  259 137  582    133     968        0        0        1        0
```
