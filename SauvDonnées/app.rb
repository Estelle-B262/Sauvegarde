require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)

require 'app/scrapper'
require 'pry'

web_scrap = Scrapper.new("https://www.annuaire-des-mairies.com/")
web_scrap.save_as_json(web_scrap.get_townhall_urls)
json = File.read('db/emails.json')
obj = JSON.parse(json)
pp obj
#web_scrap.save_as_spreadsheet(obj)




