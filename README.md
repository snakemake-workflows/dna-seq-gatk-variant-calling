# Snakemake workflow: dna-seq-gatk-variant-calling

[![Snakemake](https://img.shields.io/badge/snakemake-≥5.7.1-brightgreen.svg)](https://snakemake.readthedocs.io)
[![Snakemake-Report](https://img.shields.io/badge/snakemake-report-green.svg)](https://cdn.rawgit.com/snakemake-workflows/dna-seq-gatk-variant-calling/master/.test/report.html)

This Snakemake pipeline implements the [GATK best-practices workflow](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11145) for calling small genomic variants.

## Authors

* Johannes Köster (https://koesterlab.github.io)


## Usage

In any case, if you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and, if available, its DOI (see above).


#### Step 1: Obtain a copy of this workflow

1. Create a new github repository using this workflow [as a template](https://help.github.com/en/articles/creating-a-repository-from-a-template).
2. [Clone](https://help.github.com/en/articles/cloning-a-repository) the newly created repository to your local system, into the place where you want to perform the data analysis.

#### Step 2: Configure workflow

Configure the workflow according to your needs via editing the file `config.yaml`.

#### Step 3: Execute workflow

Test your configuration by performing a dry-run via

    snakemake --use-conda -n

Execute the workflow locally via

    snakemake --use-conda --cores $N

using `$N` cores or run it in a cluster environment via

    snakemake --use-conda --cluster qsub --jobs 100

or

    snakemake --use-conda --drmaa --jobs 100

If you not only want to fix the software stack but also the underlying OS, use

    snakemake --use-conda --use-singularity

in combination with any of the modes above.
See the [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/executable.html) for further details.

#### Step 4: Investigate results

After successful execution, you can create a self-contained interactive HTML report with all results via:

    snakemake --report report.html

This report can, e.g., be forwarded to your collaborators.
An example (using some trivial test data) can be seen [here](https://cdn.rawgit.com/snakemake-workflows/dna-seq-gatk-variant-calling/master/.test/report.html).

#### Step 5: Commit changes

Whenever you change something, don't forget to commit the changes back to your github copy of the repository:

    git commit -a
    git push

#### Step 6: Contribute back

In case you have also changed or added steps, please consider contributing them back to the original repository:

1. [Fork](https://help.github.com/en/articles/fork-a-repo) the original repo to a personal or lab account.
2. [Clone](https://help.github.com/en/articles/cloning-a-repository) the fork to your local system, to a different place than where you ran your analysis.
3. Copy the modified files from your analysis to the clone of your fork, e.g., `cp -r envs rules scripts path/to/fork`. Make sure to **not** accidentally copy config file contents or sample sheets.
4. Commit and push your changes to your fork.
5. Create a [pull request](https://help.github.com/en/articles/creating-a-pull-request) against the original repository.

## Testing

Test cases are in the subfolder `.test`. They are automtically executed via continuous integration with Github actions.
