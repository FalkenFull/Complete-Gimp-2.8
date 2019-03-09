; GIMP - The GNU Image Manipulation Program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
;
; 
; Creates a "melting" animation of the active layer in an image as described in my tutorial here:
;
; http://www.gimpdome.com/index.php?topic=3154.0
; The animation may be saved with the gif-plug-in.
;
; The script can be found under Filters > Animation > Melt Me...
;
; Script updated on October 3, 2008 to work with GIMP 2.6
 ;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sept 2009 Changed the script register path for a better integration 
;;  with GAP now the script is in <Image>Video/Animated FX
;;  PhotoComix  photocomix@gmail.com
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Define the Function

(define (script-fu-melt-me-anim 	img		 
				drawable
				counter
				inSpeed
				pause1
				pause2
				addBorder
				borderWidth
				borderColor				
				blendOpt
				)

; Declare the Variables

	(let* (
		    	(speed 0)
			(width 0)
			(height 0)	
			(theSelection 0)
			(newImage 0)		    
			(activeLayer 0)
			(activeLayerCopy 0)
			(activeLayerHolder 0)
			(floatingSelection 0)
			(borderBlendMode
				(cond 
				(( equal? blendOpt 0 ) NORMAL-MODE)
				(( equal? blendOpt 1 ) DISSOLVE-MODE)
				(( equal? blendOpt 2 ) MULTIPLY-MODE)
				(( equal? blendOpt 3 ) DIVIDE-MODE)
				(( equal? blendOpt 4 ) SCREEN-MODE)
				(( equal? blendOpt 5 ) OVERLAY-MODE)
				(( equal? blendOpt 6 ) DODGE-MODE)
				(( equal? blendOpt 7 ) BURN-MODE)
				(( equal? blendOpt 8 ) HARDLIGHT-MODE)
				(( equal? blendOpt 9 ) SOFTLIGHT-MODE)
				(( equal? blendOpt 10 ) GRAIN-EXTRACT-MODE)
				(( equal? blendOpt 11 ) GRAIN-MERGE-MODE)
				(( equal? blendOpt 12 ) DIFFERENCE-MODE)
				(( equal? blendOpt 13 ) ADDITION-MODE)
				(( equal? blendOpt 14 ) SUBTRACT-MODE)
				(( equal? blendOpt 15 ) DARKEN-ONLY-MODE)
				(( equal? blendOpt 16 ) LIGHTEN-ONLY-MODE)
				(( equal? blendOpt 17 ) HUE-MODE)
				(( equal? blendOpt 18 ) SATURATION-MODE)
				(( equal? blendOpt 19 ) COLOR-MODE)
				(( equal? blendOpt 20 ) VALUE-MODE)
				)	
			)
			(displaceLayer 0)
		    	(displaceLayerCopy 0)
			(layerName 0)
		    	(remainingFrames counter 0)
			(transparentLayer 0)
			(offset 0)
			(step 0)
			(frameNum 1)
	            	(borderLayer 0)
			(totalFrames counter)
		)

(gimp-context-push)


(set! activeLayer (car (gimp-image-get-active-layer img)))
(set! theSelection (car (gimp-selection-save img)))
(gimp-selection-none img)
(set! width (car (gimp-drawable-width activeLayer)))
(set! height (car (gimp-drawable-height activeLayer)))
(set! activeLayer (car (gimp-edit-copy activeLayer)))
(set! newImage (car (gimp-image-new width height RGB)))
(gimp-image-undo-disable newImage)
(set! activeLayerHolder (car (gimp-layer-new newImage width height RGBA-IMAGE 	"Active Layer" 100 NORMAL-MODE)))
(gimp-drawable-fill activeLayerHolder TRANSPARENT-FILL)	
(gimp-image-add-layer newImage activeLayerHolder -1)
(set! floatingSelection (car (gimp-edit-paste activeLayerHolder TRUE))) 	
(gimp-floating-sel-anchor floatingSelection)	
(set! activeLayer (car (gimp-image-get-active-layer newImage)))
(set! displaceLayer (car (gimp-layer-new newImage width height RGBA-IMAGE "Displace Layer" 100 NORMAL-MODE)))
(gimp-image-add-layer newImage displaceLayer -1) 
(plug-in-solid-noise RUN-NONINTERACTIVE newImage displaceLayer 0 0 (rand) (rand) 4.0 4.0)
(set! displaceLayerCopy (car (gimp-layer-copy displaceLayer TRUE)))
(gimp-image-add-layer newImage displaceLayerCopy -1)
(plug-in-solid-noise RUN-NONINTERACTIVE newImage displaceLayerCopy 0 0 (rand) (rand) 4.0 4.0)
(gimp-layer-set-mode displaceLayerCopy SCREEN-MODE)
(gimp-image-merge-down newImage displaceLayerCopy CLIP-TO-IMAGE)
(set! displaceLayer (car (gimp-image-get-active-layer newImage)))
(gimp-brightness-contrast displaceLayer 0 10)


(set! offset (* 2 height))
(set! step (/ (* 4 height) counter))

(while (> counter 0)

(set! speed inSpeed)	

(if (= frameNum 1)
    (begin
    (set! speed pause1)
    (set! transparentLayer (car (gimp-layer-copy activeLayer TRUE)))
    (gimp-image-add-layer newImage transparentLayer -1)
    (gimp-drawable-fill transparentLayer TRANSPARENT-FILL)	
    (set! layerName (string-append "Frame " (number->string frameNum) " (" (number->string speed) "ms)" " (replace)"))
    (gimp-drawable-set-name transparentLayer layerName)
    (set! frameNum (+ frameNum 1))
    (set! speed inSpeed)
	
	(if (= addBorder TRUE)
    	    (begin
    	    (set! borderLayer (car (gimp-layer-copy activeLayer TRUE)))
	    (gimp-image-add-layer newImage borderLayer -1)
	    (gimp-selection-all newImage)
	    (gimp-context-set-foreground borderColor)
	    (gimp-drawable-fill borderLayer FOREGROUND-FILL)
	    (gimp-selection-shrink newImage borderWidth)
	    (gimp-edit-clear borderLayer)
	    (gimp-layer-set-mode borderLayer borderBlendMode)
	    (gimp-selection-none newImage)
	    (gimp-image-merge-down newImage borderLayer CLIP-TO-IMAGE) 
	    )
	)
    )
)

(if (= frameNum (trunc (/ totalFrames 2)))
    (begin
    (set! speed pause2)
    (set! offset 0)
    (set! counter (- counter 1))
    )
)


(set! activeLayerCopy (car (gimp-layer-copy activeLayer TRUE)))
(gimp-image-add-layer newImage activeLayerCopy -1)

(if (= frameNum 1)
(plug-in-displace RUN-NONINTERACTIVE newImage activeLayerCopy 0 0 0 0  displaceLayer displaceLayer 3)
)

(plug-in-displace RUN-NONINTERACTIVE newImage activeLayerCopy 0 offset 0 1  displaceLayer displaceLayer 3)


(set! layerName (string-append "Frame " (number->string frameNum) " (" (number->string speed) "ms)" " (replace)"))
(gimp-drawable-set-name activeLayerCopy layerName)

(set! speed inSpeed)
(set! offset (- offset step))
(set! frameNum (+ frameNum 1))
(set! counter (- counter 1))



; Adds a border layer if chosen by the user with the values set

(if (= addBorder TRUE)
    (begin
    (set! borderLayer (car (gimp-layer-copy activeLayer TRUE)))
    (gimp-image-add-layer newImage borderLayer -1)
    (gimp-selection-all newImage)
    (gimp-context-set-foreground borderColor)
    (gimp-drawable-fill borderLayer FOREGROUND-FILL)
    (gimp-selection-shrink newImage borderWidth)
    (gimp-edit-clear borderLayer)
    (gimp-layer-set-mode borderLayer borderBlendMode)
    (gimp-selection-none newImage)
    (gimp-image-merge-down newImage borderLayer CLIP-TO-IMAGE) 
    )
)

) ; goes with while

; Removes the original layer from the stack because it's no longer needed  
  
(gimp-image-remove-layer newImage activeLayer) 
(gimp-image-remove-layer newImage displaceLayer) 
(gimp-image-undo-enable newImage)

(gimp-selection-load theSelection)
(gimp-image-remove-channel img theSelection)

(gimp-context-pop)

(gimp-displays-flush)

; Displays the final animation

(gimp-display-new newImage)
(gimp-image-set-active-layer img drawable)

  )
)

