require 'spec_helper'
require_relative '../../device_info_scraper.rb'

describe DeviceInfoScraper do
  let(:imei) { '013977000323877' }
  let(:scraper) { DeviceInfoScraper.new(imei) }

  context 'with right imei' do
    let(:result) do
      [ 'Valid Purchase Date',
        'Telephone Technical Support: Active',
        'Repairs and Service Coverage: Active (limits apply)' ]
    end

    it 'returns info about current device state' do
      expect(scraper.scrape_info_by_imei).to eq result
    end
  end

  context 'with wrong imei' do
    let(:imei) { '12345' }

    it 'raises WRONG_IMEI_ERROR' do
      expect { scraper.scrape_info_by_imei }.
        to raise_error ScraperError, DeviceInfoScraper::WRONG_IMEI_ERROR
    end
  end
end
