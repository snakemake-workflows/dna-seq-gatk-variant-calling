rule snpeff:
    input:
        "calls/all.final.vcf.gz",
    output:
        vcf="calls/all.annotated.vcf.gz",
        stats="snpeff/all.html",
        csvstats="snpeff/all.csv"
    log:
        "logs/snpeff.log"
    params:
        reference=config["ref"]["name"],
        extra="-Xmx6g"
    wrapper:
        "master/bio/snpeff"
