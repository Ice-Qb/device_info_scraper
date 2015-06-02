require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'date'
require_relative 'scraper_error.rb'

class DeviceInfoScraper
  include Capybara::DSL

  WRONG_IMEI_ERROR = "We're sorry, but this serial number is not valid. "\
                     "Please check your information and try again."

  def initialize(imei)
    @imei = imei
    Capybara.default_driver = :selenium
  end

  def scrape_expiration_date
    visit 'https://selfsolve.apple.com/agreementWarrantyDynamic.do'
    fill_in 'sn', with: @imei
    click_button 'Continue'
    raise ScraperError.new, WRONG_IMEI_ERROR if @imei != get_imei

    get_expiration_date
  end

  private
  #############################################################################

  def get_imei
    path = "//span[contains(.,'IMEI:')]/following-sibling::span"
    find(:xpath, path).text.strip if has_xpath?(path)
  end

  def get_expiration_date
    date_regex = /Estimated Expiration Date: (\w+ \d{1,2}, \d{4})/
    if date_str = find('#hardware-text').text[date_regex, 1]
      Date.strptime(date_str, '%B %d, %Y')
    end
  end
end
