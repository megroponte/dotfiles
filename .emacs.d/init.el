;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; デバッグ用(nil or 1)
(setq debug-on-error 1)

;(require 'cask "/usr/local/Cellar/cask/0.8.0/cask.el")
;(cask-initialize)

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get-bundle use-package)
(el-get-bundle shackle)
(el-get-bundle flycheck)
(el-get-bundle recentf-ext)
(el-get-bundle auto-complete)
(el-get-bundle ac-dabbrev)
(el-get-bundle helm)
(el-get-bundle helm-ls-git)
(el-get-bundle helm-c-yasnippet)
(el-get-bundle helm-descbinds)
(el-get-bundle yasuyk/helm-flycheck)
(el-get-bundle quickrun)
(el-get-bundle yasnippet)
(el-get-bundle haskell-mode)
(el-get-bundle ghc-mod)
(el-get-bundle direx)
(el-get-bundle emacsmirror/python-mode)
(el-get-bundle undo-tree)
(el-get-bundle which-key)
(el-get-bundle yaml-mode)
;(el-get-bundle elscreen)

;; ファイル名の指定(Mac OS)
;(when (eq system-type 'darwin)
;  (require 'ucs-normalize)
;  (setq file-name-coding-system 'utf-8-hfs)
;  (setq locale-coding-system 'utf-8-hfs)
;  ; キーボードのキー設定
;  (setq mac-option-modifier 'meta) ; OptionキーをMetaキーとしてつかう
;  (define-key global-map [165] [92]) ; \の代わりにバックスラッシュを入力する
;)

(use-package ucs-normalize
  :if (eq system-type 'darwin)
  :config
  (setq file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs)
  (setq mac-option-modifier 'meta) ; OptionキーをMetaキーとしてつかう
  (define-key global-map [165] [92]) ; \の代わりにバックスラッシュを入力する
  )

;; メニューバーを消す
(menu-bar-mode 0)

;; Defaut Directory
(setq default-directory "~/")
(setq command-line-default-directory "~/")

;; 現在行に色をつける
(global-hl-line-mode 1)
(set-face-background 'hl-line "blue")

;; 行番号を左側に表示
(global-linum-mode t)

;; yesと入力するのは面倒なのでyで十分
(defalias 'yes-or-no-p 'y-or-n-p)

;; 日本語設定 (UTF-8)
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; フォントロックモード (強調表示等) を有効にする
(global-font-lock-mode t)

;; 一時マークモードの自動有効化
(setq-default transient-mark-mode t)

;; 括弧の対応をハイライト.
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#fff00" :weight 'extra-bold)

;; 括弧を自動的に閉じる
(electric-pair-mode 1)

;; バッファ末尾に余計な改行コードを防ぐための設定
(setq next-line-add-newlines nil)

;; 時間を表示
(display-time)

;;スタートメッセージを表示しない
(setq inhibit-startup-message t)

;; BS で選択範囲を消す
(delete-selection-mode 1)

;; The local variables list in .emacs と言われるのを抑止
(add-to-list 'ignored-local-variables 'syntax)

;; cua-modeの設定(短形編集)
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; bind-key
(use-package bind-key
  :config
  (bind-keys :map ctl-x-map ; C-x
	     ("l"  . goto-line)
	     ("SPC" . cua-set-rectangle-mark)
	     ("C-j" . direx:jump-to-directory-other-window))
  (bind-key* "C-h" 'delete-backward-char) ; とにかく C-h は、1文字消す
  (bind-key "C-k" 'kill-whole-line minibuffer-local-map)) ; minibuffer 内で、C-k で行ごと消す

;; helm
(use-package helm-config
  :bind (("M-x" . helm-M-x)
	 ("C-x b" . helm-mini)
	 ("C-x C-f" . helm-find-files)
	 ("C-x C-b" . helm-buffers-list)
	 ("C-x C-r" . helm-recentf)
	 ("M-y" . helm-show-kill-ring))
  :config
  (setq helm-M-x-fuzzy-match t)
  (helm-mode 1))

;; helm-ls-git
;; https://github.com/emacs-helm/helm-ls-git
(use-package helm-ls-git
  :config
  (bind-key "C-x C-d" 'helm-browse-project)
  (bind-key "C-<f6>" 'helm-ls-git-ls))

;; helm-c-yasnippet
;; https://github.com/emacs-jp/helm-c-yasnippet
(use-package helm-c-yasnippet
  :bind (("C-c y" . helm-yas-complete))
  :config
  (setq helm-yas-space-match-any-greedy t)
  )

;(require 'yasnippet)
;(require 'helm-c-yasnippet)
;(setq helm-yas-space-match-any-greedy t)
;(global-set-key (kbd "C-c y") 'helm-yas-complete)
;(yas-global-mode 1)
;(yas-load-directory "~/.emacs.d/snippets"
;		    "~/.emacs.d/el-get/yasunippet/snippets")

;; helm-descbinds
;; https://github.com/emacs-helm/helm-descbinds
(use-package helm-descbinds
  :config
  (helm-descbinds-mode))

;; which-key
(use-package which-key
  :init
  (which-key-mode t))

;; auto-complete
(use-package auto-complete-config
  :bind (("C-o" . auto-complete))
  :config
  (ac-config-default)
  (bind-keys :map ac-complete-mode-map
	     ("C-n" . ac-next)
	     ("C-p" . ac-previous))
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (setq ac-auto-start nil))

;; ac-dabbrev
(use-package ac-dabbrev
  :config
    (add-to-list 'ac-sources 'ac-source-dabbrev))

(use-package yasnippet
  :config
  (yas-load-directory
   "~/.emacs.d/snippets"
   "~/.emacs.d/el-get/yasunippet/snippets")
  )

;; http://rubikitch.com/?s=popwin&x=0&y=0
(use-package shackle
  :bind (("C-x <left>" . winner-undo)
	 ("C-x <right>" . winner-redo))
  :init
  (winner-mode 1)
  :config
  (setq shackle-rules
	'((compilation-mode :align below :ratio 0.2)
	  ("*Help*" :align right)
	  ("*Completions*" :align below :ratio 0.3)
	  ("*helm mini*" :align below :ratio 0.7)
	  ("\*helm" :regexp t :align below :ratio 0.5)
	  ("*quickrun*" :align below :ratio 0.3)
	  ("*grep" :align below :ratio 0.3)
	  ))
  (shackle-mode 1)
;  (setq shackle-lighter "")
;  (winner-mode 1)
;  (bind-key "C-x <left>" 'winner-undo))
  )

;; undo-tree
(use-package undo-tree
  :config
  (global-undo-tree-mode))

;; recentf-ext
;; http://qiita.com/catatsuy/items/f9fad90fa1352a4d3161
(use-package recentf
  :init
   (recentf-mode)
;  (add-hook 'after-init-hook (lambda () (recentf-open-files)))
  ;:bind (("C-x C-r" . recentf-open-files))
  :config
  (setq recentf-save-file "~/.emacs.d/.recentf")
  (setq recentf-max-saved-items 500)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
;  (recentf-mode 1)
  )
(use-package recentf-ext)

;; elscreen
;(use-package elscreen
;  :config
;  (elscreen-start)
;  ; タブの左端の×を非表示
;  (setq elscreen-tab-display-kill-screen nil)
;  ;; <>を非表示
;  (setq elscreen-tab-display-control nil)
;  (elscreen-separate-buffer-list-mode 1)
;  (bind-key "C-z b" 'helm-elscreen))

;;; quickrun
;;; https://github.com/syohex/emacs-quickrun
;(require 'quickrun)
(use-package quickrun
  :bind (("C-q" . quickrun)))

;;; flycheck
;(use-package flycheck
;  :ensure t
;  :init (global-flycheck-mode))
(use-package helm-flycheck
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)  
  :config
  (eval-after-load 'flycheck
    '(define-key flycheck-mode-map (kbd "C-c @") 'helm-flycheck)))

;; python
;(autoload 'python-mode "python-mode" "Python editing mode" t)
;(custom-set-variables
; ;; custom-set-variables was added by Custom.
; ;; If you edit it by hand, you could mess it up, so be careful.
; ;; Your init file should contain only one such instance.
; ;; If there is more than one, they won't work right.
;; '(package-selected-packages (quote (flycheck)))
; '(py-indent-offset 4))
; 
;(add-hook 'python-mode-hook
; 	  '(lambda()
; 	     (setq tab-width 4)
; 	     (setq indent-tabs-mode nil)))
(use-package python-mode
  :config
  (custom-set-variables
   '(package-selected-packages (quote (flycheck)))
   '(y-indent-offset 4))
  (add-hook 'python-mode-hook
;	  'jedi:setup
	  '(lambda()
	     (setq tab-width 4)
	     (setq indent-tabs-mode nil)))
;      (setq jedi:complete-on-dot t)
  )

;; yaml
(use-package yaml-mode
  :mode (("\\.ya?ml$" . yaml-mode))
  :config
  (bind-keys :map yaml-mode-map
	     ("C-m" . newline-and-indent)))

;; for haskell
;;; haskell
;;; http://futurismo.biz/archives/2662
;(autoload 'haskell-mode "haskell-mode" nil t)
;(autoload 'haskell-cabal "haskell-cabal" nil t)
; 
;(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
;(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
;(add-to-list 'auto-mode-alist '("\\.cabal$" . haskell-cabal-mode))
; 
;;;; ghc-mod
;;;; http://hikaru515.hatenablog.com/entry/2016/09/12/021206#fn.3
;(autoload 'ghc-init "ghc" nil t)
;(autoload 'ghc-debug "ghc" nil t)
; 
;;;; indentの有効
;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;(add-hook 'haskell-mode-hook 'font-lock-mode)
;(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
; 
;;;; flycheckの有効
;(add-hook 'haskell-mode-hook
;          '(lambda ()
;             (setq flycheck-checker 'haskell-hlint)
;             (flycheck-mode 1)))
; 
;;;; ghc-modの有効
;(add-hook 'haskell-mode-hook (lambda () (ghc-init)))
; 
;(setq haskell-process-type 'stack-ghc)
;(setq haskell-program-name "/usr/local/bin/stack ghci")
; 
;;;; stack用quickrunの設定
;;;; https://github.com/syohex/emacs-quickrun
;(quickrun-add-command "haskell"
; 		      '((:command . "/usr/local/bin/stack runghc")
; 			:override t))

;;; http://futurismo.biz/archives/2662
;;; http://qiita.com/ballforest/items/111361751b4154f8ee52
(use-package haskell-mode
  :commands (haskell-cabal)
  :mode (("\\.hs$" . haskell-mode)
	 ("\\.lhs$" . literate-haskell-mode)
	 ("\\.cabel$" . haskell-cabal-mode))
  :config
  (cl-dolist (hook (list
		    'turn-on-haskell-indentation
		    'turn-on-haskell-doc-mode
		    'font-lock-mode
		    'imenu-add-menubar-index))
    (add-hook hook (lambda ()
		     (haskell-mode 1))))
  (quickrun-add-command "haskell"
			'((:command . "/usr/local/bin/stack runghc"))
			:override t)
  )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
