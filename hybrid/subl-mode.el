(let ((dir "/var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/subl-mode"))
 (if (file-exists-p dir)
  (setq load-path
   (cons dir load-path))))

(global-set-key "\C-ccer" 'cmhc-reload-subl-file)

(add-to-list 'auto-mode-alist '("\\.subl\\'" . subl-mode))
(add-to-list 'auto-mode-alist '("\\.cycl\\'" . subl-mode))

(require 'subl-util)
(require 'subl-terms)
(require 'subl-fontify)
(if (featurep 'freekbs2)
 (require 'subl-freekbs2))

(define-derived-mode subl-mode
 emacs-lisp-mode "Subl"
 "Major mode for Sigma Knowledge Engineering Environment.
\\{subl-mode-map}"
 (setq case-fold-search nil)
 (define-key subl-mode-map (kbd "TAB") 'csm-complete-subl-and-cycl-or-tab)
 (define-key subl-mode-map [C-tab] 'csm-complete-subl-or-tab)
 ;; (define-key subl-mode-map "\C-csl" 'subl-mode-load-assertion-into-stack)
 (define-key subl-mode-map "\C-csL" 'subl-mode-print-assertion-from-stack)
 (define-key subl-mode-map "\M-F" 'subl-forward-word)
 (define-key subl-mode-map "\M-B" 'subl-backward-word)
 (define-key subl-mode-map "\C-x\C-e" 'subl-eval-last-sexp)
 (define-key subl-mode-map "\C-cceus" 'subl-mode-update-subl-file-to-latest-standards)

 ;; (suppress-keymap subl-mode-map)

 (make-local-variable 'font-lock-defaults)
 (setq font-lock-defaults '(subl-font-lock-keywords nil nil))
 (re-font-lock)
 )

(defun subl-forward-word ()
 ""
 (interactive)
 (forward-char 1)
 (re-search-forward "[A-Z][a-z]")
 (backward-char 2))

(defun subl-backward-word ()
 ""
 (interactive)
 (re-search-backward "[A-Z][a-z]"))

(defun subl-mode-complete-or-tab (&optional arg)
 ""
 (interactive "P")
 (unwind-protect
  (condition-case nil
   (subl-mode-complete))
  (indent-for-tab-command arg)))

(defun subl-mode-complete (&optional predicate)
 "Perform completion on Subl symbol preceding point.
Compare that symbol against the known Subl symbols.

When called from a program, optional arg PREDICATE is a predicate
determining which symbols are considered, e.g. `commandp'.
If PREDICATE is nil, the context determines which symbols are
considered.  If the symbol starts just after an open-parenthesis, only
symbols with function definitions are considered.  Otherwise, all
this-command-keyssymbols with function definitions, values or properties are
considered."
 (interactive)
 (let* ((end (point))
	(beg (with-syntax-table emacs-lisp-mode-syntax-table
	      (save-excursion
	       (backward-sexp 1)
	       (while (or
		       (= (char-syntax (following-char)) ?\')
		       (char-equal (following-char) ?\$)
		       (char-equal (following-char) ?\#))
		(forward-char 1))
	       (point))))
	(pattern (buffer-substring-no-properties beg end))
	;; (subl-output
	;;  (subl-query
	;;   (concat "(constant-complete " "\"" pattern "\")\n")))
	;; (completions
	;;  (cm-convert-string-to-alist-of-strings
	;;   (progn
	;;    (string-match "(\\([^\)]*\\))" ; get this from Cyc and format it into an alist
	;;     cm-cyc-output)
	;;    (match-string 1 cm-cyc-output))))
	(completions
	 subl-mode-all-terms)
	(completion (try-completion pattern completions)))
  (cond ((eq completion t))
   ((null completion)
    (error)
    ;; (error "Can't find completion for \"%s\"" pattern)
    )
   ((not (string= pattern completion))
    (delete-region beg end)
    (insert completion))
   (t
    ;; (message "Making completion list...")
    ;; (let ((list (all-completions pattern completions)))
    ;;  (setq list (sort list 'string<))
    ;;  (with-output-to-temp-buffer "*Completions*"
    ;;   (display-completion-list list)))
    ;; (message "Making completion list...%s" "done")
    (let* 
     ((expansion (completing-read "Term: " 
		  (all-completions pattern completions) nil nil pattern))
      (regex (concat pattern "\\(.+\\)")))

     (string-match regex expansion)
     (insert (match-string 1 expansion)))))))

(defun subl-mode-previous-subl-sexp ()
 ""
 (interactive)
 (save-excursion
  (set-mark (point))
  (backward-sexp)
  (buffer-substring-no-properties (point) (mark))))


(defun subl-eval-last-sexp (&optional arg)
 ""
 (interactive "P")
 (let ((subl
	(kmax-remove-carriage-returns-from-string (subl-mode-previous-subl-sexp))))
  (if arg
   (cyc-shell-mode-eval-with-cyc-shell subl)
   (subl-mode-eval-with-cmh subl))))

(defun subl-mode-eval-with-cmh (subl)
 ""
 (interactive)
 (see (cmh-send-subl-command subl)))

(defun subl-mode-update-subl-file-to-latest-standards ()
 ""
 (interactive)
 (mapcar 
  (lambda (entry)
   (beginning-of-buffer)
   (replace-regexp (car entry) (cdr entry)))
  '(("find-or-create-constant" . "f")
    ("cyc-assert" . "am")
    ("cyc-query" . "qm"))))

(defun subl-quote-string (string quote)
 (let ((string (kmax-strip-outer-characters-matching-regexp (shell-quote-argument string) "\'")))
  (if quote
   (concat "\"" string "\"")
   string)))

(defun cmhc-reload-subl-file ()
 (interactive)
 (assert (kmax-mode-is-derived-from 'subl-mode))
 (cmh-send-subl-command (concat "(frdcsa-include " (subl-quote-string (eshell/basename buffer-file-name) t) ")")))

(provide 'subl-mode)

;; define inverses of functions
;; find-buffer-visiting
