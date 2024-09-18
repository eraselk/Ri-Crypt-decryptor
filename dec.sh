PROG_VER='1.0'
PROG_AUTH='eraselk @ github'

if [ "$#" -eq 0 ]; then
    echo "ERROR: no input file(s)"
    exit 1
fi

if [ "$1" = "--update" ]; then
    if ! ping -c1 8.8.8.8 >/dev/null 2>&1; then
        echo "No internet connection"
        exit 1
    fi
    echo "Updating script..."
    rm -f dec.sh
    curl -s https://raw.githubusercontent.com/eraselk/Ri-Crypt-decryptor/main/dec.sh -o dec.sh && echo "Done" || {
        echo "Failed"
        exit 1
    }
fi

echo "RCD (Ri-Crypt Decryptor) v$PROG_VER"
echo "by $PROG_AUTH"
echo
echo "WARNING: make sure the binary encrypted with 'Ri-Crypt'"

for file in $@; do

    if ! [ -f "$file" ]; then
        echo "file '$file' not found"
        exit 1
    fi

    echo
    echo "Decrypting $file..."

    start_decryptor() {
        (
            ./$file >/dev/null 2>&1 &
            a=$!
            ps -Ao ppid,cmd | grep $a | grep -v "grep $a" | cut -d ' ' -f2- | sed 's/^[0-9]*//g' | sed 's/sh -c //g' | sed 's/ | sh//g'
            kill -STOP $a
            kill -TERM $a
        ) >temp.sh 2>/dev/null
    }

    start_decryptor

    if [ -z "$(cat temp.sh)" ]; then
        until [ -n "$(cat temp.sh)" ]; do
            start_decryptor
        done
    fi

    chmod +x temp.sh
    ./temp.sh >./output/$file.dec.sh
    rm -f temp.sh
    echo "Done"

done
