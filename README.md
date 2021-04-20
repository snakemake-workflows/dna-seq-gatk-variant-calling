# Snakemake workflow: dna-seq-gatk-variant-calling

[![DOI](https://zenodo.org/badge/139045164.svg)](https://zenodo.org/badge/latestdoi/139045164)
[![Snakemake](https://img.shields.io/badge/snakemake-≥6.1.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/workflows/Tests/badge.svg?branch=main)](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/actions?query=branch%3Amain+workflow%3ATests)

This Snakemake pipeline implements the [GATK best-practices workflow](https://gatk.broadinstitute.org/hc/en-us/articles/360035535932-Germline-short-variant-discovery-SNPs-Indels-) for calling small germline variants.

## Usage

In any case, if you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and its DOI (see above).

### Requirements

* [Mamba package manager](https://github.com/conda-forge/miniforge#mambaforge)
* [Copier template engine](https://copier.readthedocs.io)
* [Snakemake workflow management system](https://snakemake.github.io)

### Step 1: Declare this workflow as a module

Using this workflow works best by declaring it as a module.
By that

1. You can easily update to a newer release by just modifying the URL.
2. You can easily extend the workflow with further steps by simply adding additional rules.
3. You can [modifying the existing rules](https://snakemake.readthedocs.io/en/stable/snakefiles/modularization.html#snakefiles-modules) if needed.
4. You can easily add other published workflows to your analysis in the same way.

#### Case a: Use in a new project

1. Create a project folder on the system where you want to execute the worklow and enter it.
2. Execute
   ```
   copier gh:snakemake-workflows/dna-seq-gatk-variant-calling .
   ```
   This will generate a file `workflow/Snakefile` with the module usage declaration and a template configuration under `config`.
3. Open `workflow/Snakefile` and replace `<release>` with the [latest stable release](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/releases). 
4. Modify the configuration according to your needs.

#### Case b: Use in an existing project

1. Create a temporary folder and enter it.
2. Execute
   ```
   copier gh:snakemake-workflows/dna-seq-gatk-variant-calling .
   ```
3. Open `workflow/Snakefile` and replace `<release>` with the [latest stable release](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/releases).
4. Copy the contents of the `config` folder into your existing project (e.g. integrate the `config.yaml` contents into a subsection of your project configuration) and modify them according to your needs.
5. Move the content of `workflow/Snakefile` into the main Snakefile of your existing project. Take case that rules don't clash with other rules in your project and make sure to pass the relevant parts of the configuration, see the [module documentation](https://snakemake.readthedocs.io/en/stable/snakefiles/modularization.html#snakefiles-modules) for details.
6. Modify the configuration according to your needs.

### Step 2: Consider using git-based version control

Consider to use git for recording the current and future state of the source files you have just created.
For using Github, details can be found [here](https://docs.github.com/en/github/importing-your-projects-to-github/adding-an-existing-project-to-github-using-the-command-line). If you do not want to use git, skip this step.

### Step 3: Execute workflow

This workflow will automatically download reference genomes and annotation.
In order to save time and space, consider to use [between workflow caching](https://snakemake.readthedocs.io/en/stable/executing/caching.html) by adding the flag `--cache` to any of the commands below.
The workflow already defines which rules are eligible for caching, so no further arguments are required.
When caching is enabled, Snakemake will automatically share those steps between different instances of this workflow.

Test your configuration by performing a dry-run via

    snakemake --use-conda -n

Execute the workflow locally via

    snakemake --use-conda --cores $N

using `$N` cores. For further options, including cluster or cloud execution, see the [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/executing/cli.html).

### Step 4: Investigate results

After successful execution, you can create a self-contained interactive HTML report with all results via:

    snakemake --report report.zip

This report can, e.g., be forwarded to your collaborators.

### Step 5: Extend or modify this workflow

If any changes or extensions you made in your local analysis are generically applicable, you are very welcome to submit them to this repository as a [pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests).
