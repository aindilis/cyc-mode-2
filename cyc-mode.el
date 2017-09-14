(setq cyc-mode-type "hybrid")
(if (string= cyc-mode-type "hybrid")
 (progn

  ;; /var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/cyc-shell-mode.el
  ;; /var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/cyc-mode-hybrid-common.el
  ;; /var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/cyc-mode-hybrid.el
  ;; /var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/cyc-mode-hybrid-w3m.el
  ;; /var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/cyc-mode-hybrid-academician.el
  ;; /var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/cyc-mode-hybrid-session-manager.el
  ;; /var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/subl-mode.el

  (add-to-list 'load-path "/var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid")
  (require 'cyc-shell-mode)
  (require 'cyc-mode-hybrid-common)
  (require 'cyc-mode-hybrid)
  (require 'cyc-mode-hybrid-w3m)
  (require 'cyc-mode-hybrid-academician)
  (require 'cyc-mode-hybrid-session-manager)
  (require 'subl-mode)
  )
 (if (string= cyc-mode-type "pure")
  (progn
   (add-to-list 'load-path "/var/lib/myfrdcsa/codebases/minor/cyc-mode/pure")
   (require 'cyc-mode-pure))))

;; This is a new CYC mode designed to be completely uninhibited by the
;; mistakes in the earlier mode, which were there because we lost the
;; latest version of it.

;; have a function to start cyc-mode bind it to C-c C-k C-v c y

;; let's consult all my files about what I want included in a cyc mode

;; well what's the best interface to use with cyc, I would imagine
;; Cyc's own APIs used through Perl - although that might
;; disenfranchise others.  Maybe that is better for KBS-mode.  I think
;; there was some recent infrastructure about all these modes.

;; maybe borrow from w3m-el mode's ability to have tabs

;; ()
