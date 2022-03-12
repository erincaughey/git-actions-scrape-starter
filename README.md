## Example GitHub Actions scraping with MPD CAD data 

**Use case:** __NOT__ good for longterm storage of CAD data. __IS__ good for emergency scenarios where reporters are tracking calls during an incident. Share [data file in repo](https://github.com/erincaughey/git-actions-scrape-starter/blob/master/mpd_cad_data.csv) as a temporary reporting tool.

**Nature of call glossary:**

+ PPS - Prisoner Processing Section
+ CJF - Criminal Justice Facility
+ PAB - Police Administration Building
+ PA - Police Academy
+ HOC - House of Correction
+ CIB - Criminal Investigation Bureau
+ MG - Municipal Garage
+ ID - Identification Division

-----

**Issues to fix:**

[MPD's Dispatched Calls for Service](https://itmdapps.milwaukee.gov/MPDCallData/) doesn't publish a table bigger than 75 rows. Once they've hit that limit they start removing earlier calls for service. This means the table will overwrite previous data with each scrape and lose earlier calls. 

**Potential solution:** 

Modify script to add new scraped data to the bottom of the previouse saved table and clean for duplicates. Run the script more frequently than once an hour to account for missing calls that could get removed.


-----


Based on this NICAR tutorial: [https://palewi.re/docs/first-github-scraper/index.html](https://palewi.re/docs/first-github-scraper/index.html)
