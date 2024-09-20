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
    chmod +x dec.sh
    exit 0
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

    name=$(basename $file)
    if echo "$file" | grep -q -e '/sdcard' -e '/storage/emulated/0' || [ ! -f "$name" ]; then
        cp -f $file .
        external=1
    fi
    [ -x "$name" ] || chmod +x $name

    echo
    echo "Decrypting $file » output/$name.dec.sh..."

    start_decryptor() {
        (
            ./$name >/dev/null 2>&1 &
            a=$!
            ps -Ao ppid,cmd | grep $a | grep -v "grep $a" | cut -d ' ' -f2- | sed 's/^[0-9]*//g' | sed 's/sh -c //g' | sed 's/ | sh//g'
            kill -STOP $a
            kill -TERM $a
        ) >temp.sh 2>/dev/null
    }

    start_decryptor

    if ! cat temp.sh | grep -q 'base64 -d'; then
        until cat temp.sh | grep -q 'base64 -d'; do
            start_decryptor
        done
    fi

    chmod +x temp.sh
    ./temp.sh >./output/$name.dec.sh
    rm -f temp.sh

    if [ "$external" = "1" ]; then
        rm -f $name
    fi

    echo "Done"

done
