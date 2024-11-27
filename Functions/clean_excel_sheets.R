#' clean_excel_sheets
#' 
#' Function to clean excel sheets by removing null rows
#'
#' @param file_path is the path to the excel file being cleaned
#'
#' @return returns excel file with no more null rows
#' 
#' @author Emma Muijen

clean_excel_sheets <- function(file_path) {
  
  # Load the workbook
  wb <- openxlsx::loadWorkbook(file_path)
  
  # Get all sheet names
  sheet_names <- openxlsx::getSheetNames(file_path)
  
  # Iterate through each sheet
  for (sheet_name in sheet_names) {
    
    # Read the sheet into a dataframe without setting column names initially
    raw_data <- readxl::read_excel(file_path, sheet = sheet_name, col_names = FALSE)
    
    # Remove rows that are entirely null (all NA or empty strings)
    cleaned_data <- raw_data %>%
      dplyr::filter(!apply(., 1, function(row) all(is.na(row) | trimws(row) == "")))
    
    # Clear the existing worksheet
    openxlsx::removeWorksheet(wb, sheet_name)
    # Add a cleaned worksheet with the same name
    openxlsx::addWorksheet(wb, sheet_name)
    # Write cleaned data to the worksheet
    openxlsx::writeData(wb, sheet_name, cleaned_data)
  }
  
  # Save the cleaned workbook, overwriting the original file
  openxlsx::saveWorkbook(wb, file_path, overwrite = TRUE)
}