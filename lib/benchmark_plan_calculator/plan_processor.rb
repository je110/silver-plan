# This module matches the imported plan, zip, and target data
# If valid data is found, it appends the benchmark rate to the output data
module PlanProcessor
  def process_benchmark_plans
    output.each do |benchmark_plan|
      matched_zip_rows = matching_zip_rows(benchmark_plan)
      next if invalid_zip_data(matched_zip_rows)
      sorted_silver_plans = matching_silver_plans(matched_zip_rows.first)
      benchmark_plan.rate = get_benchmark_plan(sorted_silver_plans)
    end
  end

  def matching_zip_rows(benchmark_plan)
    zips.select { |zip_row| zip_row.zipcode == benchmark_plan.zipcode }
  end

  def invalid_zip_data(zip_rows)
    # data is invalid if multiple rate areas for same zip code
    zip_rows.map(&:rate_area).uniq.length > 1
  end

  def matching_silver_plans(zip_row)
    plans.select do |silver_plan|
      silver_plan.state == zip_row.state && silver_plan.rate_area == zip_row.rate_area
    end.sort_by(&:rate)
  end

  def get_benchmark_plan(rate_sorted_silver_plans)
    # get second lowest cost plan
    rate_sorted_silver_plans[1].rate if rate_sorted_silver_plans.length >= 2
  end
end
