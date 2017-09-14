;;; subl-fontify.el --- a part of the simple Subl mode

(defgroup subl-faces nil "faces used for Subl mode"  :group 'faces)

(defvar in-xemacs-p "" nil)

;;; GNU requires that the face vars be defined and point to themselves

(defvar subl-main-keyword-face 'subl-main-keyword-face
  "Face to use for Subl relations.")
(defface subl-main-keyword-face
  '((((class color)) (:foreground "red" :bold t)))
  "Font Lock mode face used to highlight class refs."
  :group 'subl-faces)

(defvar subl-function-nri-and-class-face 'subl-function-nri-and-class-face
  "Face to use for Subl keywords.")
(defface subl-function-nri-and-class-face
    (if in-xemacs-p 
	'((((class color)) (:foreground "red"))
	  (t (:foreground "gray" :bold t)))
      ;; in GNU, no bold, so just use color
      '((((class color))(:foreground "red"))))
  "Font Lock mode face used to highlight property names."
  :group 'subl-faces)

(defvar subl-normal-face 'subl-normal-face "regular face")
(defface subl-normal-face
 '((t (:foreground "grey")))
 "Font Lock mode face used to highlight property names."
 :group 'subl-faces)

(defvar subl-string-face 'subl-string-face "string face")
(defface subl-string-face
    '((t (:foreground "green4")))
  "Font Lock mode face used to highlight strings."
  :group 'subl-faces)

(defvar subl-logical-operator-face 'subl-logical-operator-face
  "Face to use for Subl logical operators (and, or, not, exists, forall, =>, <=>)")
;; same as function name face
(defface subl-logical-operator-face
 '((((class color)) (:foreground "blue")))
  "Font Lock mode face used to highlight class names in class definitions."
  :group 'subl-faces)

(defvar subl-main-relation-face 'subl-main-relation-face
  "Face to use for Subl relations.")
(defface subl-main-relation-face
  '((((class color)) (:foreground "black" :bold t)))
  "Font Lock mode face used to highlight class refs."
  :group 'subl-faces)

(defvar subl-commands-face 'subl-commands-face
  "Face to use for Subl commands.")
(defface subl-commands-face
  '((((class color)) (:foreground "DeepSkyBlue" :bold t)))
  "Font Lock mode face used to highlight class refs."
  :group 'subl-faces)

(defvar subl-relation-face 'subl-relation-face
  "Face to use for Subl relations.")
(defface subl-relation-face
  '((((class color)) (:foreground "darkgrey")))
  "Font Lock mode face used to highlight class refs."
  :group 'subl-faces)

;; (defvar subl-property-face 'subl-property-face
;;   "Face to use for Subl property names in property definitions.")
;; (defface subl-property-face
;;   (if in-xemacs-p  
;;      '((((class color)) (:foreground "darkviolet" :bold t))
;;        (t (:italic t)))
;;     ;; in gnu, just magenta
;;     '((((class color)) (:foreground "darkviolet"))))
;;      "Font Lock mode face used to highlight property names."
;;      :group 'subl-faces)

(defvar subl-variable-face 'subl-variable-face
  "Face to use for Subl property name references.")
(defface subl-variable-face
  '((((class color)) (:foreground "darkviolet" ))
    (t (:italic t)))
  "Font Lock mode face used to highlight property refs."
  :group 'subl-faces)

(defvar subl-comment-face 'subl-comment-face
  "Face to use for Subl comments.")
(defface subl-comment-face
  '((((class color) ) (:foreground "red" :italic t))
    (t (:foreground "DimGray" :italic t)))
  "Font Lock mode face used to highlight comments."
  :group 'subl-faces)

(defvar subl-other-face 'subl-other-face
  "Face to use for other keywords.")
(defface subl-other-face
  '((((class color)) (:foreground "peru")))
  "Font Lock mode face used to highlight other Subl keyword."
  :group 'subl-faces)

;; (defvar subl-tag-face 'subl-tag-face
;;   "Face to use for tags.")
;; (defface subl-tag-face
;;     '((((class color)) (:foreground "violetred" ))
;;       (t (:foreground "black")))
;;   "Font Lock mode face used to highlight other untyped tags."
;;   :group 'subl-faces)

;; (defvar subl-substitution-face 'subl-substitution-face "face to use for substitution strings")
;; (defface subl-substitution-face
;;     '((((class color)) (:foreground "orangered"))
;;       (t (:foreground "lightgrey")))
;;   "Face to use for Subl substitutions"
;;   :group 'subl-faces)


;;;================================================================
;;; these are the regexp matches for highlighting Subl 

(defvar subl-font-lock-prefix "\\b")

(defvar subl-font-lock-keywords
  (let ()
    (list 

     ;; (list
     ;;  "^[^;]*\\(;.*\\)$" '(1 subl-comment-face nil))

     (list 
      ;; (concat "^\s*[^;][^\n\r]*[\s\n\r(]\\b\\(and\\|or\\|not\\|exists\\|forall\\)\\b"
      (concat "\\b\\(and\\|or\\|not\\|exists\\|forall\\)\\b"
	      )
      '(1 subl-logical-operator-face nil)
      )
     
     (list 
      (concat subl-font-lock-prefix "\\(" (join "\\|"
	      subl-mode-main-relation ) "\\)\\b" ) '(1
	      subl-main-relation-face nil) )

     (list
      (concat subl-font-lock-prefix "\\(" 
       (join "\\|"
	subl-mode-functions-non-relational-instances-and-classes) "\\)\\b")
      '(1 subl-function-nri-and-class-face nil))

     (list 
      (concat
       subl-font-lock-prefix "\\([_a-zA-Z0-9-]+Fn\\)\\b" )
       '(1 subl-function-nri-and-class-face nil) )

     (list 
      (concat "\\(\\?[_A-Za-z0-9-]+\\)\\b"
	      )
      '(1 subl-variable-face nil)
      )

     (list 
      (concat "\\(\\&\\%[_A-Za-z0-9-]+\\)\\b"
	      )
      '(1 subl-other-face nil)
      )

     (list 
      (concat subl-font-lock-prefix "\\(" (join "\\|"
     	      subl-mode-relations) "\\)\\b" ) '(1
     	      subl-relation-face nil) )

     (list 
      ;; (concat "^\s*[^;][^\n\r]*[\s\n\r(]\\(=>\\|<=>\\)"
      (concat "\\(=>\\|<=>\\)")
      '(1 subl-logical-operator-face nil)
      )

     (list 
      (concat subl-font-lock-prefix "\\(" (join "\\|"
	      subl-mode-main-keyword ) "\\)\\b" ) '(1
	      subl-main-keyword-face nil) )

     (list 
      (concat subl-font-lock-prefix "\\(" (join "\\|"
	      subl-mode-commands ) "\\)\\b" ) '(1
	      subl-commands-face nil) )

     ;; (list subl-mode-commands-regex '(1 subl-commands-face nil) )
     
     ;; black for the def parts of PROPERTY DEFINITION
     ;; and of TransitiveProperty UnambiguousProperty UniqueProperty
;;; END OF LIST ELTS
     ))

    "Additional expressions to highlight in Subl mode.")



(put 'subl-mode 'font-lock-defaults '(subl-font-lock-keywords nil nil))

(defun re-font-lock () (interactive) (font-lock-mode 0) (font-lock-mode 1))

(provide 'subl-fontify)
