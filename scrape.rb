require 'open uri'
	
	url = https://www.cdc.gov/coronavirus/2019-ncov/covid-data/covidview/01152021/specimens-tested.html
	fh = open(url)
	html = fh.read

puts html

Nokogiri::HTML.parse(open('https://www.cdc.gov/coronavirus/2019-ncov/covid-data/covidview/01152021/specimens-tested.html')).title