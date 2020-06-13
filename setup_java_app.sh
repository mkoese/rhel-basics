#!/bin/bash

LTO_NODE_HOME=/opt/cryptonodes/lto

mkdir -p $LTO_NODE_HOME

# Install packages
apt -y update 
apt -y install openjdk-11-jdk openjdk-11-jre-headless
apt -y install libleveldb-java libleveldb-api-java

# Install Python and deps
apt -y install python3 python3-pip
pip3 install --upgrade pip
pip3 install requests pyhocon pywaves==0.8.19 tqdm

cd $LTO_NODE_HOME

# Download jars
wget https://github.com/ltonetwork/docker-public-node/raw/master/lto-public-all.jar -P ./bin
wget https://github.com/ltonetwork/docker-public-node/raw/master/lto-mainnet.conf -P ./configs

cd bin
mkdir lto-public-all-exploded-jar leveldb-arm-exploded

# Extract lto jar
cd lto-public-all-exploded-jar
jar -xvf ../lto-public-all.jar
cd ..

# Copy and Extract level-db jars
cp /usr/share/java/leveldb-api.jar .
cp /usr/share/java/leveldb.jar .

cd leveldb-arm-exploded
jar -xvf ../leveldb-api.jar
jar -xvf ../leveldb.jar
cd ..

# Remove leveldb classes from lto 
rm -frv lto-public-all-exploded-jar/org/iq80
rm -frv lto-public-all-exploded-jar/org/fusesource
rm -frv lto-public-all-exploded-jar/META-INF/native

# Copy log settings to configuration path
cp -av lto-public-all-exploded-jar/logback.xml ../configs/logback.xml 2>/dev/null || :

# Remove manifest from leveldb exploeded jar
rm -fv leveldb-arm-exploded/META-INF/MANIFEST.MF

# Patch lto jar file
cp -rafv leveldb-arm-exploded/* lto-public-all-exploded-jar

# Create new jar file
jar -cfm lto-public-all-arm.jar lto-public-all-exploded-jar/META-INF/MANIFEST.MF -C lto-public-all-exploded-jar .

rm -rf lto-public-all-exploded-jar leveldb-arm-exploded lto-public-all.jar leveldb*

cd ..

sudo groupadd -r appmgr

sudo useradd -r -s /bin/false -g appmgr jvmapps

# Create start script
cat << 'END_OF_FILE' > ${LTO_NODE_HOME}/bin/entrypoint.sh
#!/bin/bash

/usr/bin/python3 ${LTO_NODE_HOME}/bin/starter.py
/usr/bin/java -Dlogback.configurationFile=${LTO_LOG_CONFIG_FILE} -server -Xms${LTO_HEAP_SIZE} -Xmx${LTO_HEAP_SIZE} -jar ${LTO_NODE_HOME}/bin/lto-public-all-arm.jar $LTO_CONFIG_FILE
END_OF_FILE

# Create envrionment variables file
cat << EOF > ${LTO_NODE_HOME}/configs/lto_node_env.conf
LTO_LOG_CONFIG_FILE=${LTO_NODE_HOME}/configs/lto-mainnet.conf
LTO_HEAP_SIZE=2g
LTO_CONFIG_FILE=${LTO_NODE_HOME}/configs/local.conf
EOF

# Copy Python script
cp ./starter.py ${LTO_NODE_HOME}/bin/

chown -R jvmapps:appmgr $LTO_NODE_HOME
chmod u+x $LTO_NODE_HOME/{*.jar,*.py,*.sh}

# Create systemd service
cat << EOF > /etc/systemd/system/ltonode.service
[Unit]
Description=LTO Node

[Service]
WorkingDirectory=$LTO_NODE_HOME
ExecStart=$LTO_NODE_HOME/bin/entrypoint.sh
EnvironmentFile=${LTO_NODE_HOME}/configs/lto_node_env.conf
User=jvmapps
Type=simple
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

# Fail2Bain is active for ssh with the default config
apt -y install fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
