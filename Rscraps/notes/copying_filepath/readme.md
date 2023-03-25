# Copying a filepath in Windows #

In Windows, R gets tripped up on the backslashes used in the default filepath. So you can't copy and paste a Windows filepath.

With the function below, if you copy a Windows filepath, you can run `cwd()` to change the working directory to it.

```R
cwd <- function() {
  pb <- readClipboard()
  tryCatch(
    expr = {
      setwd(readClipboard())
      print("Working directory changed to:")
      return(getwd())   
    },
    error = function(e) {
      print("Error! What you have in the clipboard doesn't work as a filepath: ")
      print(readClipboard())
    }
  )
}
```
