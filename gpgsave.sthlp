{smcl}
{* 2021 Sep 07}
{hline}
help for {hi:gpgsave}, {hi:gpguse}, {hi:gpgappend}, {hi:gpgmerge}{right:(Emanuele Bardelli)}
{hline}

{title:Save, use, append, and merge datasets encrypted by gpg on Windows/Unix/Linux/MacOSX}

{phang}
{cmd:gpgsave} [{it:filename}] [{cmd:,} {cmd:replace} {cmdab:comp:ress(0-9)} {it:save_options}]

{phang}
{cmd:gpgsaveold} [{it:filename}] [{cmd:,} {cmd:replace} {cmdab:comp:ress(0-9)} {it:save_options}]

{phang}
{cmd:gpguse} {it:filename}{space 1}[{cmd:,} {cmd:clear} {it:use_options}]

{phang}
{cmd:gpguse} [{varlist}] {ifin} {helpb using} {it:filename}{space 1}[{cmd:,} {cmd:clear} {it:use_options}]

{phang}
{cmd:gpgappend} [{varlist}] {helpb using} {it:filename} [{it:filename} {cmd:...}] [{cmd:,} {it:append_options}]

{phang}
{cmd:gpgmerge} [{varlist}] {helpb using} {it:filename} [{it:filename} {cmd:...}] [{cmd:,} {it:merge_options}]

{title:Description}

{pstd}
{cmd:gpgsave} encrypts and stores the current dataset on disk under the name {it:filename}.
If no {it:filename} is specified, the command tries to use the last filename under which the data were last known to Stata (c(filename)).
If {it:filename} is specified without an extension, {hi:.dta.gpg} is used.
Compression can be used by using the option {cmdab:comp:ress(0-9)}, where 0 is no compression and 9 is the highest compression level. By default, no compression is used.

{pstd}
{cmd:gzsaveold} compresses and stores the current dataset on disk in Stata 7 format.

{pstd}
{cmd:gpguse} loads a Stata-format dataset previously saved by {cmd:gpgsave} into memory.
If {it:filename} is specified without an extension, {hi:.dta.gpg} is assumed.
In the second syntax for {cmd:gpguse}, a subset of the data may be read.

{pstd}
{cmd:gpgappend} appends a Stata-format dataset previously saved by {cmd:gpgsave} to the current dataset in memory.

{pstd}
{cmd:gpgmerge} merges one or more Stata-format dataset(s) previously saved by {cmd:gpgsave} with the current dataset in memory.

{pstd}
Obviously, all these commands require the gpg command to be available at the command line.
It can be downloaded for free at {browse "http://www.gnupg.org"}.
On Unix/Linux/MacOSX you can check if gpg is available with

{p 8 13 2}
{cmd:. shell which gpg}

{pstd}
which should return something like '/usr/bin/gpg'.
On Windows the gnupg.exe must similarly be found in the path (cf. the documentation on your Windows version).
The easiest way to check if your path is set up correctly on Windows is to try out {cmd:gpgsave} and {cmd:gpguse} on a test dataset (ie. an artificial dataset you can afford to lose!).
{hi:If it does not work, the most likely explanation is that you either have not installed gpg or your path is not configured correctly.}

{pstd}
Additionally, this module requires the Stata command {cmd:whereis}, which is used to keep track of ancillary programs and must be installed together with {cmd: gpgsave}.
After installing {cmd:gpg}, you save the location of the executable in the {it:whereis} directory by running the command {cmd: whereis gpg} {it:location}.

{p 8 13 2}
{cmd:. whereis gpg /usr/bin/gpg}

{pstd}
In principle, the command should work on any system compatible with gpg and ordinary shell commands available.
The command has however only been tested on the platforms mentioned above, so as always {hi:use at your own risk!}

{pstd}
Since September 2021, the {cmd:gpgsave} suite of programs also supports encryption and decryption using age {browse "https://github.com/FiloSottile/age"}. Age is a modern replacement for gnupg that features small explicit keys, no
config options, and UNIX-style composability. Currently, only key-based encryption is supported and there are no plans
to support passphrase-based encryption for now.

To set up age, download and install the binary file from {browse "https://github.com/FiloSottile/age/releases/"} and
save the location of the executable in stata with

{p 8 13 2}
{cmd:. whereis age /path/to/age}

{title:Options}

{phang}
{cmd:replace} permits gpgsave to overwrite an existing dataset. {cmd:replace} may not be abbreviated.

{phang}
{cmd:clear} permits the data to be loaded even if there is a dataset already in memory and even if that dataset has changed since it was last saved.

{phang}
{cmd:openssl} encrypts the dataset using openssl instead of gnupg. Note that compression is not currently supported when using this option.

{phang}
{cmd:age} encrypts the dataset using age instead of gnupg. Note that only public/private key encryption is currently
supported. Note that public keys can also be passed as a text file that contains a list of keys on each line. No
passphrase support is planned at this time.

{phang}
{cmd:recipients(string)} path to the file listing users that will be able to decrypt the dataset. Age supports both its
own public keys and ssh public keys. If using a text file, list one key on each line. You can add comments to this key
file using #.

{phang}
save_options are all options available with {help save}.

{phang}
use_options are all options available with {help use}.

{phang}
append_options are all options available with {help append}.

{phang}
merge_options are all options available with {help merge}.

{title:Examples}

    {cmd:. gpgsave myfile}
    {cmd:. gpgsave myfile, replace}
    {cmd:. gpgsave myfile, replace compress(6)}
    {cmd:. gpgsave myfile.enc, replace openssl}

    {cmd:. gpgsaveold myfile}

    {cmd:. gpguse myfile}
    {cmd:. gpguse myfile, clear}

    {cmd:. gpgappend using myfile2}

    {cmd:. gpgmerge 1:1 id using myfile3}

{title:Author}

{pstd}
Emanuele Bardelli ({browse "mailto:bardelli@umich.edu":bardelli@umich.edu}), School of Education, University of Michigan, USA.

{title:Acknowledgements}

{pstd}
This program is heavely inspired and uses much of the souce code from gzsave, by Henrik Stovring, Biostatistics, Department of Public Health, Aarhus University, Denmark.

{title:Also see}

{phang}
Manual:  {hi:[R] save}

{phang}
Online: help for {help save}, {help use}, {help compress}, {help append}, {help
> merge}, {help zipsave} (if installed, otherwise {net describe zipsave})
