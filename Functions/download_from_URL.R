#' download_from_URL
#' 
#' This function downloads either xlsx or ods files from online if a URL is supplied.
#'
#' @param URL is a string that is the URL to the relevant data file.
#' @param new_folder_path is a string that is the path to the folder for the data to be saved.
#' @param data_type is a string that specifies the data being stored (eg. adult_cancer_recent)
#'
#' @return Returns an excel file saved in the specified folder path.
#'
#' @author Emma Muijen
download_from_URL <- function(URL, new_folder_path, data_type){
  
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
  if (download_status != 0) {
    stop("Failed to download the file.")
  }
  cat("File downloaded successfully at:", dest_file_path, "\n")

  # If the file is an ODS, convert it to XLSX
  if (file_extension == "ods") {
    cat("Converting ODS to XLSX...\n")
    
    # Create a new file name for the XLSX file
    xlsx_file_path <- file.path(new_folder_path, paste0(tools::file_path_sans_ext(file_name), ".xlsx"))
    
    # Initialize a new workbook
    workbook <- createWorkbook()
    
    # Get the list of all sheet names in the ODS file
    sheet_names <- readODS::ods_sheets(dest_file_path)
    
    # Loop through each sheet and add it to the XLSX file
    for (sheet_name in sheet_names) {
      cat("Processing sheet:", sheet_name, "\n")
      
      # Read the current sheet from the ODS file
      sheet_data <- readODS::read_ods(dest_file_path, sheet = sheet_name)
      
      # Add a new worksheet to the workbook and write the data
      addWorksheet(workbook, sheetName = sheet_name)
      writeData(workbook, sheet = sheet_name, x = sheet_data)
    }
    
    # Save the workbook as an XLSX file
    saveWorkbook(workbook, file = xlsx_file_path, overwrite = TRUE)
    
    cat("File converted to XLSX with all sheets at:", xlsx_file_path, "\n")
    
    dest_file_path <- xlsx_file_path
    
    # Load the workbook
    wb <- openxlsx::loadWorkbook(dest_file_path)

    # Current sheet names
    # sheet_names <- openxlsx::getSheetNames(dest_file_path)

    # Renaming sheets
    for (name in sheet_names) {
      if (grepl("^Table_\\d+$", name)) {
        # Extract the number and rename the sheet
        new_name <- gsub("_", " ", name)
        renameWorksheet(wb, sheet = name, newName = new_name)
    }
    }
    
    # Save the workbook with the new tab names
    saveWorkbook(wb, file = dest_file_path, overwrite = TRUE)
    
  }
  
  assign(paste0(data_type, "_path"), dest_file_path, .GlobalEnv)
  
  # NEED TO DELETE SOME ROWS AUTOMATICALLY
  # WOULD LIKE TO DELETE THE REMAINING ODS IN FOLDER
}