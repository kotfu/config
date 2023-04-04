(deftheme noctis-obscuro
  "Created 2023-04-03.")

(custom-theme-set-faces
 'noctis-obscuro
 '(default ((t (:family "default" :foundry "default" :width normal :height 1 :weight normal :slant normal :underline nil :overline nil :extend nil :strike-through nil :box nil :inverse-video nil :foreground "#b2cacd" :background "#031417" :stipple nil :inherit nil))))
 '(cursor ((t (:background "#91ddff"))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial")) (t (:family "Sans Serif"))))
 '(escape-glyph ((((background dark)) (:foreground "cyan")) (((type pc)) (:foreground "magenta")) (t (:foreground "brown"))))
 '(homoglyph ((((background dark)) (:foreground "cyan")) (((type pc)) (:foreground "magenta")) (t (:foreground "brown"))))
;; todo
 '(minibuffer-prompt ((t (:foreground "#09ecff"))))
;; todo
 '(highlight ((t (:foreground "#b2cacd" :background "#073a41"))))
 '(region ((t (:extend t :background "#073a41"))))
;; todo
 '(shadow ((t (:foreground "#cbe3e7"))))
;; todo
 '(secondary-selection ((t (:extend t :foreground "#100e23" :background "#91ddff"))))
;; todo
 '(trailing-whitespace ((t (:background "#ff5458"))))
 '(font-lock-builtin-face ((t (:slant italic :foreground "#df769b"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#5b858b"))))
 '(font-lock-comment-face ((t (:foreground "#5b858b"))))
 '(font-lock-constant-face ((t (:foreground "#d5971a"))))
 '(font-lock-doc-face ((t (:foreground "#ff0000"))))
 '(font-lock-doc-markup-face ((t (:inherit (font-lock-constant-face)))))
 '(font-lock-function-name-face ((t (:foreground "#16a3b6"))))
 '(font-lock-keyword-face ((t (:weight bold :foreground "#df769b"))))
;; todo
 '(font-lock-negation-char-face ((t (:weight bold :foreground "#63f2f1"))))
;; todo
 '(font-lock-preprocessor-face ((t (:weight bold :foreground "#63f2f1"))))
;; todo
 '(font-lock-regexp-grouping-backslash ((t (:weight bold :foreground "#63f2f1"))))
;; todo
 '(font-lock-regexp-grouping-construct ((t (:weight bold :foreground "#63f2f1"))))
 '(font-lock-string-face ((t (:weight bold :foreground "#49e9A6"))))
;; todo
 '(font-lock-type-face ((t (:foreground "#91ddff"))))
 '(font-lock-variable-name-face ((t (:foreground "#e4b781"))))
;; todo from here down
 '(font-lock-warning-face ((t (:inherit (warning)))))
 '(button ((t (:inherit (link)))))
 '(link ((((class color) (min-colors 88) (background light)) (:underline (:color foreground-color :style line) :foreground "RoyalBlue3")) (((class color) (background light)) (:underline (:color foreground-color :style line) :foreground "blue")) (((class color) (min-colors 88) (background dark)) (:underline (:color foreground-color :style line) :foreground "cyan1")) (((class color) (background dark)) (:underline (:color foreground-color :style line) :foreground "cyan")) (t (:inherit (underline)))))
 '(link-visited ((default (:inherit (link))) (((class color) (background light)) (:foreground "magenta4")) (((class color) (background dark)) (:foreground "violet"))))
 '(fringe ((t (:foreground "#565575" :inherit (default)))))
 '(header-line ((t (:inherit (mode-line)))))
 '(tooltip ((t (:foreground "#cbe3e7" :background "#100e23"))))
 '(mode-line ((t (:foreground "#09ecff" :background "#073a41"))))
 '(mode-line-buffer-id ((t (:weight bold))))
 '(mode-line-emphasis ((t (:weight bold))))
 '(mode-line-highlight ((((supports :box t) (class color) (min-colors 88)) (:box (:line-width (2 . 2) :color "grey40" :style released-button))) (t (:inherit (highlight)))))
 '(mode-line-inactive ((t (:foreground "#565575" :background "#100e23"))))
 '(isearch ((t (:weight bold :foreground "#100e23" :background "#aaffe4"))))
 '(isearch-fail ((((class color) (min-colors 88) (background light)) (:background "RosyBrown1")) (((class color) (min-colors 88) (background dark)) (:background "red4")) (((class color) (min-colors 16)) (:background "red")) (((class color) (min-colors 8)) (:background "red")) (((class color grayscale)) (:foreground "grey")) (t (:inverse-video t))))
 '(lazy-highlight ((t (:foreground "#cbe3e7" :background "#65b2ff"))))
 '(match ((t (:weight bold :foreground "#95ffa4" :background "#100e23"))))
 '(next-error ((t (:inherit (region)))))
 '(query-replace ((t (:inherit (isearch))))))

(provide-theme 'noctis-obscuro)
