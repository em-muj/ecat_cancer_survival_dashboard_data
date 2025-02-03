# Emma Muijen
# 21 January 2025

# Second script in a series to prepare data for ECAT Survival Dashboard

# RUN THIS SCRIPT ONE STEP AT A TIME. IF YOU DISCOVER ISSUES, VISIT THE CORRESPONDING SCRIPT SAVED IN "BACKGROUND PROCESSES" AND "FUNCTIONS" FOLDERS.
# THERE SHOULD NOT BE ANY NEED TO MAKE CHANGES TO THIS SCRIPT.

# LIBRARIES ---------------------------------------------------------------

source("Background Processes/00_required_libraries.R") # This script will download the libraries necessary for the next steps.

# CREATING NEW FOLDER FOR RAW DATA ----------------------------------------

source("Functions/new_folder.R")
new_folder(path_fldr) # This step will create a new folder in the survival dashboard data folder linked, labelled with today's date.


# DOWNLOADING ADULT SURVIVAL DATA -----------------------------------------

# Downloading data from web
source("Functions/download_from_URL.R")
download_from_URL(adlt_rcnt_URL, new_fldr_path, "adult_cancer_survival_recent")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(adult_cancer_survival_recent_path)

# Uploading data to R environment
source("Functions/read_from_cancer_site.R")
read_from_cancer_site(adult_cancer_survival_recent_path, 5, "adult_cancer_survival_rcnt")


# DOWNLOADING CHILDHOOD SURVIVAL DATA -------------------------------------

# Downloading data from web
source("Functions/download_from_URL.R")
download_from_URL(childhood_recent_URL, new_fldr_path, "childhood_survival_recent")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(childhood_survival_recent_path)

# Uploading data to R environment
source("Functions/read_from.R")
read_from(childhood_survival_recent_path, "Year of diagnosis", "childhood_survival_recent")


# DOWNLOADING CANCER INDEX SURVIVAL DATA ----------------------------------

# Downloading data from web
source("Functions/download_from_URL.R")
download_from_URL(survival_index_URL, new_fldr_path, "survival_index")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(survival_index_path)

# Uploading data to R environment
source("Functions/read_from.R")
read_from(survival_index_path, "Geography type", "survival_index")


# DOWNLOADING CANCER INCIDENCE DATA ---------------------------------------

# Downloading data
source("Functions/download_ODS.R")
download_ODS("incidence_data", paste0(path_fldr, "/", registration_data))#, "Table_1")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(incidence_data_file_path)

# Uploading data to R environment
source("Functions/read_from_incidence.R")
read_from_incidence(incidence_data_file_path, "ICD10 code", "incidence") # This may produce some errors. As long as incidence_table_0 has been uploaded, this is not a problem.


# DOWNLOADING ICB LOCATION DATA -------------------------------------------

ICB_loc <- utils::read.csv(paste0(path_fldr, "/",ICB_loc_name))


# INTERNATIONAL COMPARISONS -----------------------------------------------

# Only run the below if you would like to use R to arrange the international data and you have read the instructions in the "01_links_to_data.R" script.

file_path <- paste0(path_fldr, "/", international)

adult <- readxl::read_excel(file_path, sheet = "Adult 5 yr net survival for R")

childhood <- readxl::read_excel(file_path, sheet = "Childhood 5 yr survival for R")


adult_historic <- readxl::read_excel(file_path, sheet = "Historical adult for R")

childhood_historic <- readxl::read_excel(file_path, sheet = "Historical childhood for R")
