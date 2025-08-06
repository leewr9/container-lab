# MIT License
#
# Copyright (c) 2025 Rooam Lee
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM apache/hadoop-runner:jdk11-u2204

ARG HADOOP_VERSION=3.4.1
ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

ARG ZOOKEEPER_VERSION=3.8.4
ARG ZOOKEEPER_URL=https://dlcdn.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz

USER root
WORKDIR /opt

RUN apt update -q \
    && apt install -y --no-install-recommends \
      ssh \
      openssh-* \
      vim \
      wget \
      unzip \
      net-tools \
    && apt clean

RUN rm -rf /opt/hadoop 
RUN wget $HADOOP_URL \
    && tar -zxvf hadoop-${HADOOP_VERSION}.tar.gz \
    && rm hadoop-${HADOOP_VERSION}.tar.gz \
    && mv hadoop* /opt/hadoop \
    && mkdir -p /opt/hadoop/logs \
    && chown -R hadoop:users /opt/hadoop

ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_COMMON_HOME=/opt/hadoop
ENV HADOOP_HDFS_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV HADOOP_YARN_HOME=/opt/hadoop
ENV HADOOP_MAPRED_HOME=/opt/hadoop

RUN rm -rf /opt/zookeeper 
RUN wget $ZOOKEEPER_URL \
    && tar -zxvf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && rm apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && mv apache-zookeeper* /opt/zookeeper \
    && mkdir -p /opt/zookeeper/data \
    && mkdir -p /opt/zookeeper/logs \
    && chown -R hadoop:users /opt/zookeeper

ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV PATH=$PATH:/opt/hadoop/bin:/opt/hadoop/sbin:/opt/zookeeper/bin

COPY --chown=hadoop --chmod=755 conf /opt/hadoop/etc/hadoop
RUN chown -R hadoop:users /opt/hadoop/etc/hadoop/*

WORKDIR /opt/hadoop
USER hadoop

RUN ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg
ADD start-hadoop.sh /opt/hadoop/sbin/start-hadoop.sh
ADD log4j.properties /opt/hadoop/etc/hadoop/log4j.properties
ENTRYPOINT ["bash", "-c", "start-hadoop.sh"]