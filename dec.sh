PROG_VER='1.0'
PROG_AUTH='@gacorprjkt'

file="$1"
if [ -z "$1" ]; then
    echo "No input file"
    exit 1
fi

if ! [ -f "$1" ]; then
    echo "file '$1' not found."
    exit 1
fi

echo "RCD (Ri-Crypt Decryptor) v$PROG_VER"
echo "by $PROG_AUTH"
echo
echo "WARNING: make sure the binary encrypted with 'Ri-Crypt'"
echo
echo "Decrypting $1..."

(
./$1 >/dev/null 2>&1 & a=$!
ps -Ao ppid,cmd | grep $a | grep -v "grep $a" | cut -d ' ' -f2- | sed 's/^[0-9]*//g' | sed 's/ sh -c //g' | sed 's/ | sh//g'
kill -STOP $a
kill -TERM $a
) >temp.sh 2>/dev/null

if [ -z "$(cat temp.sh)" ]; then
 echo "couldn't decrypt $1, try again."
  rm -f temp.sh
  exit 1
fi

chmod +x temp.sh
./temp.sh >./output/$1.dec.sh
rm -f temp.sh
echo "Done"
