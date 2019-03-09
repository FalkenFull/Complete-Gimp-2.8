; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Script is from Saulgoode http://flashingtwelve.brickfilms.com/GIMP/Scripts/
;; PhotoComix Sept 2009
;; i only changed the registration path:
;;  now the script show up in Video/Animation_Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (script-fu-anim-settings image drawable req-delay req-mode)
  (define (visible-layers img)
    ;; This routine returns a list of visible layers in an image
    (let* (
        (all-layers (gimp-image-get-layers img))
        (i (car all-layers))
        (viewable ())
        (tmp FALSE)
        )
      (set! all-layers (cadr all-layers))
      (while (> i 0)
        (set! tmp (car (gimp-drawable-get-visible (aref all-layers (- i 1)))))
        (if (= tmp TRUE)
          (set! viewable (append viewable (cons (aref all-layers (- i 1))))) ;; append 
          )
        (set! i (- i 1))
        )
      viewable
      )
    )
  (gimp-image-undo-group-start image)
  (let* (
      (layers)
      (full-name)
      (par-name)
      (layer-name)
      (mode)
      (delay "")
      )
    (set! layers (visible-layers image))
    (while (pair? (car layers))
      (cond 
        ( (or (= req-mode 0) (= req-mode 3))
          (set! mode "")
          )
        ( (= req-mode 1)
          (set! mode "(combine)")
          )
        ( (= req-mode 2)
          (set! mode "(replace)")
          )
        )
      (set! full-name (strbreakup (car (gimp-drawable-get-name (car layers))) "("))
      (set! layer-name (car full-name))
      (set! full-name (cdr full-name))
      (while (pair? full-name) ;; for each parenthetical, see if it is a delay or a mode (it might be a delay)
        (set! par-name (string-trim (car full-name)))
        (cond 
          ( (= 0 (strcmp "combine)" (string-downcase par-name)))
            (if (= req-mode 0) ;; Keep
              (set! mode "(combine)")
              )
            )
          ( (= 0 (strcmp "replace)" (string-downcase par-name)))
            (if (= req-mode 0) ;; Keep
              (set! mode "(replace)")
              )
            )
          ( (< (strcspn "0123456789" (substring par-name 0 1)) 10)
            (if (= req-delay 0)
              (set! delay (string-append "(" par-name))
              (set! delay "") ;; clear delay for -1 or for positive request
              )
            )
          )
        (set! full-name (cdr full-name))
        )
      (if (> req-delay 0) 
        (set! delay (string-append "(" (number->string req-delay 10) "ms) "))
        )
      (gimp-drawable-set-name (car layers) (string-append layer-name delay mode))
      (set! layers (cdr layers))
      )
    )
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
  )

(script-fu-register "script-fu-anim-settings"
 "<Image>/Video/Utils/Animation_Settings..." 
 ;; might like to keep it separate from the standard plugins
 "Sets the Frame delay and mode of GIF animations by renaming visible layers."
 "Saul Goode"
 "Saul Goode"
 "3/11/2006"
 ""
 SF-IMAGE    "Image"    0
 SF-DRAWABLE "Drawable" 0
 SF-ADJUSTMENT "Delay: (1-10000 mS, 0=Keep, -1=Clear)" '( 100 -1 10000 1 10 0 1 )
 SF-OPTION "Mode:" '( "Keep" "(combine)" "(replace)" "Clear")
 )
