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
