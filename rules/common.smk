import pandas as pd
from peppy import Project, SAMPLE_NAME_COLNAME as PEP_SAMPLE_COL
from snakemake.utils import validate


def peppy_rename(df):
    """ Rename peppy's column for sample name identification to snakemake's. """
    if df is None:
        return None
    if "sample" in df.columns and PEP_SAMPLE_COL in df.columns:
        raise Exception("Multiple sample identifier columns present: {}".format(", ".join(["sample", PEP_SAMPLE_COL])))
    return df.rename({PEP_SAMPLE_COL: "sample"}, axis=1)


def peppy_units(df):
    """ Add unit/subsample indices to peppy a data frame.  """
    if "unit" in df.columns:
        return df
    def count_names(names):
        def go(rem, n, curr, acc):
            if rem == []:
                return acc + [n]
            h, t = rem[0], rem[1:]
            return go(t, n + 1, curr, acc) if h == curr else go(t, 1, h, acc + [n])
        return go(names[1:], 1, names[0], []) if names else []
    df.insert(1, "unit", [i for n in count_names(list(df[PEP_SAMPLE_COL])) for i in range(1, n + 1)])
    return df


###### Config file and sample sheets #####
p = Project("prjcfg.yaml")
configfile: p.snake_config
validate(config, schema="../schemas/config.schema.yaml")

samples = p.sheet
samples = peppy_rename(samples).set_index("sample", drop=False)

validate(samples, schema="../schemas/samples.schema.yaml")

units = peppy_units(peppy_rename(p.sample_subannotation)).set_index(["sample", "unit"], drop=False)
units.index = units.index.set_levels([i.astype(str) for i in units.index.levels])  # enforce str in index

validate(units, schema="../schemas/units.schema.yaml")

# contigs in reference genome
contigs = pd.read_table(config["ref"]["genome"] + ".fai",
                        header=None, usecols=[0], squeeze=True, dtype=str)


##### Wildcard constraints #####
wildcard_constraints:
    vartype="snvs|indels",
    sample="|".join(samples.index),
    unit="|".join(units["unit"]),
    contig="|".join(contigs)


##### Helper functions #####

def get_fastq(wildcards):
    """Get fastq files of given sample-unit."""
    fastqs = units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    if len(fastqs) == 2:
        return {"r1": fastqs.fq1, "r2": fastqs.fq2}
    return {"r1": fastqs.fq1}


def is_single_end(sample, unit):
    """Return True if sample-unit is single end."""
    return pd.isnull(units.loc[(sample, unit), "fq2"])


def get_read_group(wildcards):
    """Denote sample name and platform in read group."""
    return r"-R '@RG\tID:{sample}\tSM:{sample}\tPL:{platform}'".format(
        sample=wildcards.sample,
        platform=units.loc[(wildcards.sample, wildcards.unit), "platform"])


def get_trimmed_reads(wildcards):
    """Get trimmed reads of given sample-unit."""
    if not is_single_end(**wildcards):
        # paired-end sample
        return expand("trimmed/{sample}-{unit}.{group}.fastq.gz",
                      group=[1, 2], **wildcards)
    # single end sample
    return "trimmed/{sample}-{unit}.fastq.gz".format(**wildcards)


def get_sample_bams(wildcards):
    """Get all aligned reads of given sample."""
    return expand("recal/{sample}-{unit}.bam",
                  sample=wildcards.sample,
                  unit=units.loc[wildcards.sample].unit)


def get_regions_param(regions=config["processing"].get("restrict-regions"), default=""):
    if regions:
        params = "--intervals '{}' ".format(regions)
        padding = config["processing"].get("region-padding")
        if padding:
            params += "--interval-padding {}".format(padding)
        return params
    return default


def get_call_variants_params(wildcards, input):
    return (get_regions_param(regions=input.regions, default=f"--intervals {wildcards.contig}") +
            config["params"]["gatk"]["HaplotypeCaller"])


def get_recal_input(bai=False):
    # case 1: no duplicate removal
    f = "mapped/{sample}-{unit}.sorted.bam"
    if config["processing"]["remove-duplicates"]:
        # case 2: remove duplicates
        f = "dedup/{sample}-{unit}.bam"
    if bai:
        if config["processing"].get("restrict-regions"):
            # case 3: need an index because random access is required
            f += ".bai"
            return f
        else:
            # case 4: no index needed
            return []
    else:
        return f
