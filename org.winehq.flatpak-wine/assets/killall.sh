list=$(ps -x | tr -s " " | cut -d " " -f 2|sed 's/PID//g')

for i in $list; do kill -9 $i; done

