pr de gpgappend
* Append a gpg dataset
*! 0.1 HS, Nov 11, 2017
version 9.2
    qui {
        gettoken first 0: 0
        if (`"`first'"' != "using") {
        di as err "using required"
        exit 100
        }

        syntax anything(name=gpgfile) [, *]

        _gfn, filename(`gpgfile') extension(.dta.gpg)
        local gpgfile = r(fileout)

        /* We want to break off if the file to append doesn't exist */
        capture confirm file `"`gpgfile'"'
        if _rc ~= 0 {
            noi error _rc
        }

        tempfile tmpdat

        noi _requestPassword "`gpgfile'"

        whereis gpg
        shell `r(gpg)' --batch --yes --passphrase "$pass" --output `tmpdat' --decrypt "`gpgfile'"

        append using `tmpdat', `options'
    }
end
* Create filename to use with compressed save/use (gpgsave and zipsave)
*! 0.1 HS, Nov 11, 2017
    pr de _gfn, rclass
    version 9.2
    syntax , filename(string asis) extension(string)

    * Only check for punctuation in filename, not in path
    _getfilename `filename'

    * Remove opening and closing quotes, if any, from filename
    if strpos(`"`filename'"', char(34)) ~= 0 {
    local filename = subinstr(`filename', char(34), "", .)
    }

    if index(r(filename), ".") == 0 {
    local filename "`filename'`extension'"
    }
    return local fileout `"`filename'"'
end

pr de _requestPassword
    *quietly log off
    di  in green "Please enter the password for `1'", _newline _request(pass)
    *quietly log on
end
