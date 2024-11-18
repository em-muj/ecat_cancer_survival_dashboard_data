# Emma Muijen
# 15 November 2024
# Downloading Data for survival dashboard


# ToC:
# 1. Folder prep
# 2. Adult Cancer Survival Data
#   (a) Most up-to-date
#   (b) Previous set

# Uploading user inputs
source("00_user_inputs.R")


# Libraries ---------------------------------------------------------------
library(readxl)
library(lubridate)
library(stringr)
library(tidyverse)
library(openxlsx)

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
clean_excel_sheets(adult_cancer_survival_path)

# Uploading data to R environment
source("Functions/read_from_cancer_site.R")
read_from_cancer_site(adult_cancer_survival_path, 5, "adult_cancer_survival_rcnt")


# Previous dataset ----------------------------------------------------

# Downloading data from web
source("Functions/download_from_URL.R") # FUNCTION NEEDS DEVELOPMENT
download_from_URL(adlt_prev_URL, new_fldr_path, "adult_cancer_survival_prev")

# Cleaning the excel sheet
source("Functions/clean_excel_sheets.R")
clean_excel_sheets(adult_cancer_survival_path_prev)

# Uploading data to R environment
source("Functions/read_from_cancer_site.R")
read_from_cancer_site(adult_cancer_survival_path_prev, 5, "adult_cancer_survival_prev")


######################################################
# 3. Cancer Survival: Index for sub-ICBs
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