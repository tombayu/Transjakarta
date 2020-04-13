# Transjakarta
A personal project to experiment data science stuffs on Jakarta's largest transportation company!
Sources and credits: transjakarta.co.id, Trafi API, rasyidstat/transjakarta


## Contents
### Script
#### 01.R 
- Scrap all available Transjakarta routes (as in 08/04/2020)
- Download all routemaps available in transjakarta.co.id/peta-rute
#### 02.R
- Attempt to extract station names using OCR (09/04/2020) -- incomplete
#### 03.R
- Scraping Trafi's API, extract json (09/04/2020)
#### 04.R
- Parse all of the json's into R-ready format
#### 05.R
- Get the routes/corridors, save into geodata (with epsg 4326)
#### 06.R
- Get the stops (halte), save into geodata (also with epsg 4326)

### Data
#### data/rds/routes.rds
- A 'tidy' dataframe containing corridor codes and routes

### Plans, to-do, to be added
- OCR to extract all stops
- data/rds/routes - Service type, number of stations
- Dashboard
