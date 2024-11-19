# Emma Muijen
# 15 November 2024
# Prep for data download for survival dashboard

# USER INPUTS FOR FILES

# ToC:
# 1. User Details
# 2. Adult Cancer Survival Data
#   (a) Most up-to-date
#   (b) Previous set
# 3. Childhood Cancer Survival
#   (a) Most up-to-date
#   (b) Previous set
# 4. Cancer survival: Index for sub-ICBs

######################################################
# 1. User Details
######################################################
# User must supply information on location of SharePoint folder for dashboard.
# Please provide computer path to folder below
path_fldr <- "C:/Users/Emma.Muijen/Department of Health and Social Care/NW027 - Performance Insight/ANALYSTS/Cancer/Survival and Diagnosis/Dashboard/Data"

######################################################
# 2. Adult Cancer Survival Data
######################################################


# (a) Up-To-Date Adult Cancer Survival Data ----------------------------------------------

# User must supply information on the most up-to-date adult cancer survival data and the preceding data

# Please paste URL to most recent adult cancer survival data tables (you can find this by
# going to the webpage and right clicking the file, choosing "copy link address"):
adlt_rcnt_URL <- "https://files.digital.nhs.uk/A9/647D6D/adult_cancer_survival_2016_2020.xlsx"

# (b) Previous Adult Cancer Survival Data ----------------------------------------------

# Please paste URL to previous adult cancer survival data tables (you can find this by
# going to the webpage and right clicking the file, choosing "copy link address"):
adlt_prev_URL <- "https://files.digital.nhs.uk/A1/FC58F2/adult_cancer_survival_2015_2019.ods"

######################################################
# 3. Childhood Cancer Survival
######################################################

# (a) Up-To-Date Childhood Cancer Survival Data ----------------------------------------------

# Please paste URL to most recent childhood cancer survival tables (you can find this by
# going to the webpage and right clicking the file, choosing "copy link address"):
childhood_recent_URL <- "https://files.digital.nhs.uk/CE/3C0052/childhood_cancer_survival_2002_2020.xlsx"

# (b) Previous Childhood Cancer Survival Data ----------------------------------------------

# Please paste URL to previous childhood cancer survival tables (you can find this by
# going to the webpage and right clicking the file, choosing "copy link address"):
childhood_prev_URL <- "https://files.digital.nhs.uk/D4/78B4DD/childhood_cancer_survival_2002_2019.ods"

######################################################
# 4. Cancer survival: Index for sub-ICBs
######################################################

# Please paste URL to most recent adult cancer survival index tables (you can find this by
# going to the webpage and right clicking the file, choosing "copy link address"):
survival_index_URL <- "https://files.digital.nhs.uk/6D/2C8DEA/Index_reference_tables20052020.xlsx"

#######################
# END USER INPUT - NOW RUN MAIN FILE
#######################
