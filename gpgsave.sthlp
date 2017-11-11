{smcl}
{* 11ov2017}
{hline}
help for {hi:gpgsave}, {hi:gpguse}, {hi:gpgappend}, {hi:gpgmerge}{right:(Emanuele Bardelli)}
{hline}

{title:Save, use, append, and merge datasets encrypted by gpg on Windows/Unix/Linux/MacOSX}

{p 8 13 2}{cmd:gpgsave} [{it:filename}] [{cmd:,} {cmd:replace} {it:save_options}]

{p 8 13 2}{cmd:gpguse} {it:filename}{space 1}[{cmd:,} {cmd:clear} {it:use_options}]

{p 8 13 2}{cmd:gpguse} [{varlist}] {ifin} {helpb using} {it:filename}{space 1}[{cmd:,} {cmd:clear} {it:use_options}]

{p 8 13 2}{cmd:gpgappend} [{varlist}] {helpb using} {it:filename} [{it:filename} {cmd:...}] [{cmd:,} {it:append_options}]

{p 8 13 2}{cmd:gpgmerge} [{varlist}] {helpb using} {it:filename} [{it:filename} {cmd:...}] [{cmd:,} {it:merge_options}]

{title:Description}

{p 4 4 2} {cmd:gpgsave} encrypts and stores the current dataset on disk under the name {it:filename}. If no {it:filename} is specified, the command tries to use the last filename under which the data were last known to Stata (c(filename)). If {it:filename} is specified without an extension, {hi:.dta.gpg} is used.

{p 4 4 2}
{cmd:gpguse} loads a Stata-format dataset previously saved by {cmd:gpgsave} into memory.  If {it:filename} is specified without an extension, {hi:.dta.gpg} is assumed. In the second syntax for {cmd:gpguse}, a subset of the data may be read.

{p 4 4 2}
{cmd:gpgappend} appends a Stata-format dataset previously saved by {cmd:gpgsave} to the current dataset in memory.

{p 4 4 2}
{cmd:gpgmerge} merges one or more Stata-format dataset(s) previously saved by {cmd:gpgsave} with the current dataset in memory.

{p 4 4 2} Obviously, all these commands require the gpg command to be available at the command line. It can be downloaded for free at {browse "http://www.gnupg.org"}. On Unix/Linux/MacOSX you can check if gpg is available with

{p 8 8 2}{cmd:. shell which gpg}

{p 4 4 2} which should return something like '/usr/bin/gpg'. On Windows the gnupg.exe must similarly be found in the path, cf. the documentation on your Windows version. The easiest way to check if your path is set up correctly on Windows is to try out {cmd:gpgsave} and {cmd:gpguse} on a test dataset (ie. an artificial dataset you can afford to lose!). {hi:If it does not work, the most likely explanation is that you either have not installed gpgip or your path is not configured correctly.}

{p 4 4 2} In principle, the command should work on any system with gpg installed and ordinary shell commands available. The command has however only been tested on the platforms mentioned above, so as always {hi:use at your own risk!}


{title:Options}

{p 4 8 2}{cmd:replace} permits gpgsave to overwrite an existing dataset. {cmd:replace} may not be abbreviated.

{p 4 8 2}{cmd:clear} permits the data to be loaded even if there is a dataset already in memory and even if that dataset has changed since it was last saved.

{p 4 8 2}save_options are all options available with {help save}.

{p 4 8 2}use_options are all options available with {help use}.

{p 4 8 2}append_options are all options available with {help append}.

{p 4 8 2}merge_options are all options available with {help merge}.

{title:Remarks}

{p 4 4 2} These commands are useful for one purpose: 

{p 4 8 2} First, they allow to store sensitive information in encrypted datasets.

{title:Examples}

    {cmd:. gpgsave myfile}
    {cmd:. gpgsave myfile, replace}

    {cmd:. gpguse myfile}
    {cmd:. gpguse myfile, clear}

    {cmd:. gpgappend using myfile2}

    {cmd:. gpgmerge id using myfile3, unique}

    {cmd:. shell gpgip -l myfile.dta.gpg}    shows compression ratio

{title:Author}

{p 4 4 2} Emanuele Bardelli ({browse "mailto:bardelli@umich.edu":bardelli@umich,ed}), School of Education, University of Michigan, USA.

{title:Acknowledgements}

{p 4 4 2} This program is heavely inspired and uses much of the souce code from gzsave, by Henrik Stovring ({browse "mailto:stovring@biostat.au.dk":stovring@biostat.au.dk}), Biostatistics, Department of Public Health, Aarhus University, Denmark.

{title:Also see}

{p 4 13 2}
Manual:  {hi:[R] save}

{p 4 13 2}
Online: help for {help save}, {help use}, {help compress}, {help append}, {help merge}, {help zipsave} (if installed, otherwise {net describe zipsave})
{p_end}
