INSTRUCTIONS
------------


(using Docker)

A Dockerfile has been included in order to run the SLCSP calculator in a container.
(requires Docker to be installed)

-From the root directory build the image with: `docker build -t slcsp .`

-Run the Test Suite with `docker run slcsp rspec`

-Run the Benchmark Plan Calculator with `docker run slcsp rake print_benchmark_rates_to_csv`

-View the output with `docker run slcsp cat output/slcsp.csv`


(not using Docker)
Alternatively, the CSV can also be generated without the use of Docker

-Install ruby 2.5.0

-Install `bundler`

-Install the Gems with `bundle install`

-Run the Test Suite with `rspec`

-Run the Benchmark Plan Calculator with `rake print_benchmark_rates_to_csv`

-View the output with `cat output/slcsp.csv`




NOTES
-----

-A copy of the initial slcsp.csv file is stored in the output directory as `initial_slcsp.csv`

-A sample output (of the generated output by running `rake print_benchmark_rates_to_csv`)
    is included in the output directory as 'sample_output.csv'

-The plan and zip data are stored in the `data` directory