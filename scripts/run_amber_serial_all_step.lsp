#!/usr/local/env newlisp
; a simple script to do heat calculation
; serial vertion to do free energy calculation flow

(set 'pwd (append (real-path) "/"))

;get random id from [0 1 2 3]
(define (gpuid)
 (amb 0 1 2 3))


;; molcular dir
(set 'molecular-dir nil)
;; setting  amber/cuda environment
(set 'amber-arg  (string "export AMBERHOME=\"/home/bob01/project/amber18\" \n"))
(set 'pmemd-cuda-path  (string " /home/bob01/project/amber18/bin/pmemd.cuda "))
(set 'cuda-arg (string "export CUDA_HOME=\"/usr/local/cuda\" \n"))
(set 'cuda-device (string "export CUDA_VISIBLE_DEVICES=\"" (gpuid) "\" \n"))


(set 'image-dir nil)
(set 'pmemd-mpi-exec (string " /home/bob01/project/amber18/bin/pmemd.cuda.MPI "))
(set 'cpptraj-command (string "cpptraj_new -p prmtop.0 -y mdcrd.000 -tl | awk '{print $2}'"))

(define (pmemd-command prmtop-item)
  (string pmemd-cuda-path " -i heat.in -p prmtop." prmtop-item " -c min.rst7 -ref min.rst7 -O -o heat.out -inf heat.info -e heat.en -r heat.rst7 -l heat.log -x heat.nc \n")
)

(define (amber-group-mpi-exec num-image group-file)
  (string "mpirun -np " num-image " " pmemd-mpi-exec " -ng " num-image " -groupfile " group-file)
  )

; get dir list , save to image-dir
(define (get-image-dir-list)
  (set'file-list (directory pwd {^[^.]}))
  (dolist (item file-list)
    (if (directory? (append pwd item))
        (push item image-dir  -1)))
)

; num to string
(define (string-id num)
  (if 
    (< num 10) (string "00" (string num))
    (< num 100) (string "0" (string num))
    (< num 1000) (string num))
)

; get current dir list 
(define (get-molecular-dir-list)
  (set'file-list (directory pwd {^[^.]}))
  (dolist (item file-list)
    (if (directory? (append pwd item))
        (push item molecular-dir  -1)))
)

(define (num-physical-cpu)
  (nth 0 (exec (string "cat /proc/cpuinfo | grep 'physical id'| sort | uniq | wc -l")))
  )

(define (num-cpu-cores)
  (nth 0 (exec (string "cat /proc/cpuinfo | grep 'processor' | wc -l")))
  )


(define (run-parse-task a i num_frame num startid)
   (println (string "cd " a " && python parse_amber.py " i " " num_frame " " num " " startid))
   (exec (string "cd " a " && python parse_amber.py " i " " num_frame " " num " " startid))
)

(define (run-rerun-task item i numjob)
  (set 'command (string "cd " item " && parallel -j " numjob " -a " i "_pmemd_command"))
  (println command)
  (exec command)
)

(define (run-parse-energy i num_ham num_frames item)
 (exec (string " python parse_energy_my.py  " i " " num_ham " " num_frames " " item))
)


; parse dir to find prmtop file name and  return the number  
;
; for example  1.00/prmtop.5  
; (get-prmtop-num 0.00) will return 5
; this function is not used in current script
(define (get-prmtop-num folder)
  (set 'amber-file-list (directory folder {^[^.]}))
  (dolist (item amber-file-list)
    (if (regex {prmtop} item)
       (set 'prmtop-item (nth 0 (find-all {\d{3}|\d{2}$|\d$} item)))
     ))
   (int prmtop-item)
)

; main function: create run-script file and exec it
(define (run-task folder run-script)
  (local (amber-file-list prmtop-item)
  (set'amber-file-list (directory folder {^[^.]}))
  ;(println amber-file-list)
  (dolist (item amber-file-list)
    (if (regex {prmtop} item)
       (set 'prmtop-item (nth 0 (find-all {\d{3}|\d{2}$|\d$} item)))
     ))
  ;(println prmtop-item)
  (if (file? (append folder run-script)) 
   (delete-file (append folder run-script)))  
 ;(println (append folder "run.sh"))
 (append-file (append folder run-script) (string "#!/usr/bin/env bash\n")) 
 (append-file (append folder run-script) (string amber-arg))
 (append-file (append folder run-script) (string cuda-arg ))
 ;(append-file (append folder run-script) cuda-device)
 (append-file (append foloder run-script) (pmemd-command prmtop-item))
 (exec (string "cd " folder " && sh " run-script))
)
)

; copy file to dir and sbatch job
(define (run-single-task dir)
  (begin 
  (exec (string "cp parse_amber.py " dir))
  (exec (string "cp parse_energy_my.py " dir))
  (exec (string "cp rerun_script.py " dir))
  (exec (string "cp run_parse_amber.lsp " dir))
  (exec (string "cp run_amber_gpu.lsp " dir))
  (exec (string "cp run_amber_cpu.lsp " dir))
  (exec (string "cp run_gpu.sh " dir))
  (exec (string "cp run_cpu.sh " dir))
  (exec (string "cd " dir " && sbatch run_gpu.sh"))
)
)

(define (run-single-task-serial dir)
  (begin 
  (exec (string "cp parse_amber.py " dir))
  (exec (string "cp parse_energy_my.py " dir))
  (exec (string "cp rerun_script.py " dir))
  (exec (string "cp run_parse_amber.lsp " dir))
  (exec (string "cp run_amber_gpu.lsp " dir))
  (exec (string "cp run_amber_cpu.lsp " dir))
  (exec (string "cp run_gpu.sh " dir))
  (exec (string "cp run_cpu.sh " dir))
  (exec (string "cd " dir " && newlisp run_amber_gpu.lsp"))
)
)

(define (search-tree-run-cuda dir file-name)
 (dolist (item (directory dir {^[^.]}))
   (if (directory? (append dir item))
    ; search the directory
    (search-tree-run-cuda (append dir  item "/") file-name)
    ; or process the file
    (if (find file-name item))
     (begin 
        (println dir)
        (run-single-task-serial dir)
	)
     )
   )
)


;scan dir and exec run-task
(define (search-tree-and-run dir file-name run-script)
 (dolist (item (directory dir {^[^.]}))
   (if (directory? (append dir item))
    ; search the directory
    (search-tree-and-run (append dir  item "/") file-name run-script)
    ; or process the file
    (if (find file-name item))
     (begin 
        (run-task dir run-script)
        (println dir)
        )
     )
   )
 )



;create cpptraj config in file
(define (create-cpptraj-script image-id num-frames in-file)
  (local (i)
    (if (file? in-file)
	(delete-file in-file))
    (set 'cpptraj-config-in (open in-file "write"))
    (device cpptraj-config-in)
    (set 'i 0)
    (println (string "parm prmtop." image-id))
    (println (string "trajin mdcrd." (string-id image-id) " 1 " num-frames))
    (dotimes (i num-frames)
	     (println (string "trajout " i ".crd" onlyframes (+ i 1)))
	     )
    (device 0)
    (close cpptraj-config-in)
    )
)

; now run the program
(println  "molecular list need to calculate free-energy:")
(get-molecular-dir-list)
(set 'molecular-dir (sort molecular-dir))
;(set 'molecular-dir (list "CDK2" "JNK1" "Thrombin"))
(println molecular-dir)


;
(dolist (item molecular-dir)   
  (println item)
 (search-tree-and-run (append pwd item "/") "min.in" "run.sh")
)

; scan dir and submit gpu job
(dolist (item molecular-dir)   
  (println item)
 (search-tree-run-cuda (append pwd item "/") "single-run-unit")
 )



; now run the program
;
;(set 'molecular-dir (list "CDK2" "JNK1" "Thrombin"))
(define (run-single-task-serial dir)
  (get-image-dir-list)

  (set 'image-dir (sort image-dir))
  (set 'num-image (length image-dir))
  (set 'num-frames (nth 0 (exec cpptraj-command)))
  (println  "analyse traj file f for image list: ")
  (println image-dir)
  (println "number of frames is: " num-frames)
  (set 'i 0)
  (dolist (item image-dir)
	  (exec (string "cp parse_amber.py " item ))
	  (spawn 'f1 (run-parse-task item i num-image num-frames 0))
	  (inc i)
	  )
  (println "\n")
  (until (sync 10000) (println "parsing coord..."))
  (println "parse coordinates is done!")

  (set 'i 0)
  (dolist (item image-dir)
	  (run-rerun-task item i (num-cpu-cores))
	  (inc i)
	  )

  (set 'i 0)
  (dolist (item image-dir)
	  (spawn 'f1 (run-parse-energy i num-image num-frames item))
	  (inc i)
	  )

  (println "\n")
  (until (sync 10000) (println "parsing energy..."))
  (println "parse energy is done!")
  )

(exit)
