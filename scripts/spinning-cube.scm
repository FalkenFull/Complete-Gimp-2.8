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
; This script is a modification of GIMP's default spinning-globe script.
; One of the modifications I've added is the ability to scale the cube
; and adjust the speed of the animation.
;
; Updated on October 3, 2008 to work in GIMP 2.6
;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  sept 2009 modificated the script register path for a better integration 
;;  with GAP now the script is in <Image>Video/Animated FX/Spinning Cube
;;  PhotoComix  photocomix@gmail.com
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Define the function:

(define (script-fu-spinning-cube inImage
                                  inLayer
                                  inFrames
                                  inFromLeft
                                  inTransparent
                                  inIndex
                                  inSize
					    inCopy
					    inSpeed)
  (let* (
        (theImage (if (= inCopy TRUE)
                      (car (gimp-image-duplicate inImage))
                      inImage))
        (theLayer (car (gimp-image-get-active-layer theImage)))
        (n 0)
        (ang (* (/ 360 inFrames)
                (if (= inFromLeft TRUE) 1 -1) ))
        (theFrame 0)
        )

; Begin Undo Group

  (gimp-undo-push-group-start inImage)  

  (gimp-layer-add-alpha theLayer)

  (while (> inFrames n)
    (set! n (+ n 1))
    (set! theFrame (car (gimp-layer-copy theLayer FALSE)))
    (gimp-image-add-layer theImage theFrame 0)
    (gimp-drawable-set-name theFrame  (string-append "Anim Frame: " (number->string (- inFrames n)) 
						  " (" (number->string inSpeed) "ms)" 
						  " (replace)"))

    (plug-in-map-object RUN-NONINTERACTIVE
                        theImage theFrame    
                        2                    ; mapping
                        0.5 0.5 2.0          ; viewpoint
                        0.5 0.5 0.0          ; object pos
                        1.0 0.0 0.0          ; first axis
                        0.0 1.0 0.0          ; 2nd axis
                        30.0 (* n ang) 0.0     ; axis rotation
                        0 '(255 255 255)     ; light (type, color)
                        -0.5 -0.5 2.0        ; light position
                        -1.0 -1.0 1.0        ; light direction
                        0.3 1.0 0.5 0.0 27.0 ; material (amb, diff, refl, spec, high)
                        TRUE                 ; antialias
                        FALSE                ; tile
                        FALSE                ; new image
                        inTransparent        ; transparency
                        0                    ; radius
                        inSize inSize inSize ; box size (x,y,z)
				0			   ; cylinder length
                        theFrame theFrame theFrame theFrame theFrame theFrame ; box faces 1-6
				-1 -1			   ; cylinder top/bottom faces				
    )
  )

  (gimp-image-remove-layer theImage theLayer)
  ;(plug-in-autocrop RUN-NONINTERACTIVE theImage theFrame)

  (if (= inIndex 0)
      ()
      (gimp-image-convert-indexed theImage FS-DITHER MAKE-PALETTE inIndex
                                  FALSE FALSE ""))

  (if (= inCopy TRUE)
    (begin
      (gimp-image-clean-all theImage)
      (gimp-display-new theImage)
    )
  )

; End Undo Group

  (gimp-undo-push-group-end theImage)
  
  (gimp-displays-flush)
  )
)

(script-fu-register
  "script-fu-spinning-cube"
  "<Image>/Video/Animated FX/Layer to Spinning Cube..."
  "Create an animation by mapping the current image onto a spinning cube"
  "Art Wade"
  "Art Wade 2008"
  "October 3, 2008"
  "RGB* GRAY*"
  SF-IMAGE       "The Image"               0
  SF-DRAWABLE    "The Layer"               0
  SF-ADJUSTMENT  "Frames"                  '(10 3 20 1 10 0 1)
  SF-TOGGLE      "Turn from left to right" FALSE
  SF-TOGGLE      "Transparent background"  TRUE
  SF-ADJUSTMENT  "Index to n colors (0 = remain RGB)" '(0 0 256 1 10 0 1)
  SF-ADJUSTMENT  "Cube Size"			 '(0.5 0.1 0.6 0.1 0.1 1 1)
  SF-TOGGLE      "Work on copy"            FALSE
  SF-ADJUSTMENT  "Animation Speed"    	'(100 40 200 1 1 0 1)
)

                         
