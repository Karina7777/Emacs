
(setq-default mac-command-modifier 'C)

(global-set-key (kbd "C-x c") 'kill-ring-save)
(global-set-key (kbd "C-x p") 'yank)

(global-set-key (kbd "C--") 'undo)
(global-set-key (kbd "C-=") 'redo)


;; (setq-default indent-tabs-mode nil)

;; (setq-default tab-width 2)


(defun insert-tab ()
  "self-insert-command doesn't seem to work for tab"
  (interactive)
  (insert "\s\s"))
(setq indent-line-function 'insert-tab)  ;# for many modes
;;(define-key c-mode-base-map [tab] 'insert-tab) ;# for c/c++/java/etc.
(setq-default tab-width 2)

(setq make-backup-files nil) ; stop creating ~ files
(setq ruby-insert-encoding-magic-comment nil) ; do not add comment with coding

(add-hook 'write-file-hooks 'delete-trailing-whitespace t)

; insert line above START
(defun insert-and-indent-line-above ()
  (interactive)
  (push-mark)
  (let*
    ((ipt (progn (back-to-indentation) (point)))
     (bol (progn (move-beginning-of-line 1) (point)))
     (indent (buffer-substring bol ipt)))
    (newline)
    (previous-line)
    (insert indent)))
; insert line above END
(global-set-key (kbd "C-'") 'insert-and-indent-line-above)

(global-set-key (kbd "C-x .") 'next-multiframe-window)
(global-set-key (kbd "C-x ,") 'previous-multiframe-window)

(eval-after-load 'dired
  '(progn
     (define-key dired-mode-map (kbd "c") 'my-dired-create-file)
     (defun create-new-file (file-list)
       (defun exsitp-untitled-x (file-list cnt)
         (while (and (car file-list) (not (string= (car file-list) (concat "untitled" (number-to-string cnt) ".txt"))))
           (setq file-list (cdr file-list)))
         (car file-list))

       (defun exsitp-untitled (file-list)
         (while (and (car file-list) (not (string= (car file-list) "untitled.txt")))
           (setq file-list (cdr file-list)))
         (car file-list))

       (if (not (exsitp-untitled file-list))
           "untitled.txt"
         (let ((cnt 2))
           (while (exsitp-untitled-x file-list cnt)
             (setq cnt (1+ cnt)))
           (concat "untitled" (number-to-string cnt) ".txt")
           )
         )
       )
     (defun my-dired-create-file (file)
       (interactive
        (list (read-file-name "Create file: " (concat (dired-current-directory) (create-new-file (directory-files (dired-current-directory))))))
        )
       (write-region "" nil (expand-file-name file) t)
       (dired-add-file file)
       (revert-buffer)
       (dired-goto-file (expand-file-name file))
       )
     )
  )

;;file form youtube START

(setq show-paren-style 'expression) ; подсветка скобок
(show-paren-mode 2) ; подсветка скобок

(setq make-backup-files         nil) ; Don't want any backup files
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving

(add-to-list 'load-path "~/.emacs.d/my_own_packages")

(require 'linum+)
(setq linum-format "%d ")
(global-linum-mode 1)

;; built-in
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; теперь C-x C-f - теперь предлагает варианты файлов, C-x C-b - варианты буферов


;; built-in
(require 'bs)
(global-set-key (kbd "<f2>") 'bs-show)

(add-to-list 'load-path "~/.emacs.d/my_own_packages/popup")
(require 'popup)

(add-to-list 'load-path "~/.emacs.d/my_own_packages/auto-complete")
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/my_own_packages/auto-complete/dict")

(require 'sr-speedbar)
(global-set-key (kbd "<f12>") 'sr-speedbar-toggle)
(setq speedbar-show-unknown-files t)
(setq sr-speedbar-right-side nil)
(setq speedbar-directory-unshown-regexp "^\\(CVS\\|RCS\\|SCCS\\|\\.\\.*$\\)\\'")
(setq sr-speedbar-auto-refresh t)

(add-to-list 'load-path "~/.emacs.d/my_own_packages/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/my_own_packages/yasnippet/snippets")
(yas-global-mode 1)


;; THEMES START
;; http://www.emacswiki.org/emacs/ColorTheme ввести команду color-there и Tab
(add-to-list 'load-path "~/.emacs.d/my_own_packages/color-theme-collection/")
(require 'color-theme)

(add-to-list 'custom-theme-load-path "~/.emacs.d/my_own_packages/emacs-color-theme-solarized/")
;;(load-theme 'solarized t)

(add-to-list 'custom-theme-load-path "~/.emacs.d/my_own_packages/zenburn-theme/")
(load-theme 'zenburn t)

(add-to-list 'default-frame-alist '(font . "Emilbus Mono"))

(set-face-attribute 'default nil :height 130)
;; THEMES END


(add-to-list 'load-path "~/.emacs.d/my_own_packages/dash")
(require 'dash)

(add-to-list 'load-path "~/.emacs.d/my_own_packages/projectile")
(require 'projectile)
(projectile-global-mode)
(add-hook 'ruby-mode-hook 'projectile-mode)

(eval-after-load "hideshow"
 '(add-to-list 'hs-special-modes-alist
                `(ruby-mode
                  ,(rx (or "def" "class" "module" "{" "[")) ; Block start
                  ,(rx (or "}" "]" "end"))                  ; Block end
                  ,(rx (or "#" "=begin"))                   ; Comment start
                  ruby-forward-sexp nil)
								 ))


(require 'hideshow)

;; Set up hs-mode (HideShow) for Ruby
(add-to-list 'hs-special-modes-alist
             `(ruby-mode
							 ,(rx (or "def" "class" "module" "do")) ; Block start
               ,(rx (or "end"))                       ; Block end
               ,(rx (or "#" "=begin"))                ; Comment start
               ruby-forward-sexp nil))

(add-hook 'ruby-mode-hook 'hs-minor-mode)

(global-set-key (kbd "<f9>") 'hs-toggle-hiding)
(global-set-key (kbd "C-<f9>") 'hs-hide-all)
(global-set-key (kbd "C-S-<f9>") 'hs-show-all)

(global-set-key (kbd "C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<down>") 'shrink-window)
(global-set-key (kbd "C-<up>") 'enlarge-window)

(add-to-list 'load-path "~/.emacs.d/my_own_packages/slim")
(require 'slim-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(setq web-mode-extra-snippets
      '(("erb" . (("toto" . ("<% toto | %>\n\n<% end %>"))))
        ("php" . (("dowhile" . ("<?php do { ?>\n\n<?php } while (|); ?>"))
                  ("debug" . ("<?php error_log(__LINE__); ?>"))))
       ))

(setq web-mode-enable-css-colorization t)
(setq web-mode-enable-current-column-highlight t)

(setq web-mode-ac-sources-alist
  '(("php" . (ac-source-yasnippet ac-source-php-auto-yasnippets))
    ("html" . (ac-source-emmet-html-aliases ac-source-emmet-html-snippets))
    ("css" . (ac-source-css-property ac-source-emmet-css-snippets))))

(add-hook 'web-mode-before-auto-complete-hooks
          '(lambda ()
             (let ((web-mode-cur-language
                    (web-mode-language-at-pos)))
               (if (string= web-mode-cur-language "php")
                   (yas-activate-extra-mode 'php-mode)
                 (yas-deactivate-extra-mode 'php-mode))
               (if (string= web-mode-cur-language "css")
                   (setq emmet-use-css-transform t)
                 (setq emmet-use-css-transform nil)))))

(setq-default cursor-type 'bar)
(blink-cursor-mode 0)
(set-cursor-color "#C31A1A")
