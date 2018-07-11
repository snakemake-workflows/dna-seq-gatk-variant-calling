rule snpeff:
    input:
        "filtered/all.vcf.gz",
    output:
        vcf="annotated/all.vcf.gz",
        csvstats="snpeff/all.csv"
    log:
        "logs/snpeff.log"
    params:
        reference=config["ref"]["name"],
        extra="-Xmx6g"
    wrapper:
        "0.27.1/bio/snpeff"
