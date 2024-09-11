infix str stcode 1-2 ///
      int stnumber 3-4 ///
      str ori 5-11 ///
      int popgroup 12-13 ///
      byte division 14 ///
      int month 15-16 ///
      int year 17-20 ///
      long pop 21-27 ///
      int county 28-30 ///
      int smsa 31-33 ///
      byte smsaind 34 ///
      str agname 35-58 ///
      str stname 59-63 ///
      byte homtype 64 ///
      byte situat 65 ///
      int incnum 66-68 ///
      int vctcnt 69-70 ///
      int offcnt 71-72 ///
      int vicage 73-74 ///
      byte vicsex 75 ///
      byte vicrace 76 ///
      int offage 77-78 ///
      byte offsex 79 ///
      byte offrace 80 ///
      int weapon 81-82 ///
      int relation 83-84 ///
      int circum 85-86 ///
      byte subcirc 87 ///
      float wtus 88-93 ///
      float wtst 94-101 ///
      byte wtimpus 102 ///
      byte wtimpst 103 ///
      using "raw\04179-0002-Data.txt", clear

label data "Made in import_ucr on ${S_DATE} by `c(username)'"
save inter/ucr_import.dta, replace
