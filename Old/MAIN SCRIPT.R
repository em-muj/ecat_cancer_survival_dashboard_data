# Emma Muijen
# 21 November 2024
# Generating data for survival dashboard

# USER SHOULD ENSURE THEY HAVE FILLED IN THE USER INPUTS SCRIPT. THEY CAN THEN HIGHLIGHT ALL
# (CTRL + A) AND CLICK "RUN" IN THE TOP RIGHT HAND CORNER OF THIS WINDOW.

# ToC:
# 1. Downloading Data
# 2. Preparing Adult Survival Data
# 3. Preparing Childhood Cancer Survival Data
# 4. Preparing Cancer Survival: Index for sub-ICBs Data
# 5. Uploading Data for Use on Power BI


# 1. Downloading Data --------------------------------------------------------

source("Background Processes/01_downloading_data.R")

# 2. Preparing Adult Survival Data -------------------------------------------

source("Background Processes/02_adult_data_prep.R")

# 3. Preparing Childhood Cancer Survival Data -------------------------------------------

source("Background Processes/03_childhood_data_prep.R")

# 4. Preparing Cancer Survival: Index for sub-ICBs Data -------------------------------------------

source("Background Processes/04_index_data_prep.R")

# 5. Uploading Data for Use on Power BI -----------------------------------

source("Background Processes/05_uploading_cleaned_data.R")

