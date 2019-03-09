; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

(define (sg-create-modal-layers image drawable opacity
            dissolve
            multiply divide screen overlay
            dodge burn hard-light soft-light grain-extract grain-merge
            difference addition subtract darken-only lighten-only
            hue saturation color value
            )
  (define (new-layer mode name)
    (let* (
        (layer (car (gimp-layer-new-from-drawable drawable image)))
        (new-name "")
        )
      (gimp-image-add-layer image layer -1)
      (gimp-drawable-set-name layer
          (string-append name (car (gimp-drawable-get-name drawable))))
      (gimp-layer-set-opacity layer opacity)
      (gimp-layer-set-mode layer mode)
      )
    )
  (gimp-image-undo-group-start image)
  (when (= value TRUE)
    (new-layer VALUE-MODE "Value-"))
  (when (= color TRUE)
    (new-layer COLOR-MODE "Color-"))
  (when (= saturation TRUE)
    (new-layer SATURATION-MODE "Saturation-"))
  (when (= hue TRUE)
    (new-layer HUE-MODE "Hue-"))
  (when (= lighten-only TRUE)
    (new-layer LIGHTEN-ONLY-MODE "Lighten only-"))
  (when (= darken-only TRUE)
    (new-layer DARKEN-ONLY-MODE "Darken only-"))
  (when (= subtract TRUE)
    (new-layer SUBTRACT-MODE "Subtract-"))
  (when (= addition TRUE)
    (new-layer ADDITION-MODE "Addition-"))
  (when (= difference TRUE)
    (new-layer DIFFERENCE-MODE "Difference-"))
  (when (= grain-merge TRUE)
    (new-layer GRAIN-EXTRACT-MODE "Grain merge-"))
  (when (= grain-extract TRUE)
    (new-layer GRAIN-EXTRACT-MODE "Grain extract-"))
  (when (= soft-light TRUE)
    (new-layer SOFTLIGHT-MODE "Soft light-"))
  (when (= hard-light TRUE)
    (new-layer HARDLIGHT-MODE "Hard light-"))
  (when (= burn TRUE)
    (new-layer BURN-MODE "Burn-"))
  (when (= dodge TRUE)
    (new-layer DODGE-MODE "Dodge-"))
  (when (= overlay TRUE)
    (new-layer OVERLAY-MODE "Overlay-"))
  (when (= screen TRUE)
    (new-layer SCREEN-MODE "Screen-"))
  (when (= divide TRUE)
    (new-layer DIVIDE-MODE "Divide-"))
  (when (= multiply TRUE)
    (new-layer MULTIPLY-MODE "Multiply-"))
  (when (= dissolve TRUE)
    (new-layer DISSOLVE-MODE "Dissolve-"))
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
  )

(script-fu-register "sg-create-modal-layers"
 "Create modal layers..."
 "Make copies of layer in various modes"
 "Saul Goode"
 "Saul Goode"
 "5/17/2006"
 "*"
 SF-IMAGE    "Image"    0
 SF-DRAWABLE "Drawable" 0
 SF-ADJUSTMENT "Opacity" '(30 0 100 1 10 1 0)
 SF-TOGGLE "Dissolve" FALSE
 SF-TOGGLE "Multiply" TRUE
 SF-TOGGLE "Divide" FALSE
 SF-TOGGLE "Screen" TRUE
 SF-TOGGLE "Overlay" TRUE
 SF-TOGGLE "Dodge" TRUE
 SF-TOGGLE "Burn" TRUE
 SF-TOGGLE "Hard light" FALSE
 SF-TOGGLE "Soft light" FALSE
 SF-TOGGLE "Grain Extract" FALSE
 SF-TOGGLE "Grain Merge" FALSE
 SF-TOGGLE "Difference" FALSE
 SF-TOGGLE "Addition" FALSE
 SF-TOGGLE "Subtract" FALSE
 SF-TOGGLE "Lighten only" FALSE
 SF-TOGGLE "Darken only" FALSE
 SF-TOGGLE "Hue" FALSE
 SF-TOGGLE "Saturation" TRUE
 SF-TOGGLE "Color" FALSE
 SF-TOGGLE "Value" TRUE
 )
(script-fu-menu-register "sg-create-modal-layers"
  "<Image>/Layer"
  )
