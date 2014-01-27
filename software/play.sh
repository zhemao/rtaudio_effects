file=$1

if [ -z $file ]; then
    play -t raw -r 44100 -c 1 -b 16 -e signed -
else
    play -t raw -r 44100 -c 1 -b 16 -e signed $1
fi
