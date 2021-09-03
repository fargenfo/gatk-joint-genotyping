# Joint genotyping with GATK Best Practices

[![Docker build](https://img.shields.io/badge/Docker%20build-Available-informational)](https://hub.docker.com/repository/docker/olavurmortensen/gatk-joint-genotyping)

This pipeline is designed to perform joint genotyping (multi-sample variant calling) of GVCFs produced by the [LinkSeq pipeline](https://github.com/olavurmortensen/linkseq). This pipeline, as LinkSeq, is written in [Nextflow](nextflow.io/).

The main steps in the pipeline are the following:

* Joint genotyping of many GVCFs using GATK's `GenotypeGVCFs`
* Variant filtering using GATK's VQSR
* Refine genotypes using GATK's `CalculateGenotypePosteriors`
* Annotate variant effect with `SnpEff`
* QC of variants with GATK's `VariantEval`
* QC report using MultiQC


## Setup

Install dependencies with `conda` using the `environment.yml` file:

```
conda env create -f environment.yml
```

Activate the environment (check the name of the environment in the `environment.yml` file, it should be `gatk-joint-genotyping`):

```
conda activate gatk-joint-genotyping
```

Pull this project with `nextflow`:

```
nextflow pull https://github.com/olavurmortensen/gatk-joint-genotyping
```

## Usage


Below is an example config file for Nextflow.

```nextflow
resources_dir = '/path/to/resources'

params {
    tsv_file = 'samples.tsv'
    reference = "$resources_dir/gatk_bundle/Homo_sapiens_assembly38/Homo_sapiens_assembly38.fasta"
    dbsnp = "$resources_dir/gatk_bundle/Homo_sapiens_assembly38.dbsnp138/Homo_sapiens_assembly38.dbsnp138.vcf"
    targets = "$resources_dir/sureselect_human_all_exon_v6_utr_grch38/S07604624_Padded_modified.bed"
    mills = "$resources_dir/gatk_bundle/Mills_and_1000G_gold_standard.indels.hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"
    kGphase1 = "$resources_dir/gatk_bundle/1000G_phase1.snps.high_confidence.hg38/1000G_phase1.snps.high_confidence.hg38.vcf.gz"
    kGphase3 = "$resources_dir/gatk_bundle/1000G.phase3.integrated.sites_only.no_MATCHED_REV.hg38/1000G.phase3.integrated.sites_only.no_MATCHED_REV.hg38.vcf"
    omni = "$resources_dir/gatk_bundle/1000G_omni2.5.hg38/1000G_omni2.5.hg38.vcf.gz"
    hapmap = "$resources_dir/gatk_bundle/hapmap_3.3.hg38.vcf.gz/hapmap_3.3.hg38.vcf.gz"
    snpeff_datadir = "$resources_dir/snpeff_data"
    outdir = "outs"
}

process {
    executor = 'local'
    memory = '100GB'
    cpus = 20
}

executor {
    name = 'local'
    memory = '150GB'
    cpus = 30
    queueSize = 100 
}

// Capture exit codes from upstream processes when piping.
process.shell = ['/bin/bash', '-euo', 'pipefail']
```

The `samples.tsv` file will have sample names and paths to GVCF files, and will look something like this:

```tsv
sample1    /path/to/sample1.g.vcf
sample2    /path/to/sample2.g.vcf
sample3    /path/to/sample3.g.vcf
```

Run the pipeline with this command:

```bash
nextflow run olavurmortensen/gatk-joint-genotyping -resume -with-trace
```

The output of the pipeline is as follows (summarized by the `tree -L 2 outs/` command):

```
outs/
├── multiqc
│   ├── multiqc_data
│   └── multiqc_report.html
└── variants
    ├── snpEff_stats.csv
    ├── validation.log
    ├── variant_eval.table
    ├── variants.vcf.gz
    └── variants.vcf.gz.tbi
```

## Resources

Information about how to obtain the reference data can be found in the LinkSeq documentation: https://github.com/olavurmortensen/linkseq#reference-resources

