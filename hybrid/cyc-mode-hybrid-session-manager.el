;; (add-hook 'w3m-mode-hook (lambda () (local-unset-key "\C-ccm")))

(global-set-key "\C-c\C-k\C-vCY" 'cmhsm-cyc-quick-start)
(global-set-key "\C-c\C-k\C-vCD" 'cmhsm-cyc-quick-start-defaults)

(global-set-key "\C-ccmCyc" 'cmhsm-select-cyc-connection)
(global-set-key "\C-ccmCYC" 'cmhsm-select-open-cyc-connection)
(global-set-key "\C-ccmcyc" 'cmhsm-switch-to-cyc)
(global-set-key "\C-ccmcys" 'cmhsm-temporary-connect-system-cyc)
(global-set-key "\C-ccmcyk" 'cmhsm-stop-cyc)
(global-set-key "\C-ccmcyj" 'cmhsm-fix-cyc-width)

(global-set-key "\C-ccmLL" 'cmhsm-select-load-cyc)
(global-set-key "\C-ccmLa" 'cmhsm-load-cyc-all)

(global-set-key "\C-ccmLc" 'cmhsm-load-cyc-cso)
(global-set-key "\C-ccmLs" 'cmhsm-load-cyc-cw)
(global-set-key "\C-ccmLf" 'cmhsm-load-cyc-frdcsa)
(global-set-key "\C-ccmLp" 'cmhsm-load-cyc-posi)

;; (global-set-key "\C-ccmoe" 'cmhsm-open-cmhsm-el)
;; (global-set-key "\C-ccmot" 'cmhsm-open-todo)

(global-set-key "\C-ccmll" 'cmhsm-select-load-ffap)
(global-set-key "\C-ccmlL" 'cmhsm-select-load-find-ffap)

(global-set-key "\C-ccms" 'cmhsm-search-my-kb-dir)
(global-set-key "\C-ccmS" 'cmhsm-search-kb-dir)
(global-set-key "\C-ccmld" 'cmhsm-load-ffap-kb-dir)
(global-set-key "\C-ccmlr" 'cmhsm-load-ffap-flp)
(global-set-key "\C-ccmlg" 'cmhsm-load-ffap-reverse-engineering)
(global-set-key "\C-ccmlf" 'cmhsm-load-ffap-frdcsa)
(global-set-key "\C-ccmla" 'cmhsm-load-ffap-frdcsa-shared-startup)
(global-set-key "\C-ccmlF" 'cmhsm-load-ffap-fantasy)
(global-set-key "\C-ccmlP" 'cmhsm-load-ffap-prolog-version)
(global-set-key "\C-ccmlp" 'cmhsm-load-ffap-posi)
;; (global-set-key "\C-ccmlC" 'cmhsm-load-ffap-choose)
(global-set-key "\C-ccmlc" 'cmhsm-load-ffap-cso)
(global-set-key "\C-ccmlw" 'cmhsm-load-ffap-cw)
(global-set-key "\C-ccmlW" 'cmhsm-load-ffap-cw-rest)
(global-set-key "\C-ccmlt" 'cmhsm-load-ffap-todo)
(global-set-key "\C-ccmlT" 'cmhsm-load-ffap-tests)
(global-set-key "\C-ccmle" 'cmhsm-load-ffap-perform)
(global-set-key "\C-ccmlu" 'cmhsm-load-ffap-function-reference)
(global-set-key "\C-ccmlU" 'cmhsm-load-ffap-cfo)

(defvar cmhsm-release nil)
(defvar cmhsm-version nil)
(defvar cmhsm-remote-user nil)
(defvar cmhsm-remote-host nil)
(defvar cmhsm-remote-host-port nil)
(defvar cmhsm-remote-offset nil)
(defvar cmhsm-current-connection-name nil)

;; (cmhsm-remote-cyc-subl-directory-helper)

;; (cmhsm-local-cyc-subl-directory-helper)

(defun cmhsm-local-cyc-subl-directory-helper ()
 ""
 (let ((hostname (chomp (shell-command-to-string "hostname -f"))))
  (cmhsm-get-local-cyc-info hostname)
  (cmhsm-cyc-subl-directory-helper cmhsm-local-cyc-subl-directory)))

(defun cmhsm-kb-directory-helper ()
 ""
 (let ((hostname (chomp (shell-command-to-string "hostname -f"))))
  ;; (cmhsm-get-local-cyc-info hostname)
  ;; (cmhsm-cyc-subl-directory-helper cmhsm-local-cyc-subl-directory)
  "/var/lib/myfrdcsa/codebases/internal/freekbs2/data-git/KBs/cyc"
  ))

(defvar cmhsm-running-cycs-hash (make-hash-table :test 'equal))

(defun cmhsm-cyc-quick-start-defaults ()
 ""
 (interactive)
 (let* ()
  (mapcar
   (lambda (cyc)
    (cmhsm-start-cyc cyc))
   (list
    "*ResearchCyc-4.0q*"
    "*ResearchCyc-1.0 on vagrant@kbs32.frdcsa.org:2238*"
    "*Cyc-10 on vagrant@ai.frdcsa.org:2241*"))))
  
(defun cmhsm-start-cyc  (cyc)
 ""
 (interactive)
 (cmhsm-select-cyc-connection cyc)
 (cmhsm-switch-to-cyc)
 (puthash cyc t cmhsm-running-cycs-hash))

;; (cmhsm-list-currently-running-cycs)

(defun cmhsm-list-currently-running-cycs ()
 ""
 (interactive)
 (let ((list-1 nil))
  (sort (maphash (lambda (key value) (push key list-1)) cmhsm-running-cycs-hash) #'string-lessp)
  list-1))

(defun cmhsm-cycle-between-currently-running-cycs ()
 ""
 (interactive)
 (let ((list (cmhsm-list-currently-running-cycs)))
  (cmhsm-select-cyc-connection
   (nth
    (+ (kmax-get-index-of-first-item-in-list current-cyc (append list-1 list-1)) 1)
    list-1))))

(defun cmhsm-choose-currently-running-cyc ()
 ""
 (interactive)
 (let* ((cyc (completing-read "Choose running cyc: " (cmhsm-list-currently-running-cycs))))
  (cmhsm-select-cyc-connection cyc)))

(defun flp-cyc-open-defaults ()
 (interactive)
 (let* ((cycs (cmhsm-list-currently-running-cycs)))
  (delete-other-windows)
  (split-window-right)
  (split-window-below)
  (cmhsm-select-cyc-connection (nth 1 cycs))
  (other-window)
  (cmhsm-select-cyc-connection (nth 2 cycs))
  (other-window)
  (cmhsm-select-cyc-connection (nth 3 cycs))))

(defun cmhsm-get-key (connection key)
 (interactive)
 (setq cmhsm-get-key-result nil)
 (mapcar
  (lambda (key-value-pair)
   (if (equal (car key-value-pair) key)
    (setq cmhsm-get-key-result (cdr key-value-pair))))
  connection)
 cmhsm-get-key-result)

(defun cmhsm-get-local-cyc-info (hostname)
 ""
 (interactive)
 (setq cmhsm-local-cyc-subl-directory nil)
 (mapcar
  (lambda (connection)
   (if (string= (cmhsm-get-key connection cmhsm-remote-host) hostname)
    (setq cmhsm-local-cyc-subl-directory (cmhsm-get-key connection cmhsm-remote-cyc-subl-directory))))
  cmhsm-cyc-connections)
 (if (string= cmhsm-local-cyc-subl-directory nil)
  (setq cmhsm-local-cyc-subl-directory "/var/lib/myfrdcsa/codebases/internal/freekbs2/data-git/")
  (setq cmhsm-local-cyc-subl-directory cmhsm-local-cyc-subl-directory)))

(defun cmhsm-remote-cyc-subl-directory-helper ()
 ""
 (cmhsm-cyc-subl-directory-helper cmhsm-remote-cyc-subl-directory))

(defun cmhsm-cyc-subl-directory-helper (cyc-subl-dir)
 ""
 (if (string= cmhsm-release "OpenCyc")
  (concat cyc-subl-dir "MyKBs/cyc/ocyc/" cmhsm-version "/")
  (if (string= cmhsm-release "ResearchCyc")
   (concat cyc-subl-dir "MyKBs/cyc/rcyc/" cmhsm-version "/")
   (if (string= cmhsm-release "Cyc")
    (concat cyc-subl-dir "MyKBs/cyc/cyc/" cmhsm-version "/")
    (error "Unknown Cyc Version")))))

(defvar cmhsm-cyc-connections
 (list
  (list
   '(cmhsm-release "ResearchCyc")
   '(cmhsm-version "4.0q")
   '(cmhsm-remote-user "vagrant")
   '(cmhsm-remote-host "kbs.frdcsa.org")
   '(cmhsm-remote-host-port 2239)
   '(cmhsm-remote-offset nil)
   '(cmhsm-offset nil)
   '(cmhsm-remote-cyc-subl-directory "/vagrant/cyc/")
   )
  (list
   '(cmhsm-release "ResearchCyc")
   '(cmhsm-version "4.0q")
   '(cmhsm-remote-user nil)
   '(cmhsm-remote-host nil)
   '(cmhsm-remote-host-port nil)     
   '(cmhsm-remote-offset nil)
   '(cmhsm-remote-cyc-subl-directory "/var/lib/myfrdcsa/codebases/internal/freekbs2/data-git/")
   )
  (list
   '(cmhsm-release "ResearchCyc")
   '(cmhsm-version "1.0")
   '(cmhsm-remote-user "vagrant")
   '(cmhsm-remote-host "kbs32.frdcsa.org")
   '(cmhsm-remote-host-port 2238)
   '(cmhsm-remote-offset nil)
   '(cmhsm-remote-cyc-subl-directory "/vagrant/cyc/")
   )
  (list
   '(cmhsm-release "OpenCyc")
   '(cmhsm-version "4.0")
   '(cmhsm-remote-user "vagrant")
   '(cmhsm-remote-host "kbs.frdcsa.org")
   '(cmhsm-remote-host-port 2239)
   '(cmhsm-remote-offset 60)
   '(cmhsm-remote-cyc-subl-directory "/vagrant/cyc/")
   )
  (list
   '(cmhsm-release "Cyc")
   '(cmhsm-version "10")
   '(cmhsm-remote-user "vagrant")
   '(cmhsm-remote-host "ai.frdcsa.org")
   '(cmhsm-remote-host-port 2241)
   '(cmhsm-remote-offset nil)
   '(cmhsm-remote-cyc-subl-directory "/cyc/")
   )
  )
 )

;; (cmhsm-load-available-cyc-connections)

(defun cmhsm-load-available-cyc-connections (&optional when)
 ""
 (interactive)
 (setq cmhsm-connection-list nil)
 (setq cmhsm-open-connection-list nil)
 (setq cmhsm-tmp-1)
 (let ((stop-condition nil))
  (mapcar
   (lambda (connection)
    (if (not cmhsm-tmp-1)
     (let ((name (cmhsm-process-connection connection)))
      (if (string= name when)
       (setq cmhsm-tmp-1 t))
      (setq cmhsm-current-connection-name name)
      (setq cmhsm-current-connection connection)
      (unshift cmhsm-current-connection-name cmhsm-connection-list)
      (if (gnus-buffer-exists-p (get-buffer cmhsm-current-connection-name))
       (unshift cmhsm-current-connection-name cmhsm-open-connection-list))
      )))
   cmhsm-cyc-connections)
  cmhsm-current-connection))

(defun cmhsm-process-connection (connection)
 (interactive)
 (mapcar
  (lambda (key-value-pair)
   (eval (cons 'setq key-value-pair)))
  connection)
 (cmhsm-current-connection-fn))

(defun cmhsm-select-open-cyc-connection ()
 ""
 (interactive)
 (cmhsm-load-available-cyc-connections)
 (setq cmhsm-selected-connection-name
  (completing-read
   "Choose Cyc Instance: "
   cmhsm-open-connection-list))
 (message
  (cmhsm-process-connection
   (cmhsm-load-available-cyc-connections cmhsm-selected-connection-name))))

(defun cmhsm-cyc-quick-start ()
 ""
 (interactive)
 (unless (boundp 'cmhsm-selected-connection-name)
  (cmhsm-select-cyc-connection "*ResearchCyc-4.0q*"))
 (cmhsm-switch-to-cyc)
 (end-of-buffer)
 (insert "()")
 (comint-send-input))

(defun cmhsm-select-cyc-connection (&optional connection-name)
 ""
 (interactive)
 (cmhsm-load-available-cyc-connections)
 (setq cmhsm-selected-connection-name
  (or
   connection-name
   (completing-read
    "Choose Cyc Instance: "
    cmhsm-connection-list)))
 (message
  (cmhsm-process-connection
   (cmhsm-load-available-cyc-connections cmhsm-selected-connection-name))))

(defun cmhsm-current-connection-fn ()
 ""
 (interactive)
 (concat
  "*"
  (or cmhsm-release "")
  "-"
  (or cmhsm-version "")
  (if (non-nil cmhsm-remote-host)
   (concat " on "
    (if (non-nil cmhsm-remote-user)
     (concat (or cmhsm-remote-user "") "@")
     "")
    (if (non-nil cmhsm-remote-host)
     (concat (or cmhsm-remote-host "")
      (if (non-nil cmhsm-remote-host-port)
       (concat ":" (int-to-string cmhsm-remote-host-port))
       "")))))
  "*"
  )
 ;; (concat "cyc://" cmhsm-remote-host ":" cmhsm-remote-port)
 )

(defun cmhsm-switch-to-cyc ()
 ""
 (interactive)
 ;; FIXME: add the stuff for opening the cyc tunnels as well
 (setq cmhsm-start-shell nil)
 (if (string= cmhsm-release "ResearchCyc")
  (if (string= cmhsm-version "1.0")
   (cmhsm-launch-researchcyc-1.0)
   (if (string= cmhsm-version "4.0q")
    (if (gnus-boundp 'cmhsm-remote-host)
     (if (gnus-buffer-exists-p (cmhsm-current-connection-fn))
      (progn
       (switch-to-buffer (cmhsm-current-connection-fn))
       (setq cmhsm-start-shell t))
      (progn
       (ushell)
       (run-in-ansi-term 
	(concat "ssh -t "
	 (if (gnus-boundp 'cmhsm-remote-host-port) (concat "-p " (int-to-string cmhsm-remote-host-port) " ") "") 
	 (shell-quote-argument (concat (if (gnus-boundp 'cmhsm-remote-user) (concat cmhsm-remote-user "@") "") cmhsm-remote-host))
	 " "
	 ;; "\"cd /var/lib/myfrdcsa/sandbox/researchcyc-4.0q/researchcyc-4.0q/server/cyc/run && ./bin/run-cyc.sh\""
	 ;; "\"cd /var/lib/researchcyc/4.0q/server/cyc/run && ./bin/run-cyc.sh\""
	 "\"screen -x -S cyc -d -RR bash -c \\\"cd /home/vagrant/rcyc && ./run-my-cyc.sh\\\"\""
	 ;; "\"cd /home/vagrant/rcyc && ./run-my-cyc.sh\""
	 ) (cmhsm-current-connection-fn))
       (term-switch-to-shell-mode 'shell-mode)
       (setq cmhsm-start-shell t)))
     ;; FIXME: add part for cmhsm-remote-port
     (if (gnus-buffer-exists-p (cmhsm-current-connection-fn))
      (progn
       (switch-to-buffer (cmhsm-current-connection-fn))
       (setq cmhsm-start-shell t))
      (progn
       (ushell)
       (run-in-ansi-term
	"screen -x -S cyc -d -RR bash -c \"cd /home/andrewdo/rcyc/vagrant/rcyc && ./run-my-cyc-new.sh\""
	(cmhsm-current-connection-fn))
       (term-switch-to-shell-mode 'shell-mode)
       (setq cmhsm-start-shell t))))))
  (if (string= cmhsm-release "OpenCyc")
   (if (gnus-boundp 'cmhsm-remote-host)
    (progn
     (ushell)
     (run-in-shell 
      (concat "ssh "
       (if (gnus-boundp 'cmhsm-remote-host-port) (concat "-p " (int-to-string cmhsm-remote-host-port) " ") "") 
       (shell-quote-argument (concat (if (gnus-boundp 'cmhsm-remote-user) (concat cmhsm-remote-user "@") "") cmhsm-remote-host))
       " "
       "\"cd /var/lib/opencyc/4.0 && ./scripts/run-cyc-60.sh\""
       ) (cmhsm-current-connection-fn))
     (setq cmhsm-start-shell t))
    (progn
     (ushell)
     (switch-to-buffer (cmhsm-current-connection-fn))
     (run-in-shell "cd /var/lib/opencyc/4.0 && ./scripts/run-cyc-60.sh" (cmhsm-current-connection-fn))
     (setq cmhsm-start-shell t))
    )
   ))
 (if cmhsm-start-shell
  (cyc-shell-mode)
  (error "Need to select a Cyc first with cmhsm-select-cyc-connection")))

;; (if (not (derived-mode-p 'cyc-shell-mode))

(defun cmhsm-stop-cyc ()
 ""
 (interactive)
 (kmax-kill-buffer-no-ask (get-buffer (cmhsm-current-connection-fn)))
 (if (kmax-buffer-exists-p cmhsm-cyc-temp-connection-buffer-name)
  (kmax-kill-buffer-no-ask (get-buffer cmhsm-cyc-temp-connection-buffer-name))))

(defun cmhsm-commit-local-mhkb ()
 ""
 (interactive)
 (run-in-shell (concat "cd " (shell-quote-argument (concat cmhsm-local-cyc-subl-directory "MyKBs")) " && (git add .; git commit -m \"Nice Auto\" .; git pull; git push)")))

(defvar cmhsm-cyc-temp-connection-buffer-name "*Cyc Temp Connect*")

(defun cmhsm-temporary-connect-system-cyc ()
 ""
 (interactive)
 (run-in-shell
  "cd /var/lib/myfrdcsa/codebases/minor/cyc-common/scripts && ./test-system-cyc-unilang-query.pl"
  cmhsm-cyc-temp-connection-buffer-name))

(defun cmhsm-select-load-cyc (arg)
 ""
 (interactive "P")
 (if arg (progn
	  (cmhsm-commit-local-mhkb)
	  (cmhsm-sync-git-repos)
	  (read-from-minibuffer "Press any key to proceed...: ")))
 (cmhsm-select-load-cyc-helper "local" nil))

(defun cmhsm-select-load-cyc-helper (&optional local-or-remote load-all)
 ""
 (interactive)
 (cmhsm-switch-to-cyc)
 (let*
  ((all-dirs
	(kmax-grep-list-regexp
	  (kmax-directory-files-no-hidden
	   (if (string= local-or-remote "local")
	    (cmhsm-local-cyc-subl-directory-helper)
	    (cmhsm-remote-cyc-subl-directory-helper)))
	 "[^~]$"))
       (target-dirs
	(if load-all
	 all-dirs
	 (list (completing-read "Load ontology into Cyc: " all-dirs)))))
  (cmhsm-define-vars)
  (dolist (dir target-dirs)
   (comint-send-input)
   (insert
    (concat "(load \""
     (cmhsm-remote-cyc-subl-directory-helper) dir
     "\")"))
   (comint-send-input))))

(defun cmhsm-load-cyc-cw ()
 ""
 (interactive)
 (cmhsm-load-cyc-with-path "cw-rcyc" "subl"))

(defun cmhsm-load-cyc-frdcsa ()
 ""
 (interactive)
 (cmhsm-load-cyc-with-path "frdcsa" "subl"))

(defun cmhsm-load-cyc-posi ()
 ""
 (interactive)
 (cmhsm-load-cyc-with-path "posi" "subl"))

(defun cmhsm-load-cyc-cso ()
 ""
 (interactive)
 (cmhsm-load-cyc-with-path "cso" "subl"))

(defun cmhsm-load-cyc-flp ()
 ""
 (interactive)
 (cmhsm-load-cyc-with-path "free-life-planner" "subl"))

(defun cmhsm-load-cyc-reverse-engineering ()
 ""
 (interactive)
 (cmhsm-load-cyc-with-path "reverse-engineering" "subl"))

(defun cmhsm-load-cyc-with-path (item &optional extension)
 ""
 (interactive)
 (cmhsm-load-cyc (concat (cmhsm-remote-cyc-subl-directory-helper) item (if extension (concat "." extension) ""))))

(defun cmhsm-load-cyc (item)
 ""
 (interactive)
 (switch-to-buffer (cmhsm-current-connection-fn))
 (end-of-buffer)
 (insert (shell-command-to-string 
	  (concat "cat " item " | grep . | grep -vE '^\s*;;'"
	   )))
 (comint-send-input))

(defun cmhsm-load-ffap-with-path (item &optional extension)
 ""
 (interactive)
 (cmhsm-load-ffap (concat (cmhsm-local-cyc-subl-directory-helper) item (if extension (concat "." extension) ""))))

(defun cmhsm-load-ffap (item)
 ""
 (interactive)
 (ffap item))

(defun cmhsm-select-load-ffap ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path
  (completing-read "Please choose an ontology: "
   (kmax-grep-list-regexp
    (kmax-strip-hidden-files
     (kmax-find-name-dired-predicate (cmhsm-local-cyc-subl-directory-helper) (lambda (file) (kmax-filename-has-extension file "subl"))))
    "[^~]$"))))

(defun cmhsm-select-load-find-ffap ()
 ""
 (interactive)
 (ffap
  (completing-read "Please choose an ontology: "
   (kmax-find-name-dired (cmhsm-local-cyc-subl-directory-helper) "\.subl$"))))

;; FIXME: redundant with cmhsm-select-load-ffap

;; (defun cmhsm-load-ffap-choose ()
;;  ""
;;  (interactive)
;;  (let* ((subl-file
;; 	 (completing-read "SubL file to load: "
;; 	  (kmax-grep-list-regexp
;; 	   (kmax-directory-files-no-hidden
;; 	    (cmhsm-local-cyc-subl-directory-helper)) "\.subl$")))
;; 	(item (car (split-string subl-file ".")))
;; 	(extension (cdr (split-string subl-file "."))))
;;   (cmhsm-load-ffap-with-path item extension)))

(defun cmhsm-load-ffap-prolog-version ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "ontology.pl"))

(defun cmhsm-search-kb-dir-old (&optional arg)
 ""
 (interactive "P")
 (if (not arg)
  (run-in-shell
   (concat "cd "(shell-quote-argument (cmhsm-local-cyc-subl-directory-helper)) " && grep -iE "
    (shell-quote-argument (read-from-minibuffer "Cyc Local KB Search: ")) " *")
   "*Cyc Local KB Search*")))

(defun cmhsm-search-my-kb-dir (&optional search)
 ""
 (interactive)
 (let ((search (or search (read-from-minibuffer "Search?: "))))
  (kmax-search-files
   search
   (kmax-grep-list-regexp
    (kmax-find-name-dired (cmhsm-local-cyc-subl-directory-helper) ".subl$")
    "[^~]$")   
   "*Cyc Local KB Search*")))

(defun cmhsm-search-kb-dir (&optional search)
 ""
 (interactive)
 (let ((search (or search (read-from-minibuffer "Search?: "))))
  (kmax-search-files
   search
   (kmax-grep-list-regexp
    (kmax-find-name-dired (cmhsm-kb-directory-helper) ".pl$")
    "[^~]$")
   "*Cyc KB Search*")))

(defun cmhsm-load-ffap-kb-dir (&optional arg)
 ""
 (interactive "P")
 (if arg
  (run-in-shell (cmhsm-local-cyc-subl-directory-helper))  
  (cmhsm-load-ffap (cmhsm-local-cyc-subl-directory-helper))))

(defun cmhsm-load-ffap-flp ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "free-life-planner" "subl"))

(defun cmhsm-load-ffap-cw ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "cw-rcyc" "subl"))

(defun cmhsm-load-ffap-cw-rest ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "cw-rcyc-scratch" "subl"))

(defun cmhsm-load-ffap-fantasy ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "fantasy" "subl"))

(defun cmhsm-load-ffap-function-reference ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "function-reference" "subl"))

(defun cmhsm-load-ffap-cfo ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "cfo" "subl"))

(defun cmhsm-load-ffap-frdcsa ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "frdcsa" "subl"))

(defun cmhsm-load-ffap-tests ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "tests" "subl"))

(defun cmhsm-load-ffap-todo ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "todo" "subl"))

(defun cmhsm-load-ffap-posi ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "posi" "subl"))

(defun cmhsm-load-ffap-cso ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "cso" "subl"))

(defun cmhsm-load-ffap-perform ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "perform" "subl"))

(defun cmhsm-load-ffap-reverse-engineering ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "reverse-engineering" "subl"))

(defun cmhsm-load-ffap-frdcsa-shared-startup ()
 ""
 (interactive)
 (cmhsm-load-ffap-with-path "frdcsa-shared-startup" "subl"))

(defun cmhsm-search-cyc-corpora ()
 ""
 (interactive)
 ;; (search through all our kif and cycl files for a match)
 )



(defun cmhsm-launch-researchcyc-1.0 ()
 ""
 (interactive)
 (if (gnus-boundp 'cmhsm-remote-host)
  (run-in-shell
   (concat "ssh "
    (if (gnus-boundp 'cmhsm-remote-host-port) (concat "-p " (int-to-string cmhsm-remote-host-port) " ") "") 
    (shell-quote-argument (concat (if (gnus-boundp 'cmhsm-remote-user) (concat cmhsm-remote-user "@") "") cmhsm-remote-host))
    " "
    ;; 'cd /var/lib/researchcyc/researchcyc-1.0/scripts && bash -c \\\"./start-researchcyc.sh && sleep 10 && ./run-cyc.sh\\\"'\"
    ;; "\"cd /var/lib/myfrdcsas/versions/myfrdcsa-1.1/vagrant-machines/KBS-FRDCSA-Org/KBS32-FRDCSA-Org && vagrant ssh -c /vagrant/run.sh\""
    "\"cd /vagrant && ./run.sh\""
    ) (cmhsm-current-connection-fn))
  (run-in-shell "cd /var/lib/myfrdcsas/versions/myfrdcsa-1.1/vagrant/columcille.frdcsa.org/ResearchCyc-Columcille-FRDCSA-Org/ResearchCyc-Columcille-FRDCSA-Org && vagrant up; cd /var/lib/myfrdcsas/versions/myfrdcsa-1.1/vagrant/columcille.frdcsa.org/ResearchCyc-Columcille-FRDCSA-Org/ResearchCyc-Columcille-FRDCSA-Org && vagrant ssh -c 'cd /var/lib/myfrdcsa/sandbox/researchcyc-1.0/researchcyc-1.0/scripts && bash -c \"./start-researchcyc.sh && sleep 10 && ./run-cyc.sh\"'" (cmhsm-current-connection-fn))))

(defun cmhsm-load-cyc-all ()
 ""
 (interactive)
 (cmhsm-define-vars)
 (cmhsm-load-cyc-with-path "frdcsa-shared-startup" "subl"))

;; (defun cmhsm-load-cyc-all ()
;;  ""
;;  (interactive)
;;  (cmhsm-load-cyc-cw)
;;  (cmhsm-load-cyc-frdcsa)
;;  (cmhsm-load-cyc-posi)
;;  (cmhsm-load-cyc-cso)
;;  (cmhsm-load-cyc-merediths-version)
;;  (cmhsm-load-cyc-flp))

(defun cmhsm-open-cmhsm-el ()
 ""
 (interactive)
 (cmhsm-load-ffap
  "/var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/cyc-mode-hybrid-session-manager.el"))

(defun cmhsm-open-todo ()
 ""
 (interactive)
 (cmhsm-load-ffap
  "/var/lib/myfrdcsa/codebases/minor/cyc-mode/to.do"))

(defun cmhsm-sync-git-repos ()
 ""
 (interactive)
 ;; FIXME: add the stuff for opening the cyc tunnels as well
 (if (yes-or-no-p (concat "Sync remote git repo: " (cmhsm-remote-cyc-subl-directory-helper) "? ")) 
  (if (string= cmhsm-release "ResearchCyc")
   (if (string= cmhsm-version "1.0")
    (cmhsm-launch-researchcyc-1.0)
    (if (string= cmhsm-version "4.0q")
     (if (gnus-boundp 'cmhsm-remote-host)
      (progn
       (run-in-shell
	(concat "ssh "
	 (if (gnus-boundp 'cmhsm-remote-host-port) (concat "-p " (int-to-string cmhsm-remote-host-port) " ") "") 
	 (shell-quote-argument (concat (if (gnus-boundp 'cmhsm-remote-user) (concat cmhsm-remote-user "@") "") cmhsm-remote-host))
	 " "
	 ;; "\"cd /var/lib/myfrdcsa/sandbox/researchcyc-4.0q/researchcyc-4.0q/server/cyc/run && ./bin/run-cyc.sh\""
	 ;; "\"cd /var/lib/researchcyc/4.0q/server/cyc/run && ./bin/run-cyc.sh\""
	 "\"if [ ! -d " (shell-quote-argument (shell-quote-argument cmhsm-remote-cyc-subl-directory)) "MyKBs ]; then (mkdir -p "
	 (shell-quote-argument (shell-quote-argument cmhsm-remote-cyc-subl-directory)) " && cd "
	 (shell-quote-argument (shell-quote-argument cmhsm-remote-cyc-subl-directory)) " && git clone ssh://readonly@posi.frdcsa.org/gitroot/MyKBs); else "
	 "(cd " (shell-quote-argument (shell-quote-argument cmhsm-remote-cyc-subl-directory)) "MyKBs && (git add .; git commit -m \\\"CMHSM Nice\\\" .; git pull)); fi\""
	 ;; "\"cd /home/vagrant/rcyc && ./run-my-cyc.sh\""
	 )
	(concat (cmhsm-current-connection-fn) "-git")))
      ;; FIXME: add part for cmhsm-remote-port
      (progn
       (run-in-shell
	(concat
	 "cd "
	 (shell-quote-argument (cmhsm-remote-cyc-subl-directory-helper))
	 " && (git add .; git init .; git pull; git push)"
	 (concat (cmhsm-current-connection-fn) "-git")))))))
   (if (string= cmhsm-release "OpenCyc")
    (if (gnus-boundp 'cmhsm-remote-host)
     (progn
      (run-in-shell 
       (concat "ssh "
	(if (gnus-boundp 'cmhsm-remote-host-port) (concat "-p " (int-to-string cmhsm-remote-host-port) " ") "") 
	(shell-quote-argument (concat (if (gnus-boundp 'cmhsm-remote-user) (concat cmhsm-remote-user "@") "") cmhsm-remote-host))
	" "
	"\"cd " (shell-quote-argument (shell-quote-argument (cmhsm-remote-cyc-subl-directory-helper))) " && (git add .; git init -m \\\"CMHSM Nice\\\" .; git pull)\""
	)
       (concat (cmhsm-current-connection-fn) "-git")))

     (progn
      (run-in-shell
       (concat
	"cd "
	(shell-quote-argument (cmhsm-remote-cyc-subl-directory-helper))
	" && (git add .; git init . -m \"CMHSM Nice\"; git pull)"
	(cmhsm-current-connection-fn))
       (concat (cmhsm-current-connection-fn) "-git"))
      (setq cmhsm-start-shell t))
     )))))

(defun cmhsm-fix-cyc-width ()
 "Fix it when the CYC-shell mode is wrapping text prematurely"
 (interactive)
 (kmax-not-yet-implemented))

(defun cmhsm-define-vars ()
 (insert
  (concat
   (join "\n"
   (list
    (concat "(csetq-local *FRDCSA-KB-DIR* \"" (shell-quote-argument (kmax-strip-trailing-forward-slashes (cmhsm-remote-cyc-subl-directory-helper))) "\")")
    (concat "(csetq-local *subl-frdcsa-el-os-directory-separator* \"/\")"))) "\n")))

(provide 'cyc-mode-hybrid-session-manager)
