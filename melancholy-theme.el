;;; melancholy-theme.el --- A dark theme that's pretty sad  -*- lexical-binding: t -*-

;; Copyleft - do as you please

;; Author: Cooper Oscarfono
;; Maintainer: Cooper Oscarfono
;; Created: 30 August 2022
;; Last Modified: 13 March 2026

;; Version: 4.1
;; Package-Requires: ((emacs "27.1"))

;; Keywords: faces, frames
;; URL: https://github.com/oscarfono/melancholy-theme

;;; Commentary:
;; ========================================
;; A dark theme that's pretty sad really.  Requires Emacs 27.1 or later.
;;
;; Ensure the following fonts are installed before use:
;;
;;    - CommitMono Nerd Font Mono (installed as Nerd Font variant)
;;    - Caveat (https://fonts.googleapis.com/css2?family=Caveat)
;;    - Raleway (nix packages)
;;
;; Font families are specified without weight/style suffixes (e.g. "CommitMono"
;; not "CommitMono-Regular").  Emacs resolves weight and slant via face
;; attributes, not the family string.  Using suffixed names causes silent
;; font lookup failures on most systems.
;;
;; Changelog v4.1:
;;   - Added tree-sitter faces for JS/TS, Bash, Python, Go, Zig, Rust, C/C++
;;   - Added language-specific package faces: js2, typescript-mode, go-mode,
;;     rust-mode/rustic, zig-mode, python-mode
;;   - Added lsp-mode and eglot faces for inline diagnostics and highlights
;;
;; Changelog v4.0:
;;   - Adjusted palette: deeper background, lifted mid-tones for WCAG AA contrast
;;   - Fixed org-block foreground (was blue, now inherits default for correct
;;     font-lock colours inside source blocks)
;;   - Toned down font-lock-string-face (was #FFFFFF, visually dominated keywords)
;;   - Added mode-line and mode-line-inactive (were missing entirely)
;;   - Added Emacs 29 font-lock faces: bracket, punctuation, operator, property
;;   - Added completion framework faces: vertico, corfu, marginalia, orderless
;;   - Added which-key, rainbow-delimiters, diff-hl, consult faces
;;   - Added tab-bar faces
;;   - Added window-divider faces
;;   - Added fill-column-indicator
;;   - Added eldoc-highlight-function-argument
;;   - Added basic TTY colour mappings for terminal (-nw) use
;;   - Made org-level-1 foreground explicit
;;   - Removed oversized helm-source-header height (1.9 → 1.3)
;; ========================================

;;; Code:
;; ========================================

(deftheme melancholy
  "A dark theme that's pretty sad really.")

(let ((font-mono    "CommitMono Nerd Font Mono")
      (font-sans    "Raleway")
      (font-cursive "Caveat")

      ;; Palette
      ;; my-shadow is the base background. Slightly deeper than v3 to improve
      ;; contrast ratios across the board.
      (my-fluff        "#FCDEEA")
      (my-active       "#F92672")
      (my-visited      "#999999")
      (my-info         "#FFB728")
      (my-highlight    "#96BF33")
      (my-contrast     "#707070")   ;; lifted from #666666 — improves subtle text legibility
      (my-deepcontrast "#4A4A4A")   ;; lifted from #444444 — region bg now visible
      (my-hicontrast   "#DEDEDE")
      (my-shadow       "#2A2A2A")   ;; deepened from #333333 — better contrast base
      (my-pop          "#00B7FF")
      (my-warning      "#FF6969")
      (my-white        "#E8E8E8")   ;; softened from #FFFFFF — strings no longer dominate
      (my-black        "#000000"))

  (custom-theme-set-faces
   'melancholy

   ;; ============================================================
   ;; Default
   ;; ============================================================
   `(default ((((type graphic))
               (:family ,font-mono
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
                :stipple nil))
              (((type tty))
               (:foreground "white" :background "black"))))

   ;; fixed-pitch and variable-pitch are the two roots mixed-pitch-mode
   ;; uses to split mono vs proportional faces in org buffers.
   `(fixed-pitch    ((t (:family ,font-mono :weight regular :slant normal))))
   `(variable-pitch ((t (:family ,font-sans  :weight normal  :slant normal))))

   ;; ============================================================
   ;; Window and Frame
   ;; ============================================================
   `(fringe          ((t (:inherit default))))
   `(header-line     ((t (:foreground ,my-hicontrast :background ,my-shadow))))
   `(hl-line         ((t (:background ,my-deepcontrast :extend t))))
   `(menu            ((t (:foreground ,my-hicontrast :background ,my-shadow))))
   `(scroll-bar      ((t (:foreground ,my-shadow :background ,my-visited))))
   `(vertical-border ((t (:foreground ,my-contrast))))

   ;; Window dividers (used when window-divider-mode is active)
   `(window-divider              ((t (:foreground ,my-deepcontrast))))
   `(window-divider-first-pixel  ((t (:foreground ,my-contrast))))
   `(window-divider-last-pixel   ((t (:foreground ,my-deepcontrast))))

   ;; Fill column indicator (display-fill-column-indicator-mode)
   `(fill-column-indicator ((t (:foreground ,my-deepcontrast))))

   ;; ============================================================
   ;; Mode Line
   ;; ============================================================
   `(mode-line ((((type graphic))
                 (:foreground ,my-hicontrast
                  :background ,my-deepcontrast
                  :box (:line-width 1 :color ,my-contrast)))
                (((type tty))
                 (:foreground "white" :background "brightblack" :inverse-video nil))))
   `(mode-line-inactive ((((type graphic))
                           (:foreground ,my-contrast
                            :background ,my-shadow
                            :box (:line-width 1 :color ,my-deepcontrast)))
                          (((type tty))
                           (:foreground "brightblack" :background "black"))))
   `(mode-line-buffer-id  ((t (:foreground ,my-pop :weight bold))))
   `(mode-line-emphasis   ((t (:foreground ,my-highlight :weight bold))))
   `(mode-line-highlight  ((t (:foreground ,my-info))))

   ;; ============================================================
   ;; Tab Bar
   ;; ============================================================
   `(tab-bar              ((t (:background ,my-shadow :foreground ,my-contrast))))
   `(tab-bar-tab          ((t (:background ,my-deepcontrast :foreground ,my-hicontrast
                               :box (:line-width 1 :color ,my-contrast)))))
   `(tab-bar-tab-inactive ((t (:background ,my-shadow :foreground ,my-contrast
                               :box (:line-width 1 :color ,my-deepcontrast)))))

   ;; ============================================================
   ;; Line Numbers
   ;; ============================================================
   `(line-number              ((t (:foreground ,my-contrast))))
   `(line-number-current-line ((t (:foreground ,my-highlight))))

   ;; ============================================================
   ;; Base
   ;; ============================================================
   `(cursor              ((t (:background ,my-hicontrast))))
   `(region              ((t (:background ,my-deepcontrast :extend t))))
   `(query-replace       ((t (:inherit isearch))))
   `(match               ((t (:background ,my-pop :foreground ,my-black))))
   `(highlight           ((t (:foreground ,my-pop :background ,my-contrast))))
   `(lazy-highlight      ((t (:foreground ,my-shadow :background ,my-highlight))))
   `(bold                ((t (:weight bold))))
   `(italic              ((t (:slant italic))))
   `(bold-italic         ((t (:weight bold :slant italic))))
   `(shadow              ((t (:foreground ,my-contrast))))
   `(button              ((t (:foreground ,my-active :underline (:color foreground-color :style line)))))
   `(link                ((t (:foreground ,my-active :underline t :weight bold))))
   `(link-visited        ((t (:foreground ,my-visited))))
   `(secondary-selection ((t (:background ,my-fluff))))
   `(tooltip             ((t (:foreground ,my-shadow :background ,my-info))))
   `(trailing-whitespace ((t (:background ,my-warning))))

   ;; ============================================================
   ;; Font Lock — core
   ;; ============================================================
   `(font-lock-builtin-face              ((t (:foreground ,my-pop))))
   `(font-lock-comment-delimiter-face    ((t (:foreground ,my-contrast))))
   `(font-lock-comment-face              ((t (:foreground ,my-contrast :slant italic))))
   `(font-lock-constant-face             ((t (:foreground ,my-info))))
   `(font-lock-doc-face                  ((t (:foreground ,my-visited :slant italic))))
   `(font-lock-function-name-face        ((t (:foreground ,my-pop :weight bold))))
   `(font-lock-keyword-face              ((t (:foreground ,my-active :weight bold))))
   `(font-lock-negation-char-face        ((t (:foreground ,my-active))))
   `(font-lock-preprocessor-face        ((t (:foreground ,my-active))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,my-pop))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,my-pop))))
   `(font-lock-string-face               ((t (:foreground ,my-white :slant italic))))
   `(font-lock-type-face                 ((t (:foreground ,my-highlight :weight bold))))
   `(font-lock-variable-name-face        ((t (:foreground ,my-highlight))))
   `(font-lock-warning-face              ((t (:foreground ,my-warning))))

   ;; Font Lock — Emacs 29+ additions
   `(font-lock-bracket-face     ((t (:foreground ,my-contrast))))
   `(font-lock-delimiter-face   ((t (:foreground ,my-contrast))))
   `(font-lock-escape-face      ((t (:foreground ,my-info))))
   `(font-lock-number-face      ((t (:foreground ,my-info))))
   `(font-lock-operator-face    ((t (:foreground ,my-active))))
   `(font-lock-property-name-face ((t (:foreground ,my-highlight))))
   `(font-lock-property-use-face  ((t (:foreground ,my-hicontrast))))
   `(font-lock-punctuation-face ((t (:foreground ,my-contrast))))

   ;; ============================================================
   ;; Parens / Smart-Parens
   ;; ============================================================
   `(show-paren-match                ((t (:background ,my-shadow :weight extra-bold :foreground ,my-pop))))
   `(show-paren-mismatch             ((t (:background ,my-warning :weight extra-bold))))
   `(sp-show-pair-match-face         ((t (:background ,my-active :height 1.25))))
   `(sp-show-pair-match-content-face ((t (:background ,my-deepcontrast :height 1.25))))
   `(sp-show-pair-mismatch-face      ((t (:background ,my-warning :weight extra-bold))))
   `(sp-pair-overlay-face            ((t (:background ,my-contrast))))

   ;; Rainbow delimiters — depth-based bracket colouring
   `(rainbow-delimiters-depth-1-face  ((t (:foreground ,my-hicontrast))))
   `(rainbow-delimiters-depth-2-face  ((t (:foreground ,my-pop))))
   `(rainbow-delimiters-depth-3-face  ((t (:foreground ,my-highlight))))
   `(rainbow-delimiters-depth-4-face  ((t (:foreground ,my-info))))
   `(rainbow-delimiters-depth-5-face  ((t (:foreground ,my-active))))
   `(rainbow-delimiters-depth-6-face  ((t (:foreground ,my-visited))))
   `(rainbow-delimiters-depth-7-face  ((t (:foreground ,my-fluff))))
   `(rainbow-delimiters-unmatched-face ((t (:foreground ,my-warning :weight bold))))

   ;; ============================================================
   ;; Info / Errors
   ;; ============================================================
   `(success    ((t (:foreground ,my-highlight))))
   `(warning    ((t (:foreground ,my-info))))
   `(error      ((t (:foreground ,my-warning :weight bold))))
   `(next-error ((t (:inherit region))))

   ;; Eldoc
   `(eldoc-highlight-function-argument ((t (:foreground ,my-info :weight bold))))

   ;; ============================================================
   ;; All The Icons
   ;; ============================================================
   `(all-the-icons-dcyan  ((t (:foreground ,my-pop))))
   `(all-the-icons-dgreen ((t (:foreground ,my-highlight))))
   `(all-the-icons-dpink  ((t (:foreground ,my-active))))

   ;; ============================================================
   ;; Calendar
   ;; ============================================================
   `(calendar-today          ((t (:weight bold :foreground ,my-highlight))))
   `(calendar-weekday-header ((t (:foreground ,my-info))))
   `(calendar-weekend-header ((t (:foreground ,my-contrast))))
   `(calendar-holiday        ((t (:foreground ,my-contrast))))

   ;; ============================================================
   ;; Completion frameworks — vertico, corfu, marginalia, orderless
   ;; ============================================================

   ;; Vertico (vertical completion UI)
   `(vertico-current ((t (:background ,my-deepcontrast :foreground ,my-hicontrast :extend t))))

   ;; Corfu (in-buffer completion popup)
   `(corfu-default    ((t (:background ,my-deepcontrast :foreground ,my-hicontrast))))
   `(corfu-current    ((t (:background ,my-contrast :foreground ,my-hicontrast))))
   `(corfu-bar        ((t (:background ,my-pop))))
   `(corfu-border     ((t (:background ,my-contrast))))
   `(corfu-annotations ((t (:foreground ,my-visited))))

   ;; Marginalia (annotations in the minibuffer)
   `(marginalia-documentation ((t (:foreground ,my-visited :slant italic))))
   `(marginalia-key           ((t (:foreground ,my-pop))))
   `(marginalia-type          ((t (:foreground ,my-highlight))))
   `(marginalia-file-name     ((t (:foreground ,my-hicontrast))))
   `(marginalia-file-modes    ((t (:foreground ,my-contrast))))

   ;; Orderless (completion style — highlights matched parts)
   `(orderless-match-face-0 ((t (:foreground ,my-pop :weight bold))))
   `(orderless-match-face-1 ((t (:foreground ,my-highlight :weight bold))))
   `(orderless-match-face-2 ((t (:foreground ,my-info :weight bold))))
   `(orderless-match-face-3 ((t (:foreground ,my-active :weight bold))))

   ;; Consult (enhanced search/navigation commands)
   `(consult-preview-line        ((t (:background ,my-deepcontrast :extend t))))
   `(consult-preview-cursor      ((t (:background ,my-contrast))))
   `(consult-highlight-match     ((t (:foreground ,my-pop :weight bold))))
   `(consult-file                ((t (:foreground ,my-hicontrast))))
   `(consult-bookmark            ((t (:foreground ,my-info))))
   `(consult-separator           ((t (:foreground ,my-contrast))))

   ;; Standard completion faces (used by icomplete, fido, default completing-read)
   `(completions-common-part      ((t (:foreground ,my-pop :weight bold))))
   `(completions-first-difference ((t (:foreground ,my-highlight :weight bold))))

   ;; ============================================================
   ;; Which-key
   ;; ============================================================
   `(which-key-key-face                   ((t (:foreground ,my-pop :weight bold))))
   `(which-key-separator-face             ((t (:foreground ,my-contrast))))
   `(which-key-command-description-face   ((t (:foreground ,my-hicontrast))))
   `(which-key-local-map-description-face ((t (:foreground ,my-highlight))))
   `(which-key-group-description-face     ((t (:foreground ,my-info :weight bold))))

   ;; ============================================================
   ;; Dired
   ;; ============================================================
   `(dired-header    ((t (:foreground ,my-pop))))
   `(dired-directory ((t (:inherit fixed-pitch :foreground ,my-pop :weight bold))))
   `(dired-file-name ((t (:inherit fixed-pitch))))
   `(dired-symlink   ((t (:inherit fixed-pitch :foreground ,my-active))))
   `(dired-ignored   ((t (:inherit fixed-pitch :foreground ,my-contrast))))

   ;; ============================================================
   ;; Diff / diff-hl (inline diff markers in fringe)
   ;; ============================================================
   `(diff-added             ((t (:foreground ,my-highlight :background ,my-deepcontrast))))
   `(diff-removed           ((t (:foreground ,my-warning :background ,my-deepcontrast))))
   `(diff-changed           ((t (:foreground ,my-info :background ,my-deepcontrast))))
   `(diff-header            ((t (:foreground ,my-pop :weight bold))))
   `(diff-file-header       ((t (:foreground ,my-hicontrast :weight bold))))
   `(diff-hunk-header       ((t (:foreground ,my-visited))))
   `(diff-hl-insert         ((t (:foreground ,my-highlight :background ,my-highlight))))
   `(diff-hl-delete         ((t (:foreground ,my-warning :background ,my-warning))))
   `(diff-hl-change         ((t (:foreground ,my-info :background ,my-info))))

   ;; ============================================================
   ;; ERC
   ;; ============================================================
   `(erc-current-nick-face ((t (:foreground ,my-highlight))))
   `(erc-default-face      ((t (:foreground ,my-white))))
   `(erc-error-face        ((t (:foreground ,my-warning))))
   `(erc-input-face        ((t (:foreground ,my-pop))))
   `(erc-nick-default-face ((t (:foreground ,my-info))))
   `(erc-nick-message-face ((t (:foreground ,my-pop))))
   `(erc-notice-face       ((t (:foreground ,my-visited))))
   `(erc-timestamp-face    ((t (:foreground ,my-highlight))))

   ;; ============================================================
   ;; Flycheck / Flymake
   ;; ============================================================
   `(flycheck-error   ((t (:underline (:color ,my-warning :style wave)))))
   `(flycheck-warning ((t (:underline (:color ,my-info :style wave)))))
   `(flycheck-info    ((t (:underline (:color ,my-pop :style wave)))))
   `(flymake-error    ((t (:underline (:color ,my-warning :style wave)))))
   `(flymake-warning  ((t (:underline (:color ,my-info :style wave)))))
   `(flymake-note     ((t (:underline (:color ,my-pop :style wave)))))

   ;; ============================================================
   ;; Gnus
   ;; ============================================================
   `(gnus-group-mail-3          ((t (:foreground ,my-highlight))))
   `(gnus-group-mail-3-empty    ((t (:foreground ,my-contrast))))
   `(gnus-header-name           ((t (:foreground ,my-active))))
   `(gnus-header-from           ((t (:foreground ,my-hicontrast))))
   `(gnus-header-subject        ((t (:foreground ,my-highlight))))
   `(gnus-header-content        ((t (:foreground ,my-visited))))
   `(gnus-summary-normal-unread ((t (:foreground ,my-highlight))))
   `(gnus-summary-normal-read   ((t (:foreground ,my-highlight))))
   `(gnus-summary-selected      ((t (:foreground ,my-pop))))

   ;; ============================================================
   ;; Helm
   ;; ============================================================
   `(helm-buffer-archive             ((t (:foreground ,my-deepcontrast))))
   `(helm-buffer-directory           ((t (:foreground ,my-shadow :background ,my-hicontrast))))
   `(helm-buffer-file                ((t (:foreground ,my-pop))))
   `(helm-buffer-modified            ((t (:foreground ,my-visited))))
   `(helm-buffer-not-saved           ((t (:foreground ,my-warning))))
   `(helm-buffer-process             ((t (:foreground ,my-contrast))))
   `(helm-buffer-size                ((t (:foreground ,my-info))))
   `(helm-candidate-number           ((t (:foreground ,my-shadow :background ,my-info))))
   `(helm-candidate-number-suspended ((t (:foreground ,my-info :background ,my-deepcontrast))))
   `(helm-grep-match                 ((t (:foreground ,my-highlight))))
   `(helm-header                     ((t (:foreground ,my-white))))
   `(helm-header-line-left-margin    ((t (:background ,my-info :foreground ,my-shadow))))
   `(helm-match                      ((t (:foreground ,my-visited :weight bold))))
   `(helm-minibuffer-prompt          ((t (:foreground ,my-pop))))
   `(helm-no-file-buffer-modified    ((t (:foreground ,my-info))))
   `(helm-prefarg                    ((t (:foreground ,my-visited))))
   `(helm-selection                  ((t (:foreground ,my-deepcontrast :background ,my-info))))
   `(helm-separator                  ((t (:background ,my-deepcontrast))))
   `(helm-source-header              ((t (:family ,font-sans :height 1.3 :foreground ,my-contrast :underline t))))
   `(helm-visible-mark               ((t (:background ,my-visited))))

   ;; ============================================================
   ;; Heredocs
   ;; ============================================================
   `(sh-heredoc ((t (:foreground ,my-pop))))

   ;; ============================================================
   ;; Isearch
   ;; ============================================================
   `(isearch      ((t (:foreground ,my-shadow :background ,my-highlight))))
   `(isearch-fail ((t (:foreground ,my-white :background ,my-warning))))

   ;; ============================================================
   ;; Magit
   ;; ============================================================
   `(magit-section-highlight           ((t (:foreground ,my-pop :background ,my-deepcontrast))))
   `(magit-diff-added                  ((t (:foreground ,my-highlight :background ,my-deepcontrast))))
   `(magit-diff-added-highlight        ((t (:foreground ,my-highlight :background ,my-deepcontrast))))
   `(magit-diff-removed                ((t (:foreground ,my-warning :background ,my-deepcontrast))))
   `(magit-diff-removed-highlight      ((t (:foreground ,my-warning :background ,my-deepcontrast))))
   `(magit-diff-hunk-heading-highlight ((t (:foreground ,my-pop :background ,my-deepcontrast))))

   ;; ============================================================
   ;; Man pages
   ;; ============================================================
   `(Man-overstrike ((t (:inherit fixed-pitch :foreground ,my-pop :weight bold))))
   `(Man-underline  ((t (:inherit fixed-pitch :foreground ,my-active :underline t))))
   `(man-follow     ((t (:foreground ,my-active))))

   ;; ============================================================
   ;; Minibuffer
   ;; ============================================================
   `(minibuffer-prompt ((t (:weight bold :foreground ,my-pop))))

   ;; ============================================================
   ;; Org Mode
   ;; ============================================================
   `(org-agenda-day-view       ((t (:weight bold :foreground ,my-visited))))
   `(org-agenda-date           ((t (:foreground ,my-contrast))))
   `(org-agenda-date-today     ((t (:background ,my-highlight :foreground ,my-shadow :weight bold))))
   `(org-agenda-date-weekend   ((t (:foreground ,my-deepcontrast))))
   `(org-agenda-done           ((t (:slant italic :foreground ,my-contrast :strike-through t))))
   `(org-agenda-structure      ((t (:slant italic :foreground ,my-pop))))
   `(org-imminent-deadline     ((t (:foreground ,my-warning))))
   `(org-deadline-warning-days ((t (:foreground ,my-warning))))
   `(org-upcoming-deadline     ((t (:foreground ,my-visited :slant italic))))
   `(org-priority              ((t (:inherit fixed-pitch :foreground ,my-visited :slant normal))))

   ;; org-block foreground is unset (inherits default) so that font-lock
   ;; colours inside source blocks are not overridden by a blanket colour.
   `(org-block-begin-line ((t (:inherit fixed-pitch :foreground ,my-contrast :background ,my-deepcontrast :extend t))))
   `(org-block            ((t (:inherit fixed-pitch :background ,my-deepcontrast :extend t))))
   `(org-block-end-line   ((t (:inherit fixed-pitch :foreground ,my-contrast :background ,my-deepcontrast :extend t))))

   `(org-date                 ((t (:inherit fixed-pitch :foreground ,my-visited))))
   `(org-document-info        ((t (:height 1.25 :foreground ,my-visited))))
   `(org-document-info-keyword ((t (:foreground ,my-contrast))))
   `(org-document-title       ((t (:family ,font-cursive :foreground ,my-info :height 2 :weight extra-bold))))
   `(org-done                 ((t (:foreground ,my-contrast :strike-through t))))
   `(org-headline-done        ((t (:foreground ,my-contrast :strike-through t))))

   ;; Heading levels — explicit foregrounds throughout
   `(org-level-1 ((t (:family ,font-sans :foreground ,my-hicontrast :weight bold))))
   `(org-level-2 ((t (:family ,font-sans :foreground ,my-pop :weight bold :slant italic))))
   `(org-level-3 ((t (:family ,font-sans :foreground ,my-active :weight regular))))
   `(org-level-4 ((t (:family ,font-sans :foreground ,my-info :weight regular))))
   `(org-level-5 ((t (:family ,font-sans :foreground ,my-highlight :weight regular))))
   `(org-level-6 ((t (:family ,font-sans :foreground ,my-visited :weight regular))))
   `(org-level-7 ((t (:family ,font-sans :foreground ,my-contrast :weight regular))))
   `(org-level-8 ((t (:family ,font-sans :foreground ,my-fluff :weight regular))))

   `(org-link             ((t (:foreground ,my-active :underline t))))
   `(org-scheduled        ((t (:foreground ,my-info))))
   `(org-scheduled-today  ((t (:foreground ,my-highlight))))
   `(org-special-keyword  ((t (:inherit fixed-pitch :foreground ,my-contrast))))
   `(org-table            ((t (:inherit fixed-pitch :foreground ,my-hicontrast))))
   `(org-tag              ((t (:foreground ,my-active))))
   `(org-todo             ((t (:foreground ,my-info))))
   `(org-verbatim         ((t (:inherit fixed-pitch :foreground ,my-hicontrast))))
   `(org-code             ((t (:inherit fixed-pitch :foreground ,my-pop))))

   ;; ============================================================
   ;; Speedbar
   ;; ============================================================
   `(speedbar-directory-face ((t (:inherit fixed-pitch :foreground ,my-contrast))))
   `(speedbar-file-face      ((t (:inherit fixed-pitch :foreground ,my-contrast))))
   `(speedbar-selected-face  ((t (:weight extra-bold :foreground ,my-highlight))))
   `(speedbar-highlight-face ((t (:foreground ,my-active))))
   `(speedbar-button-face    ((t (:foreground ,my-pop))))

   ;; ============================================================
   ;; Terraform
   ;; ============================================================
   `(terraform--resource-name-face ((t (:foreground ,my-fluff))))
   `(terraform--resource-type-face ((t (:foreground ,my-active))))

   ;; ============================================================
   ;; Terminal — font and ANSI colour mapping
   ;; ============================================================
   `(term           ((t (:inherit fixed-pitch))))
   `(term-bold      ((t (:inherit fixed-pitch :foreground ,my-highlight :weight bold))))
   `(term-color-black   ((t (:foreground ,my-shadow   :background ,my-shadow))))
   `(term-color-blue    ((t (:foreground ,my-pop      :background ,my-pop))))
   `(term-color-cyan    ((t (:foreground ,my-pop      :background ,my-pop))))
   `(term-color-green   ((t (:foreground ,my-highlight :background ,my-highlight))))
   `(term-color-magenta ((t (:foreground ,my-active   :background ,my-active))))
   `(term-color-red     ((t (:foreground ,my-warning  :background ,my-warning))))
   `(term-color-white   ((t (:foreground ,my-white    :background ,my-white))))
   `(term-color-yellow  ((t (:foreground ,my-info     :background ,my-info))))

   ;; ============================================================
   ;; LSP / Eglot — inline diagnostics and semantic highlights
   ;; ============================================================

   ;; lsp-mode
   `(lsp-face-highlight-textual  ((t (:background ,my-deepcontrast))))
   `(lsp-face-highlight-read     ((t (:background ,my-deepcontrast :underline (:color ,my-pop :style line)))))
   `(lsp-face-highlight-write    ((t (:background ,my-deepcontrast :underline (:color ,my-active :style line)))))
   `(lsp-headerline-breadcrumb-path-face           ((t (:foreground ,my-visited))))
   `(lsp-headerline-breadcrumb-separator-face      ((t (:foreground ,my-contrast))))
   `(lsp-headerline-breadcrumb-symbols-face        ((t (:foreground ,my-hicontrast :weight bold))))
   `(lsp-ui-doc-background                         ((t (:background ,my-deepcontrast))))
   `(lsp-ui-sideline-code-action                   ((t (:foreground ,my-info))))
   `(lsp-ui-sideline-current-symbol                ((t (:foreground ,my-pop :weight bold))))

   ;; eglot
   `(eglot-highlight-symbol-face        ((t (:background ,my-deepcontrast))))
   `(eglot-diagnostic-tag-unnecessary-face ((t (:foreground ,my-contrast :slant italic))))
   `(eglot-diagnostic-tag-deprecated-face  ((t (:foreground ,my-visited :strike-through t))))
   `(eglot-inlay-hint-face              ((t (:foreground ,my-contrast :slant italic :height 0.9))))

   ;; ============================================================
   ;; Tree-sitter — generic faces (Emacs 29+, treesit built-in)
   ;;
   ;; These override the base font-lock faces with finer-grained
   ;; distinctions that tree-sitter parsers provide.  All languages
   ;; below map onto this shared set; language-specific overrides
   ;; follow in each section.
   ;; ============================================================

   `(treesit-font-lock-face               ((t (:inherit default))))

   ;; Functions and calls
   `(font-lock-function-call-face         ((t (:foreground ,my-pop))))

   ;; Variable references vs declarations get different weights
   `(font-lock-variable-use-face          ((t (:foreground ,my-hicontrast))))

   ;; ============================================================
   ;; JavaScript / TypeScript
   ;;
   ;; Colour logic:
   ;;   keywords (if/for/return etc)  → my-active  (pink, punchy)
   ;;   functions / methods           → my-pop     (cyan, stands out)
   ;;   types / classes               → my-highlight (green, structural)
   ;;   strings                       → my-white   (soft, not dominant)
   ;;   numbers / booleans            → my-info    (amber, warm)
   ;;   JSX tags                      → my-active  (same as keywords)
   ;;   JSX attributes                → my-highlight
   ;; ============================================================

   ;; js2-mode
   `(js2-function-call          ((t (:foreground ,my-pop))))
   `(js2-function-param          ((t (:foreground ,my-highlight :slant italic))))
   `(js2-object-property         ((t (:foreground ,my-hicontrast))))
   `(js2-object-property-access  ((t (:foreground ,my-hicontrast))))
   `(js2-jsdoc-tag               ((t (:foreground ,my-contrast))))
   `(js2-jsdoc-type              ((t (:foreground ,my-highlight))))
   `(js2-jsdoc-value             ((t (:foreground ,my-visited))))
   `(js2-error                   ((t (:underline (:color ,my-warning :style wave)))))
   `(js2-warning                 ((t (:underline (:color ,my-info :style wave)))))
   `(js2-external-variable       ((t (:foreground ,my-info))))

   ;; typescript-mode (non-ts-mode)
   `(typescript-this-face         ((t (:foreground ,my-active :weight bold))))
   `(typescript-access-modifier-face ((t (:foreground ,my-active :slant italic))))

   ;; tree-sitter faces for js/ts (used by js-ts-mode, tsx-ts-mode, typescript-ts-mode)
   `(js--treesit-font-lock-face              ((t (:inherit default))))

   ;; ============================================================
   ;; Bash / Shell
   ;;
   ;;   builtins (echo, cd, etc)   → my-active
   ;;   variable references $VAR   → my-highlight
   ;;   strings                    → my-white
   ;;   here-docs                  → my-pop
   ;;   process substitution       → my-info
   ;; ============================================================

   `(sh-quoted-exec    ((t (:foreground ,my-pop :weight bold))))
   `(sh-escaped-newline ((t (:foreground ,my-info))))

   ;; ============================================================
   ;; Python
   ;;
   ;;   decorators       → my-active (they're structural, like keywords)
   ;;   builtins         → my-pop
   ;;   self             → my-active italic
   ;;   f-string braces  → my-info  (stands out from string body)
   ;; ============================================================

   ;; python-mode (python.el and python-mode package)
   `(py-decorators-face            ((t (:foreground ,my-active))))
   `(py-builtins-face              ((t (:foreground ,my-pop))))
   `(py-class-name-face            ((t (:foreground ,my-highlight :weight bold))))
   `(py-def-face                   ((t (:foreground ,my-pop :weight bold))))
   `(py-number-face                ((t (:foreground ,my-info))))
   `(py-object-reference-face      ((t (:foreground ,my-active :slant italic))))

   ;; python.el built-in faces
   `(python-font-lock-decorator-face ((t (:foreground ,my-active :weight bold))))

   ;; ============================================================
   ;; Go
   ;;
   ;;   package names    → my-info   (warm, distinct from types)
   ;;   type assertions  → my-highlight
   ;;   builtins         → my-pop
   ;; ============================================================

   `(go-mode-function-name-face  ((t (:foreground ,my-pop :weight bold))))
   `(go-mode-package-name-face   ((t (:foreground ,my-info))))
   `(go-mode-import-path-face    ((t (:foreground ,my-white :slant italic))))

   ;; ============================================================
   ;; Rust
   ;;
   ;;   lifetimes        → my-active  (they're unique to Rust, make them pop)
   ;;   macros           → my-info    (amber — they're special, not regular fns)
   ;;   unsafe keyword   → my-warning (red, intentionally alarming)
   ;;   attributes #[]   → my-contrast (subtle, structural metadata)
   ;; ============================================================

   ;; rust-mode
   `(rust-string-interpolation-face ((t (:foreground ,my-info :slant italic))))

   ;; rustic-mode
   `(rustic-unsafe-face           ((t (:foreground ,my-warning :weight bold))))

   ;; tree-sitter faces shared by rust-ts-mode
   ;; Lifetimes are font-lock-type-face in treesit — already covered,
   ;; but we add a dedicated override for clarity:
   `(font-lock-lifetime-face      ((t (:foreground ,my-active :slant italic))))

   ;; ============================================================
   ;; Zig
   ;;
   ;;   comptime         → my-active  (like a keyword, but more special)
   ;;   builtins @fn()   → my-pop
   ;;   error unions     → my-warning (they're error-adjacent)
   ;; ============================================================

   `(zig-font-lock-builtin-face  ((t (:foreground ,my-pop :weight bold))))
   `(zig-font-lock-number-face   ((t (:foreground ,my-info))))

   ;; ============================================================
   ;; C / C++
   ;;
   ;;   preprocessor directives → my-active  (structural, language-level)
   ;;   type qualifiers         → my-highlight
   ;;   labels                  → my-info
   ;; ============================================================

   `(c-annotation-face    ((t (:foreground ,my-active :slant italic))))

   ;; ============================================================
   ;; Tree-sitter — language-specific face overrides (Emacs 29+)
   ;;
   ;; These faces are used by the built-in *-ts-mode variants when
   ;; treesit parsers are available.  They refine the generic
   ;; font-lock faces above with finer node-level distinctions.
   ;; ============================================================

   ;; Shared treesit faces used across all languages
   `(treesit-font-lock-level-1 ((t (:foreground ,my-active  :weight bold))))   ;; keywords
   `(treesit-font-lock-level-2 ((t (:foreground ,my-pop     :weight bold))))   ;; functions
   `(treesit-font-lock-level-3 ((t (:foreground ,my-highlight))))              ;; types/variables
   `(treesit-font-lock-level-4 ((t (:foreground ,my-hicontrast))))             ;; fine-grained

   ) ;; end custom-theme-set-faces
  )   ;; end let

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'melancholy)

;;; melancholy-theme.el ends here
