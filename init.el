(setq user-full-name "Thomas Dickson")

(if (string= (system-name) "craptop") 
    (setq default-directory "/home/thomas/")
    (setq user-emacs-directory "/home/thomas/.emacs.d/")
    (setq org-default-notes-file "/home/thomas/org-admin/organiser.org")
    (setq org-agenda-files (quote ("/home/thomas/org-admin"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Automatically tangle init.org on save to produce init.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar user/init-org-file (concat user-emacs-directory "init.org"))
(defvar user/init-el-file  (concat user-emacs-directory "init.el"))

(defun tangle-init ()
  "If the current buffer is 'init.org' the code-blocks are
tangled, and the tangled file is compiled."
  (when (equal (buffer-file-name)
               (expand-file-name user/init-org-file ))
    ;; Avoid running hooks when tangling.
    (let ((prog-mode-hook nil))
      (org-babel-tangle)
      (byte-compile-file user/init-el-file))))

(add-hook 'after-save-hook 'tangle-init)

(setq inhibit-startup-message t)
(scroll-bar-mode -1)                                                   ; Disable visible scrollbar
(tool-bar-mode -1)                                                     ; Disable the toolbar
(tooltip-mode -1)                                                      ; Disable tooltips
(menu-bar-mode -1)                                                     ; Disable the menu bar
(setq-default frame-title-format "%b (%f)")                            ; Show full name in title bar
(set-fringe-mode 10)                                                   ; Give some breathing room
(set-face-attribute 'default nil :font "Fira Code Retina" :height 120) ; Set default font
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)                ; Bind Esc to escape
(global-visual-line-mode t)                                            ; Wrap word at the end of line
(add-to-list 'default-frame-alist '(fullscreen . maximized))           ; Maximise emacs on start

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq backup-directory-alist '(("." . "~/.emacs.d/emacs/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(setq org-modules '(org-habit))
(eval-after-load 'org
  '(org-load-modules-maybe t))

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(global-set-key (kbd "C-c o") 
                (lambda () (interactive) (find-file "~/organiser.org")))
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
(setq org-tag-alist '(("@work" . ?w) ("@home" . ?h) ("@phys" . ?p) ("@scala" . ?s) ("@lisp" . ?l)))

;; Run/highlight code using babel in org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (lisp . t)
   (shell . t)
   (sql . t)
   ))
;; Syntax highlight in #+BEGIN_SRC blocks
(setq org-src-fontify-natively t)
;; Don't prompt before running code in org
(setq org-confirm-babel-evaluate nil)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package all-the-icons)

(use-package slime)

;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "/usr/bin/sbcl")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (slime use-package solarized-theme rainbow-delimiters org-bullets ivy doom-themes doom-modeline))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package yasnippet)

(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"))

(yas-global-mode 1)

(define-key yas-minor-mode-map [(tab)] nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)

(use-package magit
  :ensure t)

(use-package projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(use-package avy
  :ensure t
  :bind (("M-s" . avy-goto-word-1)))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
