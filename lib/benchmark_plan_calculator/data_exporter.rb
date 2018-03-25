require 'csv'

OUTPUT_LOCATION = 'output/slcsp.csv'.freeze

# This module writes the benchmark rates to a specified CSV
module DataExporter
  def write_to_output_file
    headers = CSV.read(OUTPUT_LOCATION, &:read_line).first
    options = { write_headers: true, headers: headers }
    CSV.open(OUTPUT_LOCATION, 'wb', options) do |csv|
      output.each do |benchmark_plan|
        csv << [benchmark_plan.zipcode, benchmark_plan.rate]
      end
    end
  end
end
