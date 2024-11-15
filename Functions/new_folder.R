#' new_folder
#'
#' @param path is a string that leads to the relevant SharePoint folder 
#'
#' @return Creates a new folder.
#'
#' @author Emma Muijen
new_folder <- function(path){
  
  # Defining folder base name
  base_fldr_name <- "survival_dashboard_data_update"
  
  # Defining date
  today <- format(Sys.Date(), "%Y-%m-%d")
  
  # Full folder name
  fldr_name <- paste0(base_fldr_name,"_", today)
  
  # Folder path
  fldr_path <- file.path(paste0(path, "/", fldr_name))
  
  # Check if folder already exists
  if (file.exists(fldr_path)) {
    # If it exists, remove the folder and its contents
    unlink(fldr_path, recursive = TRUE)
  }
  
  # Create the new folder
  dir.create(fldr_path)
  
  assign("new_fldr_path", fldr_path, .GlobalEnv)
  
  # Print message
  return(cat("Folder created at:", fldr_path, "\n"))
  
  
}