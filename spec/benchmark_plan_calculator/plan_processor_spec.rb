require_relative '../../lib/benchmark_plan_calculator/data_importer'
require_relative '../../lib/benchmark_plan_calculator/plan_processor'

describe 'PlanProcessor' do
  subject { DummyClass.new }
  let(:benchmark_plan) { OpenStruct.new(zipcode: '33021', rate: nil) }
  let(:matching_zip_row) { OpenStruct.new(zipcode: '33021',
                                          state: 'FL',
                                          county_code: '12011',
                                          name: 'Broward',
                                          rate_area: '6') }
  let(:non_matching_zip_row) { OpenStruct.new(zipcode: '33181',
                                              state: 'FL',
                                              county_code: '12086',
                                              name: 'Miami-Dade',
                                              rate_area: '43') }
  let(:zip_rows) { [matching_zip_row, non_matching_zip_row] }
  let(:multiple_rate_area_zip_row) { OpenStruct.new(zipcode: '33021',
                                                    state: 'FL',
                                                    county_code: '12011',
                                                    name: 'Broward',
                                                    rate_area: '7') }
  let(:same_rate_area_zip_row) { OpenStruct.new(zipcode: '33021',
                                                state: 'FL',
                                                county_code: '12011',
                                                name: 'Broward',
                                                rate_area: '6') }
  let(:multiple_rate_area_zip_rows) { [matching_zip_row, multiple_rate_area_zip_row] }
  let(:same_rate_area_zip_rows) { [matching_zip_row, same_rate_area_zip_row] }
  let(:matching_silver_plan) { OpenStruct.new(plan_id: '93449NR9870320',
                                              state: 'FL',
                                              metal_level: 'Silver',
                                              rate: '198.55',
                                              rate_area: '6') }
  let(:matching_silver_plan2) { OpenStruct.new(plan_id: '93449NR9870320',
                                               state: 'FL',
                                               metal_level: 'Silver',
                                               rate: '208.55',
                                               rate_area: '6') }
  let(:non_matching_silver_plan_by_state) { OpenStruct.new(plan_id: '74449NR9870320',
                                                           state: 'GA',
                                                           metal_level: 'Silver',
                                                           rate: '298.55',
                                                           rate_area: '7') }
  let(:non_matching_silver_plan_by_rate_area) { OpenStruct.new(plan_id: '93449NR9870320',
                                                               state: 'FL',
                                                               metal_level: 'Silver',
                                                               rate: '208.55',
                                                               rate_area: '7') }
  let(:plan_data) { [matching_silver_plan,
                     matching_silver_plan2,
                     non_matching_silver_plan_by_state,
                     non_matching_silver_plan_by_rate_area] }

  before(:all) do
    class DummyClass
      include DataImporter
      include PlanProcessor
      attr_accessor :plans, :zips, :output
    end
  end

  before(:each) do
    subject.import_data
  end

  describe '#process_benchmark_plans' do
    it 'should append the rate to the output row if valid data is present' do
      expect(subject.output.map(&:rate).uniq).to eq([nil])
      subject.process_benchmark_plans
      expect(subject.output.map(&:rate).uniq).not_to eq([nil])

      # default results + nil
      expect(subject.output.map(&:rate).uniq.count).to eq(31)
    end
  end

  describe '#matching_zip_rows' do
    it 'should return only the zip rows that have the same zip code as the benchmark row' do
      subject.zips = zip_rows
      expect(subject.matching_zip_rows(benchmark_plan)).to eq([matching_zip_row])
    end
  end

  describe '#invalid_zip_data' do
    it 'should return true if more than 1 rate area exists for the same zip code' do
      expect(subject.invalid_zip_data(multiple_rate_area_zip_rows)).to be_truthy
    end

    it 'should return false if same rate area exists for multiple rows with the same zip code' do
      expect(subject.invalid_zip_data(same_rate_area_zip_rows)).to be_falsy
    end
  end

  describe '#matching_silver_plans' do
    it 'should return the silver plans that match the passed in zip row' do
      subject.plans = plan_data
      expect(subject.matching_silver_plans(matching_zip_row)).to eq([matching_silver_plan,
                                                                     matching_silver_plan2])
    end

    it 'should return the matching silver plans sorted by rate (increasing)' do
      subject.plans = plan_data
      expect(subject.matching_silver_plans(matching_zip_row)).to eq([matching_silver_plan,
                                                                     matching_silver_plan2])
      expect(matching_silver_plan.rate).to be <= matching_silver_plan2.rate
    end
  end

  describe '#get_benchmark_plan' do
    it 'should return the second lowest cost rate from a sorted array of plans' do
      expect(subject.get_benchmark_plan(plan_data)).to eq(matching_silver_plan2.rate)
    end

    it 'should return nil if less than 2 plans are passed' do
      expect(subject.get_benchmark_plan([non_matching_silver_plan_by_state])).to be_nil
      expect(subject.get_benchmark_plan([])).to be_nil
    end
  end
end
