
# General settings
To configure this workflow, modify ``config/config.yaml`` according to your needs, following the explanations provided in the file.

# Sample and unit sheet

* Add samples to `config/samples.tsv`. Only the column `sample` is mandatory, but any additional columns can be added.
* For each sample, add one or more sequencing units (runs, lanes or replicates) to the unit sheet `config/units.tsv`. For each unit, define platform, and either one (column `fq1`) or two (columns `fq1`, `fq2`) FASTQ files (these can point to anywhere in your system).

The pipeline will jointly call all samples that are defined, following the GATK best practices.