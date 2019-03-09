;Duplicate Layer to the top

(define (script-fu-animated-kaleidoscope-duplicate-layer img layer1)

     (let* (

	    (duplicate) (position)
     )
	

	;undo group
	(gimp-image-undo-group-start img)

	(set! position (car(gimp-image-get-layer-position img layer1)))
	(set! position (- position 1))

	(set! duplicate (car(gimp-layer-new-from-drawable layer1 img)))
	(gimp-image-add-layer img duplicate 0)

	(gimp-image-set-active-layer img duplicate)

	;end of undo group
	(gimp-image-undo-group-end img)

))


(define (script-fu-animated-kaleidoscope inimg inlayer framenumber inpart in)

     (let*
	(
	(height (car(gimp-drawable-height inlayer)))	;layer height

	(width (car(gimp-drawable-width inlayer)))	;layer height
	
	(img (car (gimp-image-new width height RGB)))
	
	(layer (car (gimp-layer-new-from-drawable inlayer img)))

	(layer2) (layer3)

	(offset (/ width framenumber))

	(repeat 1)

	(stroke (car (gimp-vectors-new img "Selection Triangle")))

	(id)

	(name)
)

	;undo group
	;(gimp-image-undo-group-start img)

	(gimp-image-add-layer img layer -1)

	(if (= inpart 0)
	(set! id (car (gimp-vectors-stroke-new-from-points stroke 0 18 #( 0 100 0 100 0 100 50 50 50 50 50 50 0 0 0 0 0 0) TRUE)))
	)
	(if (= inpart 1)
	(set! id (car (gimp-vectors-stroke-new-from-points stroke 0 18 #( 100 100 100 100 100 100 50 50 50 50 50 50 100 0 100 0 100 0) TRUE)))
	)
	(if (= inpart 2)
	(set! id (car (gimp-vectors-stroke-new-from-points stroke 0 18 #( 0 100 0 100 0 100 50 50 50 50 50 50 100 100 100 100 100 100) TRUE)))
	)
	(if (= inpart 3)
	(set! id (car (gimp-vectors-stroke-new-from-points stroke 0 18 #( 0 0 0 0 0 0 50 50 50 50 50 50 100 0 100 0 100 0) TRUE)))
	)

	(gimp-vectors-stroke-scale stroke id (/ width 100) (/ height 100))

	(if (= 1 in)
	(set! in -1) )

	(if (= 0 in)
	(set! in 1) )

	(while (> framenumber 0)
	(begin

	(script-fu-animated-kaleidoscope-duplicate-layer img layer)

	(set! layer2 (car (gimp-image-get-active-layer img)))


		(if (= inpart 0)
		(begin

			(gimp-drawable-offset layer2 TRUE 0 (* (* offset repeat) in) 0)		
			;(gimp-free-select img 6 #( 0 100 50 50 0 0) 2 TRUE FALSE 0)

		) )

		(if (= inpart 1)
		(begin

			(gimp-drawable-offset layer2 TRUE 0 (* (- 0 (* offset repeat)) in) 0)
			;(gimp-free-select img 6 #( 100 100 50 50 100 0) 2 TRUE FALSE 0)
		) )

		(if (= inpart 2)
		(begin

			(gimp-drawable-offset layer2 TRUE 0 0 (* (- 0 (* offset repeat)) in))
			;(gimp-free-select img 6 #( 0 100 50 50 100 100) 2 TRUE FALSE 0)
		) )

		(if (= inpart 3)
		(begin

			(gimp-drawable-offset layer2 TRUE 0 0 (* in (* offset repeat)))
			;(gimp-free-select img 6 #( 0 0 50 50 100 0) 2 TRUE FALSE 0)
		) )

	(gimp-vectors-to-selection stroke 2 TRUE FALSE 0 0)

	(gimp-selection-invert img)

	(gimp-edit-clear layer2)

	(gimp-selection-none img)

	(script-fu-animated-kaleidoscope-duplicate-layer img layer2)

	(set! layer3 (car (gimp-image-get-active-layer img)))

	(gimp-drawable-transform-rotate-simple layer3 1 TRUE 0 0 TRUE)

	(set! layer2 (car (gimp-image-merge-down img layer3 2)))

	(script-fu-animated-kaleidoscope-duplicate-layer img layer2)

	(set! layer3 (car (gimp-image-get-active-layer img)))

	(gimp-drawable-transform-rotate-simple layer3 0 TRUE 0 0 TRUE)

	(gimp-drawable-transform-flip-simple layer3 1 TRUE 0 TRUE)

	(set! layer2 (car (gimp-image-merge-down img layer3 2)))

	(gimp-drawable-set-name layer2 (string-append "Frame " (number->string repeat) " (replace)")
	)

	(set! repeat (+ 1 repeat))

	(set! framenumber (- framenumber 1))

	) )

	(gimp-image-remove-layer img layer)

	(gimp-display-new img)

	;end of undo group
	;(gimp-image-undo-group-end img)

	;Refresh View
	(gimp-displays-flush)

))

(define (script-fu-animated-kaleidoscope-square inimg inlayer framenumber inpart in)

	
     (let*
	(
	(height (car(gimp-drawable-height inlayer)))	;layer height

	(width (car(gimp-drawable-width inlayer)))	;layer height

)
	(if (= width height)
	(script-fu-animated-kaleidoscope inimg inlayer framenumber inpart in) () )

	(if (not (= width height))
	(gimp-message "The drawable must be a square! (Width=Height)") () )
))

(script-fu-register
	"script-fu-animated-kaleidoscope-square"
		"<Image>/Video/Animated FX/Kaleidoscope..."
		"kaleidoscope Animation"
		"LightningIsMyName (LIMN) and fencepost"
		"LightningIsMyName (LIMN)"
		"January, 2008"
		""
		SF-IMAGE	"Image"     0
		SF-DRAWABLE	"Drawable"  0
		SF-ADJUSTMENT	"Number of Frames"	'(10 2 50 1 1 0 1)
		SF-OPTION	"Which Part to Use?"	'("Left Part" "Right Part" "Bottom Part" "Top Part")
		SF-OPTION	"Move In/Out?"	'("In" "Out")
)