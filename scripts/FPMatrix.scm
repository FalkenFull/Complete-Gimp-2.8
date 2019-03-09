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
; Creates a "matrix-style" background using the steps described here:
; based on the tutorial here:
; http://www.gimpdome.com/index.php?topic=7042
; Script updated on October 3, 2008 to work in GIMP 2.6
;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sept 2009 changed register path for a better integration 
;;  with GAP now the script is in <Image>Video/Animated FX/Matrix
;;  PhotoComix  photocomix@gmail.com
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (script-fu-fp-matrix image drawable color)

(let* 	(
	(width (car (gimp-image-width image)))
	(height (car (gimp-image-height image)))
	(backgroundLayer 0)
	(backgroundCopyLayer 0)
	(colorLayer 0)
	)

; Set up the script so that user settings in place priot to the script can be reset after the script is run

(gimp-context-push)

; Begin Undo Group

(gimp-undo-push-group-start image)

; Create the backgroundLayer based on the current image dimensions and add it to the image

(set! backgroundLayer (car (gimp-layer-new image width height RGBA-IMAGE "Matrix Layer" 100 NORMAL-MODE)))
(gimp-image-add-layer image backgroundLayer -1)

; Set the foreground color and fill the backgroundLayer with it

(gimp-context-set-foreground color)
(gimp-drawable-fill backgroundLayer WHITE-FILL)



(plug-in-rgb-noise RUN-NONINTERACTIVE image backgroundLayer 0 0 0.2 0.2 0.2 0)
(plug-in-displace RUN-NONINTERACTIVE image backgroundLayer 10 height TRUE TRUE backgroundLayer backgroundLayer 2)
(plug-in-dilate RUN-NONINTERACTIVE image backgroundLayer 0 2 1.0 0 0 255)
(plug-in-edge RUN-NONINTERACTIVE image backgroundLayer 3.7 0 1)
(set! backgroundCopyLayer (car (gimp-layer-copy backgroundLayer TRUE)))
(gimp-image-add-layer image backgroundCopyLayer -1)
(script-fu-tile-blur image backgroundCopyLayer 3.0 TRUE TRUE 0)
(gimp-layer-set-mode backgroundCopyLayer ADDITION-MODE)
(gimp-image-merge-down image backgroundCopyLayer CLIP-TO-IMAGE)
(set! backgroundLayer (car (gimp-image-get-active-layer image)))
(set! colorLayer (car (gimp-layer-copy backgroundLayer TRUE)))
(gimp-image-add-layer image colorLayer -1)
(gimp-drawable-fill colorLayer FOREGROUND-FILL)
(gimp-layer-set-mode colorLayer MULTIPLY-MODE)
(gimp-image-merge-down image colorLayer CLIP-TO-IMAGE)






; End Undo Group

(gimp-undo-push-group-end image)

; Refresh the GIMP Display

(gimp-displays-flush)

; Resets previous user settings 

(gimp-context-pop)


)
)


(script-fu-register "script-fu-fp-matrix"
            	"<Image>/Video/Animated FX/Matrix..."
            	"Create a matrix-style effect."
            	"Art Wade"    
            	"Art Wade"    
            	"October 3, 2008"
            	"RGB*"            
		SF-IMAGE 	"Image" 		0
    		SF-DRAWABLE 	"Drawable" 		0
		SF-COLOR	"Matrix Color"	'(0 255 36)

)
