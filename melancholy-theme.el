;;; melancholy-theme.el --- A dark theme that's pretty sad  -*- lexical-binding: t -*-

;; Copyleft - do as you please

;; Author: Cooper Oscarfono
;; Maintainer: Cooper Oscarfono
;; Created: 30 August 2022
;; Last Modified: 18 March 2025

;; Version: 2.1
;; Package-Requires: ((emacs "27.1"))

;; Keywords: faces, frames
;; URL: https://github.com/oscarfono/melancholy-theme

;;; Commentary:
;; ========================================
;; A dark theme that’s pretty sad really. Requires Emacs 27.1 or later.
;;
;; Ensure the following fonts are installed before use:
;;
;;    - "Impact Label" (https://www.fontsquirrel.com/fonts/download/impact-label)
;;    - "TeX Live: Source Code Pro" (package: texlive-sourcecodepro)
;;    - "Purisa" (package: fonts-purisa or thai-scalable-purisa-fonts)
;;    - "Dancing Script" (package: fonts-dancingscript)
;;    - "Open Sans Condensed" (package: fonts-opensans or similar)
;;
;; ========================================

;;; Code:
;; ========================================

(deftheme melancholy
  "A dark theme that’s pretty sad really.")

(let ((font-heading "ImpactLabel")
      (font-cursive "Dancingscript")
      (font-default "Purisa")
      (font-mono "SourceCodePro")
      (font-sans "OpenSansCondensed")
      (my-fluff "#FCDEEA")
      (my-active "#F92672")
      (my-visited "#999999")
      (my-info "#FFB728")
      (my-highlight "#96BF33")
      (my-contrast "#666666")
      (my-deepcontrast "#444444")
      (my-hicontrast "#DEDEDE")
      (my-shadow "#333333")
      (my-pop "#00B7FF")
      (my-warning "#FF6969")
      (my-white "#FFFFFF"))

  ;; Theme Faces
  (custom-theme-set-faces
   'melancholy

   ;; Default
   ;; ========================================
   `(default ((t (:family ,font-mono
                  :width normal
                  :weight regular
                  :slant normal
                  :foreground ,my-hicontrast
                  :background ,my-shadow
                  :underline nil
                  :overline nil
                  :strike-through nil
                  :box nil
                  :inverse-video nil
                  :stipple nil))))

   ;; Window and Frame Settings
   ;; ========================================
   `(fringe ((t (:inherit default))))
   `(header-line ((t (:foreground ,my-hicontrast :background ,my-shadow))))
   `(hl-line ((t (:background ,my-contrast))))
   `(menu-bar ((t (:foreground ,my-deepcontrast :background ,my-shadow))))
   `(scroll-bar ((t (:foreground ,my-shadow :background ,my-visited))))
   `(vertical-border ((t (:foreground ,my-contrast))))

   ;; Line Numbers
   ;; ========================================
   `(linum ((t (:foreground ,my-deepcontrast))))
   `(line-number ((t (:foreground ,my-deepcontrast))))
   `(line-number-current-line ((t (:foreground ,my-highlight))))

   ;; Base Settings
   ;; ========================================
   `(cursor ((t (:background ,my-hicontrast))))
   `(region ((t (:background ,my-deepcontrast :foreground unspecified))))  ; Fixed: inherit -> unspecified
   `(query-replace ((t (:inherit isearch))))
   `(match ((t (:background ,my-pop))))
   `(highlight ((t (:foreground ,my-pop :background ,my-contrast))))
   `(lazy-highlight ((t (:foreground ,my-shadow :background ,my-highlight))))
   `(fixed-pitch ((t (:family ,font-mono))))
   `(variable-pitch ((t (:family ,font-sans :height 99 :weight normal))))
   `(bold ((t (:weight bold))))
   `(italic ((t (:slant italic))))
   `(bold-italic ((t (:weight bold :slant italic))))
   `(shadow ((t (:background ,my-shadow))))
   `(button ((t (:foreground ,my-active :underline (:color foreground-color :style line)))))
   `(link ((t (:foreground ,my-active :underline t :weight bold))))
   `(link-visited ((t (:foreground ,my-visited))))
   `(secondary-selection ((t (:background ,my-fluff))))
   `(font-lock-builtin-face ((t (:family ,font-mono :foreground ,my-pop))))
   `(font-lock-comment-delimiter-face ((t (:family ,
