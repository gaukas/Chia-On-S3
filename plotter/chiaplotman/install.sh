#!/bin/bash

source plotman.conf

sudo apt-get update
sudo apt install git unzip zip smartmontools -y

# Checkout the source and install
cd ~
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules
cd chia-blockchain
sh install.sh

# venv
. ./activate
chia init
pip install --force-reinstall git+https://github.com/ericaltendorf/plotman@main
plotman config generate

PLOTMAN_CONF_PATH=$(plotman config path)
cat << EOF > $PLOTMAN_CONF_PATH
user_interface:
        use_stty_size: True

directories:
        log: /data/chia-logs/
        tmp:
                - /data/plots
        dst:
                - /data/plots

# Plotting scheduling parameters
scheduling:
        tmpdir_stagger_phase_major: 1
        tmpdir_stagger_phase_minor: 7
        # Optional: default is 1
        tmpdir_stagger_phase_limit: 1

        # Don't run more than this many jobs at a time on a single temp dir.
        tmpdir_max_jobs: 4

        # Don't run more than this many jobs at a time in total.
        global_max_jobs: 4

        # Don't run any jobs (across all temp dirs) more often than this, in minutes.
        global_stagger_m: 75

        # How often the daemon wakes to consider starting a new plot job, in seconds.
        polling_time_s: 120

plotting:
        k: 32
        e: False             # Use -e plotting option
        n_threads: 4         # Threads per job
        n_buckets: 128       # Number of buckets to split data into
        job_buffer: 8192     # Per job memory
        # If specified, pass through to the -f and -p options.  See CLI reference.
        farmer_pk: $_FPK
        pool_pk: $_PPK
EOF
# printf "        farmer_pk: %s\n" $_FPK >> PLOTMAN_CONF_PATH
# printf "        pool_pk: %s\n" $_PPK >> PLOTMAN_CONF_PATH

# Dir setup
sudo mkdir -p /data/plots
sudo mkdir -p /data/chia-logs
sudo chmod 777 -R /data