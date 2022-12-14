# copyright 2017-2018 Regents of the University of California and the Broad Institute. All rights reserved.

FROM r-base:4.2.2

RUN apt-get update  && \
    apt-get install -t unstable libssl-dev  --yes && \
    apt-get install libxml2-dev --yes && \
    apt-get install libcurl4-gnutls-dev --yes && \
    apt-get update && apt-get install -y --no-install-recommends apt-utils && \
    apt-get install libxml2-dev -y && \
    apt-get install libcairo2-dev -y && \
    apt-get install  xvfb xauth xfonts-base libxt-dev -y && \
    apt-get install -y  -t unstable git && \
    apt-get install -t unstable -y libv8-dev && \
    rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -t unstable pandoc --yes
RUN mkdir -p /build/source/

# temporary untill the biocinstaller is in place
RUN cd /build/source && \
    wget https://github.com/GuoLabUCSD/OutSplice/tarball/GenePatternNotebook -O OutSplice.tar.gz

COPY install_stuff.R /build/source/install_stuff.R
RUN Rscript /build/source/install_stuff.R 


COPY outsplice_wrapper.R /build/source/outsplice_wrapper.R

CMD ["bash"  ]

