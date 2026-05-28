Stream Hydrology
================


This repository contains the scripts for running hydrology metrics
on stream discharge and stage data. This work is part of the City of Bellevue's 
Stream Environmental Monitoring Program.

## Calculated metrics include:

- **TQmean** - The fraction of time during a water year that the daily
average stage or discharge is greater than the annual average
value for that water year.
- **Richards-Baker Index (RBI)** - A dimensionless index of flow or stage
oscillations relative to total flow/stage, based on daily
average values measured during a water year.
- **Reversals** - The number of times that the daily average stage or discharge 
changed from an increase to a decrease or vice versa during a water year.

(Definitions adapted from Booth and Konrad 2017)

## Data source

Data are pulled in via Herrera’s DRIP API. Data are collected by Herrera
and King County as part of Bellevue’s Environmental Monitoring Program.

## Output

Data results are saved to the EMP Data Library on SharePoint.

## File structure

- File names beginning with 00_ do not rely on other scripts. These scripts often define functions. 
- File names beginning 01_ are dependent on one or more 00_ level scripts.