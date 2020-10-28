FROM nfcore/base:latest

LABEL \
    authors="olavur@fargen.fo" \
    description="Align reads and call variants from Illumina short reads using GATK best practices [WIP]" \
    maintainer="Ólavur Mortensen <olavur@fargen.fo>"

RUN apt-get update -yqq && \
    apt-get install -yqq \
    unzip \
    ttf-dejavu

COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/fargen-ngs/bin:$PATH
RUN nextflow pull olavurmortensen/fargen-ngs
