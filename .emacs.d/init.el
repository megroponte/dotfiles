;;; デバッグ用(nil or 1)
(setq debug-on-error 1)

(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)

;;; ファイル名の指定(Mac OS)
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (setq file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs)

  ;; キーボードのキー設定
  (setq mac-option-modifier 'meta) ; OptionキーをMetaキーとしてつかう
  (define-key global-map [165] [92]) ; \の代わりにバックスラッシュを入力する
)

;;; 現在行に色をつける
(global-hl-line-mode 1)
(set-face-background 'hl-line "lightskyblue")

;;; 行番号を左側に表示
(global-linum-mode t)

;;; yesと入力するのは面倒なのでyで十分
(defalias 'yes-or-no-p 'y-or-n-p)

;;; 日本語設定 (UTF-8)
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;;; フォントロックモード (強調表示等) を有効にする
(global-font-lock-mode t)

;;; 一時マークモードの自動有効化
(setq-default transient-mark-mode t)

;;; 括弧の対応をハイライト.
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#fff00" :weight 'extra-bold)

;;; バッファ末尾に余計な改行コードを防ぐための設定
(setq next-line-add-newlines nil) 

;;; 時間を表示
(display-time) 

;;;スタートメッセージを表示しない
(setq inhibit-startup-message t)

;;; BS で選択範囲を消す
(delete-selection-mode 1)

;;; The local variables list in .emacs と言われるのを抑止
(add-to-list 'ignored-local-variables 'syntax) 

;;; cua-modeの設定(短形編集)
(cua-mode t)
(setq cua-enable-cua-keys nil)

;;; helm
(require 'helm-config)
(helm-mode 1)  
(setq helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t
	helm-M-x-fuzzy-match t)
 
;;; direx
;;; http://cx4a.blogspot.jp/2011/12/popwineldirexel.html
(require 'direx)

;;; auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(setq ac-auto-start nil)
(ac-config-default)

;;; ac-dabbrev
(require 'ac-dabbrev)
(add-to-list 'ac-sources 'ac-source-dabbrev)

;;; popwin
;;; http://d.hatena.ne.jp/m2ym/20110120/1295524932
;;; https://github.com/m2ym/popwin-el/blob/master/README.md
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
;; direx
(push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)
;; grep
(push '("*grep*" :noselect t) popwin:special-display-config)
;; helm
(setq helm-samewindow nil)
(push '("*helm-mini*" :height 20) popwin:special-display-config)

;;; recentf-ext
(require 'recentf)
(setq recentf-save-file "~/.emacs.d/.recentf")
(setq recentf-max-save-times 1000)
(setq recentf-exclude '(".recentf"))
(setq recentf-auto-cleanup 10)
(run-with-idle-timer 30 t 'recentf-save-list)
(require 'recentf-ext)

;;; quickrun
;;; https://github.com/syohex/emacs-quickrun
(require 'quickrun)
(push '("*quickrun*") popwin:special-display-config)

;;; magit
;;; http://www.magiccircuit.com/emacs-magitメモ
(require 'magit)

;;; yasunippet
;;; http://fukuyama.co/yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
	"~/.emacs.d/.cask/24.4.1/elpa/yasnippet-20150212.240/snippets"))
(yas-global-mode 1)

(custom-set-variables '(yas-trigger-key "TAB"))

;;; bind-key
(require 'bind-key)
(bind-keys :map global-map
           ("M-?" . help-for-help)
           ("C-/" . undo)
           ("C-q" . quickrun)
           ("M-x" . helm-M-x)
           ("C-o" . auto-complete))

;; とにかく C-h は、1文字消す
(bind-key* "C-h" 'delete-backward-char)

;; minibuffer 内で、C-k で行ごと消す
(bind-key "C-k" 'kill-whole-line minibuffer-local-map)

;; C-x
(bind-keys :map ctl-x-map
           ("l"  . goto-line)
           ("SPC" . cua-set-rectangle-mark)
           ("C-j" . direx:jump-to-directory-other-window)
           ("b" . helm-mini)
           ("C-f" . helm-find-files)
           ("C-b" . helm-buffers-list))

;; helm
(bind-key "TAB" 'helm-execute-persistent-action helm-find-files-map)
(bind-key "TAB" 'helm-execute-persistent-action helm-read-file-map)

;; yasnippet
(bind-keys :prefix-map yas-minor-mode-map
           :prefix "C-x i"
           ("i" . yas-insert-snippet)
           ("n" . yas-new-snippet)
           ("v" . yas-visit-snippet-file))

;; auto-complete
(bind-keys :map ac-completing-map
           ("C-n" . ac-next)
           ("C-p" . ac-previous))

;;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
;; for haskell
(add-hook 'haskell-mode-hook
          '(lambda ()
             (setq flycheck-checker 'haskell-hlint)
             (flycheck-mode 1)))

;;; haskell
;;; http://futurismo.biz/archives/2662
(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'haskell-cabal "haskell-cabal" nil t)

(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal$" . haskell-cabal-mode))

;; indentの有効
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
