pr de gpgmerge
* Merge a gpg dataset
*! 0.0.2  EB, Dec 14, 2017 - Support openssl encryption
*! 0.0.1a EB, Nov 30, 2017 - Add merge type selection
*! 0.0.1  EB, Nov 11, 2017
    version 11

    gettoken mtype 0 : 0, parse(" ,")

    if (!strpos("`mtype'", ":") & "`mtype'"!="") {
        if (_caller()>=11) {
            di as smcl as txt "{p}"
            di as smcl "(note: you are using old"
            di as smcl "{bf:merge} syntax; see"
            di as smcl "{bf:{help merge:[D] merge}} for new syntax)"
            di as smcl "{p_end}"
        }
        merge_10 `mtype' `0'
        exit
    }

    local mtype `"`mtype'"'

    qui {
        gettoken first 0: 0

        while (`"`first'"' != "using" & `"`first'"' != "") {
        local vlist "`vlist' `first'"
        gettoken first 0: 0
    }

    if "`vlist'" != "" {
        unab vlist : `vlist'
        foreach var of local vlist {
            capture confirm variable `var'
            if _rc {
              di as err "variable `var' not found"
              exit 111
            }
        }
    }

    if (`"`first'"' != "using") {
        di as err "using required"
        exit 100
    }
    else {
        syntax anything(id="gpgfilelist") [, openssl *]
    }

    local anything2 `"`anything'"'

    gettoken gpgfile anything: anything
    while (`"`gpgfile'"' ~= "") {

    _gfn, filename("`gpgfile'") extension(.dta.gpg)
    local gpgfile = r(fileout)

    /* We want to break off if the file to merge with doesn't exist */

    capture confirm file `"`gpgfile'"'
    if _rc ~= 0 {
        noi error _rc
    }
        gettoken gpgfile anything: anything
    }

    local fn = 0
    gettoken gpgfile anything2: anything2
    while (`"`gpgfile'"' ~= "") {

        _gfn, filename("`gpgfile'") extension(.dta.gpg)
        local gpgfile = r(fileout)

        tempfile tmpdat`fn'

        noi _requestPassword "`gpgfile'"

        if !missing("`openssl'") {
            shell openssl aes-256-cbc -a -d -in "`gpgfile'" -out `tmpdat`fn'' -k "$pass"
        }
        else {
            whereis gpg
            shell `r(gpg)' --batch --yes --passphrase "$pass" --output `tmpdat`fn'' --decrypt "`gpgfile'"
        }
        
        local filelist = "`filelist' `tmpdat`fn''"
        local fn = `fn' + 1

        gettoken gpgfile anything2: anything2
    }

    merge `mtype' `vlist' using `filelist', `options'
    }
end
* Create filename to use with encrypted save/use (gpgsave)
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
    di as input "Please enter the password for `1'", _newline _request(pass)
    *quietly log on
end
