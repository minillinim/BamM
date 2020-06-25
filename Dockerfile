FROM python:3.8.3-buster

RUN \
    apt update \
  && apt install -y \
    --no-install-recommends \
    texinfo \
  && rm -rf /var/lib/apt/lists/* \
  && pip install numpy

RUN mkdir /app

WORKDIR /app

RUN \
     git clone https://github.com/minillinim/BamM.git \
  && cd BamM/c \
  && git clone https://github.com/codebrainz/libcfu.git \
  && cd libcfu \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && git clone https://github.com/samtools/htslib.git \
  && cd htslib/ \
  && make \
  && make install \
  && cd .. \
  && git clone https://github.com/lh3/bwa.git \
  && cd bwa/ \
  && make \
  && cp bwa /usr/bin/ \
  && cd .. \
  && git clone https://github.com/samtools/samtools.git \
  && cd samtools/ \
  && make \
  && make install \
  && cd /app/BamM/ \
  && python3 \
    setup.py install \
    --with-libcfu-inc /app/BamM/c/libcfu/src/ \
    --with-libhts-inc /app/BamM/c/htslib/htslib

CMD ["bamm"]
