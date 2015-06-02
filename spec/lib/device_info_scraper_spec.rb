require 'spec_helper'
require_relative '../../device_info_scraper.rb'

describe DeviceInfoScraper do
  let(:scraper) { DeviceInfoScraper.new(imei) }

  context 'with right imei' do
    context 'when device is in warranty' do
      let(:imei) { '013977000323877' }

      it 'returns the date of expiration' do
        expect(scraper.scrape_expiration_date).to eq Date.new(2016, 8, 10)
      end
    end

    context 'when device is out of warranty and date of expiration is not '\
            'present on site' do
      let(:imei) { '013896000639712' }

      it 'returns nil' do
        expect(scraper.scrape_expiration_date).to be_nil
      end
    end
  end

  context 'with wrong imei' do
    let(:imei) { '12345' }

    it 'raises WRONG_IMEI_ERROR' do
      expect { scraper.scrape_expiration_date }.
        to raise_error ScraperError, DeviceInfoScraper::WRONG_IMEI_ERROR
    end
  end
end
