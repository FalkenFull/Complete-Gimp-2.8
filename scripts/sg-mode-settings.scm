; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

(define (script-fu-layers-mode-settings image drawable visible-only? mode)
  (let* (
      (all-layers (gimp-image-get-layers image))
      (i (car all-layers))
      (layer 0)
      (tmp FALSE)
      (mode-lut '#( 0 1 3 15 4 5 16 17 18 19 20 21 6 7 8 9 10 11 12 13 14))
      )
    (gimp-image-undo-group-start image)
    (set! all-layers (cadr all-layers))
    (while (> i 0)
      (set! layer (aref all-layers (- i 1)))
      (if (or (= visible-only? FALSE) (= (car (gimp-drawable-get-visible layer)) TRUE))
        (gimp-layer-set-mode layer (vector-ref mode-lut mode))
        )
      (set! i (- i 1))
      )
    )
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
  )

(script-fu-register "script-fu-layers-mode-settings"
  "<Image>/Video/Utils/Set Mode of Layers"
  "Change the layermode of multiple layers."
  "Saul Goode"
  "Saul Goode"
  "1/30/2009"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  SF-TOGGLE "Visible layers only?" TRUE
  SF-OPTION "Blend Mode" '( "Normal"     ; 0
                            "Dissolve"   ; 1
                            "Multiply"   ; 3
                            "Divide"     ; 15
                            "Screen"     ; 4
                            "Overlay"    ; 5
                            "Dodge"      ; 16
                            "Burn"       ; 17
                            "Hard light" ; 18
                            "Soft light" ; 19
                            "Grain extract" ; 20
                            "Grain merge" ; 21
                            "Difference" ; 6
                            "Addition"   ; 7
                            "Substract"  ; 8
                            "Darken only" ; 9
                            "Lighten only" ; 10
                            "Hue" ; 11
                            "Saturation" ;12
                            "Color" ; 13
                            "Value" ; 14
                            )
  )
