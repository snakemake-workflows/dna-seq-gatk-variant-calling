# Snakemake workflow: variant-calling-germline

[![Snakemake](https://img.shields.io/badge/snakemake-≥5.1.5-brightgreen.svg)](https://snakemake.bitbucket.io)
[![Build Status](https://travis-ci.org/snakemake-workflows/dna-seq-gatk-variant-calling.svg?branch=master)](https://travis-ci.org/snakemake-workflows/dna-seq-gatk-variant-calling)

This is the template for a new Snakemake workflow. Replace this text with a comprehensive description covering the purpose and domain.
Insert your code into the respective folders, i.e. `scripts`, `rules`, and `envs`. Define the entry point of the workflow in the `Snakefile` and the main configuration in the `config.yaml` file.

## Authors

* Johannes Köster (@johanneskoester)

## Usage

### Step 1: Install workflow

If you simply want to use this workflow, download and extract the [latest release](https://github.com/snakemake-workflows/variant-calling-germline/releases).
If you intend to modify and further develop this workflow, fork this repository. Please consider providing any generally applicable modifications via a pull request.

In any case, if you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this repository and, if available, its DOI (see above).

### Step 2: Configure workflow

Configure the workflow according to your needs via editing the file `config.yaml`.

### Step 3: Execute workflow

Test your configuration by performing a dry-run via

    snakemake -n

Execute the workflow locally via

    snakemake --cores $N

using `$N` cores or run it in a cluster environment via

    snakemake --cluster qsub --jobs 100

or

    snakemake --drmaa --jobs 100

See the [Snakemake documentation](http://snakemake.readthedocs.io/en/stable/executable.html) for further details and other options (e.g. Cloud execution).

### Step 4: Investigate results

### Step 4: Investigate results

After successful execution, you can create a self-contained report with all results via:

    snakemake --report report.html
 
Example output from our test dataset can be seen [here](https://cdn.rawgit.com/snakemake-workflows/dna-seq-gatk-variant-calling/master/.test/report.html).

## Testing

Tests cases are in the subfolder `.test`. They should be executed via continuous integration with Travis CI.
