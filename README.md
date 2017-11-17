# Description
This replication package contains the Stata code and raw spreadsheets needed to create the state-level local debt limitation and referendum dataset utilized in [Goodman (2017)](https://osf.io/by6uw/) and [Goodman and Leland (2017)](https://osf.io/5wn4c/).

## Contents of /code/
Run the following do-files to create the state-level extracts. You will need to change the ${home} directory in these do-files to match your directory setup. The running the code will update and replace the contents of the /exports/ and /release/ folders.
1. debt_lim.do - creates a state-level dataset of local debt limits
2. debt_ref.do - creates a state-level dataset of local bond referenda requirements

## Contents of /rawdata/
These are the spreadsheets called by the do-files above:
* localdebtlimit_changes.xlsx - changes in local debt limits
* localdebtref_changes.xlsx - changes in local bond referenda requirements
* crosswalk.xlsx - state fips codes, census codes, names, and abbreviations
