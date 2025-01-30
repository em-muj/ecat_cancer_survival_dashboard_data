# Emma Muijen
# 21 January 2025

# First script in a series to prepare data for ECAT Survival Dashboard

# MAKE YOUR USER INPUT CHANGES AND RUN THIS SCRIPT FIRST


###########################################################################
# USER INPUTS - PLEASE CHANGE THESE ---------------------------------------
###########################################################################




# PATH TO FOLDER FOR DATA -------------------------------------------------

# User must supply information on location of SharePoint folder for dashboard.
# Please provide computer path to folder below

path_fldr <- "C:/Users/Emma.Muijen/Department of Health and Social Care/NW027 - Performance Insight/ANALYSTS/Cancer/Survival and Diagnosis/Dashboard/Data"


# ADULT CANCER SURVIVAL DATA ----------------------------------------------

# User must supply information on the most up-to-date adult cancer survival data. This must have an xlsx or ods file extension.

# Please paste URL to most recent adult cancer survival data tables (you can find this by
# going to the webpage and right clicking the file, choosing "copy link address"):

adlt_rcnt_URL <- "https://files.digital.nhs.uk/A9/647D6D/adult_cancer_survival_2016_2020.xlsx"



# CHILDHOOD CANCER SURVIVAL DATA ------------------------------------------

# User must supply information on the most up-to-date childhood cancer survival data. This must have an xlsx or ods file extension.

# Please paste URL to most recent childhood cancer survival tables (you can find this by
# going to the webpage and right clicking the file, choosing "copy link address"):
childhood_recent_URL <- "https://files.digital.nhs.uk/CE/3C0052/childhood_cancer_survival_2002_2020.xlsx"



# CANCER SURVIVAL INDEX ---------------------------------------------------

# User must supply information on the most up-to-date childhood cancer survival data. This must have an xlsx or ods file extension.

# Please paste URL to most recent adult cancer survival index tables (you can find this by
# going to the webpage and right clicking the file, choosing "copy link address"):
survival_index_URL <- "https://files.digital.nhs.uk/6D/2C8DEA/Index_reference_tables20052020.xlsx"



# CANCER INDIDENCE - REGISTRATIONS ----------------------------------------

# Visit following website: https://digital.nhs.uk/data-and-information/publications/statistical/cancer-registration-statistics/england-2022
# Download "Cancer registration statistics, England 2022 data tables - OpenDocument spreadsheet" (or more recent equivalent)
# Save cancer_registrations_2022_table_1_national to data folder (path_fldr specified in line 21 of this script by user above)

# Please enter the updated name of the file below (INCLUDING THE FILE EXTENSION):
registration_data <- "Cancer_Registrations_2018_Data_Tables_GW-1286.ods"


# ICB LOCATION ------------------------------------------------------------
# This data provides the longitudinal and latitudinal location of ICBs.
# If this is not thought to have changed, the below does not have to be updated and can just be run.

# If the locations have been dated, please download the csv with long and lat for each ICB. 2023 data was found here:  https://geoportal.statistics.gov.uk/datasets/ons::integrated-care-boards-april-2023-en-bsc-2/explore?location=52.954548%2C0.164306%2C6.50
# Save this csv in the path_fldr (specified by the user in line 21 of this script.)

# Please enter the updated name of the file below (INCLUDING THE FILE EXTENSION):
ICB_loc_name <- "Integrated_Care_Boards_April_2023_LOCATIONS.csv"



# INTERNATIONAL COMPARISONS -----------------------------------------------

# This data is extracted from the Concord data. At the time of writing, the most up-to-date data was 2010-2014.
# The "international_comparisons.xlsx" data saved on the SharePoint, with path: Department of Health and Social Care/NW027 - Performance Insight/ANALYSTS/Cancer/Survival and Diagnosis/Dashboard/Data
# had tabs ending with "for R" extracted from the data.
# Note the "historic" tabs have data from the previous Concord dataset, (2000-2009)
# If the Concord dataset is updated, this historic data would be what is used currently, 2010-2014 data

# If you would like to arrange the data using R, then please enter the name of the file with the same data and tab names as those ending in "for R" in the previous file.
# This file should be saved in the path_fldr (specified by the user in line 21 of this script)
international <- "international_comparisons.xlsx"
