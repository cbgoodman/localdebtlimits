* ==================================
* TITLE: STATE-IMPOSED LOCAL DEBT REFERENDA REQS
* Created: 	11.17.2017
* Modified:	11.17.2017
* ==================================

* Description: This .do file expands the local debt referenda data by state into long annual panel

set more off
clear all

* GLOBALS
* The $home directory will need to be changed
global home "~/Dropbox/Data/debtlimits/"
global raw "${home}rawdata/"
global exports "${home}/localdebtlimits/exports/"

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

* PREPARING THE LOCAL DEBT REFERENDA DATA
* Load in raw local debt refernda data
import excel using ${raw}localdebtref_changes.xlsx, clear firstrow
destring statefips, replace

label var typename "Govt Type"
label var typecode "Census Govt Type Code"
label var referendum "Bond referendum req (1=Yes)"
label var ref_all "Bond referendum req for all muni debt (1=Yes)"
label var ref_go "Bond referendum req for go muni debt (1=Yes)"
label var ref_maj_plus "Supermajority required (1=Yes)"
label var ref_maj_amt "Supermajority amount"

merge m:1 statefips using `crosswalk', nogen keep(3)

order statefips statecode statename stateabb typecode typename year referendum ref_all ref_go ref_maj_plus ref_maj_amt notes
label var statefips "State FIPS Code"
label var statename "State"

* Export to Stata file
sort stateabb year
save ${exports}debt_ref_changes.dta, replace

* Export to Excel File
export excel using ${exports}debt_ref_changes.xlsx, replace firstrow(varlabels)

* Reshape wide on govt type
egen stateyear = concat(statefips year), p(_)
drop typename notes
drop if typecode==.
reshape wide referendum ref_all ref_go ref_maj_plus ref_maj_amt, i(stateyear) j(typecode)

order statefips statecode statename stateabb year referendum1-ref_maj_amt5
drop stateyear

* Expanding the year variable
tsset statefips year
tsfill

* Filling in the missing parts of the data
foreach x of varlist referendum1-ref_maj_amt5 {
  bysort statefips (year): replace `x' = `x'[_n-1] if `x' == .
}

* Keeping overlapping data only (1962 to 2012)
keep if year >= `begindate' & year <= `finaldate'

merge m:1 statefips using `crosswalk', nogen update

* rename and relabel variables
rename referendum1 county_ref
rename ref_all1 county_all
rename ref_go1 county_go
rename ref_maj_plus1 county_maj_plus
rename ref_maj_amt1 county_maj_amt
label var county_ref "County bond referendum (1=Yes)"
label var county_all "County debt referendum, all issues (1=Yes)"
label var county_go "County debt referendum, go issues (1=Yes)"
label var county_maj_plus "County debt referendum, supermajority (1=Yes)"
label var county_maj_amt "County debt referendum, supermajority (threshold)"

rename referendum2 city_ref
rename ref_all2 city_all
rename ref_go2 city_go
rename ref_maj_plus2 city_maj_plus
rename ref_maj_amt2 city_maj_amt
label var city_ref "City bond referendum (1=Yes)"
label var city_all "City debt referendum, all issues (1=Yes)"
label var city_go "City debt referendum, go issues (1=Yes)"
label var city_maj_plus "City debt referendum, supermajority (1=Yes)"
label var city_maj_amt "City debt referendum, supermajority (threshold)"

rename referendum5 sd_ref
rename ref_all5 sd_all
rename ref_go5 sd_go
rename ref_maj_plus5 sd_maj_plus
rename ref_maj_amt5 sd_maj_amt
label var sd_ref "School district bond referendum (1=Yes)"
label var sd_all "School district debt referendum, all issues (1=Yes)"
label var sd_go "School district debt referendum, go issues (1=Yes)"
label var sd_maj_plus "School district debt referendum, supermajority (1=Yes)"
label var sd_maj_amt "School district debt referendum, supermajority (threshold)"

* Exporting to Stata .dta file
sort stateabb year
save ${exports}debt_ref_state.dta, replace

* Exporting to excel spreadsheet format
export excel using ${exports}debt_ref_state.xlsx, replace firstrow(varlabels)