(script-fu-register "script-fu-melt-me-anim"
  "<Image>/Video/Animated FX/Melt..."
  "Create an animated melt effect"
  "Art Wade"
  "Art Wade"
  "October 3, 20082008"
  "RGB*"
  SF-IMAGE       	"Image" 0
  SF-DRAWABLE    	"Drawable" 0
  SF-ADJUSTMENT 	"Number of frames" '(50 15 50 1 10 0 1)
  SF-ADJUSTMENT 	"Animation Speed (in ms)" '(100 10 500 1 1 0 1)
  SF-ADJUSTMENT	  	"First Frame Delay Time (in ms)" '(2000 10 20000 1 1 0 1)
  SF-ADJUSTMENT	  	"Middle Frame Delay Time (in ms)" '(2000 10 20000 1 1 0 1)
  SF-TOGGLE       	"Add Border?" FALSE
  SF-ADJUSTMENT   	"Border Width" '(1 1 3 1 1 0 1)
  SF-COLOR        	"Border Color" '(255 255 255)  
  SF-OPTION		"Border Blend Mode" 		'("NORMAL-MODE" 
							"DISSOLVE-MODE"
							"MULTIPLY-MODE"
							"DIVIDE-MODE"
							"SCREEN-MODE"
							"OVERLAY-MODE"
							"DODGE-MODE"
							"BURN-MODE"
							"HARDLIGHT-MODE"
							"SOFTLIGHT-MODE"
							"GRAIN-EXTRACT-MODE"
							"GRAIN-MERGE-MODE"														"DIFFERENCE-MODE"
							"ADDITION-MODE"
							"SUBTRACT-MODE"
							"DARKEN-ONLY-MODE"
							"LIGHTEN-ONLY-MODE"
							"HUE-MODE"
							"SATURATION-MODE"
							"COLOR-MODE"
							"VALUE-MODE")
)


                         
