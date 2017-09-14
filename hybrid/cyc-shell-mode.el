(define-derived-mode cyc-shell-mode
 shell-mode "CYC-shell"
 "Major mode for editing Cyc Shell.
\\{shell-mode-map}"
 (setq case-fold-search nil)
 (define-key cyc-shell-mode-map (kbd "TAB") 'csm-complete-subl-and-cycl-or-tab)
 (define-key cyc-shell-mode-map [C-tab] 'csm-complete-subl-or-tab)
 (define-key cyc-shell-mode-map "\C-c\C-c" 'csm-before-comint-interrupt-subjob)
 ;; (define-key cyc-shell-mode-map [] 'cyc-shell-mode-fix-truncated-remote-session)

 (make-local-variable 'font-lock-defaults)
 (setq font-lock-defaults '(subl-font-lock-keywords nil nil))
 (re-font-lock)
 )

(defun csm-before-comint-interrupt-subjob ()
 (interactive)
 (if (y-or-n-p "Interrupt subjob?: ")
  (comint-interrupt-subjob)))

;; (defun csm-constant-complete ()
;;  ""
;;  (interactive)
;;  ;; add the ability to complete commands from here:
;;  ;; /var/lib/myfrdcsas/versions/myfrdcsa-1.1/vagrant-machines/KBS-FRDCSA-Org/KBS-FRDCSA-Org/cyc/researchcyc-commands.txt

;;  (cmh-constant-complete))

(defvar csm-subl-commands nil)

(defun cmh-cyclified-constant-p (string)
 (non-nil (string-match "^#\\$" string)))

(defun csm-get-list-of-subl-commands ()
 ""
 (interactive)
 (if (null csm-subl-commands)
  (setq csm-subl-commands 
   (split-string 
    (downcase
     (shell-command-to-string
      (concat "cat " (shell-quote-argument (cmh-get-subl-commands-file)))))
   "\n")))
 csm-subl-commands)

(defun cmh-get-subl-commands-file ()
 ""
 (if (string= cmhsm-release "ResearchCyc")
  cmhc-subl-rcyc-commands-file
  (if (string= cmhsm-release "OpenCyc")
   cmhc-subl-ocyc-commands-file
   (error "Don't know which release of Cyc you are using"))))
  
(defun csm-complete-subl (pattern)
 ""
 (interactive)
 (mapcar (lambda (completion) (csm-truncate-completion-at-whitespace completion))
  (kmax-grep-list-regexp (csm-get-list-of-subl-commands) (concat "^" pattern))))

(defun csm-complete-cycl (pattern)
 ""
 (interactive)
 (let*
  ((result (constant-complete (prin1-to-string pattern)))
   (final-result (if (listp result)
		  result
		  (list))))
  (mapcar (lambda (string) (concat (cmh-decyclify string) "#$")) final-result)))

(defun csm-truncate-completion-at-whitespace (completion)
 ""
 (string-match "^\\(.+?\\)\s" completion)
 (match-string 1 completion))

(defun csm-complete-subl-or-tab (&optional arg)
 ""
 (interactive "P")
 (csm-complete-subl-and-cycl-or-tab arg t))

(defun csm-complete-subl-and-cycl-or-tab (&optional arg arg2)
 (interactive "P")
 (let* ((csm-line-prefix (save-excursion
			  (set-mark (point))
			  (beginning-of-line nil)
			  (buffer-substring-no-properties (point) (mark)))))
  (if (string-match "^[\s\t]*$" csm-line-prefix)
   (progn
    ;; (see "yes") 
    (indent-for-tab-command arg))
   (progn
    ;; (see "no")
    (unwind-protect
     (condition-case ex
      (csm-complete-subl-and-cycl (or arg2 nil))
      ('error (indent-for-tab-command arg))))))))

(defun csm-complete-subl-and-cycl (arg &optional predicate)
 "Perform completion on Cyc symbol preceding point.
Compare that symbol against the known Cyc symbols.

When called from a program, optional arg PREDICATE is a predicate
determining which symbols are considered, e.g. `commandp'.
If PREDICATE is nil, the context determines which symbols are
considered.  If the symbol starts just after an open-parenthesis, only
symbols with function definitions are considered.  Otherwise, all
this-command-keyssymbols with function definitions, values or properties are
considered."
 (interactive "P")
 (let* ((end (point))
	(pattern
	 (cmh-decyclify
          (cyc-mode-get-cyc-constant-or-symbol-at-point)))
	(beg (- (point) (length pattern)))
	)
  (if (and
       (non-nil pattern)
       (non-nil (string-match "\\([^\\s]\\)" pattern))
       (not (equal (line-beginning-position) (point)))
       )
   (let*
    ((completions
      (if arg
       (si-list-to-alist
	(csm-complete-subl pattern))
       (si-list-to-alist
       	(union
       	 (csm-complete-subl pattern)
	 (csm-complete-cycl pattern)))))
     (completion (union
		  (try-completion pattern completions)
		  (try-completion (concat "#$" pattern) completions))))
    (seed completions)
    (cond
     ((eq completion t))
     ((null completion)
      (error "Can't find completion for \"%s\"" pattern)
      (ding))
     ((not (string= pattern (cmh-decyclify completion)))
      (if (cmh-cyclified-constant-p completion)
       (delete-region (- beg 2) end)
       (delete-region beg end))
      (string-match "^\\(.+?\\)\\(#\\$\\)?$" completion)
      (insert (match-string 1 completion)))
     (t
      ;; (message "Making completion list...")
      ;; (let ((list (all-completions pattern completions)))
      ;;  (setq list (sort list 'string<))
      ;;  (with-output-to-temp-buffer "*Completions*"
      ;;   (display-completion-list list)))
      ;; (message "Making completion list...%s" "done")
      (let* 
       ((expansion (completing-read "Constant: " 
		    (union
		     (all-completions pattern completions)
		     (all-completions (cmh-cyclify-stupid pattern) completions)) nil nil pattern))
	(regex (concat pattern "\\(.+\\)")))
       (string-match regex expansion)
       (let ((match (match-string 1 expansion)))
	(string-match "^\\(.+?\\)\\(#\\$\\)?$" match)
	(insert (match-string 1 match)))))))
   (error "Nothing to complete."))))

(defun si-list-to-alist (lst)
  (let ((alst))
    (while lst
      (setq alst (cons (list (car lst)) alst))
      (setq lst (cdr lst)))
    alst))

(defun cyc-shell-mode-fix-truncated-remote-session ()
 (interactive)
 ;; ;; (c #$expertRegarding)
 ;; (term-switch-to-shell-mode 'term-mode)
 ;; (term-ansi-reset)
 ;; (term-switch-to-shell-mode 'shell-mode)
 ;; (cyc-shell-mode)
 )

(defun cyc-shell-mode-eval-with-cyc-shell (subl)
 ""
 (interactive)
 (save-excursion
  (cmhsm-switch-to-cyc)
  (end-of-buffer)
  (insert subl)
  (comint-send-input)))

(provide 'cyc-shell-mode)
