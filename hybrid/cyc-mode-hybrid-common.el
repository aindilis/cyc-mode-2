(global-set-key "\C-ccwas" 'cmhc-wrap-sexp-with-cyc-assert)
(global-set-key "\C-ccwqu" 'cmhc-wrap-sexp-with-cyc-query)
(global-set-key "\C-cclr" 'cmhc-load-resource)
(global-set-key "\C-cclc" 'cmhc-load-sample-cycl-1)
(global-set-key "\C-cclC" 'cmhc-load-sample-cycl-2)
(global-set-key "\C-cclso" 'cmhc-load-subl-ocyc-functions)
(global-set-key "\C-cclsr" 'cmhc-load-subl-rcyc-functions)
(global-set-key "\C-cclss" 'cmhc-load-subl-reference)
(global-set-key "\C-cccp" 'cmhc-pp-sexp-at-point)
(global-set-key "\C-cccI" 'cmhc-insert-item)
(global-set-key "\C-ccci" 'cmhc-freekbs2-insert-top-of-stack-decyclify)
(global-set-key "\C-cccjc" 'cmhc-jump-to-cyc-lisp)
(global-set-key "\C-cccs" 'cmhc-search-cyc-lisp)
(global-set-key "\C-cccS" 'cmhc-federated-search)
(global-set-key "\C-ccca" 'cmhc-subl-apropos)
(global-set-key "\C-ccct" 'cmhc-insert-template)

(defvar cmhc-subl-rcyc-commands-file "/var/lib/myfrdcsas/versions/myfrdcsa-1.1/vagrant-machines/KBS-FRDCSA-Org/KBS-FRDCSA-Org/cyc/researchcyc-commands.txt")
(defvar cmhc-subl-ocyc-commands-file "/var/lib/myfrdcsas/versions/myfrdcsa-1.1/vagrant-machines/KBS-FRDCSA-Org/KBS-FRDCSA-Org/cyc/opencyc-commands.txt")

(defun cmhc-wrap-sexp-with-cyc-assert ()
 ""
 (interactive)
 (cmhc-wrap-sexp-with "cyc-assert" cmhc-microtheory))

(defun cmhc-wrap-sexp-with-cyc-query ()
 ""
 (interactive)
 (cmhc-wrap-sexp-with "cyc-query" cmhc-microtheory))

(defun cmhc-wrap-sexp-with (&optional subl-command microtheory previous additional)
 "While editing a todo file, use this to mark the solution for a particular task."
 ;; have the option of moving it to the end
 ;; also use the elisp pretty printer (when the git repos are synced)
 (interactive)
 (save-excursion
  (do-todo-list-re-search-forward "[^[:blank:]\n]" nil t) 
  (backward-char)
  (let*
   ((sexp (do-todo-list-kill-sexp-at-point))
    (modified-sexp
     (concat
      "("
      (cmhc-get-subl-command subl-command)
      " "
      (if previous (concat previous " "))
      "'"
      sexp
      (if additional (concat " " additional))
      (if microtheory
       " ")
      (if microtheory
       ;; (cmhc-get-microtheory microtheory)
       microtheory
       )
      ")")))
   (insert modified-sexp))))

(defun cmhc-get-subl-command (subl-command)
 (if subl-command
  subl-command
  (completing-read "Select subl-command"
   (si-list-to-alist (csm-complete-subl "")))))

(setq cmhc-initial-resources
 '(("cyc-api" . "/var/lib/myfrdcsas/versions/myfrdcsa-1.0/codebases/releases/perllib-0.1/perllib-0.1/systems/opencyc-el-0.1/opencyc-el-0.1/cyc-api.el")
   ("sample-cycl-1" . "/var/lib/myfrdcsa/codebases/minor/cyc-common/data-git/DesertShieldMt.cycl")
   ("sample-cycl-2" . "/var/lib/myfrdcsa/codebases/minor/cyc-common/data-git/results.cycl"))
 )

(defvar cmhc-resources nil)

(defun cmhc-load-resources ()
 (interactive)
 (unless cmhc-resources
  (setq cmhc-resources (append cmhc-initial-resources nil))))

(defun cmhc-load-resource ()
 ""
 (interactive)
 (cmhc-load-resources)
 (let ((resource-name (completing-read "Load Cyc Resource: " cmhc-resources)))
  (ffap (cdr (assoc resource-name cmhc-resources)))))

(defun cmhc-load-sample-cycl-1 ()
 ""
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/minor/cyc-common/data-git/DesertShieldMt.cycl"))

(defun cmhc-load-sample-cycl-2 ()
 ""
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/minor/cyc-common/data-git/results.cycl"))

(defun cmhc-load-subl-rcyc-functions ()
 ""
 (interactive)
 (ffap cmhc-subl-rcyc-commands-file))

(defun cmhc-load-subl-ocyc-functions ()
 ""
 (interactive)
 (ffap cmhc-subl-ocyc-commands-file))

(defun cmhc-load-subl-reference ()
 ""
 (interactive)
 (ffap "/var/lib/myfrdcsas/versions/myfrdcsa-1.0/codebases/minor/cyc-common/documentation/www.cyc.com/documentation/subl-reference.html")
 (kmax-view-current-html-file))

(defun cmhc-pp-sexp-at-point ()
 ""
 (interactive)
 (save-excursion
  (do-todo-list-re-search-forward "[^[:blank:]\n]" nil t) 
  (backward-char)
  (set-mark (point))
  (forward-sexp)
  (narrow-to-region (mark) (point))
  (pp-buffer)
  (beginning-of-buffer)
  (condition-case ex
   (while (re-search-forward "\#\<AS\:")
    (backward-char 5)
    (insert "\n")
    (forward-char 5)) ('error nil))
  (emacs-lisp-mode)
  (mark-whole-buffer)
  (indent-region (point) (mark))
  (widen)
  (cyc-shell-mode)))
  
(defun cmhc-insert-item ()
 ""
 (interactive)
 (insert (completing-read "Item to insert?: " (list "#$EverythingPSC"))))

(defun cmhc-freekbs2-insert-top-of-stack-decyclify ()
 "Push the URL given onto the stack"
 (interactive)
 (insert (cmh-decyclify (freekbs2-get-top-of-stack))))

(defun cmhc-search-cyc-lisp ()
 ""
 (interactive)
 (run-in-shell
  (concat "cd /var/lib/myfrdcsa/codebases/minor/cyc-common/cyc-resources/cyc/prologmoo.com/devel/cyc-oldsys/cyc/cyc-lisp/cycl && grep -iE "
   (shell-quote-argument (cmh-referent)) " *.lisp")
  "*Cyc Code Search*"))

(defun cmhc-jump-to-cyc-lisp ()
 ""
 (interactive)
 (run-in-shell "cd /var/lib/myfrdcsa/codebases/minor/cyc-common/cyc-resources/cyc/prologmoo.com/devel/cyc-oldsys/cyc/cyc-lisp/cycl"))

(defun cmhc-get-subl-function ()
 ""
 (interactive)
 (or
  (cyc-mode-get-cyc-constant-or-symbol-at-point)
  (read-from-minibuffer "Cyc Code Search: ")))

(defun cmhc-subl-apropos ()
 ""
 (interactive)
 (let ((subl-command-pattern-string (read-from-minibuffer "SubL Command Apropos: ")))
  (see (kmax-grep-list-regexp (csm-get-list-of-subl-commands) subl-command-pattern-string))))

(defvar cmhc-cyc-whitepaper-dir "/var/lib/myfrdcsas/versions/myfrdcsa-1.0/codebases/minor/cyc-common/documentation/pdfs")

(defun cmhc-search-cyc-whitepapers ()
 ""
 (let ((search (read-from-minibuffer "Search?: ")))
  (kmax-search-files
   search
   (kmax-swap-filename-extensions "pdf" "txt"
    (kmax-find-name-dired cmhc-cyc-whitepaper-dir "\.pdf$"))
   "*Cyc Whitepaper Search*")))

(defvar cmhc-federated-search-functions
 (list
  'cmhc-search-cyc-whitepapers
  'cmhsm-search-my-kb-dir
  'cmhsm-search-kb-dir))

(defun cmhc-federated-search ()
 ""
 (interactive)
 (let ((search-function (completing-read "Search Function: " cmhc-federated-search-functions nil nil (try-completion "" cmhc-federated-search-functions))))
  (see search-function
   (funcall (read search-function)))))

(defun cmhc-load-cyc-documentation ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

(defun cmhc-load-search-cyc-documentation ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

(setq cmhc-subl-templates
 '((assert . "(am '() #$EverythingPSC)")
   (query . "(qm '() #$EverythingPSC)")))

(defun cmhc-insert-template (&optional template-name)
 ""
 (interactive)
 (insert
  (cdr
   (assoc
    (read
     (or template-name
      (completing-read "Insert which SubL template: "
       (kmax-alist-keys cmhc-subl-templates))))
    cmhc-subl-templates))))

(defun cmhc-convert-assertion-into-query ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

(defun cmhc-convert-query-into-assertion ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

(kmax-fixme "not yet working from emacs (all-instances #$FRDCSAMinorCodebase #$EverythingPSC)")

(provide 'cyc-mode-hybrid-common)
