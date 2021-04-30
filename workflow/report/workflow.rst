Variants where called following the `GATK best practices workflow`_:
Reads were mapped onto {{ snakemake.config["ref"]["species"] }} build {{ snakemake.config["ref"]["build"] }} with `BWA mem`_, and both optical and PCR duplicates were removed with Picard_, followed by base recalibration with GATK_.
The GATK_ HaplotypeCaller was used to call variants per-sample, including summarized evidence for non-variant sites (GVCF_ approach).
Then, GATK_ genotyping was done in a joint way over GVCF_ files of all samples.
{% if snakemake.config["filtering"]["vqsr"] %}
Genotyped variants were filtered with the GATK_ VariantRecalibrator approach.
{% else %}
Genotyped variants were filtered using hard thresholds.
For SNVs, the criterion ``{{ snakemake.config["filtering"]["hard"]["snvs"] }}`` was used, for Indels the criterion ``{{ snakemake.config["filtering"]["hard"]["indels"] }}`` was used.
{% endif %}
Finally, SnpEff_ was used to predict and report variant effects.
In addition, quality control was performed with FastQC_, Samtools_, and Picard_ and aggregated into an interactive report via MultiQC_.

.. _GATK: https://software.broadinstitute.org/gatk/
.. _BWA mem: http://bio-bwa.sourceforge.net/
.. _Picard: https://broadinstitute.github.io/picard
.. _GATK best practices workflow: https://software.broadinstitute.org/gatk/best-practices/workflow?id=11145
.. _GVCF: https://gatkforums.broadinstitute.org/gatk/discussion/4017/what-is-a-gvcf-and-how-is-it-different-from-a-regular-vcf
.. _SnpEff: http://snpeff.sourceforge.net
.. _MultiQC: http://multiqc.info/
.. _Samtools: http://samtools.sourceforge.net/
.. _FastQC: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
