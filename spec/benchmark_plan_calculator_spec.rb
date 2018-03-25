require 'spec_helper'
require_relative '../lib/benchmark_plan_calculator'

describe 'BenchmarkPlanCalculator' do
  subject { BenchmarkPlanCalculator }
  let(:benchmark_plan_calculator_instance)  { subject.new }

  before(:each) do
    stub_const('DataImporter::BENCHMARK_DATA_LOCATION', TEST_OUTPUT_LOCATION)
    stub_const('DataExporter::OUTPUT_LOCATION', TEST_OUTPUT_LOCATION)
  end

  describe 'included modules' do
    it 'includes the DataImporter module' do
      expect(subject.included_modules).to include(DataImporter)
    end
    
    it 'includes the PlanProcessor module' do
      expect(subject.included_modules).to include(PlanProcessor)
    end
    
    it 'includes the DataExporter module' do
      expect(subject.included_modules).to include(DataExporter)
    end
  end

  describe '#initialize' do
    after(:each) do
      benchmark_plan_calculator_instance.send(:initialize)
    end

    it 'should call #import_data' do
      expect(benchmark_plan_calculator_instance).to receive(:import_data)
    end

    it 'should call #process_benchmark_plans' do
      expect(benchmark_plan_calculator_instance).to receive(:process_benchmark_plans)
    end

    it 'should call #write_to_output_file' do
      expect(benchmark_plan_calculator_instance).to receive(:write_to_output_file)
    end
  end
end
