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
