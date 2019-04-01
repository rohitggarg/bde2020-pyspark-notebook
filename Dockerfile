FROM bde2020/spark-base:latest

RUN apk update && apk add \
    jq \
    git \
    vim \
    emacs \
    wget \
    gcc \
    g++ \
    python-dev \
    freetype-dev \
    libpng-dev \
    linux-headers \
    ca-certificates \
    bzip2 \
    unzip \
    sudo \
    openssl

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.18.0/tini-amd64 && \
    mv tini-amd64 /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.9-src.zip
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info
ENV SHELL /bin/bash
ENV NB_USER rdd
ENV NB_UID 1000
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
RUN adduser -h /home/$NB_USER -s /bin/bash -D -u $NB_UID $NB_USER

RUN apk add openblas-dev \
    lapack \
    gfortran

# Add local files as late as possible to avoid cache busting
COPY start-notebook.sh /usr/local/bin/
EXPOSE 8888
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

USER rdd

ENV PATH=$PATH:/home/${NB_USER}/.local/bin
# Setup rdd home directory
RUN mkdir /home/$NB_USER/work && \
    mkdir /home/$NB_USER/.jupyter && \
    mkdir /home/$NB_USER/.local && \
    echo "cacert=/etc/ssl/certs/ca-certificates.crt" > /home/$NB_USER/.curlrc

COPY requirements.txt /home/$NB_USER/
# Install Jupyter notebook as rdd
RUN cd /home/$NB_USER && pip install -r requirements.txt --user --no-warn-script-location
COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/
WORKDIR /home/$NB_USER/work
