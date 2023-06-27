### This is the R script that runs everytime 
### Maxim opens RStudio. It is run from the 
### local <Rprofile.site> file.

### User messages ###############################
print("Running custom Rprofile build in Maxim's dropbox folder")
print("File location on this computer: ")
print(file.path(dropbox,"berkeley/projects/R/startup.r"))
################################################

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

### Personalized functions ##########################

# Function to copy working directory from clipboard:
cwd <- function() {
  pb <- readClipboard()
  tryCatch(
    expr = {
      setwd(readClipboard())
      print("Working directory changed to:")
      return(getwd())   
    },
    error = function(e) {
      print("Error! What you have in the clipboard doesn't work as a filepath. Might want to remove quotes")
      print("Here it is")
      print(readClipboard())
    }
  )
}

# Function to copy filepath from clipboard
cfp <- function() {
  my_filepath = noquote(readClipboard())
  print(c(my_filepath, " "))
  # writeClipboard(as.character(my_filepath))
}

print("Finished running startup.r")
