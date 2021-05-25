#!/bin/bash

source plotter.conf

sudo apt update
sudo apt install unzip zip -y

path_to_installation=$PWD

# Install rclone
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
rm -rf rclone-*-linux-amd64 rclone-current-linux-amd64.zip

sudo mkdir -p $(dirname ${_LOG_PATH})
sudo chmod 777 $(dirname ${_LOG_PATH})

mkdir -p ~/.config/rclone/
cat << EOF > ~/.config/rclone/rclone.conf
[${_RCLONE_PROFILE}]
type = s3
provider = ${_RCLONE_PROVIDER}
env_auth = false
access_key_id = ${_S3_KEY_ID}
secret_access_key = ${_S3_SECRET_KEY}
region = ${_S3_REGION}
endpoint = ${_S3_ENDPOINT}
acl = ${_S3_ACL}
chunk_size = ${_S3_CHUNK_SIZE}
disable_checksum = ${_S3_DISABLE_CHECKSUM}
upload_concurrency = ${_S3_UPLOAD_CONCURRENCY}
EOF

cd $path_to_installation
cat << EOF > ./cos3-plotter.service
[Unit]
Description=Chia On S3 Plotter Version uploads plots to S3 buckets.
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=$USER
WorkingDirectory=${path_to_installation}
ExecStart=/bin/bash ${path_to_installation}/service.sh

[Install]
WantedBy=multi-user.target
EOF

sudo mv cos3-plotter.service /etc/systemd/system/cos3-plotter.service
sudo systemctl enable cos3-plotter
sudo systemctl start cos3-plotter