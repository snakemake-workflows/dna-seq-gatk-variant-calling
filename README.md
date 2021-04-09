# Snakemake workflow: dna-seq-gatk-variant-calling

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.1.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/workflows/Tests/badge.svg?branch=master)](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/actions?query=branch%3Amaster+workflow%3ATests)

This Snakemake pipeline implements the [GATK best-practices workflow](https://gatk.broadinstitute.org/hc/en-us/articles/360035535932-Germline-short-variant-discovery-SNPs-Indels-) for calling small germline variants.

## Authors

* Johannes Köster (https://koesterlab.github.io)


## Usage

In any case, if you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and its DOI (see above).

### Step 0: Install Snakemake

In case you don't yet have Snakemake installed, make sure to install it, together with the mamba package manager, as outlined in the [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html).

### Step 1: Prepare a new Snakemake workflow

In case you want to use this workflow from an already existing Snakemake workflow, you can skip this step.

1. Create a project folder on the system where you want to execute the worklow.
2. Enter the folder.
3. Create a new empty *Snakefile* `workflow/Snakefile`.

### Step 2: Declare workflow usage

Enter the following into your *Snakefile*:

```python
configfile: "config/config.yaml"

module dna_seq_gatk:
    snakefile:
        "https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/raw/<release>/Snakefile"
    config:
        config

use rule * from dna_seq_gatk
```
while replacing `<release>` with the [latest stable release](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/releases).
See [here](https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#using-and-combining-pre-exising-workflows) for advanced options.

At first sight, it might seem cumbersome that this snippet has to be inserted into an empty new workflow.
However, this way has several advantages over just running this workflow from a local copy of this repo:

1. You can easily update to a newer release by just modifying the URL.
2. You can easily extend the workflow with further steps by simply adding additional rules.
3. You can [modifying the existing rules](https://snakemake.readthedocs.io/en/stable/snakefiles/modularization.html#snakefiles-modules) if needed.
4. You can easily add other published workflows to your analysis in the same way.

All of this happens while transparently documenting your modifications directly in the *Snakefile*.

### Step 3: Configure workflow

1. Obtain the template configuration from this repository, either by copy pasting into your existing configuration, or by downloading via
   ```bash
   mkdir -p config
   wget -P config https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/raw/<release>/{config.yaml,samples.tsv,units.tsv}
   ```
   while replacing `<release>` with the [latest stable release](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling/releases).
2. Modify the configuration according to your needs.

### Step 4: Consider using git-based version control

Consider to use git for recording the current and future state of the source files you have just created.
For using Github, details can be found [here](https://docs.github.com/en/github/importing-your-projects-to-github/adding-an-existing-project-to-github-using-the-command-line). If you do not want to use git, skip this step.

### Step 5: Execute workflow

This workflow will automatically download reference genomes and annotation.
In order to save time and space, consider to use [between workflow caching](https://snakemake.readthedocs.io/en/stable/executing/caching.html) by adding the flag `--cache` to any of the commands below.
The workflow already defines which rules are eligible for caching, so no further arguments are required.
When caching is enabled, Snakemake will automatically share those steps between different instances of this workflow.

Test your configuration by performing a dry-run via

    snakemake --use-conda -n

Execute the workflow locally via

    snakemake --use-conda --cores $N

using `$N` cores. For further options, including cluster or cloud execution, see the [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/executing/cli.html).

### Step 6: Investigate results

After successful execution, you can create a self-contained interactive HTML report with all results via:

    snakemake --report report.zip

This report can, e.g., be forwarded to your collaborators.
An example (using some trivial test data) can be seen [here](https://cdn.rawgit.com/snakemake-workflows/dna-seq-gatk-variant-calling/master/.test/report.html).

### Step 7: Extend or modify this workflow

If any changes or extensions you made in your local analysis generically applicable, you are very welcome to submit them to this repository as a [pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests).
