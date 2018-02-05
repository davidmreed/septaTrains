# septaTrains

[![CircleCI](https://circleci.com/gh/davidmreed/septaTrains.svg?style=svg)](https://circleci.com/gh/davidmreed/septaTrains)
[![codecov](https://codecov.io/gh/davidmreed/septaTrains/branch/master/graph/badge.svg)](https://codecov.io/gh/davidmreed/septaTrains)

This application is a transit tracker focused on [SEPTA](http://www.septa.org) regional rail trains. It's built with Salesforce Lightning and Salesforce DX, and is intended as a demonstration and learning project for Lightning and for SFDX development lifecycle and toolchain work. 

For discussion of the toolchain being used here, including SFDX, Visual Studio Code, CircleCI, Codecov.io, Code Climate/ApexMetrics and PMD, see [ktema.org](http://ktema.org).

## SEPTA APIs

This application uses three SEPTA APIs:

- "Regional Rail Station Arrivals & Departures (JSON)" (https://www3.septa.org/hackathon/Arrivals/<STATION>)
- "TrainView (JSON)" (https://www3.septa.org/hackathon/TrainView/)
- "Regional Rail Schedules (JSON)" (https://www3.septa.org/hackathon/RRSchedules/<TRAIN>)

It also sources station location data from SEPTA's GTFS feed (stored statically).

SEPTA APIs refer to stations using several different names. In this package, they are referred to as the "display name", the "API name", and the "GTFS name". Stations also have a numeric location ID and in some cases a short name returned by the Regional Rail Schedules API. 

The API name is mostly acceptable for user-facing purposes, but in some cases uses out-of-date names or terse abbreviations. In many cases, the API name is identical to the display name. The display name and the GTFS name are mostly identical (and are close together than the GTFS and API names) but differ in a number of cases. Mappings between the display name and API name are officially [established by SEPTA](http://www3.septa.org/VIRegionalRail.html). There is no official mapping between API names and location IDs or GTFS names known to me.

The Arrivals and Departures API requires the station API name or the location ID. The latter is a recent addition, and permits some future refactoring of how septaTrains handles name storage.

The TrainView API and the Regional Rail Schedules API return schedules in terms of API names. However, the Regional Rail Schedules API sometimes returns non-standard short station names, such as "30th St" and "Norristown" (which are neither the API nor display names for those stations). There is no offical list of these short names or a mapping known to me.

The System Locations (JSON) API, which is not used in the current version of this project due to its 50-record return limitation, returns display names and location IDs.

The SEPTA GTFS feed includes location IDs and GTFS names. This project uses data transformed by hand from the GTFS feed, via [SEPTA's GitHub](https://github.com/septadev/GTFS/releases/tag/v20171113) to match the display names. 
