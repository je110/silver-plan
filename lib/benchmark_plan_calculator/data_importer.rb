require 'ostruct'
require 'csv'

PLAN_DATA_LOCATION = 'data/plans.csv'.freeze
ZIP_DATA_LOCATION = 'data/zips.csv'.freeze
BENCHMARK_DATA_LOCATION = 'output/slcsp.csv'.freeze
BENCHMARK_METAL_LEVEL = 'Silver'.freeze

# This module imports data from the plans, zip codes, and output CSVs
# It filters the imported plan data to only store Benchmark level (Silver) plans
module DataImporter
  def import_data
    self.plans = select_silver_plans(csv_to_struct_array(PLAN_DATA_LOCATION))
    self.zips = csv_to_struct_array(ZIP_DATA_LOCATION)
    self.output = csv_to_struct_array(BENCHMARK_DATA_LOCATION)
  end

  def select_silver_plans(plan_data)
    plan_data.select { |plan| plan.metal_level == BENCHMARK_METAL_LEVEL }
  end

  def csv_to_struct_array(file_location)
    CSV.read(file_location, headers: true)
       .map(&:to_hash)
       .map { |hash_row| OpenStruct.new(hash_row) }
  end
end
