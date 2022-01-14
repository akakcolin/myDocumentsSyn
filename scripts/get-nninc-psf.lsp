#!/usr/bin/env newlisp
# download psf file nninc
(dolist (fname (2 (main-args)))
    (write-file fname (get-url (append "http://nninc.cnf.cornell.edu/psp_files/" fname)))
    (println "file ---> " fname)
)
(exit)
