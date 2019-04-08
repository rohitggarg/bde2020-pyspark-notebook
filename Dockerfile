FROM jupyter/scipy-notebook

USER root

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless ca-certificates-java && \
    rm -rf /var/lib/apt/lists/*

ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-3.1/hadoop-3.1.tar.gz
ENV SPARK_URL http://mirrors.ukfast.co.uk/sites/ftp.apache.org/spark/spark-2.4.0/spark-2.4.0-bin-without-hadoop.tgz
RUN cd /tmp \
    && wget -q "$HADOOP_URL" \
    && tar xzf hadoop-3.1.tar.gz -C /opt/ \
    && rm hadoop-3.1.tar.gz

RUN ln -s /opt/hadoop-3.1/etc/hadoop /etc/hadoop
RUN mkdir /opt/hadoop-3.1/logs

RUN mkdir /hadoop-data

ENV HADOOP_PREFIX=/opt/hadoop-3.1
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV PATH $HADOOP_PREFIX/bin/:$PATH

RUN cd /tmp && \
        wget -q "$SPARK_URL" && \
        tar xzf spark-2.4.0-bin-without-hadoop.tgz -C /opt && \
        rm spark-2.4.0-bin-without-hadoop.tgz

RUN cd / && ln -s /opt/spark-2.4.0-bin-without-hadoop spark

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
