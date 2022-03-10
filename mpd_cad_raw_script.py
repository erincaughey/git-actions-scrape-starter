import requests
import bs4
import csv

URL = 'https://itmdapps.milwaukee.gov/MPDCallData/'

warn_page = requests.get(URL)

soup = bs4.BeautifulSoup(warn_page.text, 'html.parser')
table = soup.find('table')
rows = table.find_all('tr')

HEADERS = [
    'call_number',
    'date_time',
    'location',	
    'police_district',
    'nature_of_call',
    'status',
]

with open ('mpd_cad_data.csv', 'w', newline='') as outfile: 
    writer = csv.writer(outfile)
    writer.writerow(HEADERS)
    for row in rows[1:]:
        cells = row.find_all('td')
        values = [c.text.strip() for c in cells]
        writer.writerow(values)

