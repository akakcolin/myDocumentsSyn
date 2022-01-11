#!/usr/local/bin/newlisp

(set 'pwd (append (real-path) "/"))

;(println pwd)

(define (generate-dftb-jobs file-prefix job-type) 
  (dolist (i (directory "./" {^[^.]}))
    (begin 
      (if (not (directory? i))
	  (begin 
	    (let (iffind (starts-with  i file-prefix ))
	      (if iffind
		  (begin
		    (set 'new-dirname (chop i 4))
		    ;(make-dir new-dirname)
		    ;(exec (string " cp  " i " " new-dirname "/"))
		    ;(exec (string "cp ../run_cg.py " new-dirname "/"))
		    ;(exec (string "cp ../run_unit.py " new-dirname "/"))
		    (exec (string "cp run_cellopt.py " new-dirname "/"))
		    (println (string "cd " new-dirname " && python run_" job-type ".py " i ))
		    (exec (string "cd " new-dirname " && python run_" job-type ".py " i ))
		    )
		  )
	      )
	    )
	  )
      )
    )
  )


(define (gather_cg_unit file-prefix ) 
  (dolist (i (directory "./" {^[^.]}))
    (begin 
      (if (not (directory? i))
	  (begin 

	    (let (iffind (starts-with  i file-prefix ))
	      (if iffind
		  (begin
		    (set 'new-dirname (chop i 4))
		    ;(make-dir new-dirname)
		    ;(exec (string " cp  " i " " new-dirname "/"))
		    (println (string " sed -i '1c " new-dirname "' " i))
		    (set 'energy-cg (exec (string "cd " new-dirname " && tail -1 cg.log | awk '{print $5}'")))
		    (set 'energy-unit (exec (string "cd " new-dirname " && tail -1 dftb_unit.log | awk '{print $4}'")))
		    (set 'energy-cellopt (exec (string "cd " new-dirname " && tail -1 cellopt2.log | awk '{print $1}'")))
		    (set 'step-cg (exec (string "cd " new-dirname " && wc cg.log | awk '{print $1}'")))
		    (set 'step-unit (exec (string "cd " new-dirname " && wc dftb_unit.log | awk '{print $1}'")))
		    (set 'step-cellopt (exec (string "cd " new-dirname " && wc cellopt2.log | awk '{print $1}'")))
		    (println (format "%s ," new-dirname)  (format "%s ," step-cg)(format " %s ," step-unit) (format " %s  ," step-cellopt) (format " %s  ," energy-cg) (format " %s  ," energy-unit) (format " %s," energy-cellopt))
		    ; (println new-dirname)
		    )
		  )
	      )
	    )
	  )
      )
    )
  )

(define (sed_file_firstline file-prefix ) 
  (dolist (i (directory "./" {^[^.]}))
    (begin 
      (if (not (directory? i))
	  (begin 
	    (let (iffind (starts-with  i file-prefix ))
	      (if iffind
		  (begin
		    (set 'new-dirname (chop i 4))
		    (println (string " sed -i '1c data_" new-dirname "' " i))
		    (exec (string " sed -i '1c data_" new-dirname "' " i))
		    )
		  )
	      )
	    )
	  )
      )
    )
  )


(define (plot-energy file-prefix ) 
  (dolist (i (directory "./" {^[^.]}))
    (begin 
      (if (not (directory? i))
	  (begin 

	    (let (iffind (starts-with  i file-prefix ))
	      (if iffind
		  (begin
		    (set 'new-dirname (chop i 4))
		    ;(make-dir new-dirname)
		    ;(exec (string " cp  " i " " new-dirname "/"))
		    (exec (string "cp plot.plt " new-dirname "/"))
		    (exec (string "cd " new-dirname " &&  awk '{print $5}' cg.log >cg"))
		    (exec (string "cd " new-dirname " && grep Sci dftb_unit.log | awk '{print $4}' >unit"))
		    (exec (string "cd " new-dirname " && cat cellopt2.log >cellopt2"))
		    (exec (string "cd " new-dirname " && gnuplot < plot.plt"))
		    (exec (string "cd " new-dirname " && cp cg_unit_cellopt2.png ../plot_" new-dirname ".png" ))
		    (println new-dirname)
		    )
		  )
	      )
	    )
	  )
      )
    )
  )

;(generate-dftb-jobs "DFTB_st" "unit")
;(generate-dftb-jobs "DFTB_st" "cellopt")
;(gather_cg_unit "FF_st")
;(sed_file_firstline "DFTB_st")
;(sed_file_firstline "FF_st")
;(sed_file_firstline "VASP_OPT_st")
(plot-energy "FF_st")

(exit)
