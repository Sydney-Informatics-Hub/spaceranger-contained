# Container with 10x spaceranger

#To build this file:
#sudo docker build . -t sydneyinformaticshub/spaceranger:centos7

#To run this, mounting your current host directory in the container directory,
# at /project, and excute an example run:
#sudo docker run -it -v `pwd`:/project sydneyinformaticshub/spaceranger:centos7 /bin/bash -c "spaceranger testrun --id=tiny"

#To push to docker hub:
#sudo docker push sydneyinformaticshub/spaceranger:centos7

#To build a singularity container
#export SINGULARITY_CACHEDIR=`pwd`
#export SINGULARITY_TMPDIR=`pwd`
#singularity build spaceranger.img docker://sydneyinformaticshub/spaceranger:centos7

#To run the singularity image (noting singularity mounts the current folder by default)
#singularity run --bind /project:/project spaceranger.img /bin/bash -c "cd "$PBS_O_WORKDIR" && export TENX_IGNORE_DEPRECATED_OS=1; spaceranger testrun --id=tiny"

# Pull base image.
FROM centos:centos7
MAINTAINER Nathaniel Butterworth USYD SIH

RUN mkdir /project /scratch && touch /usr/bin/nvidia-smi

# Set up centos dependencies
RUN yum -y update && \
 yum -y groupinstall 'Development Tools' && \
 yum -y install epel-release which wget gzip tar && \
 yum clean all && \
 rm -rf /var/cache/yum

# Make the dir everything will go in
WORKDIR /build

# Download spaceranger and some refererence data from https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/installation
# Unzip them with tar -xzvf ... docker file
# Put them in your build directory, then add them into the
# Versions: refdata-gex-GRCh38-2020-A.tar.gz, refdata-gex-mm10-2020-A.tar.gz, spaceranger-2.0.1.tar.gz
ADD spaceranger-2.0.1 /build/spaceranger
ADD refdata-gex-GRCh38-2020-A /build/refdata

# Add spaceranger to the environment
ENV PATH="/build/spaceranger:${PATH}"
ARG PATH="/build/spaceranger:${PATH}"

CMD spaceranger
