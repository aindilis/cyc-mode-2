(global-set-key "\C-ccS" 'cmh-w3m-search)
(global-set-key "\C-cccM" 'cmh-process-main-page)
(global-set-key "\C-ccct" 'cmh-w3m-test)
(global-set-key "\C-cccw" 'cmh-w3m-start)
(global-set-key "\C-cccr" 'cmh-w3m-restore-windows)
(global-set-key "\C-cccc" 'cmh-process-main-page)

(defvar cmh-cyc-server-hostname "localhost")
(defvar cmh-current-window-configuration nil)

(add-hook
 'w3m-mode-hook
 (lambda ()
  (define-key w3m-mode-map "\C-m" 'cmh-w3m-view-this-url)
  ))

 ;; (lambda ()
 ;;  ;; w3m-info-like-map
 ;;  (let ((map (copy-keymap w3m-info-like-map)))
 ;;   (define-key map "\C-m" 'cmh-w3m-view-this-url)
 ;;   (setq w3m-info-like-map map)))

(defun cmh-w3m-test ()
 ""
 (interactive)
 (progn 
  (w3m-view-this-url)
  (see "hi there")))

;; (add-hook
;;  'w3m-display-hook
;;  (lambda ()
;;   ()
;;   ))

(defun cmh-w3m-view-this-url (&optional arg new-session)
 ""
 (interactive (if (member current-prefix-arg '(2 (16)))
	       (list nil t)
	       (list current-prefix-arg nil)))
 (if (derived-mode-p 'w3m-mode)
  (let ((current-url (w3m-print-current-url))
	(url (w3m-print-this-url)))
   (if (and 
	(non-nil url)
	(non-nil
	 (string-match
	  "^.+? (http://\\(.+?\\):\\([0-9]+?\\)/cgi-bin/cyccgi/cg\\?\\(.+?\\))$"
	  url)))
    (save-excursion
     (w3m-next-buffer 1)
     (while (not (string= current-url (w3m-print-current-url)))
      (w3m-delete-buffer)
      (w3m-next-buffer 1)))
    (w3m-view-this-url)
    (sit-for 3.0)
    (cmh-process-main-page current-url)
    (w3m-view-this-url)
    ))))

(defun cmh-process-main-page ()
 ""
 (interactive)
 (let* ((index-url (progn
		    (beginning-of-buffer)
		    (search-forward "index")
		    (backward-char 1)
		    (w3m-print-this-url)))
	(content-url (progn
		      (beginning-of-buffer)
		      (search-forward "content")
		      (backward-char 1)
		      (w3m-print-this-url)))
	(toolbar-url (progn
		      (string-match "^\\(.+?\\)\\?\\(.+?\\)&\\(.+?\\)$" index-url)
		      (concat (match-string 1 index-url) "?cb-toolbar-frame&" 
		       (match-string 3 index-url))
		      )))
  (delete-other-windows)
  (w3m-browse-url content-url t)      
  (cmh-w3m-pause)
  (w3m-next-buffer 1)
  (w3m-delete-buffer)
  (split-window-vertically)
  (shrink-window 19)
  (w3m-browse-url toolbar-url t)
  (cmh-w3m-pause)
  (other-window 1)
  (split-window-horizontally)
  (shrink-window-horizontally 42)
  (w3m-browse-url index-url t)
  )
 (setq cmh-current-window-configuration (current-window-configuration))
 )

;; (defun cmh-w3m-view-this-url (&optional arg new-session)
;;  ""
;;  (interactive (if (member current-prefix-arg '(2 (16)))
;; 	       (list nil t)
;; 	       (list current-prefix-arg nil)))
;;  (if (derived-mode-p 'w3m-mode)
;;   (let ((current-url (w3m-print-current-url))
;; 	(url (w3m-print-this-url)))
;;    (if (and 
;; 	(non-nil url)
;; 	(non-nil
;; 	 (string-match
;; 	  "^.+? (http://\\(.+?\\):\\([0-9]+?\\)/cgi-bin/cyccgi/cg\\?\\(.+?\\))$"
;; 	  url)))
;;     (progn
;;      (save-excursion
;;       (w3m-next-buffer 1)
;;       (while (not (string= current-url (w3m-print-current-url)))
;;        (w3m-delete-buffer)
;;        (w3m-next-buffer 1)))
;;      (w3m-view-this-url)
     
;;      (sit-for 3.0)
;;      (let* ((index-url (progn
;; 			(beginning-of-buffer)
;; 			(search-forward "index")
;; 			(backward-char 1)
;; 			(w3m-print-this-url)))
;; 	    (content-url (progn
;; 			  (beginning-of-buffer)
;; 			  (search-forward "content")
;; 			  (backward-char 1)
;; 			  (w3m-print-this-url)))
;; 	    (toolbar-url (progn
;; 			  (string-match "^\\(.+?\\)\\?\\(.+?\\)&\\(.+?\\)$" index-url)
;; 			  (concat (match-string 1 index-url) "?cb-toolbar-frame&" 
;; 			   (match-string 3 index-url))
;; 			  )))
;;       (delete-other-windows)
;;       (w3m-browse-url content-url t)      
;;       (cmh-w3m-pause)
;;       (w3m-next-buffer 1)
;;       (w3m-delete-buffer)
;;       (split-window-vertically)
;;       (shrink-window 19)
;;       (w3m-browse-url toolbar-url t)
;;       (cmh-w3m-pause)
;;       (other-window 1)
;;       (split-window-horizontally)
;;       (shrink-window-horizontally 42)
;;       (w3m-browse-url index-url t)
;;       )
;;      )
;;     (w3m-view-this-url)
;;     ))))

(defun cmh-w3m-pause ()
 ""
 (sit-for 0.1)
 )

;; cgi-bin/cg?cb-start
;; cgi-bin/cyccgi/cg?cb-toolbar-frame&c4102
;; http://192.168.1.28:3602/cgi-bin/cyccgi/cg?cb-inferred-gaf-arg-assertions&c94009&c94009&1&c6138                                                                                                          
;; use this somewhere w3m-force-window-update, w3m-force-redisplay

;; can make a catalyst proxy that goes between the browser and cyc and
;; reformats things for clarity on the browser.

(defun cmh-w3m-browse-in-external-browser ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

(defun cmh-w3m-start ()
 ""
 (interactive)
 (w3m-browse-url (concat "http://" cmh-cyc-server-hostname ":3602/cgi-bin/cyccgi/cg?cb-toolbar-frame")))

(defun cmh-w3m-search (&optional arg search-term)
 ""
 (interactive "P")
 (w3m-browse-url 
  (concat
   "http://" cmh-cyc-server-hostname ":3602/cgi-bin/cyccgi/cg?cb-handle-specify=&handler=cb-cf&arg-done=T&query="
   (w3m-url-encode-string
    (or search-term (read-from-minibuffer "Cyc Search?: " (cmh-referent (not arg)))))
   "&gloss-required=NONE&=Clear&uniquifier-code=253")))

(defun cmh-w3m-restore-windows ()
 "Take the different buffers open and redisplay them in the
 correct positions"
 (interactive)
 (if (non-nil cmh-current-window-configuration)
  (set-window-configuration cmh-current-window-configuration)
  (error "No window configuration set.")))

(provide 'cyc-mode-hybrid-w3m)
