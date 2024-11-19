#' read_from
#' 
#' This function interprets a dataframe from an excel worksheet from a row containing a single specified entry.
#'
#' @param file_path is a string of the path of the excel worksheet
#' @param key_column is a string that is the entry that the rows of the df should begin from.
#' @param table_name is a string that is the name of the table saved to the global environment.
#'
#' @return returns dataframes from the workbook to the global environment, starting with the THIRD SHEET in the workbook.
#' 
#' @author Emma Muijen
read_from <- function(file_path, key_column, table_name){
  
  # Get all sheet names
  sheet_names <- readxl::excel_sheets(file_path)
  
  # STARTING WITH THIRD SHEET - CHANGE THIS IF THIS IS NOT THE CASE IN THE WORKBOOK
  
  for (i in 3:length(sheet_names)){
  
    # Read sheet into df
    raw_data <- read_excel(file_path, sheet = sheet_names[i], col_names = FALSE)
    
    # Find the row number containing "Example words"
    header_row <- which(apply(raw_data, 1, function(row) any(grepl(key_column, row))))
    
    # If key_column is found, read data from that row onwards
    if (length(header_row) > 0) {
      # Read the data again with the correct header and skip rows before the header
      data <- read_excel(file_path, sheet = sheet_names[i], skip = header_row - 1, col_names = TRUE)
    } else {
      # If not found, return NULL or an empty dataframe
      data <- NULL
    }
    
    # Saving tables to environment
    assign(paste0(table_name, "_table_",i-2), data, .GlobalEnv)
  }
}