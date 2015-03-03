;;; デバッグ用(nil or 1)
(setq debug-on-error 1)

(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)

;;; 全角スペース/タブ文字可視化
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "LightSlateGray")
(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
(set-face-background 'whitespace-tab "DarkSlateGray")

;;; 現在行に色をつける
(global-hl-line-mode 1)
;;; 色
(set-face-background 'hl-line "lightskyblue")

;;; 行番号、桁番号を表示する
;(line-number-mode t)
;(column-number-mode t)

;;; 行番号を左側に表示
(global-linum-mode t)

;;; バッテリー残量表示
;(display-battery-mode t)

;;; タイトルバーにファイルのフルパスを表示
;(setq frame-title-format "%f")

;;; yesと入力するのは面倒なのでyで十分
(defalias 'yes-or-no-p 'y-or-n-p)

;;; 日本語設定 (UTF-8)
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;;; ファイル名の指定(Mac OS)
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (setq file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;;; フォントロックモード (強調表示等) を有効にする
(global-font-lock-mode t)

;;; 一時マークモードの自動有効化
(setq-default transient-mark-mode t)

;;; 括弧の対応をハイライト.
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "red")

;;; バッファ末尾に余計な改行コードを防ぐための設定
(setq next-line-add-newlines nil) 

;;; 時間を表示
(display-time) 

;;; cua-modeの設定(短形編集)
(cua-mode t)
(setq cua-enable-cua-keys nil)
(define-key global-map (kbd "C-x SPC") 'cua-set-rectangle-mark)

;;; デフォルトの透明度を設定する
(add-to-list 'default-frame-alist '(alpha . 85))

;;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;;; カレントウィンドウの透明度を変更する
(set-frame-parameter nil 'alpha 85)

;;;スタートメッセージを表示しない
(setq inhibit-startup-message t)

;;; BS で選択範囲を消す
(delete-selection-mode 1)

;;; The local variables list in .emacs と言われるのを抑止
(add-to-list 'ignored-local-variables 'syntax) 

;;; リセットされた場合に UTF-8 に戻す
;;; http://0xcc.net/blog/archives/000041.html
(set-default-coding-systems 'utf-8)

;;; キーボードのキー設定 for MacOS X
(setq mac-option-modifier 'meta) ; OptionキーをMetaキーとしてつかう
(define-key global-map [165] nil)
(define-key global-map [67109029] nil)
(define-key global-map [134217893] nil)
(define-key global-map [201326757] nil)
(define-key function-key-map [165] [?\\])
(define-key function-key-map [67109029] [?\C-\\])
(define-key function-key-map [134217893] [?\M-\\])
(define-key function-key-map [201326757] [?\C-\M-\\])

;;; C-h でカーソルの左にある文字を消す
(define-key global-map (kbd "C-h") 'delete-backward-char)

;;; minibuffer 内で、C-k で行ごと消す
(define-key minibuffer-local-map (kbd "C-k") 'kill-whole-line)

;;; C-h に割り当てられている関数 help-command を C-x C-h に割り当てる
(define-key global-map (kbd "C-x C-h") 'help-command)

;;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
;(define-key global-map (kbd "C-t") 'other-window)

;;; "C-m"で改行とインデントを行う
;(global-set-key (kbd "C-m") 'newline-and-indent)

;;; C-x l で goto-line を実行
(define-key ctl-x-map "l" 'goto-line) 

;;; helm
;;; https://github.com/emacs-helm/helm/wiki
;;; http://emacs.tsutomuonoda.com/emacs-anything-el-helm-mode-install/
;;; http://d.hatena.ne.jp/sugyan/20140227/1393511303
(when (require 'helm-config nil t)
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (setq helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t
        helm-M-x-fuzzy-match t)
)

;;; direx
;;; http://cx4a.blogspot.jp/2011/12/popwineldirexel.html
(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)

;;; auto-complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;; ac-dabbrev
(defun ac-dabbrev-expand ()
  (interactive)
  (auto-complete '(ac-source-dabbrev)))
(global-set-key "\M-/" 'ac-dabbrev-expand)

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
(global-set-key (kbd "<f5>") 'quickrun)

;;; magit
;;; http://www.magiccircuit.com/emacs-magitメモ
(require 'magit)

;;; yasunippet
;;; http://fukuyama.co/yasnippet
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/yasnippet"))
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"))
(yas-global-mode 1)

(custom-set-variables '(yas-trigger-key "TAB"))

(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)

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
