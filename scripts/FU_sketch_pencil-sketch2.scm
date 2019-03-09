; FU_contrast_change-contrast.scm
; version 1.0 [gimphelp.org]
; last modified/tested by Paul Sherman
; 09/29/2015 on GIMP-2.8.14
;
; added a couple tweeks to punch up contrast a bit....
;==============================================================
;
; Installation:
; This script should be placed in the user or system-wide script folder.
;
;	Windows Vista/7/8)
;	C:\Program Files\GIMP 2\share\gimp\2.0\scripts
;	or
;	C:\Users\YOUR-NAME\.gimp-2.8\scripts
;	
;	Windows XP
;	C:\Program Files\GIMP 2\share\gimp\2.0\scripts
;	or
;	C:\Documents and Settings\yourname\.gimp-2.8\scripts   
;    
;	Linux
;	/home/yourname/.gimp-2.8/scripts  
;	or
;	Linux system-wide
;	/usr/share/gimp/2.0/scripts
;
;==============================================================
;
; LICENSE
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;==============================================================
; Original information 
;
; script by Lukas Stahl
;==============================================================

(define (FU-pencil-sketch2 sfImage
                                  sfDrawable
                                  sfBlurRadius
                                  sfStrength
                                  sfMergeLayers)
    (let* (
            (varActiveLayer
                (car
                    (gimp-layer-copy sfDrawable
                                     FALSE) ; Don't add an alpha channel to the layer
                )
            )
            (varCounter 1)
          )

        (gimp-context-push)
        (gimp-image-undo-group-start sfImage)

        (gimp-image-add-layer sfImage
                              varActiveLayer
                              -1 ; Layer position
        )

        (gimp-hue-saturation varActiveLayer
                             0 ; Range of affected hues 0 = ALL-HUES
                             0 ; Hue offset in degrees
                             0 ; Lightness modification
                             -100) ; Saturation modification

        (set! varActiveLayer
            (car
                (gimp-layer-copy varActiveLayer
                                 FALSE)
            )
        )

        (gimp-image-add-layer sfImage
                              varActiveLayer
                              -1)

        (plug-in-gauss-rle2 1 ; non-interactive
                            sfImage
                            varActiveLayer
                            sfBlurRadius ; horizontal radius of gaussian blur
                            sfBlurRadius) ; vertical radius of gaussian blur

        (gimp-invert varActiveLayer)

        (gimp-layer-set-opacity varActiveLayer
                                50) ; opacity

        (set! varActiveLayer
            (car
                (gimp-image-merge-down sfImage
                                       varActiveLayer
                                       0) ; merge-type 0 = EXPAND-AS-NECESSARY
            )
        )

        (set! varActiveLayer
            (car
                (gimp-layer-copy varActiveLayer
                                 FALSE)
            )
        )

        (gimp-image-add-layer sfImage
                              varActiveLayer
                              -1)

        (gimp-layer-set-mode varActiveLayer
                             16) ; 16 = DODGE-MODE

        (set! varActiveLayer
            (car
                (gimp-image-merge-down sfImage
                                       varActiveLayer
                                       0)
            )
        )


		(gimp-curves-spline varActiveLayer HISTOGRAM-VALUE 4 #(140 0 255 240))
		(plug-in-unsharp-mask 1 sfImage varActiveLayer 4 1.0 0)


        (while (< varCounter sfStrength)
            (set! varActiveLayer
                (car
                    (gimp-layer-copy varActiveLayer
                                     FALSE)
                )
            )

            (gimp-image-add-layer sfImage
                                  varActiveLayer
                                  -1)

           (gimp-layer-set-mode varActiveLayer
                                3) ; 3 = MULTIPLY-MODE)

            (set! varCounter
                (+ varCounter 1)
            )
        )





        (when (= sfMergeLayers TRUE)

            (set! varCounter 2)

            (while (< varCounter sfStrength)
                (set! varActiveLayer
                    (car
                        (gimp-image-merge-down sfImage
                                               varActiveLayer
                                               0)
                    )
                )

                (gimp-layer-set-mode varActiveLayer
                                     3) ; 3 = MULTIPLY-MODE)

                (set! varCounter
                    (+ varCounter 1)
                )
            )
        )
    )
    (gimp-context-pop)
    (gimp-displays-flush)
    (gimp-image-undo-group-end sfImage)
)

(script-fu-register "FU-pencil-sketch2"
    "<Image>/Script-Fu/Sketch/Pencil Sketch 2"
    "Generate a pencil drawing from a photo."
    "Lukas Stahl"
    "Copyright 2009, Lukas Stahl based on an tutorial from gimpusers.de"
    "04.01.2010"
    "*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-ADJUSTMENT "Blur Radius" '(4 0 5120 1 10 0 1)
    SF-ADJUSTMENT "Strength" '(1 1 50 1 10 0 0)
    SF-TOGGLE "Merge Layers" TRUE
)
