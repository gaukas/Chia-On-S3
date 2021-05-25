source plotter.conf

while true
do
    _REFERENCE_DATE=$(date -d ${_DATE_BASE} +%s)
    _CURRENT_DATE=$(date -d 'now' +%s)
    _DATE_DIFF=$(( (${_CURRENT_DATE}-${_REFERENCE_DATE})/(86400/${_UPDATE_RATE}) ))
    # mkdir -p ${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-${_NEXT_DIFF} # Create folder for tmr
    /usr/bin/rclone move ${_PLOT_FOLDER}/ --include "plot-*.plot" ${_RCLONE_PROFILE}:${_BUCKET_PREFIX}/${_FOLDER_PREFIX}-${_DATE_DIFF} -v &> ${_LOG_PATH}
    # Sleep for 10 minutes after every transmission to avoid abuse detection.
    /usr/bin/sleep 600s 
done