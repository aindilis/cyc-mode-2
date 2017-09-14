;;; cyc-mode.el

(let ((dir "/var/lib/myfrdcsa/codebases/minor/cyc-mode/frdcsa/emacs"))
 (if (file-exists-p dir)
  (setq load-path
   (cons dir load-path))))

(require 'cyc-api)
(require 'cyc-si)
(require 'cyc-api-data)
(require 'cyc-w3m)

(if t
 (setq inferior-lisp-program "/var/lib/myfrdcsa/codebases/minor/cyc-mode/cyc1")
 (setq inferior-lisp-program "/var/lib/myfrdcsa/codebases/minor/cyc-mode/cyc2"))

(setq auto-mode-alist
 (cons '("\\.subl\\'" . cyc-mode) auto-mode-alist))
(setq auto-mode-alist
 (cons '("\\.cycl\\'" . cyc-mode) auto-mode-alist))

(defvar cm-current-kb "#$EverythingPSC")

(defcustom cyc-mode-hook nil
 "Normal hook run when entering Cyc mode and many related modes."
 :type 'hook
 :options '(turn-on-auto-fill flyspell-mode)
 :group 'data)

(defvar cyc-mode-variant nil
 "Non-nil if this buffer's major mode is a variant of Cyc mode.")

(defvar cyc-mode-syntax-table nil
 "Syntax table used while in cyc mode.")

(defvar cyc-mode-abbrev-table nil
 "Abbrev table used while in cyc mode.")
(define-abbrev-table 'cyc-mode-abbrev-table ())

(progn ; if cyc-mode-syntax-table
 (setq cyc-mode-syntax-table (copy-syntax-table lisp-mode-syntax-table)))

(defvar cyc-mode-map nil
 "Keymap for Cyc mode.
 Many other modes, such as Mail mode, Outline mode and Indented Cyc mode,
 inherit all the commands defined in this map.")

(progn ; if cyc-mode-map
 (setq cyc-mode-map (make-sparse-keymap))
 (set-keymap-parent cyc-mode-map lisp-mode-map)
 (global-unset-key "\C-ccs")
 (global-unset-key "\C-ccc")
 (global-unset-key "\C-ccm")
 (global-unset-key "\C-ccp")
 (global-set-key "\C-ccv" 'complete-symbol)
 (global-set-key "\C-ccde" 'cm-defun)
 (global-set-key "\C-cck" 'cm-push-cap)
 (global-set-key "\C-ccg" 'cm-generic-api-fn)
 (global-set-key "\C-cch" 'cm-all-api-fn)
 (global-set-key "\C-ccsc" 'cm-sk-comment)
 (global-set-key "\C-ccsq" 'cm-sk-cyc-query)
 (global-set-key "\C-ccsa" 'cm-sk-cyc-assert)
 (global-set-key "\C-ccsd" 'cm-sk-cdolist)
 (global-set-key "\C-ccsf" 'cm-sk-find-or-create-constant)
 (global-set-key "\C-ccsg" '(cm-cyclify-sexp))
 ;;   (global-set-key "" ')
 ;;   (global-set-key "" ')
 ;;   (global-set-key "" ')
 ;;   (global-set-key "" ')
 (global-set-key "\C-cci" 'cm-constant-complete)
 (global-set-key "\C-cccs" 'cm-cyclify-sexp)
 (global-set-key "\C-ccpw" 'cm-popup-windows)
 (global-set-key "\C-ccpi" 'cm-popup-interaction)
 (global-set-key "\C-cco" 'cm-comment)
 (global-set-key "\C-ccmg" 'cm-min-genls)
 (global-set-key "\C-ccag" 'cm-all-genls)
 (global-set-key "\C-ccas" 'cm-all-specs)
 (global-set-key "\C-ccsp" 'cm-create-plan-spec)
 (global-set-key "\C-ccca" 'cm-constant-apropos)
 (global-set-key "\C-ccat" 'cm-all-term-assertions)
 (global-set-key "\C-ccck" 'cm-set-cm-current-kb)
 

 )

;; here are general bindings to load when using cyc

(define-derived-mode cyc-mode lisp-mode "Cyc"
 ;(defun cyc-mode ()
 "Major mode for editing cyc written for humans to read.
In this mode, paragraphs are delimited only by blank or white lines.
You can thus get the full benefit of adaptive filling
 (see the variable `adaptive-fill-mode').
\\{cyc-mode-map}
Turning on Cyc mode runs the normal hook `cyc-mode-hook'."
 (interactive)
 (kill-all-local-variables)
 (use-local-map cyc-mode-map)
 (setq local-abbrev-table cyc-mode-abbrev-table)
 (set-syntax-table cyc-mode-syntax-table)
 (make-local-variable 'paragraph-start)
 (setq paragraph-start (concat page-delimiter "\\|[ \t]*$"))
 (if (eq ?^ (aref paragraph-start 0))
  (setq paragraph-start (substring paragraph-start 1)))
 (make-local-variable 'paragraph-separate)
 (setq paragraph-separate paragraph-start)
 (make-local-variable 'indent-line-function)
 (setq indent-line-function 'indent-relative-maybe)
 (setq mode-name "Cyc")
 (setq major-mode 'cyc-mode)
 (run-hooks 'cyc-mode-hook))

(defun paragraph-indent-cyc-mode ()
 "Major mode for editing cyc, with leading spaces starting a paragraph.
In this mode, you do not need blank lines between paragraphs
when the first line of the following paragraph starts with whitespace.
`paragraph-indent-minor-mode' provides a similar facility as a minor mode.
Special commands:
\\{cyc-mode-map}
Turning on Paragraph-Indent Cyc mode runs the normal hooks
`cyc-mode-hook' and `paragraph-indent-cyc-mode-hook'."
 (interactive)
 (kill-all-local-variables)
 (use-local-map cyc-mode-map)
 (setq mode-name "Parindent")
 (setq major-mode 'paragraph-indent-cyc-mode)
 (setq local-abbrev-table cyc-mode-abbrev-table)
 (set-syntax-table cyc-mode-syntax-table)
 (run-hooks 'cyc-mode-hook 'paragraph-indent-cyc-mode-hook))

(defun paragraph-indent-minor-mode ()
 "Minor mode for editing cyc, with leading spaces starting a paragraph.
In this mode, you do not need blank lines between paragraphs when the
first line of the following paragraph starts with whitespace, as with
`paragraph-indent-mode'.
Turning on Paragraph-Indent minor mode runs the normal hook
`paragraph-indent-cyc-mode-hook'."
 (interactive)
 (set (make-local-variable 'paragraph-start)
  (default-value 'paragraph-start))
 (set (make-local-variable 'paragraph-separate) paragraph-start)
 (run-hooks 'paragraph-indent-cyc-mode-hook))

(defalias 'indented-cyc-mode 'cyc-mode)

(defun cyc-mode-hook-identify ()
 "Mark that this mode has run `cyc-mode-hook'.
This is how `toggle-cyc-mode-auto-fill' knows which buffers to operate on."
 (make-local-variable 'cyc-mode-variant)
 (setq cyc-mode-variant t))

(add-hook 'cyc-mode-hook 'cyc-mode-hook-identify)

(defun toggle-cyc-mode-auto-fill ()
 "Toggle whether to use Auto Fill in Cyc mode and related modes.
This command affects all buffers that use modes related to Cyc mode,
both existing buffers and buffers that you subsequently create."
 (interactive)
 (let ((enable-mode (not (memq 'turn-on-auto-fill cyc-mode-hook)))
       (buffers (buffer-list)))
  (if enable-mode
   (add-hook 'cyc-mode-hook 'turn-on-auto-fill)
   (remove-hook 'cyc-mode-hook 'turn-on-auto-fill))
  (while buffers
   (with-current-buffer (car buffers)
    (if cyc-mode-variant
     (auto-fill-mode (if enable-mode 1 0))))
   (setq buffers (cdr buffers)))
  (message "Auto Fill %s in Cyc modes"
   (if enable-mode "enabled" "disabled"))))

(add-hook 'comint-output-filter-functions 'cm-output-filter)

(defun cm-cyc-query (string)
 (let ((window-config (current-window-configuration)))
  (save-excursion
   (setq cm-output-string nil)
   (comint-send-string (cyc-mode-inferior-lisp-proc) string)
   (while (eq cm-output-string nil)
    (sit-for 0.001))
   (sit-for 0.005)
   (set-window-configuration window-config)
   cm-output-string)))

(setq cm-output-string "")

(defun cm-output-filter (string)
 (setq cm-output-string (concat cm-output-string string)))

(defun cm-constant-complete (&optional predicate)
 "Perform completion on Cyc symbol preceding point.
Compare that symbol against the known Cyc symbols.

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
	(pattern
	 (buffer-substring-no-properties beg end)))
  (if (non-nil (string-match "\\([^\\s]\\)" pattern))
   (let*
    ((cm-cyc-output
      (cm-cyc-query
       (concat "(constant-complete " "\"" pattern "\")\n")))
     (completions
      (cm-convert-string-to-alist-of-strings
       (progn
	(string-match "(\\([^\)]*\\))" ; get this from Cyc and format it into an alist
	 cm-cyc-output)
	(match-string 1 cm-cyc-output))))
     (completion (try-completion pattern completions)))
    (cond ((eq completion t))
     ((null completion)
      (message "Can't find completion for \"%s\"" pattern)
      (ding))
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
       ((expansion (completing-read "Constant: " 
		    (all-completions pattern completions) nil nil pattern))
	(regex (concat pattern "\\(.+\\)")))

       (string-match regex expansion)
       (insert (match-string 1 expansion))))))
   (error "Nothing to complete."))))

;; cm-cyclify-sexp
(defun cm-cyclify-sexp (&optional arg)
 "Cyclify the expression before cursor."
 (interactive)
 (progn (backward-sexp (or arg 1))
  (mark-sexp)
  (while (and
	  (re-search-forward "[^A-Za-z0-9-_?][A-Za-z0-9-_?]")
	  (< (point) (mark)))
   (if
    (and
     (not (string= "?" (buffer-substring (- (point) 1) (point))))
     (not (string= "*" (buffer-substring (- (point) 2) (- (point) 1))))
     (not (string= ":" (buffer-substring (- (point) 2) (- (point) 1))))
     (not (string= "#$" (buffer-substring (- (point) 3) (- (point) 1)))))
    ; check that it is not a cyc-api function and bordering a left paren
    (progn
     (backward-char)
     (insert "#$")
     (forward-char 2))))
  (backward-char))
 (goto-char (mark)))

(defun cm-decyclify ())

(defun cm-convert-string-to-alist-of-strings (s)
 (let ((current (current-buffer))
       (temp-buffer (get-buffer-create "*refer-temp*")))
  (set-buffer temp-buffer)
  (erase-buffer)
  (insert (regexp-quote s))
  (goto-char (point-min))
  (insert "((\"")
  (while (re-search-forward "[ \t#$\\]+" nil t)
   (replace-match "\" . t) (\"" t t))
  (goto-char (point-max))
  (insert "\" . t))")
  (goto-char (point-min))
  (prog1 (read temp-buffer)
   (set-buffer current))))

(defun cm-popup-windows ()
 "Puts inferior lisp in the other window."
 (interactive)
 (switch-to-buffer-other-window "*inferior-lisp*")
 (end-of-buffer)
 (other-window -1))

(defun cm-popup-interaction ()
 "Puts inferior lisp in the other window."
 (interactive)
 (switch-to-buffer-other-window "interaction.cycl")
 (end-of-buffer)
 (other-window -1))

(defun cm-no-properties ()
 "Return the constant at point."
 (let ((constant (thing-at-point 'filename)))
  (string-match "^[^a-zA-Z-_]*\\([a-zA-Z-_]*\\)" constant)
  (or
   (match-string-no-properties 1 constant)
   "hdafd")))

(defun cm-constant-at-point ()
 "Return the constant at point."
 (let ((constant (thing-at-point 'filename)))
  (string-match "^[^a-zA-Z-_]*\\([a-zA-Z-_]*\\)" constant)
  (if (not (string= (match-string-no-properties 1 constant) ""))
   (concat "#$" (match-string-no-properties 1 constant))
   nil)))

(defun cm-comment ()
 "Do some cyc-dirty-work."
 (interactive)
 (let*
  ((cm-cyc-output
    (cm-cyc-query
     (concat "(comment " (cm-constant-at-point) " " cm-current-kb ")\n"))))
  (message cm-cyc-output)))

(defun cm-constant-apropos ()
 (interactive)
 (let*
  ((pattern (cm-no-properties))
   (cm-cyc-output
    (cm-cyc-query
     (concat "(constant-apropos " "\"" pattern "\")\n")))
   (completions
    (cm-convert-string-to-alist-of-strings
     (progn
      (string-match "(\\([^\)]*\\))" ; get this from Cyc and format it into an alist
       cm-cyc-output)
      (match-string 1 cm-cyc-output))))
   (completion (try-completion pattern completions)))
  (cond ((eq completion t))
   ((null completion)
    (message "Can't find completion for \"%s\"" pattern)
    (ding))
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
     ((expansion (completing-read "Constant: " completions))
      (regex (concat pattern "\\(.+\\)")))

     (string-match regex expansion)
     (insert (match-string 1 expansion)))))))

(defun cm-all-term-assertions ()
 (interactive)
 (let ((constant (concat "(all-term-assertions " (cm-constant-at-point) ")\n")))
  (cm-cyc-query constant)))

;; (all-term-assertions #$MailingLocation)

;; general way of constructing these
;; follow the syntax of the language
;; key bindings to common templates, not exactly functions if possible
;; general input skeletons

;;   (interactive "CConstant apropos: \np")
;;   (mint-send-string (cyc-mode-inferior-lisp-proc)
;;		      (concat "(constant-apropos \"" () "\")\n")))

;; Skeleton Functions

(defun cm-skel-dwim
 (if (cm-constant-at-point)
  ()))

(define-skeleton cm-sk-comment "" nil
 "(comment #$" _ ")")

(define-skeleton cm-sk-cyc-query "" nil
 "(cyc-query " _ " " cm-current-kb ")")

(define-skeleton cm-sk-cyc-assert "" nil
 "(cyc-assert " _ " " cm-current-kb ")")

(define-skeleton cm-sk-find-or-create-constant "" nil
 "(find-or-create-constant " _ ")")

(define-skeleton cm-sk-cdolist "" nil
 "(cdolist (*new* '" _ "))")



(define-skeleton cm-defun "" nil
 "(defun cm-" _ " () \"\")")

(define-skeleton cm-define-skeleton "" nil
 "(defun " _ " \"\" nil " _ ")")

(defun cm-doc-load-subl-reference ())

(defun cm-restore-tags ()
 (interactive)
 (setq tags-file-name "/var/lib/myfrdcsa/codebases/minor/cyc-mode/TAGS")
 (setq tags-table-list nil))

(defun cm-put-string-on-kill-ring (string)
 (setq kill-ring (cons string kill-ring))
 (if (> (length kill-ring) kill-ring-max)
  (setcdr (nthcdr (1- kill-ring-max) kill-ring) nil))
 (setq kill-ring-yank-pointer kill-ring)
 (see kill-ring))

(defun cm-constantify () ""
 (interactive)
 (if (> (point) (mark))
  (exchange-point-and-mark))
 (let ((beg (point))
       (string ""))
  (while (search-forward "#" (mark) t)
   (backward-char)
   (let ((beg (point)))
    (forward-sexp)
    (setq string (concat string " " (buffer-substring-no-properties beg (point))))))
  (cm-put-string-on-kill-ring string)))

(defun cm-terms-to-strings () ""
 )

(defun cm-convert-lisp () ""
 (interactive)
 (down-list)
 (cm-put-string-on-kill-ring (cm-convert-lisp-tree-to-cyc "" "")))

(defun cm-convert-lisp-tree-to-cyc (parent string) ""
 (let* ((beg (point))
	(child (save-excursion
		(forward-sexp)
		(buffer-substring-no-properties beg (point))))
	(string (concat string "(#$genls " child " " parent ")\n")))
  (while (condition-case err-var
	  (prog1 t (down-list 1))
	  (error nil))
   (setq string (cm-convert-lisp-tree-to-cyc child string))
   (up-list))
  (setq string string)))

;; here are new things to have keys bound to

;; (set up all things that can take it from point
;;     (automatically assign key bindings to them))

;; COMMON QUERIES

;; (let ((constant ))
;;   (comint-send-string (cyc-mode-inferior-lisp-proc) constant)
;;   (display-message-or-buffer constant)))

(defun cm-min-genls ()
 "Do some cyc-dirty-work."
 (interactive)
 (cm-see-query-result (concat "(min-genls " (cm-constant-at-point) " " cm-current-kb ")\n")))

(defun cm-all-genls ()
 "Do some cyc-dirty-work."
 (interactive)
 (cm-see-query-result (concat "(all-genls " (cm-constant-at-point) " " cm-current-kb ")\n")))

(defun cm-comment ()
 "Do some cyc-dirty-work."
 (interactive)
 (cm-see-query-result (concat "(comment " (cm-constant-at-point) " " cm-current-kb ")\n")))

(defun cm-all-specs ()
 "Do some cyc-dirty-work."
 (interactive)
 (cm-see-query-result (concat "(all-specs " (cm-constant-at-point) " " cm-current-kb ")\n")))

(defun cm-see-query-result (query)
 "Do some cyc-dirty-work."
 (interactive)
 (let*
  ((cm-cyc-output
    (cm-cyc-query
     query)))
  (message cm-cyc-output)))

(defun cm-constant-to-string (string) ""
 (string-match "#$\(.*\)" string)
 (match-string 1 string))

(defun cm-create-plan-spec (name)
 "Do some cyc-dirty-work."
 (interactive "sName for spec plan: ")
 (let ((constant (concat "(cdolist (*new* (list (find-or-create-constant \"" name "\")))
	 (cyc-assert (list #$isa *new* #$plan) " cm-current-kb ")
	 (cyc-assert (list #$genls *new* " (cm-constant-at-point) " ) " cm-current-kb "))\n")))
  (comint-send-string (cyc-mode-inferior-lisp-proc) constant)
  (display-message-or-buffer constant)))

(defun cm-set-cm-current-kb () ""
 (interactive)
 (setq cm-current-kb (cm-constant-at-point))
 (see cm-current-kb))

(defun cm-generic-api-fn () ""
 (interactive)
 ())

(defun cm-generic-api-fn ()
 (interactive)
 (let ((constant (concat "(" (completing-read "Cyc API function: " cm-api-type-1)
		  " " (or (cm-constant-at-point)
		       (read-from-minibuffer "Cyc term: ")) " " cm-current-kb ")\n")))
  (comint-send-string (cyc-mode-inferior-lisp-proc) constant)
  (display-message-or-buffer constant)))

(defun cm-all-api-fn ()
 (interactive)
 (let* ((cm-temp
	 (setq cm-temp
	  (cm-list-to-alist
	   (cm-alist-to-list
	    (read
	     (si-query "(cyc-query '(#$cyc-api-function ?X) #$cyc-mode-Mt)\n"))))))
	(constant (concat "(" (completing-read "Cyc API function: " cm-temp)
		   " " (or (cm-constant-at-point)
			(read-from-minibuffer "Cyc term: ")) " " cm-current-kb ")\n")))
  (comint-send-string (cyc-mode-inferior-lisp-proc) constant)
  (display-message-or-buffer constant)))

(defun cm-push-cap () ""
 (interactive)
 (cm-put-string-on-kill-ring (cm-constant-at-point)))

(defun cm-list-to-alist (lst)		; from viper
 (let ((alist))
  (while lst
   (setq alist (cons (list (car lst)) alist))
   (setq lst (cdr lst)))
  alist))

(defun cm-alist-to-list (alst)
 (let ((lst))
  (while alst
   (setq lst (cons (cdr (car (car alst))) lst))
   (setq alst (cdr alst)))
  lst))

(defun cm-quote-region () ""
 (interactive)
 (replace-regexp "\(\\.|\"\)" "\\\1" nil (point) (mark)))

(defun cm-unquote-region () ""
 (interactive)
 (replace-string "\\\\" "\\" nil (mark) (point))
 (replace-string "\\\"" "\"" nil (mark) (point)))

(fset 'cm-quote-lines
 [?\C-u ?\M-| ?s ?e ?d ?  ?- ?e ?  ?' ?s ?/ ?^ ?/ ?\" ?/ ?' ?  ?- ?e ?  ?' ?s ?/ ?$ ?/ ?\" ?/ ?' return])

(fset 'cm-characterstring-to-sublstring
 [?\C-u ?\M-| ?p ?e ?r ?l ?  ?- ?p ?e ?  ?' ?s ?/ ?( ?\\ ?\\ ?. ?| ?\" ?) ?/ ?\\ ?\\ ?\\ ?1 ?/ ?g ?' return])

(defun cm-format-output-start ()
 (call-process "/usr/bin/perl" nil "*formatted*" t (concat cyc-mode-home "/format.pl")))

(defun cyc-mode-inferior-lisp-proc ()
 ""
 (condition-case nil
  (inferior-lisp-proc)
  ((debug error) 
   (progn
    ;; (si-init)
    (inferior-lisp inferior-lisp-program)
    (inferior-lisp-proc)))))

(provide 'cyc-mode)

