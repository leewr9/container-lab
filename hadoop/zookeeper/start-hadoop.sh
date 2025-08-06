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

# Start SSH service
sudo service ssh start

if [ -n "$ZOOKEEPER_MY_ID" ]; then
    echo $ZOOKEEPER_MY_ID > /opt/zookeeper/data/myid
    zkServer.sh start 
    hdfs --daemon start journalnode
fi

if [ "$HADOOP_MODE" == "namenode" ]; then
    echo "Running as NameNode"
    hdfs zkfc -formatZK
    hdfs namenode -format
    hdfs --daemon start namenode
    start-dfs.sh
    start-yarn.sh
    mapred --daemon start historyserver
elif [ "$HADOOP_MODE" == "standby" ]; then
    echo "Running as Standby NameNode"
    hdfs --daemon start journalnode
    hdfs namenode -bootstrapStandby
elif [ "$HADOOP_MODE" == "datanode" ]; then
    echo "Running as DataNode"
else
    echo "Running in Standalone Mode"
    hdfs namenode -format
    start-dfs.sh
    start-yarn.sh
fi

tail -f /dev/null
