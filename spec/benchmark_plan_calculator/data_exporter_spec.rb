require 'csv'
require_relative '../../lib/benchmark_plan_calculator/data_exporter'

describe 'DataExporter' do
  subject { DummyClass.new }
  let(:output) { OpenStruct.new(zipcode: '33021', rate: '100.00') }
  let(:output2) { OpenStruct.new(zipcode: '33181', rate: '150.10') }
  let(:rateless_output) { OpenStruct.new(zipcode: '33021', rate: nil) }
  let(:rateless_output2) { OpenStruct.new(zipcode: '33181', rate: nil) }
  let(:output_data) { [output, output2] }
  let(:rateless_output_data) { [rateless_output, rateless_output2] }

  before(:all) do
    class DummyClass
      include DataExporter
      attr_accessor :output
    end
  end

  describe '#write_to_output_file' do
    # reset test_output to having all blanks for the rate column
    before(:each) do
      stub_const('DataExporter::OUTPUT_LOCATION', TEST_OUTPUT_LOCATION)
      subject.output = rateless_output_data
      subject.write_to_output_file
      subject.output = output_data
    end

    it 'should write the rate data to the corresponding row in a csv' do
      # test csv file starts with no rate data
      expect(CSV.read(TEST_OUTPUT_LOCATION, headers: true)
                .map { |row| row['rate'] }.uniq).to eq([nil])

      subject.write_to_output_file

      # test csv file now has rate data
      expect(CSV.read(TEST_OUTPUT_LOCATION, headers: true)
                .map { |row| row['rate'] }.uniq).not_to eq([nil])

      # test csv file rate data matches the output rate data
      expect(CSV.read(TEST_OUTPUT_LOCATION, headers: true)
                .map { |row| row['rate'] }.uniq).to eq(output_data.map(&:rate))
      
      # test csv file rows match the output data
      expect(CSV.read(TEST_OUTPUT_LOCATION, headers: true)
                .map(&:to_hash)
                .map { |hash_row| OpenStruct.new(hash_row) }).to eq(output_data)
    end
  end
end
