pr de gpgsave
* Save as gpg encrypted dataset
*! 0.0.3 EB, Sep 7, 2021 - Support age encryption
*! 0.0.2 EB, Dec 14, 2017 - Support openssl encryption
*! 0.0.1 EB, Nov 11, 2017

    version 9.2
    syntax [anything(name=file)] [, replace openssl age COMPress(integer 0) *]
    qui {

    if `"`file'"' == "" {
        local file = `""$S_FN""'
        if `"$S_FN"' == "" {
            di in red "invalid file specification"
            exit
        }
    }

    if !missing("`age'") {
        _gfn, filename(`file') extension(.dta.age)
    }
    else if !missing("`openssl'") {
        _gfn, filename(`file') extension(.dta.enc)
    }
    else {
        _gfn, filename(`file') extension(.dta.gpg)
    }
    local file = r(fileout)

    _ok2encrypt, filename(`file') `replace'

    tempfile tmpdat
    sa `tmpdat', `options'

    if !missing("`age'") {
        * Request password from user
        noi _requestPubage_key "`file'"
        whereis age
        shell `r(age)' -R $pub_age_key `tmpdat' > "`file'"
    }
    else if !missing("`openssl'") {
        * Request password from user
        noi _requestPassword "`file'"
        shell openssl aes-256-cbc -a -salt -in `tmpdat' -out "`file'" -k "$pass"
    }
    else {
        * Request password from user
        noi _requestPassword "`file'"
        whereis gpg
        shell `r(gpg)' --batch --yes --passphrase "$pass" -z `compress' --output "`file'" --symmetric `tmpdat'
    }

    global S_FN = `"`file'"'

    noi di in green "data encrypted and saved in file `file'"
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


* OK to save filename with encrypted save? (gpgsave)
*! 0.0.1 EB, Nov 11, 2017
pr de _ok2encrypt
    version 9.2
    syntax , filename(string asis) [replace]

    if "`replace'" == "" {
        confirm new file "`filename'"
    }
    else {
        capture confirm file "`filename'"
        if _rc == 0 {
        erase "`filename'"
        }
        else {
            di in green `"(note: file `filename' not found)"'
        }
    }
end

pr de _requestPassword
    if missing("${pass}") {
        capture quietly log off
        di as input "Please enter the password for `1'", _newline _request(pass)
        capture quietly log on
    }
end

pr de _requestPubage_key
    if missing("${pub_age_key}") {
        capture quietly log off
        di as input "Please enter the path to the public key file for `1'", _newline _request(pub_age_key)
        capture quietly log on
    }
end
