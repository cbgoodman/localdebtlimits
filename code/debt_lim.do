* ==================================
* TITLE: STATE-IMPOSED LOCAL DEBT LIMITS
* Created: 	11.16.2017
* Modified:	11.16.2017
* ==================================

* Description: This .do file expands the local debt limit data by state into long annual panel

set more off
clear all

* GLOBALS
* The $home directory will need to be changed
global home "~/Dropbox/Data/debtlimits/"
global raw "${home}rawdata/"
global exports "${home}exports/"

local begindate 1962
local finaldate 2012

* IMPORTING A CROSSWALK FOR FIPS CODES, STATE NAMES, AND STATE ABBREVIATIONS
* Importing and "loading in" the crosswalk
import excel using ${raw}crosswalk.xlsx, clear firstrow

* Renaming variables
rename Name statename
rename FIPSStateCode statefips
rename CensusStateCode statecode
rename USPSAbbreviation stateabb
replace stateabb = upper(stateabb)
label var stateabb "State Abbreviation"

destring statefips statecode, replace

* Saving crosswalk as a temporary file
tempfile crosswalk
save `crosswalk'
* Storing the levels of State FIPS for use in expanding dataset
levelsof statefips, local(fips)

* PREPARING THE LOCAL DEBT LIMIT DATA
* Load in raw local debt limit data
import excel using ${raw}localdebtlimit_changes.xlsx, clear firstrow
destring statefips, replace

label var typename "Govt Type"
label var typecode "Census Govt Type Code"
label var dl "Debt Limit (1=Yes)"
label var lim_perc_assess "Debt Limit as a % of Assessed Value (1=Yes)"
label var lim_perc_assess_amt "Debt Limit as a % of Assessed Value"
label var lim_other "Debt Limit as other (1=Yes)"

merge m:1 statefips using `crosswalk'
*, nogen assert(3)

order statefips statecode statename stateabb typecode typename year dl lim_perc_assess lim_perc_assess_amt lim_other notes
label var statefips "State FIPS Code"
label var statename "State"

* Export to Stata file
*sort stateabb year
*save ${exports}debt_limit_changes.dta, replace

* Export to Excel File
*export excel using ${exports}debt_limit_changes.xlsx, replace firstrow(varlabels)

* Reshape wide on govt type
egen stateyear = concat(statefips year), p(_)
drop typename _merge notes
replace typecode = 51 if typecode==5.1
drop if typecode==.
reshape wide dl lim_perc_assess lim_perc_assess_amt lim_other, i(stateyear) j(typecode)

order statefips statecode statename stateabb year dl1-lim_other51
drop stateyear

* Expanding the year variable
tsset statefips year
tsfill

* Filling in the missing parts of the data
foreach x of varlist dl1-lim_other51 {
  bysort statefips (year): replace `x' = `x'[_n-1] if `x' == .
}

* Keeping overlapping data only (1962 to 2012)
keep if year >= `begindate' & year <= `finaldate'

merge m:1 statefips using `crosswalk', nogen update

* rename and relabel variables


* Exporting to Stata .dta file
sort stateabb year
save ${exports}debt_limit_state.dta, replace

* Exporting to excel spreadsheet format
export excel using ${exports}debt_limit_state.xlsx, replace firstrow(varlabels)

