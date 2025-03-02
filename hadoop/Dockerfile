# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. See accompanying LICENSE file.

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
ENV PATH=$PATH:/opt/hadoop/bin:/opt/hadoop/sbin

COPY --chown=hadoop --chmod=755 conf /opt/hadoop/etc/hadoop
RUN chown -R hadoop:users /opt/hadoop/etc/hadoop/*

WORKDIR /opt/hadoop
USER hadoop

RUN ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ADD start-hadoop.sh /opt/hadoop/sbin/start-hadoop.sh
ADD log4j.properties /opt/hadoop/etc/hadoop/log4j.properties
ENTRYPOINT ["bash", "-c", "start-hadoop.sh"]