; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

(define (script-fu-layers-opacity-settings image drawable visible-only? opacity)
  (let* (
      (all-layers (gimp-image-get-layers image))
      (i (car all-layers))
      (layer 0)
      (tmp FALSE)
      )
    (gimp-image-undo-group-start image)
    (set! all-layers (cadr all-layers))
    (while (> i 0)
      (set! layer (aref all-layers (- i 1)))
      (if (or (= visible-only? FALSE) (= (car (gimp-drawable-get-visible layer)) TRUE))
        (gimp-layer-set-opacity layer opacity)
        )
      (set! i (- i 1))
      )
    )
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
  )

(script-fu-register "script-fu-layers-opacity-settings"
  "<Image>/Video/Utils/Set Opacity of Layers"
  "Change the opacity setting of multiple layers."
  "Saul Goode"
  "Saul Goode"
  "1/30/2009"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  SF-TOGGLE "Visible layers only?" TRUE
  SF-ADJUSTMENT "Opacity" '( 100 0 100 1 10 0 0)
  )
