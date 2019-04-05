FROM jupyter/scipy-notebook

USER root

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless ca-certificates-java && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
        wget -q http://mirrors.ukfast.co.uk/sites/ftp.apache.org/spark/spark-2.4.0/spark-2.4.0-bin-hadoop3.1.tgz && \
        tar xzf spark-2.4.0-bin-hadoop3.1.tgz -C /opt --owner root --group root --no-same-owner && \
        rm spark-2.4.0-bin-hadoop3.1.tgz

RUN cd / && ln -s /opt/spark-2.4.0-bin-hadoop3.1 spark

# Spark config
ENV SPARK_HOME /spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

USER $NB_UID

# Install pyarrow
RUN conda install --quiet -y 'pyarrow' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
