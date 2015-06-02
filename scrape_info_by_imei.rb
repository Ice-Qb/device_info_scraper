require_relative 'device_info_scraper.rb'

puts DeviceInfoScraper.new(ARGV[0]).scrape_expiration_date
