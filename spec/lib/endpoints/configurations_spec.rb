require 'spec_helper'

describe AthenaHealth::Endpoints::Configurations do
  describe '#all_facilities' do
    let(:parameters) do
      {
        practice_id: 195_900,
        department_id: 1,
        order_type: 'PRESCRIPTION',
        params: {
          name: 'New York'
        }
      }
    end

    it 'returns array of Facility instances' do
      VCR.use_cassette('all_facilities') do
        facilities = client.all_facilities(parameters)
        expect(facilities.map(&:class).uniq).to eq [AthenaHealth::Facility]
      end
    end
  end

  describe '#all_medications' do
    let(:parameters) do
      {
        practice_id: 195_900,
        search_value: 'asp'
      }
    end

    it 'returns array of Medication instances' do
      VCR.use_cassette('all_medications') do
        medications = client.all_medications(parameters)
        expect(medications.map(&:class).uniq).to eq [AthenaHealth::Medication]
      end
    end
  end

  describe '#all_allergies' do
    let(:parameters) do
      {
        practice_id: 195_900,
        search_value: 'asp'
      }
    end

    it 'returns array of Allergy instances' do
      VCR.use_cassette('all_allergies') do
        allergies = client.all_allergies(parameters)
        expect(allergies.map(&:class).uniq).to eq [AthenaHealth::Allergy]
      end
    end
  end
end
