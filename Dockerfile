FROM nfcore/base:latest

LABEL \
    authors="olavur@fargen.fo" \
    description="Perform joint genotyping of GVCFs via GATK's GenotypeGVCFs." \
    maintainer="Ólavur Mortensen <olavur@fargen.fo>"

RUN apt-get update -yqq && \
    apt-get install -yqq \
    unzip \
    ttf-dejavu

COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/gatk-joint-genotyping/bin:$PATH
RUN nextflow pull olavurmortensen/gatk-joint-genotyping
