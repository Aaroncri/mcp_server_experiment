PORT1=6277
PID1=$(lsof -i :${PORT1} | grep "(LISTEN)" | awk '{print $2}')

PORT2=6274
PID2=$(lsof -i :${PORT2} | grep "(LISTEN)" | awk '{print $2}')

kill -9 $PID2
kill -9 $PID1