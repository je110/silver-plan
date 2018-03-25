require 'rake'

describe 'runner rake task' do
  before(:all) do
    Rake.application.rake_require '../lib/runner'
    Rake::Task.define_task(:environment)
  end

  describe ':print_benchmark_rates_to_csv' do
    before(:each) do
      stub_const('DataExporter::OUTPUT_LOCATION', TEST_OUTPUT_LOCATION)
    end

    it 'should call BenchmarkPlanCalculator.new' do
      expect(BenchmarkPlanCalculator).to receive(:new)
      Rake.application.invoke_task "print_benchmark_rates_to_csv"
    end
  end

end