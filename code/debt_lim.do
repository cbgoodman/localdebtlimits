* ==================================
* TITLE: STATE IMPOSED LOCAL DEBT LIMITS
* Created: 	May 18, 2017
* Modified:	November 13, 2017
* ==================================

* Description: This .do file expands the local debt limit data by state into long annual panel

set more off
clear all

* GLOBALS
* The $home directory will need to be changed
global home "~Dropbox/Data/Debt Limits/localdebtlimits/"
global raw "${home}rawdata/"
global exports "${home}exports/"
global release "${home}release/"
