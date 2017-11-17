# gpgsave

These programs extend Stata to use encrypted datasets.

## How to install
Run

    net install gpgsave, from("https://raw.githubusercontent.com/ebardelli/gpgsave/master/")

or alternatively
    
    github install ebardelli/gpgsave

## Dependencies
- Gnupg: At least version 2.
- whereis: Install this program using ssc (```ssc install whereis```) and register gpg using ```whereis gpg your_path```.

## Usage
To use, simply run
    
    gpgsave dataset

or alternatively
    
    gpguse dataset

gpgmerge and gpgappend are also available.

## Acknowledgements
The inspiration for this program and much of its code is directly taken from Henrik Stovring's gzsave.

