#' read_from_cancer_site
#' 
#' This function ignores all rows on the excel spreadsheet before the data begins. It assumes data begins
#' in the row succeeding that which contains "Cancer Site".
#'
#' @param excel_file is a string containing the path to the excel file in question.
#' @param no_tables is the number of tables from the excel file you wish to download to the R environment.
#' @param data_type is a string for the purposes of naming the resulting dataframes. Eg. "adult_cancer_2019"
#'
#' @return Returns the tables as dataframes in R
#'
#' @examples read_from_cancer_site
#' 
#' @author Emma Muijen
read_from_cancer_site <- function(excel_file, no_tables, data_type){
  
  
  for (i in 1:no_tables){
  # Reading data into R
  raw_data <- readxl::read_excel(excel_file, sheet = paste0("Table ", i), col_names = F)
  
  # Find the row number containing "Cancer Site"
  header_row <- which(apply(raw_data, 1, function(row) {
    # Convert all elements to character strings
    row <- as.character(row)
    # Check if any cell matches exactly "Cancer Site" or "Cancer site"
    any(row == "Cancer Site" | row == "Cancer site")
  }))
  
  # If "Cancer site" is found, read data from that row onwards
  if (length(header_row) > 0) {
    # Read the data again with the correct header and skip rows before the header
    data <- read_excel(excel_file, sheet = paste0("Table ", i), skip = header_row - 1, col_names = TRUE)
  } else {
    # If not found, return NULL or an empty dataframe
    data <- NULL
  }
  
  # Saving tables to environment
  assign(paste0(data_type, "_table_",i), data, .GlobalEnv)
  
  }
}