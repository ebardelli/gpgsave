# gpgsave

These programs extend Stata to use encrypted datasets.

## How to install
Run

    net install gpgsave, from("https://raw.githubusercontent.com/ebardelli/gpgsave/main/")

or alternatively
    
    github install ebardelli/gpgsave

## Dependencies
- Gnupg: At least version 2.
- whereis: Install this program using ssc (```ssc install whereis```) and register gpg using ```whereis gpg your_path```.

## Passowrd-based Usage
To use, simply run
    
    gpgsave dataset

or alternatively
    
    gpguse dataset

gpgmerge and gpgappend are also available.

`gpgsave` will ask for the password used to encrypt the files.

### Openssl

`openssl` encryption is also password-based and is a drop-in replacement for `gpg`
encryption. The only difference is that `openssl` is installed on most systems
already while `gpg` is usually not instsalled by default.

## Key-based Usage

`gpgsave` also allows for key-based encryption using [age](https://github.com/FiloSottile/age).

In this case, `age` needs access to a list of public keys that have access to the
data while encrypting and an authorized private key to decrypt the data.

For example, this encrypts data using a list of authorized ssh keys 

    gpgsave "file.age", replace age recipients("authorized_users.txt")

and decrypts it using a user's private ssh key:

    gpguse "file.age", clear age

Note that `gpgsave` will ask you for the path to an authorized private key that
is authorized to decrypt the data.

## Acknowledgements
The inspiration for this program and much of its code is directly taken from Henrik Stovring's gzsave.

