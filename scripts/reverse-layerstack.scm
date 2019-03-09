(define (script-fu-reverse-layerstack image drawable)
  ;; Get list of layers, (bottom ... top)
  (define (sf-image-get-layers img)
    (let* (
        (all-layers (gimp-image-get-layers img))
        (i (car all-layers))
        (list-of-layers ()))
      (set! all-layers (cadr all-layers))
      (while (> i 0)
        (set! list-of-layers (append list-of-layers (cons (aref all-layers (- i 1)))))
        (set! i (- i 1)))
      list-of-layers))

  ;; Move layer to a layerstack position (position "0" = top layer)
  ;; If either the layer or position is the bottom layer then
  ;; it is up to the caller to assure that the "Background" has
  ;; an alpha channel.
  (define (sf-image-move-layer-to-position image layer position)
    (let* (
        (all-layers (sf-image-get-layers image)) 
        )
      (if (not (= (car (last all-layers)) layer))
        (gimp-image-raise-layer-to-top image layer)
        )
      (while (> position 0)
        (gimp-image-lower-layer image layer)
        (set! position (- position 1)))))
      
  (let* (
      (layer-list (sf-image-get-layers image))
      (position 0))
    (gimp-image-undo-group-start image)
    (if (= (car (gimp-drawable-has-alpha (car layer-list))) 0)
      (gimp-layer-add-alpha (car layer-list)))
    (while (cdr layer-list)
      (sf-image-move-layer-to-position image (car layer-list) position)
      (set! position (+ position 1))
      (set! layer-list (cdr layer-list))
      )
    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
    )
  )
(script-fu-register "script-fu-reverse-layerstack"
		   "<Image>/Video/Utils/Reverse Layerstack.." 
		    _"Swap the order of layers in the layerstack"
		    "Saulgoode"
		    "Saulgoode"
		    "2006/6/21"
		    ""
		    SF-IMAGE       "Image"           0
		    SF-DRAWABLE    "Drawable"        0
	)


