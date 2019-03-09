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
; Makes a copy of your image and creates an animated rain effect of the active layer
; as seen in my tutorial here: http://fence-post.deviantart.com/art/Gimp-Animated-Rain-35843590
; The animation may be saved with the gif-plug-in.
;
; 1/22/08: Added option to create a border for each frame. Using a the specified border width
; and color.  Border can be up to 3 pixels wide.
;
; Script updated on October 3, 2008 to work in GIMP 2.6
;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sept 2009 modificated the script register path for a better integration 
;;  with GAP now the script is in <Image>Video/Animated FX/Rain
;;  PhotoComix  photocomix@gmail.com
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Define the Function

(define (script-fu-rain-anim 	img		 
				drawable
				num-frames
				rain-amt
				blur-length
				blur-angle
				speed
				add-border
				border-width
				border-color				
				)

; Declare the Variables

	(let* (
		    (rain-layer 0)
		    (num-frames (max 1 num-frames))
		    (remaining-frames num-frames)
		    (newImage (car (gimp-image-duplicate img)))
		    (source-layer (car (gimp-image-get-active-layer newImage))) ; The original image (the animation will be based on
		    (center-x (/ (car (gimp-image-width newImage)) 2)) ; Gets the center of the image width for use in the motion blur plugin
		    (center-y (/ (car (gimp-image-height newImage)) 2)) ; Gets the center of the image height for use in the motion blur plugin
                (border-layer 0)		

            )
  (gimp-context-push)

  (gimp-image-undo-disable newImage)
  
  ; ****************************************************************************
  ; Creates a loop so that the operation will continue as long as the
  ; remaining-frames variable is greater than 0
  ; ****************************************************************************
  
  (while (> remaining-frames 0)
	
	  (let* (
	          (base-layer (car (gimp-layer-copy source-layer TRUE))) ; Sets the base layer to be a copy of the original image
	          (rain-layer (car (gimp-layer-copy source-layer TRUE))) ; Sets the rain-layer to be a copy of the original image
                  (layer-name (string-append "Frame " (number->string (- (+ num-frames 1)remaining-frames)) " (" (number->string speed) "ms)" " (replace)"))
	        )

    (gimp-image-add-layer newImage base-layer -1) ; Adds the base-layer to the new image
    (gimp-drawable-set-name base-layer layer-name) ; Sets the name of the base layer
    (gimp-image-add-layer newImage rain-layer -1) ; Adds the rain layer to the new image
    (gimp-drawable-fill rain-layer WHITE-FILL) ; fills rain layer with white

; ******************************************************************************
; Adds "rain" to the rain layer via the rgb-noise plugin.  The noise amounts were
; specified by the user in the pop-up window when the script was first run
; ******************************************************************************

    (plug-in-rgb-noise  RUN-NONINTERACTIVE
                        newImage
                        rain-layer
                        0
                        0
                        rain-amt
		        	rain-amt
                        rain-amt
                        0)

; ******************************************************************************
; Blurs the "rain" on the rain layer via the motion blur plugin.  The blur length
; and angle were specified by the user in the pop-up window when the script was first run.
; ******************************************************************************

    (plug-in-mblur RUN-NONINTERACTIVE
			 newImage
			 rain-layer
			 LINEAR
			 blur-length
			 blur-angle
			 center-x
			 center-y)

; Sets the rain layer blend mode to multiply

    (gimp-layer-set-mode rain-layer MULTIPLY-MODE)

; Merges the rain layer with the base layer below it

    (gimp-image-merge-down newImage rain-layer CLIP-TO-IMAGE)


; Adds a border layer if chosen by the user with the values set

(if (= add-border TRUE)
    (begin
    (set! border-layer (car (gimp-layer-copy source-layer TRUE)))
    (gimp-image-add-layer newImage border-layer -1)
    (gimp-selection-all newImage)
    (gimp-context-set-foreground border-color)
    (gimp-drawable-fill border-layer FOREGROUND-FILL)
    (gimp-selection-shrink newImage border-width)
    (gimp-edit-clear border-layer)
    (gimp-selection-none newImage)
    (gimp-image-merge-down newImage border-layer CLIP-TO-IMAGE) 
    )
)

; Reduces the remaining frames variable by 1  

    (set! remaining-frames (- remaining-frames 1))
    )
  )

; Removes the original layer from the stack because it's no longer needed  
  
  (gimp-image-remove-layer newImage source-layer) 

 
  (gimp-image-undo-enable newImage)

  (gimp-context-pop)

; Displays the final animation

  (gimp-display-new newImage)
  )
)

(script-fu-register "script-fu-rain-anim"
  "<Image>/Video/Animated FX/Animated Rain..."
  "Creates a multi-layer image with a rain effect"
  "Art Wade"
  "Art Wade"
  "October 3, 2006"
  "RGB* GRAY*"
  SF-IMAGE       	"Image" 0				; first required parameter for operating on an open image
  SF-DRAWABLE    	"Drawable" 0				; second required parameter for operating on an open image
  SF-ADJUSTMENT 	"Number of frames" '(3 1 10 1 10 0 1)	; user selects the number of frames the animation will have
  SF-ADJUSTMENT 	"Amount of rain" '(.5 .1 1 .1 .2 1 1)	; user selects the amount of "rain" each frame will have
  SF-ADJUSTMENT 	"Blur length" '(10 5 256 1 10 0 1) 	; user selects how length of blur applied to each raindrop
  SF-ADJUSTMENT 	"Blur angle" '(135 45 135 1 10 0 1)	; user selects the angle of the rain
  SF-ADJUSTMENT 	"Speed" '(100 10 500 1 1 0 1)		; users selects how fast the animation will play
  SF-TOGGLE       "Add Border?" TRUE
  SF-ADJUSTMENT   "Border Width" '(1 1 3 1 1 0 1)
  SF-COLOR        "Border Color" '(0 0 0)
)


                         
