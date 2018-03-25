require_relative '../../lib/benchmark_plan_calculator/data_importer'

SILVER_METAL_LEVEL = 'Silver'.freeze

describe 'DataImporter' do
  subject { DummyClass.new }
  let(:gold_plan) { OpenStruct.new(plan_id: '74449NR9870320',
                                   state: 'GA',
                                   metal_level: 'Gold',
                                   rate: '298.55',
                                   rate_area: '7') }
  let(:silver_plan) { OpenStruct.new(plan_id: '93449NR9870320',
                                     state: 'FL',
                                     metal_level: 'Silver',
                                     rate: '198.55',
                                     rate_area: '3') }
  let(:plan_data) { [gold_plan, silver_plan] }

  before(:all) do
    class DummyClass
      include DataImporter
      attr_accessor :plans, :zips, :output
    end
  end

  describe '#import_data' do
    before(:each) do
      subject.import_data
    end

    context 'using the default data' do
      it 'should import data for the plans, zips, and output of the calling object' do
        # number of silver plans in default data
        expect(subject.plans.count).to eq(8_461)

        # number of zip codes in default data
        expect(subject.zips.count).to eq(51_541)

        # number of output rows in default data
        expect(subject.output.count).to eq(51)
      end

      it 'should only import silver plans' do
        expect(subject.plans.map(&:metal_level).uniq).to eq([SILVER_METAL_LEVEL])
      end

      it 'should turn the imported data into an OpenStruct' do
        expect(subject.plans.map(&:class).uniq).to eq([OpenStruct])
        expect(subject.zips.map(&:class).uniq).to eq([OpenStruct])
        expect(subject.output.map(&:class).uniq).to eq([OpenStruct])
      end
    end
  end

  describe '#select_silver_plans' do
    it 'returns only silver plans' do
      expect(subject.select_silver_plans(plan_data)).to eq([silver_plan])
    end
  end

  describe '#csv_to_struct_array' do
    it 'returns an OpenStruct for each CSV non-header row' do
      # number of total plans in default data
      expect(subject.csv_to_struct_array(PLAN_DATA_LOCATION).count).to eq(22_239)

      expect(subject.csv_to_struct_array(PLAN_DATA_LOCATION).map(&:class).uniq).to eq([OpenStruct])
    end
  end
end
