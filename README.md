# [Ri-Crypt](https://github.com/RiProG-id/Ri-Crypt) Decryptor (RCD)

## Installing RCD
```
cd $HOME; pkg update -y && yes | pkg upgrade && pkg install -y curl openssl; curl -s https://raw.githubusercontent.com/eraselk/Ri-Crypt-decryptor/main/setup.sh -o setup.sh; chmod +x setup.sh; bash setup.sh
```

## Using RCD
### Decrypt
```
./dec.sh [FILE] ...
```

### Update the script
```
./dec.sh --update
```
