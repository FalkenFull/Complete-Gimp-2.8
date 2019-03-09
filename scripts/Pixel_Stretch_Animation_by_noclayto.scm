;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Pixel Stretch
;;  by noclayto <noclayto.deviantart.com> 
;;  
;;  Something Something Something
;;
;;  Creative Commons License
;;  Some rights reserved. This work is licensed under a
;;  Creative Commons Attribution-Share Alike 3.0 License.
;;
;;  ;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sept 2009 modificated the script register path for a better integration 
;;  with GAP now the script is in <Image>Video/Animated FX/Pixel Strecht FX
;;  PhotoComix  photocomix@gmail.com
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (script-fu-pixel-stretch img drawable direction step)
  
  (let* ( 
         (y1 0) 
         (y2 0)
         (width  (car (gimp-drawable-width  drawable)))
         (height (car (gimp-drawable-height drawable)))
         (wh-temp width) 
         (counter 0) 
         (new-layer 0)
         (name "What")
         ) 
    
    
    (gimp-context-push)
    (gimp-image-undo-group-start img)
    
    (cond
      
      ;;North
      ((= direction 0)
       (set! name "NorthStretch")
       )
      
      ;; East
      ((= direction 1)
       (set! name "EastStretch")
       (set! width height)
       (set! height wh-temp)
       (gimp-image-rotate img 0)
       )
      
      ;; South 
      ((= direction 2)
       (set! name "SouthStretch")
       (gimp-image-rotate img 1)
       )
      
      ;; West 
      ((= direction 3)
       (set! name "WestStretch")
       (set! width height)
       (set! height wh-temp)
       (gimp-image-rotate img 2)
       )
      )
    
    (set! y1 0)
    (set! y2 step)
    (set! counter height)
    
    ;; Main Loop
    (while (> counter 0)
           (set! new-layer (car (gimp-layer-new img width step 0 name 100 0 )))
           (gimp-image-add-layer img new-layer -1)
           
           (gimp-rect-select img 0 y1 width y2 2 0 0)
           (gimp-edit-copy drawable)
           (gimp-selection-all img)
           (gimp-floating-sel-anchor (car (gimp-edit-paste new-layer TRUE)))
           (gimp-selection-none img)
           
           (gimp-layer-scale new-layer width height TRUE)
           (gimp-layer-set-offsets new-layer 0 0)
           
           (gimp-rect-select img 0 0 width y2 2 0 0)
           (gimp-edit-copy drawable)
           (gimp-floating-sel-anchor (car (gimp-edit-paste new-layer TRUE)))
           
           (set! counter (- counter step))
           (set! y1 y2) (set! y2 (+ y2 step))
           
           ) 
    
    
    (gimp-selection-none img)
    
    ; ; (gimp-message (number->string dir-x 10))
    ; ; (gimp-message (number->string dir-y 10))
    
    
    (cond
      
      ;; East
      ((= direction 1)
       (gimp-image-rotate img 2)
       )
      
      ;; South 
      ((= direction 2)
       (gimp-image-rotate img 1)
       
       )
      
      ;; West 
      ((= direction 3)
       (gimp-image-rotate img 0)
       )
      )
    
    
    (gimp-image-undo-group-end img)
    (gimp-context-pop)
    (gimp-displays-flush)))

(script-fu-register "script-fu-pixel-stretch"
                    _"<Image>/Video/Animated FX/Pixel Stretch FX"
                    ""
                    "noclayto"
                    "noclayto"
                    "July 2006"
                    "RBG"
                    
                    SF-IMAGE       "Image"    0	
                    SF-DRAWABLE    "Drawable" 0
                    SF-OPTION	  _"Direction"	'(_"N" _"E" _"S" _"W")
                    SF-ADJUSTMENT _"Pixel Step"  '(1 1 15 1 1 0 1)
                    )




