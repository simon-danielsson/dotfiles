(require 'autothemer)

(autothemer-deftheme
 dimma "Simon's nice and soothing colorscheme"

 ((((class color) (min-colors #xFFFFFF)))

  ;; palette
  (fg  "#aab3c0")
  (fg2 "#6e6e87")
  (mg  "#40404f")
  (bg  "#2a2a33")
  (bg2 "#25252d")
  (acc "#6087AE"))

 ;; faces
 ((default                   (:foreground fg :background bg2))
  (cursor                    (:background fg))
  (hl-line                    (:background bg))
  (region                    (:background mg))
  (mode-line                 (:foreground fg :background bg))
  (mode-line-inactive        (:foreground mg :background bg))
  (line-number               (:background bg2 :foreground mg))
  (line-number-current-line  (:background bg :foreground fg))
  (fill-column-indicator  (:background bg :foreground bg))
  (org-level-1               (:foreground acc))))

    (provide-theme 'dimma)

