(global-set-key "\C-ccadr" 'cmh-academician-declare-comment-read-for-constant)

(defun cmh-academician-declare-comment-read-for-constant ()
 ""
 (interactive)
 ;; figure out how to get the constant that is being read
 ;; (done (read #$AndrewJDougherty-TheAIResearcher (valueOf (comment #$ConstantBeingReadAbout #$Microtheory)))) #$Academician-AndrewJDoughertyMt

 )

(provide 'cyc-mode-hybrid-academician)
