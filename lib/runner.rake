require_relative 'benchmark_plan_calculator'

desc 'Run the BenchmarkPlanCalculator'
task :print_benchmark_rates_to_csv do
  puts 'Running the BenchmarkPlanCalculator................'
  BenchmarkPlanCalculator.new
  puts 'Execution Complete. Results are printed to the target CSV'
end
