download_ODS <- function(data_name, file_path, sheet_name){
  
  # Check if the readODS package is installed
  if (!requireNamespace("readODS", quietly = TRUE)) {
    stop("The 'readODS' package is required but not installed. Please install it with install.packages('readODS').")
  }
  
  # Check if the openxlsx package is installed
  if (!requireNamespace("openxlsx", quietly = TRUE)) {
    stop("The 'openxlsx' package is required but not installed. Please install it with install.packages('openxlsx').")
  }
  
  # Create the path for the new xlsx file
  xlsx_file_path <- gsub("\\.ods$", ".xlsx", file_path)
  
  ###########################################################################
  # Initialize a new workbook
  workbook <- openxlsx::createWorkbook()
  
  # Get the list of all sheet names in the ODS file
  sheet_names <- readODS::ods_sheets(file_path)
  
  # Loop through each sheet and add it to the XLSX file
  for (sheet_name in sheet_names) {
    cat("Processing sheet:", sheet_name, "\n")
    
    # Read the current sheet from the ODS file
    sheet_data <- readODS::read_ods(file_path, sheet = sheet_name)
    
    # Add a new worksheet to the workbook and write the data
    openxlsx::addWorksheet(workbook, sheetName = sheet_name)
    openxlsx::writeData(workbook, sheet = sheet_name, x = sheet_data)
  }
  
  # Save the workbook as an XLSX file
  openxlsx::saveWorkbook(workbook, file = xlsx_file_path, overwrite = TRUE)
  
  #cat("File converted to XLSX with all sheets at:", xlsx_file_path, "\n")

  # Load the workbook
  #wb <- openxlsx::loadWorkbook(xlsx_file_path)
  
  
  
  
  ############################################################################
  # # Save the dataframe as an xlsx file
  # openxlsx::write.xlsx(data, file = xlsx_file_path)
  
  # Output the path of the new xlsx file to the global environment
  assign(paste0(data_name, "_file_path"), xlsx_file_path, envir = .GlobalEnv)
  
  message(paste(paste0(data_name," saved at "), xlsx_file_path, "successfully."))
}
