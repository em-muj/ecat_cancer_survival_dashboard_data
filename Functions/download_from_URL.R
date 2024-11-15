download_from_URL <- function(URL, new_folder_path, data_type, additional = NULL){
  
  library(readODS)
  library(openxlsx)
  
  # Extracting file name from the URL
  file_name <- basename(URL)

  # Determine the full destination file path
  dest_file_path <- file.path(new_folder_path, file_name)
  
  # Check file extension to determine download handling
  file_extension <- tools::file_ext(file_name)
  
  if (!file_extension %in% c("xlsx", "ods")) {
    stop("Unsupported file type. Please provide a URL ending with '.xlsx' or '.ods'.")
  }
  
  # Download file
  download_status <- utils::download.file(url = URL, destfile = dest_file_path, mode = "wb")
  
  # Check if the download was successful
  if (download_status == 0) {
    cat("File downloaded successfully at:", dest_file_path, "\n")
  } else {
    cat("Failed to download the file.\n")
  }
  
  assign(paste0(data_type, "path", ifelse(is.na(additional), NULL, "_"), additional), dest_file_path, .GlobalEnv)
}