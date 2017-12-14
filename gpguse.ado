pr de gpguse
* Open a gpg encrypted dataset
*! 0.0.2 EB, Dec 14, 2017 - Support openssl encryption
*! 0.0.1 EB, Nov 11, 2017
    version 9.2
    local allargs `"`0'"'

    gettoken first allargs: allargs
    while  (`"`first'"' != "using" & `"`first'"' != "") {
        gettoken first allargs: allargs
    }
    if `"`first'"' == "using" {
        gettoken first 0: 0

        while (`"`first'"' != "using" & `"`first'"' != "") {
            local initlist "`initlist' `first'"
            gettoken first 0: 0
        }
        local usind = "using"
    }

    syntax anything(name=gpgfile) [, clear openssl *]

    qui {
        if !missing("`openssl'") {
            _gfn, filename(`gpgfile') extension(.dta.enc)
        }
        else {
            _gfn, filename(`gpgfile') extension(.dta.gpg)
        }
        local gpgfile = r(fileout)

        _ok2use, filename(`gpgfile') `clear'
        tempfile tmpdat

        * Request password from user
        noi _requestPassword "`gpgfile'"

        if !missing("`openssl'") {
            shell openssl aes-256-cbc -a -d -in "`gpgfile'" -out `tmpdat' -k "$pass"
        }
        else {
            whereis gpg
            shell `r(gpg)' --batch --yes --passphrase "$pass" --output `tmpdat' --decrypt "`gpgfile'"
        }

        use `initlist' `usind' `tmpdat', clear `options'
        global S_FN = "`gpgfile'"
    }
end

* Create filename to use with encrypted save/use (gpgsave)
*! 0.0.1 EB, Nov 11, 2017
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


* OK to open filename with compressed use? (gpgsave and zipsave)
*! 0.0.1 EB, Nov 11, 2017
pr de _ok2use
    version 9.2
    syntax , filename(string asis) [clear]

    /* We want to break off if the file to use doesn't exist */
    capture confirm file `"`filename'"'
        if _rc ~= 0 {
        noi error _rc
    }

    /* We want to break off before decompression if data have changed and thus
    the subsequent -use- would be disallowed without a -clear- */

    if "`clear'" == "" {
        if c(changed) == 1 {
        noi error 4
        }
    }
end

pr de _requestPassword
    capture quietly log off
    di as input "Please enter the password for `1'", _newline _request(pass)
    capture quietly log on
end
