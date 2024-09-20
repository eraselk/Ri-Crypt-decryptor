if ! ping -c1 8.8.8.8 >/dev/null 2>&1; then
    echo "No internet connection, aborted."
    exit 1
fi

if [ "$(pwd)" != "$HOME" ]; then
    echo "Please run this script in $HOME directory"
    exit 1
fi

echo "Installing RCD..."

if [ -d "RCD" ]; then rm -rf RCD; fi

mkdir RCD
curl -s https://raw.githubusercontent.com/eraselk/Ri-Crypt-decryptor/main/dec.sh -o RCD/dec.sh
mkdir RCD/output
chmod +x RCD/dec.sh

echo "Done"
rm -f setup.sh
true
