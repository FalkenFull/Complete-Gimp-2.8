(define (sg-hue-cycle image drawable step-size)
  (gimp-image-undo-group-start image)
  (let* (
      (layer 0)
      (step step-size)
      (count (abs step-size))
      (hue-offset 0)
      )
    (while (< count 360)
      (set! layer (car (gimp-layer-new-from-drawable drawable image)))
      (gimp-image-add-layer image layer 0)
      (set! hue-offset (if (and (>= step -180) (<= step 180))
                             step
                             (if (< step -180)
                               (+ 360 step)
                               (- step 360)
                               )))
      (gimp-hue-saturation layer
                           ALL-HUES
                           hue-offset
                           0
                           0)
      (gimp-drawable-set-name layer (number->string hue-offset))
      (set! count (+ count (abs step-size)))
      (set! step (+ step step-size))
      )
    )
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
  )

(script-fu-register "sg-hue-cycle"
 "<Image>/Video/Animated FX/Hue cycle..."
 "Create animation layers which alter the hue"
 "Saul Goode"
 "Saul Goode"
 "4/6/2009"
 "RGBA"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  SF-ADJUSTMENT "Step size" '(0 -180 180 1 10 0 0 0)
  )



