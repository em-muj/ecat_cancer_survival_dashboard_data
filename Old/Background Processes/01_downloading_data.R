# Emma Muijen
# 15 November 2024
# Downloading Data for survival dashboard


# ToC:
# 1. Folder prep
# 2. Adult Cancer Survival Data
#   (a) Most up-to-date
#   (b) Previous set
# 3. Childhood Cancer Survival
#   (a) Most up-to-date
#   (b) Previous set
# 4. Cancer Survival: Index for sub-ICBs

# Uploading user inputs
source("USER INPUTS.R")

message("User inputs understood.")

# Libraries ---------------------------------------------------------------
source("Background Processes/00_required_libraries.R")

message("Packages understood.")

######################################################
# 1. Folder Prep
######################################################
source("Functions/new_folder.R")
new_folder(path_fldr)

message("New folder created.")

######################################################
# 2. Adult Cancer Survival Data
######################################################

# Most up-to-date data ----------------------------------------------------

# Downloading data from web
source("Functions/download_from_URL.R")
download_from_URL(adlt_rcnt_URL, new_fldr_path, "adult_cancer_survival_recent")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(adult_cancer_survival_recent_path)

# Uploading data to R environment
source("Functions/read_from_cancer_site.R")
read_from_cancer_site(adult_cancer_survival_recent_path, 5, "adult_cancer_survival_rcnt")

message("Recent adult cancer survival dataset downloaded.")

# Previous dataset ----------------------------------------------------

# Downloading data from web
source("Functions/download_from_URL.R") # FUNCTION NEEDS DEVELOPMENT
download_from_URL(adlt_prev_URL, new_fldr_path, "adult_cancer_survival_prev")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(adult_cancer_survival_prev_path)

# Uploading data to R environment
source("Functions/read_from_cancer_site.R")
read_from_cancer_site(adult_cancer_survival_prev_path, 5, "adult_cancer_survival_prev")

message("Previous adult cancer survival dataset downloaded.")

######################################################
# 3. Childhood Cancer Survival
######################################################

# Most up-to-date data ----------------------------------------------------

# Downloading data from web
source("Functions/download_from_URL.R")
download_from_URL(childhood_recent_URL, new_fldr_path, "childhood_survival_recent")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(childhood_survival_recent_path)

# Uploading data to R environment
source("Functions/read_from.R")
read_from(childhood_survival_recent_path, "Year of diagnosis", "childhood_survival_recent")

message("Recent childhood cancer survival dataset downloaded.")

# Previous data ----------------------------------------------------

# # Downloading data from web
# source("Functions/download_from_URL.R")
# download_from_URL(childhood_prev_URL, new_fldr_path, "childhood_survival_prev")
# 
# # Cleaning the excel sheet
# source("Functions/clean_excel_sheets.R")
# clean_excel_sheets(childhood_survival_prev_path)
# 
# # Uploading data to R environment
# source("Functions/read_from.R")
# read_from(childhood_survival_prev_path, "Year of diagnosis", "childhood_survival_prev")
# 
# message("Previous childhood cancer survival dataset downloaded.")

######################################################
# 4. Cancer Survival: Index for sub-ICBs
######################################################

# Downloading data from web
source("Functions/download_from_URL.R")
download_from_URL(survival_index_URL, new_fldr_path, "survival_index")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(survival_index_path)

# Uploading data to R environment
source("Functions/read_from.R")
read_from(survival_index_path, "Geography type", "survival_index")

message("Overall cancer survival index dataset downloaded.")

######################################################
# 5. Cancer Incidence: Registrations
######################################################

# # Downloading data from web
# source("Functions/download_from_URL.R")
# download_from_URL(incidence_URL, new_fldr_path, "incidence")
# 
# # Cleaning the excel sheet
# source("Functions/clean_excel_sheets.R")
# clean_excel_sheets(incidence_path)
# 
# # Uploading data to R environment
# source("Functions/read_from.R")
# read_from(incidence_path, "ICD10 code", "incidence")

# Downloading data
source("Functions/download_ODS.R")
download_ODS("incidence_data", paste0(new_fldr_path, "/cancer_registrations_2022_table_2_national.ods"), "Table_1_National")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(incidence_data_file_path)

# Uploading data to R environment
source("Functions/read_from.R")
read_from(incidence_data_file_path, "Geography type", "incidence")

message("Cancer incidence dataset downloaded.")


######################################################
# 6. ICBs - Longitude and Latitude
######################################################

ICB_loc <- read.csv(paste0(path_fldr, "/Integrated_Care_Boards_April_2023_LOCATIONS.csv"))

# Data found at: https://geoportal.statistics.gov.uk/datasets/ons::integrated-care-boards-april-2023-en-bsc-2/explore?location=52.954548%2C0.164306%2C6.50