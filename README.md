# Description
This replication package contains the Stata code and raw spreadsheets needed to create the state-level local debt limitation and referendum dataset utilized in [Goodman (2018)](https://dx.doi.org/10.1093/publius/pjx065) and [Goodman and Leland (2018)](https://dx.doi.org/10.1177/0275074018804665).

## Contents of /code/
Run the following do-files to create the state-level extracts. You will need to change the ${home} directory in these do-files to match your directory setup. The running the code will update and replace the contents of the /exports/ and /release/ folders.
1. debt_lim.do - creates a state-level dataset of local debt limits
2. debt_ref.do - creates a state-level dataset of local bond referenda requirements

## Contents of /rawdata/
These are the spreadsheets called by the do-files above:
* localdebtlimit_changes.xlsx - changes in local debt limits
* localdebtref_changes.xlsx - changes in local bond referenda requirements
* crosswalk.xlsx - state fips codes, census codes, names, and abbreviations

## Source material
Full legal citations for all included data can be found on the [wiki](https://github.com/cbgoodman/localdebtlimits/wiki) at the top of this page.

## Bugs
Please report any bugs or errors [here](https://github.com/cbgoodman/localdebtlimits/issues).
