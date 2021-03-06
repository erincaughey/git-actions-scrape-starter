# use override date variable commented below and run `make date=[date-in-20220705-format]` in command line. 
# otherwise change the 'date=[date]' variable at the top of this makefile to match the current and just run `make update`
# current download matches the date below this table https://droughtmonitor.unl.edu/DmData/GISData.aspx

# override date ?= ERROR: open the data/drought folder and run `make date=dateinfilename` i.e. date=20220614
date=20220705

update: filter-data ca-drought bay-area-drought

bay-area-drought: to-geojson project-bay-area
	mapshaper data/final/us-drought-monitor-current.json -clip data/boundaries/projections/bay-area-counties-proj.json -o data/final/bay-area-drought-zones.json

ca-drought: to-geojson project-state
	mapshaper data/final/us-drought-monitor-current.json -clip data/boundaries/projections/ca-state-proj.json -o data/final/ca-state-drought-zones.json

to-geojson: rename
	ogr2ogr -f GeoJSON -s_srs data/dm-shp/USDM_current.prj -t_srs EPSG:4326 data/final/us-drought-monitor-current.json data/dm-shp/USDM_current.shp
	rm 'data/dm-shp/USDM_current.shp' 'data/dm-shp/USDM_current.prj' 'data/dm-shp/USDM_current.shx' 'data/dm-shp/USDM_current.cpg' 'data/dm-shp/USDM_current.dbf' 'data/dm-shp/USDM_current.sbn' 'data/dm-shp/USDM_current.sbx' 'data/dm-shp/USDM_current.shp.xml'

rename: download
	rename -vs USDM_$(date) USDM_current data/dm-shp/**

filter-data: download
	mapshaper data/csv/us-state-drought.csv -filter 'State == "CA"' -o data/csv/ca-state-drought.csv 
	mapshaper data/csv/us-county-drought.csv -filter 'State == "CA"' -o data/csv/ca-county-drought.csv 
	mapshaper data/csv/ca-county-drought.csv -filter '"Contra Costa County,Alameda County,Marin County,Napa County,San Francisco County,San Mateo County,Santa Clara County,Solano County,Sonoma County".indexOf(County) > -1' -o data/csv/bay-area-county-drought.csv 

download:
	mkdir -p data/dm-shp
	mkdir -p data/csv
	mkdir -p data/final
	curl -o data/dm-shp/drought-monitor-current.zip 'https://droughtmonitor.unl.edu/data/shapefiles_m/USDM_current_M.zip'
	curl -o data/csv/us-state-drought.csv 'https://droughtmonitor.unl.edu/DmData/GISData.aspx?mode=table&aoi=state&date='
	curl -o data/csv/us-county-drought.csv 'https://droughtmonitor.unl.edu/DmData/GISData.aspx?mode=table&aoi=county&date='
	unzip data/dm-shp/drought-monitor-current.zip -d data/dm-shp

project-bay-area: project-state
	mapshaper data/boundaries/projections/ca-counties-proj.json -filter '"Contra Costa,Alameda,Marin,Napa,San Francisco,San Mateo,Santa Clara,Solano,Sonoma".indexOf(NAME) > -1' -o bay-area-counties-proj.json	
	mv bay-area-counties-proj.json data/boundaries/projections

project-state: 
	mapshaper data/boundaries/ca-state-boundary/CA_State_TIGER2016.shp -proj EPSG:4326 -o ca-state-proj.json
	mapshaper data/boundaries/ca-county-boundaries/CA_Counties_TIGER2016.shp -proj EPSG:4326 -o ca-counties-proj.json
	mkdir -p data/boundaries/projections
	mv ca-state-proj.json data/boundaries/projections
	mv ca-counties-proj.json data/boundaries/projections

dependencies: 
	brew install make
	brew install gdal
	brew unlink util-linux 
	brew install rename
	npm install -g mapshaper


	


#DEPENDENCIES 
# homebrew and node package manager (npm) are required to run this script and are the easiest way to install script dependencies
# brew install make - allows you to run the script
# brew install rename - rename files 
# have to run brew unlink util-linx to prevent a duplication error when installing gdal and rename
# brew install gdal - used to convert geo formats and map projections
# npm install -g mapshaper - command line tool for mapshaper.org to filter and clip map data

#DATA 
# download and unzip the ca state and county boundaries and store them in a `data/boundaries/` folder before running this MAKE script 
# STATE: https://data.ca.gov/dataset/e212e397-1277-4df3-8c22-40721b095f33/resource/3db1e426-fb51-44f5-82d5-a54d7c6e188b/download/ca-state-boundary.zip
# COUNTY: https://data.ca.gov/dataset/ca-geographic-boundaries/resource/b0007416-a325-4777-9295-368ea6b710e6
# DROUGHT DATA: https://droughtmonitor.unl.edu/DmData/GISData.aspx
