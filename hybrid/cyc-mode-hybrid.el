(global-set-key "\C-css" 'freekbs2-push-cyc-constant-onto-stack)
(global-set-key "\C-ccsa" 'cmh-act-on-referent-and-push-onto-ring)
(global-set-key "\C-ccsA" 'cmh-act-on-referent)
(global-set-key "\C-ccsi" 'cmh-act-all-instances-of-referent-and-push-onto-ring)
(global-set-key "\C-ccsI" 'cmh-act-all-instances-of-referent)
(global-set-key "\C-ccst" 'cmh-act-all-term-assertions-of-referent)
(global-set-key "\C-cces" 'cmh-insert-everythingpsc)
(global-set-key "\C-ccsc" 'cmh-comment-for-referent)
(global-set-key "\C-ccsr" 'cmh-speak-comment-for-referent)
(global-set-key "\C-ccsp" 'cmh-constant-apropos-for-referent)
(global-set-key "\C-ccsn" 'cmh-arg-isa-for-referent)
(global-set-key "\C-ccs2" 'cmh-toggle-cyclification)
(global-set-key "\C-ccs@" 'cmh-toggle-cyclification-single)
(global-set-key "\C-ccs#" 'cmh-cyclify-tos)
(global-set-key "\C-ccs3" 'cmh-cyclify-tos-single)
(global-set-key "\C-ccs$" 'cmh-decyclify-tos)
(global-set-key "\C-ccs4" 'cmh-decyclify-tos-single)
(global-set-key "\C-ccq" 'cmh-cyc-query-into-stack)
(global-set-key "\C-ccx" 'cmh-set-microtheory)
(global-set-key "\C-cci" 'cmh-constant-complete)
(global-set-key "\C-cchf" 'cmh-describe-subl-function)
(global-set-key "\C-ccmoe" 'cmh-enable-modes)
(global-set-key "\C-ccmod" 'cmh-disable-modes)

(global-set-key (kbd "TAB") 'cmh-complete-or-tab)

(defvar cmh-is-connected nil "")
(defvar cmhc-microtheory "#$EverythingPSC" "")
(defvar cmh-user "CycAdministrator" "")
(defvar cmh-cycke "GeneralCycKE" "")

(put 'cyc-constant 'forward-op 'forward-cyc-constant)
(put 'cyc-constant 'beginning-op 'beginning-cyc-constant)
(put 'cyc-constant 'end-op 'end-cyc-constant)

(setq cmh-debug nil)

(defun forward-cyc-constant () 
 ""
 (re-search-forward "[\#\$_a-zA-Z0-9-]+\\b"))

(defun beginning-cyc-constant ()
 ""
 (re-search-backward "#$[_a-zA-Z0-9-]+"))

(defun end-cyc-constant ()
 ""
 (re-search-forward "[\#\$_a-zA-Z0-9-]+\\b"))

;; Is this a minor mode, with windows that pop up allowing us to query
;; and edit the KB, I think so

(defun cmh-analyze-tos ()
 "Take the Item at the top of the FreeKBS2 stack and analyze it."
 (interactive)
 )

(defun cmh-get-tap (tap arg)
 (interactive)
 (if arg
  (cmh-cyclify-item-single tap)
  tap))

(defun cmh-referent (&optional arg)
 ""
 (interactive)
 (let* ((tmp (cyc-mode-get-cyc-constant-or-symbol-at-point))
	(tap (if (non-nil tmp) (substring-no-properties tmp) nil)))
  (if (non-nil tap)
   (cmh-get-tap tap arg)
   (let ((temp (thing-at-point 'sexp)))
    (if (non-nil temp)
     (let ((ie (freekbs2-get-assertion-importexport t "CycL String")))
      (if (non-nil ie)
       ie
       (error "should not get here")))
     (let ((tos (car freekbs2-stack)))
      (if (non-nil tos)
       tos
       (error "Nothing found to work with"))))))))

;; (cmh-send-subl-command (concat "(comment " "#$subEvents" " " cmhc-microtheory ")"))

(defun cmh-comment-for-referent (&optional arg)
 "Take the Item at the top of the FreeKBS2 stack and analyze it."
 (interactive "P")
 ;; FIXME: use (freekbs2-query )
 (let ((referent (cmh-referent (not arg))))
  ;;  (seed referent)
  (freekbs2-load-onto-stack
   (list 
    (cmh-send-subl-command
     (see (concat "(comment " referent " " cmhc-microtheory ")") 0.1))))))

(defun cmh-constant-apropos-for-referent (&optional arg)
 "Take the Item at the top of the FreeKBS2 stack and analyze it."
 (interactive "P")
 ;; FIXME: use (freekbs2-query )
 (let ((referent (cmh-referent (not arg))))
  ;;  (seed referent)
  (freekbs2-load-onto-stack
   (list 
    (cmh-send-subl-command
     (see (concat "(constant-apropos \"" (cmh-decyclify referent) "\")")))))))

;; (cmh-cyc-query (list "#$arg1Isa" "#$hasWorkers" 'var-TYPE))

(defun cmh-arg-isa-for-referent (&optional n)
 "Take the Item at the top of the FreeKBS2 stack and analyze it."
 (interactive "p")
 (let ((referent (cmh-referent t)))
  (freekbs2-load-onto-stack
   (cmh-cyc-query (list (concat "#$arg" (or (prin1-to-string n) "1") "Isa") referent 'var-TYPE)))))

(defun freekbs2-push-cyc-constant-onto-stack (arg)
 "Push the goal at point onto a list of goals for use in the RPN system."
 (interactive "P")
 (freekbs2-push-onto-stack
  (cyc-mode-get-cyc-constant-or-symbol-at-point) arg))

(defun cyc-mode-get-cyc-constant-or-symbol-at-point ()
 ""
 (let ((item (or 
	      (thing-at-point 'cyc-constant)
              (save-excursion
               (condition-case ex (backward-char 1) ('error nil))
               (thing-at-point 'cyc-constant))
	      (thing-at-point 'symbol))))
  (if (non-nil item)
   (substring-no-properties item)
   nil)))

(defun cmh-startserver (subl)
 ""
 (interactive)
 (let*
  (
   (message 
    (cmh-send-to-system-cyc
     (list
      (cons "_DoNotLog" 1)
      (cons "StartServer" 1)
      )
     )
    )
   )
  message))

(defun cmh-connect (&optional user-arg cycke-arg)
 ""
 (interactive)
 (if (or
      (not cmh-is-connected)
      (and (non-nil user-arg) (not (string= user-arg cmh-user)))
      (and (non-nil cycke-arg) (not (string= cycke-arg cmh-cycke)))
      )
  (progn
   (if (non-nil user-arg)
    (setq cmh-user user-arg))
   (if (non-nil cycke-arg)
    (setq cmh-cycke cycke-arg))
   ;; (see
   (cmh-send-to-system-cyc
    (list
     (cons "_DoNotLog" 1)
     (cons "Connect" 1)
     (cons "User" cmh-user)
     (cons "CycKE" cmh-cycke)
     )
    )
   ;; )
   (setq cmh-is-connected t))))

(defun cmh-send-subl-command (subl)
 "Send a SubL command to Cyc, get the result back"
 (interactive)
 ;; (seed subl)
 (setq cmh-is-connected nil)
 (cmh-connect)
 (let*
  (
   (message 
    (cmh-send-to-system-cyc 
     (list
      (cons "_DoNotLog" 1)
      (cons "SubLQuery" subl)
      (cons "OutputType" "Interlingua")
      ;; (cons "ConnectionInfo" <PUT THE CONNECTION INFORMATION FROM CW IN HERE IF AVAILABLE>)
      ))
    )
   )
  message))

(defun cmh-send-to-system-cyc (item)
 "Send a SubL command to Cyc, get the result back"
 (interactive)
 (let*
  (
   (message
    (freekbs2-get-result 
     ;; (seed 
     (uea-query-agent-raw nil "Org-FRDCSA-System-Cyc"
      (freekbs2-util-data-dumper
       item
       )
      )
     ;; )
     )
    )
   )
  message))

(if nil
 ;; note this doesn't run very well, it dies with 

 ;; org.opencyc.parser.InvalidConstantNameException: Invalid constant name(s): #$SKSICYCOPRLANMT, #$SKSICYCORPLANMT, #$SKSICYCORPLANMODELMT at /var/lib/myfrdcsa/codebases/internal/freekbs2/KBS2/ImportExport/Mod/CycL.pm line 281, <GEN8> line 631.
 ;; $VAR1 = 'Can\'t use an undefined value as an ARRAY reference at /var/lib/myfrdcsa/codebases/internal/freekbs2/KBS2/ImportExport/Mod/CycL.pm line 297, <GEN8> line 632.
 ;; ';
 ;; $VAR1 = 'Can\'t use an undefined value as an ARRAY reference at /var/lib/myfrdcsa/codebases/internal/freekbs2/KBS2/ImportExport/Mod/CycL.pm line 297, <GEN8> line 632.
 (let ((referent "#$Microtheory"))
  (completing-read
   "Microtheory?: " 
   (see
    (sort 
     (mapcar (lambda (item) (prin1-to-string item t)) 
      (car
       (cmh-send-subl-command
	(concat "(all-instances " referent " " cmhc-microtheory ")")))) 'string<)))))

(defun cmh-act-all-instances-of-referent ()
 ""
 (interactive)
 (cmh-act-on-referent (list 'all-instances)))

;; (defun cmh-act-all-term-assertions-of-referent-orig ()
;;  ""
;;  (interactive)
;;  (cmh-act-on-referent (list 'c)))

(defun cmh-act-all-term-assertions-of-referent ()
 ""
 (interactive)
 (cmh-act-on-referent (list 'all-term-assertions 'no-mt 'push-onto-ring)))

(defun cmh-act-all-term-assertions-of-referent-misc (&optional arg)
 ""
 (interactive "P")
 (let ((subl (concat "(all-term-assertions " (cmh-referent) ")")))
  (if arg
   (cyc-shell-mode-eval-with-cyc-shell subl)
   (see (cmh-send-subl-command subl)))))

(defun cmh-act-all-instances-of-referent-and-push-onto-ring ()
 ""
 (interactive)
 (cmh-act-on-referent (list 'all-instances 'push-onto-ring)))

(defun cmh-act-on-referent-and-push-onto-ring ()
 ""
 (interactive)
 (cmh-act-on-referent (list 'push-onto-ring)))

(defun cmh-act-on-referent (&optional modes-arg function-arg referent-arg mt-arg)
 "Take the Item at the top of the FreeKBS2 stack and analyze it."
 (interactive)
 (let* ((referent (if referent-arg referent-arg (cmh-referent)))
	(modes (cmh-merge-modes-lists cmh-currently-enabled-modes modes-arg))

	(function (if function-arg function-arg 
		   (if (kmax-mode-match 'all-instances modes)
		    "all-instances"
		    (if (kmax-mode-match 'all-term-assertions modes)
		     "all-term-assertions"
		     (completing-read "Function?: " 
		      (sort cyc-subl-function-names 'string<))))))
	(results (sort 
		  (mapcar (lambda (item) (prin1-to-string item t)) 
		   (car
		    (cmh-send-subl-command
		     (see (concat
			   "(" function " " referent
			   (if (not (kmax-mode-match 'no-mt modes))
			    (concat " " (if mt-arg mt-arg cmhc-microtheory)))
			   ")") 0.2))))
		  'string<)))
  (if (kmax-mode-match 'speak modes)
   (if (stringp results)
    (all-speak-text results)))
  (if (kmax-mode-match 'push-onto-ring modes)
   (freekbs2-load-onto-stack results)
   (if (kmax-mode-match 'ret modes)
    results
    (freekbs2-load-onto-stack
     (freekbs2-get-assertion-importexport t "CycL String"
      (completing-read
       (concat "Choose from "function " of " (prin1-to-string referent t) "?: ") 
       results
       )))))))


(defun cm-exec (function referent &optional mt)
 "Take the Item at the top of the FreeKBS2 stack and analyze it."
 (interactive "P")
 (car
  (cmh-send-subl-command
   (seed
    (concat
     "(" function " " referent (if mt (concat " " mt) "") ")")))))

(defun cm-exec-a (function referent)
 "Take the Item at the top of the FreeKBS2 stack and analyze it."
 (interactive "P")
 (car
  (cmh-send-subl-command
   (concat
    "(" function " " referent ")"))))

(defun cmh-unknown ()
 (let ((referent "#$Predicate"))
  (freekbs2-load-onto-stack
   (cmh-send-subl-command
    (concat "(all-isa " referent " " cmhc-microtheory ")")))))

(defun cmh-define-all-subl-api-commands-for-emacs ()
 ""
 ;; FIXME: Figure out how to set the description of the function as well
 (mapcar 
  (lambda (function-name)
   (let ((cm-exec-version "cm-exec")
	 ;; (cm-exec-version "cm-exec-2")
	 (symbol (concat "'" function-name)))
    (fset (eval (read symbol)) 
     (eval (read (concat "(lambda (item) (" cm-exec-version " \"" function-name "\" item))"))))))
  cyc-subl-function-names))

(fset 'constant-complete (lambda (item) (cm-exec "constant-complete" item)))

(defun cm-exec-2 (function referent &optional mt)
 ""
 ;; FIXME do a macro here
 (interactive "P")
 (mapcar
  (lambda (term)
   (if (and
	(stringp term)
	(string-match "^\#\$\\([A-Za-z][_A-Za-z0-9-]*\\)$" term))
    (let ((symbol (match-string 1 term)))
     (eval (read (concat "(setq " symbol " \"" term "\")")))
     (make-symbol symbol))
    term))
  (car
   (cmh-send-subl-command
    (concat
     "(" function " " referent " " (if mt mt cmhc-microtheory) ")")))))

;; "List of functions in the SubL-API that we want to import to
;;  Emacs as 'cm-<FUNCTION-NAME>'"
(defvar cyc-subl-function-names nil "")

(setq cyc-subl-function-names
 (list "all-instances" "all-term-assertions" "all-isa" "comment" 
  "min-genls" "all-genls" "all-specs" "constant-complete"
  "cyclify" "create-constant" "find-or-create-constant" "constant-apropos"
  "cyc-assert" "cyc-query" "get-arglist" "arg1-isa" "arg2-isa"
  "constant-apropos-print" "cap" "ca" "all-term-assertions-print"
  "all-term-assertions-print-mt" "all-instances-print"
  "all-instances-print-mt" "cyc-query-print" "cyc-query-print-mt"
  "all-isa-print" "all-isa-print-mt" "c" "c-mt" "p" "q" "q-mt"
  "describe-all-instances" "cc" "apropos" "arg1" "arg2" "arg3"))

(cmh-define-all-subl-api-commands-for-emacs)

(defun cmh-cyclify-tos ()
 ""
 (interactive)
 (let ((result 
	(cdr 
	 (assoc "Output" 
	  (freekbs2-importexport-convert 
	   (car freekbs2-stack)
	   "Interlingua" "Cyclified String")))))
  (freekbs2-replace-tos-with-item result t)))

(defun cmh-cyclify-item-single (item)
 ""
 (interactive)
 (string-match "^\\(#\\$\\)?\\(.+?\\)$" item)
 (concat "#$" (match-string 2 item)))

(defun cmh-cyclify-tos-single ()
 ""
 (interactive)
 (freekbs2-replace-tos-with-item (cmh-cyclify-item-single (car freekbs2-stack))))

;; (freekbs2-importexport-convert "item" "Interlingua" "Cyclified String")

;; (cmh-cyclify-freekbs2-stack)



;; (join "\n" (sort (mapcar (lambda (item) (prin1-to-string item t)) (cm-all-isa "#$Dog")) 'string<))
;; (cm-all-term-assertions "#$Researcher")

;; cm-exec
;; (all-instances "#$Dog")

;; cm-exec-2
;; (all-instances Dog)




;; (make-symbol "#$Dog")
;; (eval (read "(setq #$Dog \"#$Dog\")"))
;; (eval (read "(setq #$Dog \"#$Dog\")"))
;; (setq Dog "#$Dog")
;; (all-instances Dog)

;; (prin1-to-string \#$Dog)

;; (setq cyc-Dog "#$Dog")
;; (cm-all-isa cyc-Dog)

;; (setq $Dog "#$Dog")
;; (cm-all-instances $Dog)

;;(mapcar (lambda (term) (cm-all-isa term))
;; (cm-all-instances "#$Dog"))

;; (make-symbol "#$test")
;; #$Researcher
;; (cm-all-instances "#$Researcher")
;; 
;; (cmh-act-on-referent nil "all-instances" "#$Dog")

;; (all-instances "#$CycLNonAtomicReifiedTerm")

;; #$CycLNonAtomicReifiedTerm

;; (defun cmh-cyc-query ()
;;  ""
;;  (interactive)
;;  (seed 
;;   (cmh-send-subl-command 
;;    (concat "(cyc-query '(#$hasDegreeInField ?X #$PhDDegree ?Y) #$EverythingPSC)"))))


;; (all-instances (list #$NotDiplomaticallyRecognizedByFn #$UnitedStatesOfAmerica) "#$EverythingPSC")

(defun cmh-set-microtheory (&optional arg mt)
 ""
 (interactive "P")
 ;; ordinarily we'd just completing read this, but there's too many I think
 ;; (completing-read "Microtheory?: " 
 ;;  (all-instances "#$Microtheory"))
 (see
  (setq cmhc-microtheory
   (if arg (cmh-referent)
    (completing-read "Microtheory?: "
     (list "#$BaseKB" "#$EverythingPSC" "#$ComputingWorkshop2015Mt"))))))

(defun cmh-cyc-query-into-stack (&optional formula mt)
 ""
 (interactive)
 (freekbs2-ring-push
  (cmh-cyc-query formula mt)))

;; (defun cmh-cyc-query (&optional formula mt)
;;  ""
;;  (interactive)
;;  (cyc-query (seed (cmh-get-stack-as-cycl-string-quoted formula))))

(defun cmh-get-stack-as-cycl-string-quoted (&optional formula mt)
 ""
 (concat "'" (cmh-get-stack-as-cycl-string formula)))

; (cmh-get-stack-as-cycl-string)

(defun cmh-cyc-query (&optional formula mt)
 ""
 (interactive)
 (cmh-send-subl-command 
  (seed (concat "(cyc-query '" (cmh-get-stack-as-cycl-string formula) " " 
   (or mt cmhc-microtheory "#$EverythingPSC") ")"))))

(defun seed (item)
 ""
 (if cmh-debug
  (see item)
  item))

(defun cmh-get-stack-as-cycl-string (&optional formula)
 ""
 (interactive)
 (cdr
  (assoc "Output"
   (freekbs2-importexport-convert
    (prin1-to-string (or formula freekbs2-stack)) 
    "Emacs String" "CycL String"))))


;; (cdr
;;  (assoc "Output"
;;   (freekbs2-importexport-convert
;;    (prin1-to-string freekbs2-stack) 
;;    "Emacs String" "CycL String")))

;; (cdr
;;  (assoc "Output"
;;   (freekbs2-importexport-convert
;;    (list freekbs2-stack)
;;    "Interlingua" "CycL String")))

;; (freekbs2-importexport-convert "(not                                               
;;               (thereExists ?DESTRUCTION                        
;;                 (and                                           
;;                   (isa ?DESTRUCTION DestructionEvent)          
;;                   (inputsDestroyed ?DESTRUCTION TheOneRing))))" "CycL String")


;; here's a test

(if nil
 (progn
  (freekbs2-ring-clear)
  (setq freekbs2-stack 
   '("#$not"
     ("#$thereExists" var-DESTRUCTION
      ("#$and"
       ("#$isa" var-DESTRUCTION "#$DestructionEvent")
       ("#$inputsDestroyed" var-DESTRUCTION "#$TheOneRing")))))
  (seed (cmh-cyc-query))
  ))



(defun cmh-constant-complete (&optional predicate)
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
	(pattern
	 (cmh-decyclify
          (cyc-mode-get-cyc-constant-or-symbol-at-point)))
	(beg (- (point) (length pattern)))
	)
  (if (and (non-nil pattern)
       (non-nil (string-match "\\([^\\s]\\)" pattern)))
   (let*
    ((completions
      (cmh-decyclify
       (constant-complete (prin1-to-string pattern))))
     (completion (try-completion pattern completions)))
    (seed completions)
    (cond ((eq completion t))
     ((null completion)
      (error "Can't find completion for \"%s\"" pattern)
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

;; (freekbs2-ring-push (constant-apropos "Microtheory"))
;; (cmh-cyc-query '("#$ist" "#$HPKB-Y1-CM-PQ-Microtheory" 'var-X))

(defun cmh-cyclified (string)
 (interactive)
 (non-nil (string-match "\\#\\$" string)))

(defun cmh-toggle-cyclification ()
 (interactive)
 ""
 (if (cmh-cyclified (freekbs2-get-top-of-stack))
  (cmh-decyclify-tos)
  (cmh-cyclify-tos)))

(defun cmh-toggle-cyclification-single ()
 (interactive)
 ""
 (if (cmh-cyclified (car freekbs2-stack))
  (cmh-decyclify-tos-single)
  (cmh-cyclify-tos-single)))

(defun cmh-decyclify-tos ()
 (interactive)
 (freekbs2-replace-tos-with-item
  (cmh-decyclify
   (freekbs2-get-top-of-stack))))

(defun cmh-decyclify-tos-single ()
 (interactive)
 (freekbs2-replace-tos-with-item
  (cmh-decyclify
   (car freekbs2-stack))))

(defun cmh-decyclify-real (interlingua)
 ""
 (kmax-not-yet-implemented))

(defun cmh-decyclify-quick (interlingua)
 ""
 (if (stringp interlingua)
  (if (and 
       (string-match "^#$\\([_a-zA-Z0-9-]+\\)$" interlingua)
       (match-string 1 interlingua))
   (match-string 1 interlingua)
   interlingua)
  (if (listp interlingua)
   (mapcar 'cmh-decyclify-quick interlingua)
   interlingua)))

(defun cmh-cyclify-stupid (interlingua)
 (if (stringp interlingua)
 (concat "#$" interlingua)))

(defun cmh-decyclify (interlingua)
 ""
 (cmh-decyclify-quick interlingua))

(defun cmh-complete-or-tab (&optional arg)
 (interactive "P")
 (let* ((cmh-line-prefix (save-excursion
			  (set-mark (point))
			  (beginning-of-line nil)
			  (buffer-substring-no-properties (point) (mark)))))
  (if (string-match "^[\s\t]*$" cmh-line-prefix)
   (progn
    ;; (see "yes") 
    (indent-for-tab-command arg))
   (progn
    ;; (see "no")
    (unwind-protect
    (condition-case ex
     (cmh-constant-complete)
     ('error (indent-for-tab-command arg))))))))

(defun cmh-wrap-sexp-with-cyc-assert ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

(defun constant-apropos (string)
 (interactive)
 (cm-exec-a "constant-apropos" (prin1-to-string string)))

(defun cmh-insert-everythingpsc ()
 (interactive)
 (insert "#$EverythingPSC"))

;; (SUBLISP::REQ-0 &OPTIONAL SUBLISP::OPT-1)

(defun cmh-speak-comment-for-referent (&optional arg)
 (interactive "P")
 (cmh-comment-for-referent arg)
 (all-speak-text (freekbs2-get-top-of-stack)))

(setq cmh-currently-enabled-modes (list 'speak))
(defvar cmh-all-modes
 (list 'all-instances 'all-term-assertions 'no-mt 'push-onto-ring 'speak))

(defun cmh-merge-modes-lists (a b)
 (union a b))

(defun cmh-enable-modes ()
 (interactive)
 (org-frdcsa-manager-dialog--subset-select
  (set-difference cmh-all-modes cmh-currently-enabled-modes)
  'cmh-modes-enable))

;; (cmh-modes-disable (list 'no-mt))
;; (cmh-modes-enable (list 'no-mt))

(defun cmh-disable-modes ()
 (interactive)
 (org-frdcsa-manager-dialog--subset-select
  cmh-currently-enabled-modes
  'cmh-modes-disable))

(defun cmh-modes-enable (modes)
 (setq cmh-currently-enabled-modes
  (union cmh-currently-enabled-modes modes)))

(defun cmh-modes-disable (modes)
 (setq cmh-currently-enabled-modes
  (set-difference cmh-currently-enabled-modes modes)))

(defun cmh-describe-subl-function ()
 (interactive)
 (let* ((referent (cmh-referent))
	(result (kmax-search-files
		 (concat "(define " referent " ")
		 (kmax-grep-list-regexp
		  (kmax-find-name-dired (cmhsm-local-cyc-subl-directory-helper) ".subl$")
		  "[^~]$")))
	(filename (progn
		   (string-match "^\\(.+?\\):\s*(\s*define\s*" result)
		   (match-string 1 result))))
  (kmax-edit-temp-buffer "*SubL Help*")
  (insert (concat referent " is a SubL function in `" (eshell/basename filename) "'.\n\n"))
  (insert (concat "(" referent ")\n"))
  ;; (insert (subl-get-arglist referent))
  ;; (subl-get-arglist "all-term-assertions")
  ;; determine if it is bound
  ))

(defun cmhsm-search-my-kb-dir (&optional search)
 ""
 (interactive)
 (let ((search (or search (read-from-minibuffer "Search?: "))))
  (kmax-search-files
   search
   (kmax-grep-list-regexp
    (kmax-find-name-dired (cmhsm-local-cyc-subl-directory-helper) ".subl$")
    "[^~]$")
   "*SubL Cyc Search*")))

(defun cmh-get-subl-arity (subl-function)
 (interactive)
 (see (cmh-send-to-system-cyc-no-result-parsing (concat "(get-subl-arity \"" subl-function "\")"))))

;; (see (cmh-get-arg-list "get-arglist"))

;; HAVE TO USE THESE BECAUSE THE ONES THAT WORK WITH DEFINE DONT

(defun subl-arg-list (subl-function)
 (interactive)
 (cmh-send-subl-command
  (concat
   "(cyc-query (list #$subLArgNIsa (list #$subLFunctionFn \""
   subl-function
   "\") '?X '?Y) #$FRDCSASubLMt)")))

(defun subl-arity (subl-function)
 (interactive)
 (cmh-send-subl-command
  (concat
   "(cyc-query (list #$subLArity (list #$subLFunctionFn \""
   subl-function
   "\") '?X) #$FRDCSASubLMt)")))

(defun subl-get-arglist (subl-function)
 (interactive)
 (see (cmh-send-to-system-cyc-no-result-parsing
  (see (concat
   "(get-arglist '" subl-function ")")))))

;; (subl-constant-complete-exact "Project")

(defun subl-constant-complete-exact (constant)
 (interactive)
 (see (cmh-send-subl-command
  (see (concat
   "(constant-complete-exact \"" constant "\")")))))

(defun cmh-send-to-system-cyc-no-result-parsing (subl-function)
 (interactive)
 (uea-query-agent-raw nil "Org-FRDCSA-System-Cyc"
  (freekbs2-util-data-dumper
   (list
    (cons "_DoNotLog" 1)
    (cons "SubLQuery" subl-function)
    (cons "OutputType" "Interlingua")))))

;; (subl-arity "all-term-assertions")

(provide 'cyc-mode-hybrid)
