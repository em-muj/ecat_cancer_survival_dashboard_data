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
download_from_URL(adlt_rcnt_URL, new_fldr_path, "adult_cancer_survival_")

# Uploading data to R environment

for (i in 1:5){
  df <- readxl::read_excel(adult_cancer_survival_path, sheet = paste0("Table ", i))
  
  colnames(df) <- df %>% slice(2) %>% unlist() %>% unname() %>% as.character()
  df <- df %>% tail(nrow(df)-2)
  
  assign(paste0("adlt_rcnt_", i), df)
}

# Previous dataset ----------------------------------------------------

# Downloading data from web
source("Functions/download_from_URL.R") # FUNCTION NEEDS DEVELOPMENT
download_from_URL(adlt_prev_URL, new_fldr_path, "adult_cancer_survival_", "prev")

# Uploading data to R environment

for (i in 1:5){
  df <- readxl::read_excel(adult_cancer_survival_path_prev, sheet = paste0("Table ", i))
  
  colnames(df) <- df %>% slice(2) %>% unlist() %>% unname() %>% as.character()
  df <- df %>% tail(nrow(df)-2)
  
  assign(paste0("adlt_prev_", i), df)
}
adlt_rcnt_1 <- readxl::read_excel(adult_cancer_survival_path, sheet = "Table 1")