pr de gpgappend
* Append a gpg dataset
*! 0.0.1 EB, Dec 14, 2017
*! 0.0.1 EB, Nov 11, 2017
version 9.2
    qui {
        gettoken first 0: 0
        if (`"`first'"' != "using") {
        di as err "using required"
        exit 100
        }

        syntax anything(name=gpgfile) [, openssl  age *]

        if !missing("`age'") {
            _gfn, filename(`gpgfile') extension(.dta.age)
        }
        else if !missing("`openssl'") {
            _gfn, filename(`gpgfile') extension(.dta.enc)
        }
        else {
            _gfn, filename(`gpgfile') extension(.dta.gpg)
        }
        local gpgfile = r(fileout)

        /* We want to break off if the file to append doesn't exist */
        capture confirm file `"`gpgfile'"'
        if _rc ~= 0 {
            noi error _rc
        }

        tempfile tmpdat

        if !missing("`age'") {
            * Request age_key from user
            noi _requestage_key "`file'"
            whereis age
            shell `r(age)' -d -i $age_key "`gpgfile'" > `tmpdat'
        }
        else if !missing("`openssl'") {
            * Request password from user
            noi _requestPassword "`file'"
            shell openssl aes-256-cbc -md md5 -a -d -in "`gpgfile'" -out `tmpdat' -k "$pass"
        }
        else {
            * Request password from user
            noi _requestPassword "`file'"
            whereis gpg
            shell `r(gpg)' --batch --yes --passphrase "$pass" --output `tmpdat' --decrypt "`gpgfile'"
        }

        append using `tmpdat', `options'
    }
end
* Create filename to use with compressed save/use (gpgsave and zipsave)
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

pr de _requestPassword
    if missing("${pass}") {
        capture quietly og off
        di as input "Please enter the password for `1'", _newline _request(pass)
        capture quietly log on
    }
end

pr de _requestage_key
    if missing("${age_key}") {
        capture quietly log off
        di as input "Please enter the path to your key file for `1'", _newline _request(age_key)
        capture quietly log on
    }
end
