;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Hue Animator
;;  by noclayto <noclayto.deviantart.com>
;;  Will cycle through the HUE by a user chosen number of
;;  steps.
;; ;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sept 2009 modificated the script register path for a better integration 
;;  with GAP now the script is in <Image>Video/Animated FX/Hue_Change FX
;;  PhotoComix  photocomix@gmail.com
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


(define (script-fu-hue-animator img drawable step)
  
  (let* (
	 (counter step) 
	 (new-layer drawable)
	 ) 
    
    (gimp-image-undo-group-start img)
    ;;(gimp-image-raise-layer-to-top img drawable) ;;error??? 
    ;; WHY? I hate when I don't understand???
    

    (while (< counter 180)
	   (set! new-layer (car (gimp-layer-copy drawable TRUE)))
	   (gimp-image-add-layer img new-layer -1)
	   (gimp-hue-saturation new-layer 0 counter 0 0)
	   (set! counter (+ counter step))
	   )
    
    (set! counter (- counter 360))
    
    (while (< counter 0)
	   (set! new-layer (car (gimp-layer-copy drawable TRUE)))
	   (gimp-image-add-layer img new-layer -1)
	   (gimp-hue-saturation new-layer 0 counter 0 0)
	   (set! counter (+ counter step))
	   )
    


    
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)))

(script-fu-register "script-fu-hue-animator"
		    _"<Image>/Video/Animated FX/Hue-Change FX..."
		    ""
		    "noclayto"
		    "noclayto"
		    "July 2006"
		    ""
                    SF-IMAGE       "Image"    0
		    SF-DRAWABLE    "Drawable" 0
		    SF-ADJUSTMENT _"Color Step"  '(45 1 360 1 10 0 1)
		    )

		    


