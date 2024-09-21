if ! ping -c1 8.8.8.8 >/dev/null 2>&1; then
    echo "No internet connection, aborted."
    exit 1
fi

if [ "$(pwd)" != "$HOME" ]; then
    echo "Please run this script in $HOME directory"
    exit 1
fi

return=true

echo "Installing RCD..."

if [ -d "RCD" ]; then
    rm -rf RCD
fi

mkdir -p RCD/output
curl -s https://raw.githubusercontent.com/eraselk/Ri-Crypt-decryptor/main/dec.sh -o RCD/dec.sh
chmod +x RCD/dec.sh

echo "Done"

if ! hash strings >/dev/null 2>&1; then
    echo
    echo "strings not installed, installing strings..."
    pkg install strings -y >/dev/null 2>&1 && echo "Done" || echo "Failed" && return=false
fi

rm -f setup.sh
$return
