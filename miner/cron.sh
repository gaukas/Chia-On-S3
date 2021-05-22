source miner.conf

_REFERENCE_DATE=$(date -d ${_DATE_BASE} +%s)
_CURRENT_DATE=$(date -d 'now' +%s)
_DATE_DIFF=$(( (${_CURRENT_DATE}-${_REFERENCE_DATE})/(86400/${_UPDATE_RATE}) ))
_DATE_EXTENSION=$(( 2*${_UPDATE_RATE} )) # Pre-create all folders needed in 2 days
i=0
while [ $i -ne ${_DATE_EXTENSION} ]
do
    DIR_NAME=${_S3_MOUNTPOINT}/${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-$((${_DATE_DIFF}+$i))
    mkdir -p ${DIR_NAME}
    CHECK_EXIST=$(grep ${DIR_NAME} ${_MINER_CONFIG})
    if [ -z ${CHECK_EXIST} ]; then
        # Append to config if not in config
        sudo echo "- ${DIR_NAME} " >> ${_MINER_CONFIG}
    fi
    i=$(($i+1))
done

sudo systemctl restart chia-miner