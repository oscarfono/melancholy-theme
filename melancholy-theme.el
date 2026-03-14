;;; melancholy-theme.el --- A dark theme that's pretty sad  -*- lexical-binding: t -*-

;; License: GPL-3.0-or-later

;; Author: Cooper Oscarfono
;; Maintainer: Cooper Oscarfono
;; Created: 30 August 2022
;; Last Modified: 14 March 2026

;; Version: 5.0
;; Package-Requires: ((emacs "29.1"))

;; Keywords: faces, frames, theme, dark
;; URL: https://github.com/oscarfono/melancholy-theme

;;; Commentary:
;;
;; A dark theme that's pretty sad really.
;;
;; Melancholy is a muted, desaturated dark theme with warm amber accents and
;; carefully chosen contrast ratios.  It covers core Emacs faces, org-mode,
;; magit, LSP, tree-sitter, and a broad set of language-specific modes.
;;
;; FONTS
;; -----
;; Melancholy looks best with the following fonts but degrades gracefully to
;; system fonts if they are not installed.  Run M-x melancholy-check-fonts
;; to see what is installed and where to get anything that is missing.
;;
;;   Preferred mono   : CommitMono Nerd Font Mono  https://www.nerdfonts.com
;;   Fallback mono    : JetBrains Mono, Hack, monospace
;;
;;   Preferred sans   : Raleway   https://fonts.google.com/specimen/Raleway
;;   Fallback sans    : Inter, sans-serif
;;
;;   Preferred cursive: Caveat    https://fonts.google.com/specimen/Caveat
;;   Fallback cursive : Segoe Print, serif
;;
;; Font families are specified without weight/style suffixes.  Emacs resolves
;; weight and slant via face attributes; suffixed names cause silent failures.
;;
;; CUSTOMISATION
;; -------------
;; The three accent colours can be overridden before loading the theme:
;;
;;   (setq melancholy-accent-primary   "#00B7FF"   ; cyan  — functions, builtins
;;         melancholy-accent-secondary "#F92672"   ; pink  — keywords, operators
;;         melancholy-accent-tertiary  "#96BF33")  ; green — types, variables
;;   (load-theme 'melancholy t)
;;
;; CHANGELOG
;; ---------
;; v5.0  Font fallback chains — loads cleanly without preferred fonts present
;;       melancholy-check-fonts interactive helper
;;       defcustom accent colour overrides
;;       nerd-icons faces (successor to all-the-icons)
;;       indent-guide, highlight-indent-guides
;;       symbol-overlay
;;       wgrep, deadgrep, rg.el, full grep faces
;;       Full 16-colour ANSI term face set (bright variants included)
;;       notmuch, elfeed faces
;;       treemacs, perspective faces
;;       Full magit face coverage (branches, log, bisect, process)
;;       Full org-mode face coverage (checkboxes, citations, drawers)
;;       Full corfu, vertico, marginalia, consult, orderless coverage
;;       Eglot inlay hint faces
;;       Fixed shadow face (was :background, should be :foreground)
;;       Fixed org-level heights for visual hierarchy
;;
;; v4.1  Tree-sitter and language-specific faces: JS/TS, Bash, Python,
;;       Go, Zig, Rust, C/C++; LSP and eglot faces
;;
;; v4.0  Contrast fixes, mode-line, tab-bar, completion frameworks,
;;       which-key, rainbow-delimiters, diff-hl, TTY support

;;; Code:

;; ============================================================
;; Customisable accent colours
;; Set these before calling load-theme for changes to take effect.
;; ============================================================

(defgroup melancholy nil
  "Melancholy theme options."
  :group 'faces
  :prefix "melancholy-")

(defcustom melancholy-accent-primary "#00B7FF"
  "Primary accent — functions, builtins, pop elements (default: cyan).
Set before loading the theme."
  :type 'color
  :group 'melancholy)

(defcustom melancholy-accent-secondary "#F92672"
  "Secondary accent — keywords, operators, active elements (default: pink).
Set before loading the theme."
  :type 'color
  :group 'melancholy)

(defcustom melancholy-accent-tertiary "#96BF33"
  "Tertiary accent — types, variables, success states (default: green).
Set before loading the theme."
  :type 'color
  :group 'melancholy)

;; ============================================================
;; Font availability helper
;; ============================================================

(defun melancholy-check-fonts ()
  "Display installation status of Melancholy's recommended fonts.
Shows ✓ for installed fonts and a download URL for missing ones."
  (interactive)
  (let ((fonts '(("CommitMono Nerd Font Mono" . "https://www.nerdfonts.com")
                 ("JetBrains Mono"            . "https://www.jetbrains.com/lp/mono")
                 ("Hack"                      . "https://sourcefoundry.org/hack")
                 ("Raleway"                   . "https://fonts.google.com/specimen/Raleway")
                 ("Inter"                     . "https://rsms.me/inter")
                 ("Caveat"                    . "https://fonts.google.com/specimen/Caveat"))))
    (with-current-buffer (get-buffer-create "*melancholy-fonts*")
      (erase-buffer)
      (insert "Melancholy Theme — Font Status\n")
      (insert (make-string 52 ?─) "\n\n")
      (dolist (f fonts)
        (let ((installed (find-font (font-spec :name (car f)))))
          (insert (format "  %s  %-32s %s\n"
                          (if installed "✓" "✗")
                          (car f)
                          (if installed "installed" (cdr f))))))
      (insert "\nRun M-x melancholy-check-fonts to refresh.\n")
      (display-buffer (current-buffer)))))

;; ============================================================
;; Theme definition
;; ============================================================

(deftheme melancholy "A dark theme that's pretty sad really.")

(let (
      ;; --- Font resolution ---
      ;; Emacs picks the first name in each chain that is installed.
      (font-mono
       (cond ((find-font (font-spec :name "CommitMono Nerd Font Mono")) "CommitMono Nerd Font Mono")
             ((find-font (font-spec :name "JetBrains Mono"))            "JetBrains Mono")
             ((find-font (font-spec :name "Hack"))                      "Hack")
             (t "monospace")))
      (font-sans
       (cond ((find-font (font-spec :name "Raleway")) "Raleway")
             ((find-font (font-spec :name "Inter"))   "Inter")
             (t "sans-serif")))
      (font-cursive
       (cond ((find-font (font-spec :name "Caveat"))      "Caveat")
             ((find-font (font-spec :name "Segoe Print")) "Segoe Print")
             (t "serif")))

      ;; --- Base palette ---
      (my-shadow       "#2A2A2A")   ;; background
      (my-deepcontrast "#4A4A4A")   ;; subtle bg: region, blocks
      (my-contrast     "#707070")   ;; muted fg: comments, borders
      (my-visited      "#999999")   ;; de-emphasised fg
      (my-hicontrast   "#DEDEDE")   ;; primary fg
      (my-white        "#E8E8E8")   ;; string fg — soft so it doesn't dominate
      (my-black        "#000000")
      (my-info         "#FFB728")   ;; amber: numbers, constants, macros
      (my-warning      "#FF6969")   ;; red: errors, unsafe, danger
      (my-fluff        "#FCDEEA")   ;; pale pink: deep heading levels, rare use

      ;; --- Accent tones resolved from defcustom ---
      (my-pop       (bound-and-true-p melancholy-accent-primary))
      (my-active    (bound-and-true-p melancholy-accent-secondary))
      (my-highlight (bound-and-true-p melancholy-accent-tertiary)))

  ;; Apply defaults if the defcustoms were not set before load-theme
  (unless my-pop       (setq my-pop       "#00B7FF"))
  (unless my-active    (setq my-active    "#F92672"))
  (unless my-highlight (setq my-highlight "#96BF33"))

  (custom-theme-set-faces
   'melancholy

   ;; ============================================================
   ;; Default — graphic/tty split prevents hex colours corrupting terminals
   ;; ============================================================
   `(default ((((type graphic))
               (:family ,font-mono
                        :width normal :weight regular :slant normal
                        :foreground ,my-hicontrast :background ,my-shadow
                        :underline nil :overline nil :strike-through nil
                        :box nil :inverse-video nil :stipple nil))
              (((type tty))
               (:foreground "white" :background "black"))))

   ;; mixed-pitch-mode uses these as roots to split mono/proportional faces
   `(fixed-pitch    ((t (:family ,font-mono :weight regular :slant normal))))
   `(variable-pitch ((t (:family ,font-sans  :weight normal  :slant normal))))

   ;; ============================================================
   ;; Window and Frame
   ;; ============================================================
   `(fringe                     ((t (:inherit default))))
   `(header-line                ((t (:foreground ,my-hicontrast :background ,my-shadow))))
   `(hl-line                    ((t (:background ,my-deepcontrast :extend t))))
   `(menu                       ((t (:foreground ,my-hicontrast :background ,my-shadow))))
   `(scroll-bar                 ((t (:foreground ,my-shadow :background ,my-visited))))
   `(vertical-border            ((t (:foreground ,my-contrast))))
   `(window-divider             ((t (:foreground ,my-deepcontrast))))
   `(window-divider-first-pixel ((t (:foreground ,my-contrast))))
   `(window-divider-last-pixel  ((t (:foreground ,my-deepcontrast))))
   `(fill-column-indicator      ((t (:foreground ,my-deepcontrast))))
   `(internal-border            ((t (:background ,my-shadow))))

   ;; ============================================================
   ;; Mode Line
   ;; ============================================================
   `(mode-line ((((type graphic))
                 (:foreground ,my-hicontrast :background ,my-deepcontrast
                              :box (:line-width 1 :color ,my-contrast)))
                (((type tty))
                 (:foreground "white" :background "brightblack"))))
   `(mode-line-inactive ((((type graphic))
                          (:foreground ,my-contrast :background ,my-shadow
                                       :box (:line-width 1 :color ,my-deepcontrast)))
                         (((type tty))
                          (:foreground "brightblack" :background "black"))))
   `(mode-line-buffer-id  ((t (:foreground ,my-pop :weight bold))))
   `(mode-line-emphasis   ((t (:foreground ,my-highlight :weight bold))))
   `(mode-line-highlight  ((t (:foreground ,my-info))))

   ;; ============================================================
   ;; Tab Bar / Tab Line
   ;; ============================================================
   `(tab-bar               ((t (:background ,my-shadow :foreground ,my-contrast))))
   `(tab-bar-tab           ((t (:background ,my-deepcontrast :foreground ,my-hicontrast
                                            :box (:line-width 1 :color ,my-contrast)))))
   `(tab-bar-tab-inactive  ((t (:background ,my-shadow :foreground ,my-contrast
                                            :box (:line-width 1 :color ,my-deepcontrast)))))
   `(tab-line              ((t (:background ,my-shadow :foreground ,my-contrast))))
   `(tab-line-tab          ((t (:background ,my-deepcontrast :foreground ,my-hicontrast))))
   `(tab-line-tab-current  ((t (:background ,my-deepcontrast :foreground ,my-pop :weight bold))))
   `(tab-line-tab-inactive ((t (:background ,my-shadow :foreground ,my-contrast))))

   ;; ============================================================
   ;; Line Numbers
   ;; ============================================================
   `(line-number              ((t (:foreground ,my-contrast :background ,my-shadow))))
   `(line-number-current-line ((t (:foreground ,my-highlight :background ,my-shadow :weight bold))))
   `(line-number-major-tick   ((t (:foreground ,my-visited))))
   `(line-number-minor-tick   ((t (:foreground ,my-deepcontrast))))

   ;; ============================================================
   ;; Base faces
   ;; ============================================================
   `(cursor              ((t (:background ,my-hicontrast))))
   `(region              ((t (:background ,my-fluff :extend t))))
   `(secondary-selection ((t (:background ,my-fluff :foreground ,my-shadow))))
   `(query-replace       ((t (:inherit isearch))))
   `(match               ((t (:background ,my-pop :foreground ,my-black))))
   `(highlight           ((t (:foreground ,my-pop :background ,my-contrast))))
   `(lazy-highlight      ((t (:foreground ,my-shadow :background ,my-highlight))))
   `(bold                ((t (:weight bold))))
   `(italic              ((t (:slant italic))))
   `(bold-italic         ((t (:weight bold :slant italic))))
   `(underline           ((t (:underline t))))
   `(shadow              ((t (:foreground ,my-contrast))))
   `(button              ((t (:foreground ,my-active :underline (:color foreground-color :style line)))))
   `(link                ((t (:foreground ,my-active :underline t :weight bold))))
   `(link-visited        ((t (:foreground ,my-visited :underline t))))
   `(tooltip             ((t (:foreground ,my-shadow :background ,my-info))))
   `(trailing-whitespace ((t (:background ,my-warning))))
   `(escape-glyph        ((t (:foreground ,my-info :weight bold))))
   `(homoglyph           ((t (:foreground ,my-info))))
   `(nobreak-space       ((t (:foreground ,my-warning :underline t))))

   ;; ============================================================
   ;; Font Lock — core (all supported Emacs versions)
   ;; ============================================================
   `(font-lock-builtin-face              ((t (:foreground ,my-pop))))
   `(font-lock-comment-delimiter-face    ((t (:foreground ,my-contrast))))
   `(font-lock-comment-face              ((t (:foreground ,my-contrast :slant italic))))
   `(font-lock-constant-face             ((t (:foreground ,my-info))))
   `(font-lock-doc-face                  ((t (:foreground ,my-visited :slant italic))))
   `(font-lock-doc-markup-face           ((t (:foreground ,my-pop :slant italic))))
   `(font-lock-function-name-face        ((t (:foreground ,my-pop :weight bold))))
   `(font-lock-keyword-face              ((t (:foreground ,my-active :weight bold))))
   `(font-lock-negation-char-face        ((t (:foreground ,my-active))))
   `(font-lock-preprocessor-face        ((t (:foreground ,my-active))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,my-pop))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,my-pop))))
   `(font-lock-string-face               ((t (:foreground ,my-white :slant italic))))
   `(font-lock-type-face                 ((t (:foreground ,my-highlight :weight bold))))
   `(font-lock-variable-name-face        ((t (:foreground ,my-highlight))))
   `(font-lock-warning-face              ((t (:foreground ,my-warning :weight bold))))

   ;; Font Lock — Emacs 29+ finer-grained faces
   ;;
   ;; Declarations (name faces) are bright/coloured.
   ;; Uses/references (use faces) are muted — this is the key to stopping JS
   ;; files looking uniformly white.  At treesit-font-lock-level 4, almost
   ;; every identifier gets a use face; keeping them at my-hicontrast means
   ;; they drown out keywords, functions, and types.
   ;; Also ensure (setq treesit-font-lock-level 4) is set in your config.
   `(font-lock-bracket-face          ((t (:foreground ,my-contrast))))
   `(font-lock-delimiter-face        ((t (:foreground ,my-contrast))))
   `(font-lock-escape-face           ((t (:foreground ,my-info :weight bold))))
   `(font-lock-function-call-face    ((t (:foreground ,my-pop))))
   `(font-lock-misc-punctuation-face ((t (:foreground ,my-contrast))))
   `(font-lock-number-face           ((t (:foreground ,my-info))))
   `(font-lock-operator-face         ((t (:foreground ,my-active))))
   `(font-lock-property-name-face    ((t (:foreground ,my-highlight))))  ;; declarations: green
   `(font-lock-property-use-face     ((t (:foreground ,my-visited))))    ;; accesses: muted grey
   `(font-lock-punctuation-face      ((t (:foreground ,my-contrast))))
   `(font-lock-regexp-face           ((t (:foreground ,my-info))))
   `(font-lock-variable-use-face     ((t (:foreground ,my-visited))))    ;; references: muted grey
   `(font-lock-lifetime-face         ((t (:foreground ,my-active :slant italic))))

   ;; ============================================================
   ;; Parens, Smart-Parens, Rainbow Delimiters
   ;; ============================================================
   `(show-paren-match            ((t (:foreground ,my-pop :background ,my-shadow :weight extra-bold))))
   `(show-paren-mismatch         ((t (:background ,my-warning :weight extra-bold))))
   `(show-paren-match-expression ((t (:background ,my-deepcontrast))))
   `(sp-show-pair-match-face         ((t (:background ,my-active))))
   `(sp-show-pair-match-content-face ((t (:background ,my-deepcontrast))))
   `(sp-show-pair-mismatch-face      ((t (:background ,my-warning :weight extra-bold))))
   `(sp-pair-overlay-face            ((t (:background ,my-deepcontrast))))

   `(rainbow-delimiters-depth-1-face    ((t (:foreground ,my-hicontrast))))
   `(rainbow-delimiters-depth-2-face    ((t (:foreground ,my-pop))))
   `(rainbow-delimiters-depth-3-face    ((t (:foreground ,my-highlight))))
   `(rainbow-delimiters-depth-4-face    ((t (:foreground ,my-info))))
   `(rainbow-delimiters-depth-5-face    ((t (:foreground ,my-active))))
   `(rainbow-delimiters-depth-6-face    ((t (:foreground ,my-visited))))
   `(rainbow-delimiters-depth-7-face    ((t (:foreground ,my-fluff))))
   `(rainbow-delimiters-depth-8-face    ((t (:foreground ,my-pop :weight bold))))
   `(rainbow-delimiters-depth-9-face    ((t (:foreground ,my-highlight :weight bold))))
   `(rainbow-delimiters-unmatched-face  ((t (:foreground ,my-warning :weight bold))))
   `(rainbow-delimiters-mismatched-face ((t (:foreground ,my-warning :background ,my-deepcontrast :weight bold))))

   ;; ============================================================
   ;; Status
   ;; ============================================================
   `(success    ((t (:foreground ,my-highlight :weight bold))))
   `(warning    ((t (:foreground ,my-info :weight bold))))
   `(error      ((t (:foreground ,my-warning :weight bold))))
   `(next-error ((t (:inherit region))))

   ;; ============================================================
   ;; Isearch
   ;; ============================================================
   `(isearch         ((t (:foreground ,my-shadow :background ,my-highlight :weight bold))))
   `(isearch-fail    ((t (:foreground ,my-white :background ,my-warning))))
   `(isearch-group-1 ((t (:foreground ,my-shadow :background ,my-pop))))
   `(isearch-group-2 ((t (:foreground ,my-shadow :background ,my-info))))

   ;; ============================================================
   ;; Minibuffer
   ;; ============================================================
   `(minibuffer-prompt ((t (:foreground ,my-pop :weight bold))))

   ;; ============================================================
   ;; Completion — vertico, corfu, marginalia, orderless, consult
   ;; ============================================================
   `(vertico-current          ((t (:background ,my-deepcontrast :extend t))))
   `(vertico-group-title      ((t (:foreground ,my-contrast :slant italic))))
   `(vertico-group-separator  ((t (:foreground ,my-deepcontrast :strike-through t))))

   `(corfu-default     ((t (:background ,my-deepcontrast :foreground ,my-hicontrast))))
   `(corfu-current     ((t (:background ,my-contrast :foreground ,my-hicontrast))))
   `(corfu-bar         ((t (:background ,my-pop))))
   `(corfu-border      ((t (:background ,my-contrast))))
   `(corfu-annotations ((t (:foreground ,my-visited :slant italic))))
   `(corfu-deprecated  ((t (:foreground ,my-visited :strike-through t))))

   `(marginalia-documentation ((t (:foreground ,my-visited :slant italic))))
   `(marginalia-key           ((t (:foreground ,my-pop))))
   `(marginalia-type          ((t (:foreground ,my-highlight))))
   `(marginalia-char          ((t (:foreground ,my-info))))
   `(marginalia-lighter       ((t (:foreground ,my-contrast))))
   `(marginalia-locus         ((t (:foreground ,my-contrast))))
   `(marginalia-file-name     ((t (:foreground ,my-hicontrast))))
   `(marginalia-file-modes    ((t (:foreground ,my-contrast))))
   `(marginalia-file-owner    ((t (:foreground ,my-visited))))
   `(marginalia-size          ((t (:foreground ,my-info))))
   `(marginalia-date          ((t (:foreground ,my-visited))))
   `(marginalia-version       ((t (:foreground ,my-contrast))))
   `(marginalia-installed     ((t (:foreground ,my-highlight))))

   `(orderless-match-face-0 ((t (:foreground ,my-pop :weight bold))))
   `(orderless-match-face-1 ((t (:foreground ,my-highlight :weight bold))))
   `(orderless-match-face-2 ((t (:foreground ,my-info :weight bold))))
   `(orderless-match-face-3 ((t (:foreground ,my-active :weight bold))))

   `(consult-preview-line     ((t (:background ,my-deepcontrast :extend t))))
   `(consult-preview-cursor   ((t (:background ,my-contrast))))
   `(consult-highlight-match  ((t (:foreground ,my-pop :weight bold))))
   `(consult-file             ((t (:foreground ,my-hicontrast))))
   `(consult-bookmark         ((t (:foreground ,my-info))))
   `(consult-separator        ((t (:foreground ,my-contrast))))
   `(consult-narrow-indicator ((t (:foreground ,my-active :weight bold))))
   `(consult-async-running    ((t (:foreground ,my-info))))
   `(consult-async-finished   ((t (:foreground ,my-highlight))))

   `(completions-common-part      ((t (:foreground ,my-pop :weight bold))))
   `(completions-first-difference ((t (:foreground ,my-highlight :weight bold))))
   `(completions-annotations      ((t (:foreground ,my-visited :slant italic))))

   ;; ============================================================
   ;; Which-key
   ;; ============================================================
   `(which-key-key-face                   ((t (:foreground ,my-pop :weight bold))))
   `(which-key-separator-face             ((t (:foreground ,my-contrast))))
   `(which-key-note-face                  ((t (:foreground ,my-visited :slant italic))))
   `(which-key-command-description-face   ((t (:foreground ,my-hicontrast))))
   `(which-key-local-map-description-face ((t (:foreground ,my-highlight))))
   `(which-key-group-description-face     ((t (:foreground ,my-info :weight bold))))
   `(which-key-highlighted-command-face   ((t (:foreground ,my-active :weight bold))))
   `(which-key-special-key-face           ((t (:foreground ,my-warning :weight bold))))

   ;; ============================================================
   ;; Eldoc
   ;; ============================================================
   `(eldoc-highlight-function-argument ((t (:foreground ,my-info :weight bold))))
   `(eldoc-box-body                    ((t (:background ,my-deepcontrast :foreground ,my-hicontrast))))
   `(eldoc-box-border                  ((t (:background ,my-contrast))))

   ;; ============================================================
   ;; Symbol overlay
   ;; ============================================================
   `(symbol-overlay-default-face ((t (:background ,my-deepcontrast
                                                  :underline (:color ,my-pop :style line)))))
   `(symbol-overlay-face-1  ((t (:background ,my-deepcontrast :foreground ,my-pop))))
   `(symbol-overlay-face-2  ((t (:background ,my-deepcontrast :foreground ,my-highlight))))
   `(symbol-overlay-face-3  ((t (:background ,my-deepcontrast :foreground ,my-info))))
   `(symbol-overlay-face-4  ((t (:background ,my-deepcontrast :foreground ,my-active))))
   `(symbol-overlay-face-5  ((t (:background ,my-deepcontrast :foreground ,my-warning))))
   `(symbol-overlay-face-6  ((t (:background ,my-deepcontrast :foreground ,my-fluff))))
   `(symbol-overlay-face-7  ((t (:background ,my-deepcontrast :foreground ,my-visited))))
   `(symbol-overlay-face-8  ((t (:background ,my-deepcontrast :foreground ,my-hicontrast))))

   ;; ============================================================
   ;; Indent guides
   ;; ============================================================
   `(indent-guide-face                            ((t (:foreground ,my-deepcontrast))))
   `(highlight-indent-guides-character-face       ((t (:foreground ,my-deepcontrast))))
   `(highlight-indent-guides-top-character-face   ((t (:foreground ,my-contrast))))
   `(highlight-indent-guides-stack-character-face ((t (:foreground ,my-contrast))))

   ;; ============================================================
   ;; Icons — nerd-icons (preferred) and all-the-icons (compat)
   ;; ============================================================
   `(nerd-icons-dcyan    ((t (:foreground ,my-pop))))
   `(nerd-icons-lcyan    ((t (:foreground ,my-pop))))
   `(nerd-icons-dgreen   ((t (:foreground ,my-highlight))))
   `(nerd-icons-lgreen   ((t (:foreground ,my-highlight))))
   `(nerd-icons-dpink    ((t (:foreground ,my-active))))
   `(nerd-icons-lpink    ((t (:foreground ,my-fluff))))
   `(nerd-icons-dyellow  ((t (:foreground ,my-info))))
   `(nerd-icons-lyellow  ((t (:foreground ,my-info))))
   `(nerd-icons-dred     ((t (:foreground ,my-warning))))
   `(nerd-icons-lred     ((t (:foreground ,my-warning))))
   `(nerd-icons-dsilver  ((t (:foreground ,my-contrast))))
   `(nerd-icons-lsilver  ((t (:foreground ,my-visited))))
   `(all-the-icons-dcyan  ((t (:foreground ,my-pop))))
   `(all-the-icons-dgreen ((t (:foreground ,my-highlight))))
   `(all-the-icons-dpink  ((t (:foreground ,my-active))))

   ;; ============================================================
   ;; Calendar / Diary
   ;; ============================================================
   `(calendar-today          ((t (:foreground ,my-highlight :weight bold))))
   `(calendar-weekday-header ((t (:foreground ,my-info))))
   `(calendar-weekend-header ((t (:foreground ,my-contrast))))
   `(calendar-holiday        ((t (:foreground ,my-active))))
   `(diary                   ((t (:foreground ,my-pop))))

   ;; ============================================================
   ;; Dired
   ;; ============================================================
   `(dired-header         ((t (:foreground ,my-pop :weight bold))))
   `(dired-directory      ((t (:inherit fixed-pitch :foreground ,my-pop :weight bold))))
   `(dired-file-name      ((t (:inherit fixed-pitch))))
   `(dired-symlink        ((t (:inherit fixed-pitch :foreground ,my-active))))
   `(dired-broken-symlink ((t (:inherit fixed-pitch :foreground ,my-warning :strike-through t))))
   `(dired-ignored        ((t (:inherit fixed-pitch :foreground ,my-contrast))))
   `(dired-special        ((t (:inherit fixed-pitch :foreground ,my-info))))
   `(dired-flagged        ((t (:foreground ,my-warning :weight bold))))
   `(dired-marked         ((t (:foreground ,my-highlight :weight bold))))
   `(dired-mark           ((t (:foreground ,my-highlight :weight bold))))
   `(dired-perm-write     ((t (:foreground ,my-info))))

   ;; ============================================================
   ;; Diff / diff-hl
   ;; ============================================================
   `(diff-added          ((t (:foreground ,my-highlight :background ,my-deepcontrast))))
   `(diff-removed        ((t (:foreground ,my-warning :background ,my-deepcontrast))))
   `(diff-changed        ((t (:foreground ,my-info :background ,my-deepcontrast))))
   `(diff-header         ((t (:foreground ,my-pop :weight bold))))
   `(diff-file-header    ((t (:foreground ,my-hicontrast :weight bold))))
   `(diff-hunk-header    ((t (:foreground ,my-visited))))
   `(diff-refine-added   ((t (:foreground ,my-highlight :weight bold))))
   `(diff-refine-removed ((t (:foreground ,my-warning :weight bold))))
   `(diff-hl-insert      ((t (:foreground ,my-highlight :background ,my-highlight))))
   `(diff-hl-delete      ((t (:foreground ,my-warning :background ,my-warning))))
   `(diff-hl-change      ((t (:foreground ,my-info :background ,my-info))))
   `(diff-hl-margin-insert ((t (:foreground ,my-highlight))))
   `(diff-hl-margin-delete ((t (:foreground ,my-warning))))
   `(diff-hl-margin-change ((t (:foreground ,my-info))))

   ;; ============================================================
   ;; Flycheck / Flymake
   ;; ============================================================
   `(flycheck-error              ((t (:underline (:color ,my-warning :style wave)))))
   `(flycheck-warning            ((t (:underline (:color ,my-info :style wave)))))
   `(flycheck-info               ((t (:underline (:color ,my-pop :style wave)))))
   `(flycheck-fringe-error       ((t (:foreground ,my-warning))))
   `(flycheck-fringe-warning     ((t (:foreground ,my-info))))
   `(flycheck-fringe-info        ((t (:foreground ,my-pop))))
   `(flycheck-error-list-error   ((t (:foreground ,my-warning))))
   `(flycheck-error-list-warning ((t (:foreground ,my-info))))
   `(flycheck-error-list-info    ((t (:foreground ,my-pop))))
   `(flymake-error               ((t (:underline (:color ,my-warning :style wave)))))
   `(flymake-warning             ((t (:underline (:color ,my-info :style wave)))))
   `(flymake-note                ((t (:underline (:color ,my-pop :style wave)))))

   ;; ============================================================
   ;; Magit
   ;; ============================================================
   `(magit-section-heading             ((t (:foreground ,my-info :weight bold))))
   `(magit-section-heading-selection   ((t (:foreground ,my-highlight :weight bold))))
   `(magit-section-highlight           ((t (:background ,my-deepcontrast))))
   `(magit-diff-added                  ((t (:foreground ,my-highlight :background ,my-deepcontrast))))
   `(magit-diff-added-highlight        ((t (:foreground ,my-highlight :background ,my-deepcontrast :weight bold))))
   `(magit-diff-removed                ((t (:foreground ,my-warning :background ,my-deepcontrast))))
   `(magit-diff-removed-highlight      ((t (:foreground ,my-warning :background ,my-deepcontrast :weight bold))))
   `(magit-diff-context                ((t (:foreground ,my-visited))))
   `(magit-diff-context-highlight      ((t (:foreground ,my-hicontrast :background ,my-deepcontrast))))
   `(magit-diff-hunk-heading           ((t (:foreground ,my-contrast :background ,my-shadow))))
   `(magit-diff-hunk-heading-highlight ((t (:foreground ,my-pop :background ,my-deepcontrast))))
   `(magit-diff-file-heading           ((t (:foreground ,my-hicontrast :weight bold))))
   `(magit-diff-file-heading-selection ((t (:foreground ,my-pop :weight bold))))
   `(magit-hash                        ((t (:foreground ,my-contrast))))
   `(magit-log-author                  ((t (:foreground ,my-active))))
   `(magit-log-date                    ((t (:foreground ,my-visited))))
   `(magit-log-graph                   ((t (:foreground ,my-contrast))))
   `(magit-branch-local                ((t (:foreground ,my-pop :weight bold))))
   `(magit-branch-remote               ((t (:foreground ,my-highlight :weight bold))))
   `(magit-branch-current              ((t (:foreground ,my-pop :weight bold :box t))))
   `(magit-tag                         ((t (:foreground ,my-info))))
   `(magit-filename                    ((t (:foreground ,my-hicontrast))))
   `(magit-process-ok                  ((t (:foreground ,my-highlight :weight bold))))
   `(magit-process-ng                  ((t (:foreground ,my-warning :weight bold))))
   `(magit-bisect-good                 ((t (:foreground ,my-highlight))))
   `(magit-bisect-bad                  ((t (:foreground ,my-warning))))
   `(magit-bisect-skip                 ((t (:foreground ,my-info))))

   ;; ============================================================
   ;; Grep / ripgrep / wgrep
   ;; ============================================================
   `(grep-match-face           ((t (:foreground ,my-pop :weight bold))))
   `(grep-hit-face             ((t (:foreground ,my-highlight))))
   `(grep-context-face         ((t (:foreground ,my-visited))))
   `(deadgrep-match-face       ((t (:foreground ,my-shadow :background ,my-highlight))))
   `(deadgrep-filename-face    ((t (:foreground ,my-pop :weight bold))))
   `(deadgrep-search-term-face ((t (:foreground ,my-active :weight bold))))
   `(rg-match-face             ((t (:foreground ,my-shadow :background ,my-highlight))))
   `(rg-filename-face          ((t (:foreground ,my-pop :weight bold))))
   `(rg-line-number-face       ((t (:foreground ,my-contrast))))
   `(wgrep-face                ((t (:foreground ,my-info :background ,my-deepcontrast))))
   `(wgrep-done-face           ((t (:foreground ,my-highlight))))
   `(wgrep-reject-face         ((t (:foreground ,my-warning :weight bold))))

   ;; ============================================================
   ;; Treemacs
   ;; ============================================================
   `(treemacs-root-face               ((t (:foreground ,my-pop :weight bold :height 1.1))))
   `(treemacs-directory-face          ((t (:foreground ,my-pop))))
   `(treemacs-directory-collapsed-face ((t (:foreground ,my-pop))))
   `(treemacs-file-face               ((t (:foreground ,my-hicontrast))))
   `(treemacs-tags-face               ((t (:foreground ,my-hicontrast))))
   `(treemacs-help-title-face         ((t (:foreground ,my-info :weight bold))))
   `(treemacs-help-column-face        ((t (:foreground ,my-pop))))
   `(treemacs-fringe-indicator-face   ((t (:foreground ,my-active))))
   `(treemacs-git-modified-face       ((t (:foreground ,my-info))))
   `(treemacs-git-renamed-face        ((t (:foreground ,my-pop))))
   `(treemacs-git-ignored-face        ((t (:foreground ,my-contrast))))
   `(treemacs-git-untracked-face      ((t (:foreground ,my-visited))))
   `(treemacs-git-added-face          ((t (:foreground ,my-highlight))))
   `(treemacs-git-conflict-face       ((t (:foreground ,my-warning :weight bold))))
   `(treemacs-on-success-pulse-face   ((t (:background ,my-highlight))))
   `(treemacs-on-failure-pulse-face   ((t (:background ,my-warning))))

   ;; ============================================================
   ;; Perspective
   ;; ============================================================
   `(persp-selected-face ((t (:foreground ,my-pop :weight bold))))

   ;; ============================================================
   ;; Elfeed
   ;; ============================================================
   `(elfeed-search-unread-title-face ((t (:foreground ,my-hicontrast :weight bold))))
   `(elfeed-search-title-face        ((t (:foreground ,my-visited))))
   `(elfeed-search-date-face         ((t (:foreground ,my-contrast))))
   `(elfeed-search-feed-face         ((t (:foreground ,my-pop))))
   `(elfeed-search-tag-face          ((t (:foreground ,my-highlight))))
   `(elfeed-search-unread-count-face ((t (:foreground ,my-info))))
   `(elfeed-log-error-level-face     ((t (:foreground ,my-warning))))
   `(elfeed-log-warn-level-face      ((t (:foreground ,my-info))))
   `(elfeed-log-info-level-face      ((t (:foreground ,my-pop))))
   `(elfeed-log-debug-level-face     ((t (:foreground ,my-contrast))))

   ;; ============================================================
   ;; Notmuch
   ;; ============================================================
   `(notmuch-search-unread-face          ((t (:foreground ,my-hicontrast :weight bold))))
   `(notmuch-search-date                 ((t (:foreground ,my-contrast))))
   `(notmuch-search-count                ((t (:foreground ,my-contrast))))
   `(notmuch-search-subject              ((t (:foreground ,my-hicontrast))))
   `(notmuch-search-matching-authors     ((t (:foreground ,my-pop))))
   `(notmuch-search-non-matching-authors ((t (:foreground ,my-visited))))
   `(notmuch-tag-face                    ((t (:foreground ,my-highlight :weight bold))))
   `(notmuch-tag-unread                  ((t (:foreground ,my-active :weight bold))))
   `(notmuch-tag-flagged                 ((t (:foreground ,my-info))))
   `(notmuch-message-summary-face        ((t (:background ,my-deepcontrast))))
   `(notmuch-crypto-verified-signature   ((t (:foreground ,my-highlight))))
   `(notmuch-crypto-invalid-signature    ((t (:foreground ,my-warning :weight bold))))

   ;; ============================================================
   ;; ERC
   ;; ============================================================
   `(erc-current-nick-face ((t (:foreground ,my-highlight :weight bold))))
   `(erc-default-face      ((t (:foreground ,my-white))))
   `(erc-error-face        ((t (:foreground ,my-warning))))
   `(erc-input-face        ((t (:foreground ,my-pop))))
   `(erc-my-nick-face      ((t (:foreground ,my-highlight :weight bold))))
   `(erc-nick-default-face ((t (:foreground ,my-info))))
   `(erc-nick-msg-face     ((t (:foreground ,my-active))))
   `(erc-notice-face       ((t (:foreground ,my-contrast))))
   `(erc-prompt-face       ((t (:foreground ,my-pop :weight bold))))
   `(erc-timestamp-face    ((t (:foreground ,my-contrast))))
   `(erc-keyword-face      ((t (:foreground ,my-active :weight bold))))

   ;; ============================================================
   ;; Helm
   ;; ============================================================
   `(helm-buffer-archive             ((t (:foreground ,my-deepcontrast))))
   `(helm-buffer-directory           ((t (:foreground ,my-shadow :background ,my-hicontrast))))
   `(helm-buffer-file                ((t (:foreground ,my-pop))))
   `(helm-buffer-modified            ((t (:foreground ,my-info))))
   `(helm-buffer-not-saved           ((t (:foreground ,my-warning))))
   `(helm-buffer-process             ((t (:foreground ,my-contrast))))
   `(helm-buffer-size                ((t (:foreground ,my-visited))))
   `(helm-candidate-number           ((t (:foreground ,my-shadow :background ,my-info))))
   `(helm-candidate-number-suspended ((t (:foreground ,my-info :background ,my-deepcontrast))))
   `(helm-grep-match                 ((t (:foreground ,my-highlight :weight bold))))
   `(helm-header                     ((t (:foreground ,my-hicontrast))))
   `(helm-header-line-left-margin    ((t (:background ,my-info :foreground ,my-shadow))))
   `(helm-match                      ((t (:foreground ,my-pop :weight bold))))
   `(helm-minibuffer-prompt          ((t (:foreground ,my-pop :weight bold))))
   `(helm-no-file-buffer-modified    ((t (:foreground ,my-info))))
   `(helm-prefarg                    ((t (:foreground ,my-visited))))
   `(helm-selection                  ((t (:background ,my-deepcontrast :extend t))))
   `(helm-separator                  ((t (:foreground ,my-deepcontrast))))
   `(helm-source-header              ((t (:family ,font-sans :height 1.3 :foreground ,my-contrast
                                                  :underline (:color ,my-deepcontrast :style line)))))
   `(helm-visible-mark               ((t (:foreground ,my-highlight :weight bold))))

   ;; ============================================================
   ;; Gnus
   ;; ============================================================
   `(gnus-group-mail-3          ((t (:foreground ,my-highlight))))
   `(gnus-group-mail-3-empty    ((t (:foreground ,my-contrast))))
   `(gnus-header-name           ((t (:foreground ,my-active :weight bold))))
   `(gnus-header-from           ((t (:foreground ,my-hicontrast))))
   `(gnus-header-subject        ((t (:foreground ,my-highlight :weight bold))))
   `(gnus-header-content        ((t (:foreground ,my-visited :slant italic))))
   `(gnus-summary-normal-unread ((t (:foreground ,my-hicontrast :weight bold))))
   `(gnus-summary-normal-read   ((t (:foreground ,my-contrast))))
   `(gnus-summary-selected      ((t (:foreground ,my-pop :weight bold))))

   ;; ============================================================
   ;; Man pages
   ;; ============================================================
   `(Man-overstrike ((t (:inherit fixed-pitch :foreground ,my-pop :weight bold))))
   `(Man-underline  ((t (:inherit fixed-pitch :foreground ,my-active :underline t))))
   `(man-follow     ((t (:foreground ,my-active))))

   ;; ============================================================
   ;; Org Mode
   ;; ============================================================
   `(org-document-title         ((t (:family ,font-cursive :foreground ,my-info
                                             :height 2.0 :weight extra-bold))))
   `(org-document-info          ((t (:foreground ,my-visited :height 1.1))))
   `(org-document-info-keyword  ((t (:foreground ,my-contrast))))

   ;; Heading levels with progressive height for visual hierarchy
   `(org-level-1 ((t (:family ,font-sans :foreground ,my-hicontrast :weight bold   :height 1.3))))
   `(org-level-2 ((t (:family ,font-sans :foreground ,my-pop       :weight bold   :height 1.2 :slant italic))))
   `(org-level-3 ((t (:family ,font-sans :foreground ,my-active    :weight medium :height 1.1))))
   `(org-level-4 ((t (:family ,font-sans :foreground ,my-info      :weight medium))))
   `(org-level-5 ((t (:family ,font-sans :foreground ,my-highlight :weight regular))))
   `(org-level-6 ((t (:family ,font-sans :foreground ,my-visited   :weight regular))))
   `(org-level-7 ((t (:family ,font-sans :foreground ,my-contrast  :weight regular))))
   `(org-level-8 ((t (:family ,font-sans :foreground ,my-fluff     :weight regular))))

   ;; No foreground on org-block — lets font-lock colours work inside src blocks
   `(org-block-begin-line ((t (:inherit fixed-pitch :foreground ,my-contrast
                                        :background ,my-deepcontrast :extend t))))
   `(org-block            ((t (:inherit fixed-pitch :background ,my-deepcontrast :extend t))))
   `(org-block-end-line   ((t (:inherit fixed-pitch :foreground ,my-contrast
                                        :background ,my-deepcontrast :extend t))))

   `(org-agenda-structure      ((t (:family ,font-sans :foreground ,my-pop :slant italic :weight bold))))
   `(org-agenda-date           ((t (:foreground ,my-contrast))))
   `(org-agenda-date-today     ((t (:foreground ,my-shadow :background ,my-highlight :weight bold))))
   `(org-agenda-date-weekend   ((t (:foreground ,my-deepcontrast))))
   `(org-agenda-done           ((t (:foreground ,my-contrast :slant italic :strike-through t))))
   `(org-agenda-day-view       ((t (:foreground ,my-visited :weight bold))))
   `(org-date                  ((t (:inherit fixed-pitch :foreground ,my-visited :underline t))))
   `(org-deadline-warning-days ((t (:foreground ,my-warning))))
   `(org-done                  ((t (:foreground ,my-contrast :strike-through t))))
   `(org-headline-done         ((t (:foreground ,my-contrast :strike-through t))))
   `(org-imminent-deadline     ((t (:foreground ,my-warning :weight bold))))
   `(org-upcoming-deadline     ((t (:foreground ,my-visited :slant italic))))
   `(org-scheduled             ((t (:foreground ,my-info))))
   `(org-scheduled-today       ((t (:foreground ,my-highlight :weight bold))))
   `(org-warning               ((t (:foreground ,my-warning :weight bold))))
   `(org-link                  ((t (:foreground ,my-active :underline t))))
   `(org-code                  ((t (:inherit fixed-pitch :foreground ,my-pop))))
   `(org-verbatim              ((t (:inherit fixed-pitch :foreground ,my-hicontrast))))
   `(org-table                 ((t (:inherit fixed-pitch :foreground ,my-hicontrast))))
   `(org-formula               ((t (:inherit fixed-pitch :foreground ,my-info))))
   `(org-tag                   ((t (:foreground ,my-active :weight bold))))
   `(org-todo                  ((t (:foreground ,my-info :weight bold))))
   `(org-priority              ((t (:inherit fixed-pitch :foreground ,my-visited))))
   `(org-special-keyword       ((t (:inherit fixed-pitch :foreground ,my-contrast))))
   `(org-drawer                ((t (:foreground ,my-contrast))))
   `(org-property-value        ((t (:foreground ,my-visited))))
   `(org-checkbox              ((t (:inherit fixed-pitch :foreground ,my-info :weight bold))))
   `(org-checkbox-statistics-todo ((t (:foreground ,my-info))))
   `(org-checkbox-statistics-done ((t (:foreground ,my-highlight))))
   `(org-footnote              ((t (:foreground ,my-visited :underline t))))
   `(org-cite                  ((t (:foreground ,my-pop))))
   `(org-cite-key              ((t (:foreground ,my-pop :underline t))))
   `(org-ellipsis              ((t (:foreground ,my-contrast :underline nil))))

   ;; ============================================================
   ;; LSP / Eglot
   ;; ============================================================
   `(lsp-face-highlight-textual             ((t (:background ,my-deepcontrast))))
   `(lsp-face-highlight-read                ((t (:background ,my-deepcontrast
                                                             :underline (:color ,my-pop :style line)))))
   `(lsp-face-highlight-write               ((t (:background ,my-deepcontrast
                                                             :underline (:color ,my-active :style line)))))
   `(lsp-headerline-breadcrumb-path-face    ((t (:foreground ,my-visited))))
   `(lsp-headerline-breadcrumb-separator-face ((t (:foreground ,my-contrast))))
   `(lsp-headerline-breadcrumb-symbols-face ((t (:foreground ,my-hicontrast :weight bold))))
   `(lsp-ui-doc-background                  ((t (:background ,my-deepcontrast))))
   `(lsp-ui-sideline-code-action            ((t (:foreground ,my-info))))
   `(lsp-ui-sideline-current-symbol         ((t (:foreground ,my-pop :weight bold))))

   `(eglot-highlight-symbol-face           ((t (:background ,my-deepcontrast))))
   `(eglot-diagnostic-tag-unnecessary-face ((t (:foreground ,my-contrast :slant italic))))
   `(eglot-diagnostic-tag-deprecated-face  ((t (:foreground ,my-visited :strike-through t))))
   `(eglot-inlay-hint-face                 ((t (:foreground ,my-contrast :slant italic :height 0.85))))
   `(eglot-type-hint-face                  ((t (:foreground ,my-highlight :slant italic :height 0.85))))
   `(eglot-parameter-hint-face             ((t (:foreground ,my-visited :slant italic :height 0.85))))

   ;; ============================================================
   ;; Tree-sitter — generic level faces (Emacs 29+)
   ;; ============================================================
   `(treesit-font-lock-level-1 ((t (:foreground ,my-active    :weight bold))))
   `(treesit-font-lock-level-2 ((t (:foreground ,my-pop       :weight bold))))
   `(treesit-font-lock-level-3 ((t (:foreground ,my-highlight))))
   `(treesit-font-lock-level-4 ((t (:foreground ,my-hicontrast))))

   ;; ============================================================
   ;; JavaScript / TypeScript
   ;; ============================================================
   `(js2-function-call            ((t (:foreground ,my-pop))))
   `(js2-function-param           ((t (:foreground ,my-highlight :slant italic))))
   `(js2-object-property          ((t (:foreground ,my-hicontrast))))
   `(js2-object-property-access   ((t (:foreground ,my-hicontrast))))
   `(js2-jsdoc-tag                ((t (:foreground ,my-contrast))))
   `(js2-jsdoc-type               ((t (:foreground ,my-highlight))))
   `(js2-jsdoc-value              ((t (:foreground ,my-visited))))
   `(js2-error                    ((t (:underline (:color ,my-warning :style wave)))))
   `(js2-warning                  ((t (:underline (:color ,my-info :style wave)))))
   `(js2-external-variable        ((t (:foreground ,my-info))))
   `(typescript-this-face             ((t (:foreground ,my-active :weight bold))))
   `(typescript-access-modifier-face  ((t (:foreground ,my-active :slant italic))))

   ;; ============================================================
   ;; Bash / Shell
   ;; ============================================================
   `(sh-quoted-exec     ((t (:foreground ,my-pop :weight bold))))
   `(sh-escaped-newline ((t (:foreground ,my-info))))
   `(sh-heredoc         ((t (:foreground ,my-pop :slant italic))))

   ;; ============================================================
   ;; Python
   ;; ============================================================
   `(py-decorators-face              ((t (:foreground ,my-active :weight bold))))
   `(py-builtins-face                ((t (:foreground ,my-pop))))
   `(py-class-name-face              ((t (:foreground ,my-highlight :weight bold))))
   `(py-def-face                     ((t (:foreground ,my-pop :weight bold))))
   `(py-number-face                  ((t (:foreground ,my-info))))
   `(py-object-reference-face        ((t (:foreground ,my-active :slant italic))))
   `(python-font-lock-decorator-face ((t (:foreground ,my-active :weight bold))))

   ;; ============================================================
   ;; Go
   ;; ============================================================
   `(go-mode-function-name-face ((t (:foreground ,my-pop :weight bold))))
   `(go-mode-package-name-face  ((t (:foreground ,my-info))))
   `(go-mode-import-path-face   ((t (:foreground ,my-white :slant italic))))

   ;; ============================================================
   ;; Rust
   ;; ============================================================
   `(rust-string-interpolation-face ((t (:foreground ,my-info :slant italic))))
   `(rustic-unsafe-face             ((t (:foreground ,my-warning :weight bold))))

   ;; ============================================================
   ;; Zig
   ;; ============================================================
   `(zig-font-lock-builtin-face ((t (:foreground ,my-pop :weight bold))))
   `(zig-font-lock-number-face  ((t (:foreground ,my-info))))

   ;; ============================================================
   ;; C / C++
   ;; ============================================================
   `(c-annotation-face ((t (:foreground ,my-active :slant italic))))

   ;; ============================================================
   ;; Terraform
   ;; ============================================================
   `(terraform--resource-name-face ((t (:foreground ,my-fluff))))
   `(terraform--resource-type-face ((t (:foreground ,my-active))))

   ;; ============================================================
   ;; Speedbar
   ;; ============================================================
   `(speedbar-directory-face ((t (:inherit fixed-pitch :foreground ,my-contrast))))
   `(speedbar-file-face      ((t (:inherit fixed-pitch :foreground ,my-hicontrast))))
   `(speedbar-selected-face  ((t (:foreground ,my-highlight :weight extra-bold))))
   `(speedbar-highlight-face ((t (:foreground ,my-active))))
   `(speedbar-button-face    ((t (:foreground ,my-pop))))

   ;; ============================================================
   ;; Terminal — full 16-colour ANSI set for term/multi-term/vterm
   ;; Both :foreground and :background are needed; term uses each as required
   ;; depending on whether the escape code targets fg or bg.
   ;;
   ;; blue (#6B9FD4) is intentionally distinct from cyan (my-pop) so that
   ;; ls directory colours (blue) and symlinks (cyan) are distinguishable.
   ;; ============================================================
   `(term                ((t (:inherit fixed-pitch :foreground ,my-hicontrast :background ,my-shadow))))
   `(term-bold           ((t (:weight bold))))
   `(term-underline      ((t (:underline t))))
   `(term-color-black        ((t (:foreground ,my-shadow      :background ,my-shadow))))
   `(term-color-red          ((t (:foreground ,my-warning     :background ,my-warning))))
   `(term-color-green        ((t (:foreground ,my-highlight   :background ,my-highlight))))
   `(term-color-yellow       ((t (:foreground ,my-info        :background ,my-info))))
   `(term-color-blue         ((t (:foreground "#5BC8F5"       :background "#5BC8F5"))))
   `(term-color-magenta      ((t (:foreground ,my-active      :background ,my-active))))
   `(term-color-cyan         ((t (:foreground ,my-pop         :background ,my-pop))))
   `(term-color-white        ((t (:foreground ,my-white       :background ,my-white))))
   `(term-color-bright-black   ((t (:foreground ,my-contrast    :background ,my-contrast))))
   `(term-color-bright-red     ((t (:foreground ,my-warning     :background ,my-warning))))
   `(term-color-bright-green   ((t (:foreground ,my-highlight   :background ,my-highlight))))
   `(term-color-bright-yellow  ((t (:foreground ,my-info        :background ,my-info))))
   `(term-color-bright-blue    ((t (:foreground "#8FE0FF"       :background "#8FE0FF"))))
   `(term-color-bright-magenta ((t (:foreground ,my-fluff       :background ,my-fluff))))
   `(term-color-bright-cyan    ((t (:foreground ,my-pop         :background ,my-pop))))
   `(term-color-bright-white   ((t (:foreground ,my-hicontrast  :background ,my-hicontrast))))

   ;; comint — shell prompt and input line (term-mode inherits these)
   ;; prompt: cyan bold so it stands out clearly against output
   ;; input:  full-brightness white so typed text is never ambiguous
   `(comint-highlight-prompt ((t (:foreground ,my-pop :weight bold))))
   `(comint-highlight-input  ((t (:foreground ,my-hicontrast :weight normal))))

   ) ;; end custom-theme-set-faces
  )   ;; end let

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'melancholy)

;;; melancholy-theme.el ends here
