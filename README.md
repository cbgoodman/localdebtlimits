# State-imposed Local Government Debt Limitations and Referendum Requirements
----

## Description
This replication package contains the Stata code and raw spreadsheets needed to create the state-level local debt limitation and referendum dataset utilized in [Goodman (2018)](https://dx.doi.org/10.1093/publius/pjx065) and [Goodman and Leland (2019)](https://dx.doi.org/10.1177/0275074018804665).

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

## Citation
If you use these data, please cite either (or both) of the papers:

```bibtex
@article{goodmanleland2019,
  Author = {Goodman, Christopher B. and Leland, Suzanne M.},
  Title = {Do Cities and Counties Attempt to Circumvent Changes in Their Autonomy by Creating Special Districts?},
  Journal = {The American Review of Public Administration},
  Year = {2019}},
  Volume = {49},
  Number = {2},
  Pages = {203-217}
```

or

```bibtex

@article{goodman2018,
  Author = {Goodman, Christopher B.},
  Title = {Usage of Specialized Service Delivery: Evidence from Contiguous Counties},
  Journal = {Publius: The Journal of Federalism},
  Year = {2018}}
  Volume = {48},
  Number = {4},
  Pages = {686-708}
```

>Goodman, Christopher B., and Suzanne M. Leland. “Do Cities and Counties Attempt to Circumvent Changes in Their Autonomy by Creating Special Districts?” *The American Review of Public Administration* 49, no. 2 (2019): 203–17.

or

> Goodman, Christopher B. “Usage of Specialized Service Delivery: Evidence from Contiguous Counties.” *Publius: The Journal of Federalism* 48, no. 4 (2018): 686–708.


## Bugs
Please report any bugs or errors [here](https://github.com/cbgoodman/localdebtlimits/issues).
