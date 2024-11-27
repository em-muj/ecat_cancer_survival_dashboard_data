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


# Libraries ---------------------------------------------------------------
source("Background Processes/00_required_libraries.R")

######################################################
# 1. Folder Prep
######################################################
source("Functions/new_folder.R")
new_folder(path_fldr)

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

# Previous data ----------------------------------------------------

# Downloading data from web
source("Functions/download_from_URL.R")
download_from_URL(childhood_prev_URL, new_fldr_path, "childhood_survival_prev")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(childhood_survival_prev_path)

# Uploading data to R environment
source("Functions/read_from.R")
read_from(childhood_survival_prev_path, "Year of diagnosis", "childhood_survival_prev")

######################################################
# 4. Cancer Survival: Index for sub-ICBs
######################################################

# Downloading data from web
source("Functions/download_from_URL.R")
download_from_URL(survival_index_URL, new_fldr_path, "survival_index")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(survival_index_path) # ISSUE AT THIS STEP WHERE ENGLAND RECORDS DELETED

# Uploading data to R environment
source("Functions/read_from.R")
read_from(survival_index_path, "Geography type", "survival_index")
