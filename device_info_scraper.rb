require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require_relative 'scraper_error.rb'

class DeviceInfoScraper
  include Capybara::DSL

  WRONG_IMEI_ERROR = "We're sorry, but this serial number is not valid. "\
                     "Please check your information and try again."

  def initialize(imei)
    @imei = imei
    Capybara.default_driver = :selenium
  end

  def scrape_info_by_imei
    visit 'https://selfsolve.apple.com/agreementWarrantyDynamic.do'
    fill_in 'sn', with: @imei
    click_button 'Continue'
    raise ScraperError.new, WRONG_IMEI_ERROR if @imei != get_imei

    get_info(%w(registration phone hardware))
  end

  private
  #############################################################################

  def get_imei
    path = "//span[contains(.,'IMEI:')]/following-sibling::span"
    find(:xpath, path).text.strip if has_xpath?(path)
  end

  def get_info(ids)
    ids.map { |id| find("##{id} h3").text }
  end
end
