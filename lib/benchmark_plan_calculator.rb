require_relative 'benchmark_plan_calculator/data_importer.rb'
require_relative 'benchmark_plan_calculator/data_exporter.rb'
require_relative 'benchmark_plan_calculator/plan_processor.rb'

# Calculates and writes the "Benchmark" plan rate for given Zip Codes
class BenchmarkPlanCalculator
  include DataImporter
  include PlanProcessor
  include DataExporter

  attr_accessor :plans, :zips, :output

  def initialize
    import_data
    process_benchmark_plans
    write_to_output_file
  end
end
