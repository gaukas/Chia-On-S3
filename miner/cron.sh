source miner.conf

_REFERENCE_DATE=$(date -d ${_DATE_BASE} +%s)
_CURRENT_DATE=$(date -d 'now' +%s)
_DATE_DIFF=$(( (${_CURRENT_DATE}-${_REFERENCE_DATE})/(86400*${_UPDATE_RATE}) ))
_NEXT_DIFF=$(( ${_DATE_DIFF} + 1 ))

sudo mkdir -p ${_S3_MOUNTPOINT}/${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-${_DATE_DIFF} # Make sure today's folder is AVAILABLE
sudo mkdir -p ${_S3_MOUNTPOINT}/${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-${_NEXT_DIFF} # Also create folder for tmr

# Make sure mining folder is added to config
TODAY_DIR=$(grep ${_S3_MOUNTPOINT}/${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-${_DATE_DIFF} ${_MINER_CONFIG})
if [ -z ${TODAY_DIR} ]; then
    # Append to config
    sudo echo "- ${_S3_MOUNTPOINT}/${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-${_DATE_DIFF} "
fi

NEXT_DIR=$(grep ${_S3_MOUNTPOINT}/${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-${_NEXT_DIFF} ${_MINER_CONFIG})
if [ -z ${_NEXT_DIR} ]; then
    # Append to config
    sudo echo "- ${_S3_MOUNTPOINT}/${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-${_NEXT_DIFF} "
fi

sudo systemctl restart chia-miner