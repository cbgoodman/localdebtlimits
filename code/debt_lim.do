* ==================================
* TITLE: STATE-IMPOSED LOCAL DEBT LIMITS
* Created: 	11.16.2017
* Modified:	11.17.2017
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

merge m:1 statefips using `crosswalk', nogen keep(3)

order statefips statecode statename stateabb typecode typename year dl lim_perc_assess lim_perc_assess_amt lim_other notes
label var statefips "State FIPS Code"
label var statename "State"

* Export to Stata file
sort stateabb year
save ${exports}debt_limit_changes.dta, replace

* Export to Excel File
export excel using ${exports}debt_limit_changes.xlsx, replace firstrow(varlabels)

* Reshape wide on govt type
egen stateyear = concat(statefips year), p(_)
drop typename notes
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
rename dl1 county_dl
rename lim_perc_assess1 county_dl_assess
rename lim_perc_assess_amt1 county_dl_assess_amt
rename lim_other1 county_dl_other
label var county_dl "County debt limit (1=Yes)"
label var county_dl_assess "County debt limit, % of assessed value (1=Yes)"
label var county_dl_assess_amt "County debt limit, % of assessed value (Amount)"
label var county_dl_other "County debt limit, other form"

rename dl2 city_dl
rename lim_perc_assess2 city_dl_assess
rename lim_perc_assess_amt2 city_dl_assess_amt
rename lim_other2 city_dl_other
label var city_dl "Municipal debt limit"
label var city_dl_assess "Municipal debt limit, % of assessed value (1=Yes)"
label var city_dl_assess_amt "Municipal debt limit, % of assessed value (Amount)"
label var city_dl_other "Municipal debt limit, other form"

rename dl5 sd_dl
rename lim_perc_assess5 sd_dl_assess
rename lim_perc_assess_amt5 sd_dl_assess_amt
rename lim_other5 sd_dl_other
label var sd_dl "School district debt limit"
label var sd_dl_assess "School district debt limit, % of assessed value (1=Yes)"
label var sd_dl_assess_amt "School district debt limit, % of assessed value (Amount)"
label var sd_dl_other "School district debt limit, other form"

rename dl51 usd_dl
rename lim_perc_assess51 usd_dl_assess
rename lim_perc_assess_amt51 usd_dl_assess_amt
rename lim_other51 usd_dl_other
label var usd_dl "Unified school district debt limit"
label var usd_dl_assess "Unified school district debt limit, % of assessed value (1=Yes)"
label var usd_dl_assess_amt "Unified school district debt limit, % of assessed value (Amount)"
label var usd_dl_other "Unified school district debt limit, other form"

* Drop AZ Unified School Districts -- Comment out to keep
drop usd_dl usd_dl_assess usd_dl_assess_amt usd_dl_other

* Exporting to Stata .dta file
sort stateabb year
save ${exports}debt_limit_state.dta, replace

* Exporting to excel spreadsheet format
export excel using ${exports}debt_limit_state.xlsx, replace firstrow(varlabels)

