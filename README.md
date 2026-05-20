Stream Hydrology
================


This repo contains the scripts for running hydrology metrics
on stream discharge and stage data.

## Calculated metrics include:

- TQmean - The fraction of time during a water year that the daily
average flow rate is greater than the annual average
flow rate of that year.
- Richards-Baker Index (RBI) - A dimensionless index of flow
oscillations relative to total flow, based on daily
average discharge measured during a water year.
- Flow reversals - The number of times that the flow rate changed from
an increase to a decrease or vice versa during a water
year.

(Definitions from Booth and Konrad 2017)

## Data source

Data are pulled in via Herrera’s DRIP API. Data are collected by Herrera
and King County as part of Bellevue’s Environmental Monitoring Program.

## Output

Data results are saved to the EMP Data Library on SharePoint.
