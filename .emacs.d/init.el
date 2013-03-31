;;; デバッグ用(nil or 1)
(setq debug-on-error nil)

(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))

;;; パスを設定する関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;;; パスの設定
(add-to-load-path "conf" "el-get" "elisp" "public_repos" "info" "elisp/apel" "elisp/emu")

;;; ELPA(package.el)の設定
(when (require 'package nil t)
  (add-to-list 'package-archives
	       '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  (package-initialize))

;;; el-get
;;; http://shishithefool.blogspot.jp/2012/04/el-get-emacs.html
(when (require 'el-get nil t)
;(setq el-get-sources
; 	'(
; 	  (:name ruby-mode-trunk-head
; 		 :type http
; 		 :description "Major mode for editing Ruby files. (trunk-head)"
; 		 :url "http://bugs.ruby-lang.org/projects/ruby-trunk/repository/raw/misc/ruby-mode.el")
; 	  (:name php-mode-github
; 		 :type github
; 		 :website "https://github.com/ejmr/php-mode"
; 		 :description "Major mode for editing PHP files. (on Github based on SourceForge version))"
; 		 :pkgname "ejmr/php-mode")
; 	  (:name multi-web-mode
; 		 :type git
; 		 :website "https://github.com/fgallina/multi-web-mode"
; 		 :description "Multi Web Mode is a minor mode wich makes web editing in Emacs much easier."
; 		 :url "git://github.com/fgallina/multi-web-mode.git")
; 	  ))
  (el-get 'sync))

;;; auto-installの設定
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;;; 現在行に色をつける
(global-hl-line-mode 1)
;;; 色
(set-face-background 'hl-line "lightskyblue")

;;; 行番号、桁番号を表示する
(line-number-mode t)
(column-number-mode t)

;;; 行番号を左側に表示
(global-linum-mode t)

;;; バッテリー残量表示
(display-battery-mode t)

;;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;;; yesと入力するのは面倒なのでyで十分
(defalias 'yes-or-no-p 'y-or-n-p)

;;; ツールバーとスクロールバーを消す
(tool-bar-mode -1)
(scroll-bar-mode -1)

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

;;; C-x l で goto-line を実行
(define-key ctl-x-map "l" 'goto-line) 

;;; 時間を表示
(display-time) 

;;; cua-modeの設定(短形編集)
(cua-mode t)
(setq cua-enable-cua-keys nil)

;;; デフォルトの透明度を設定する
(add-to-list 'default-frame-alist '(alpha . 85))

;;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;;; カレントウィンドウの透明度を変更する
(set-frame-parameter nil 'alpha 85)

;;; C-h でカーソルの左にある文字を消す
(define-key global-map "\C-h" 'delete-backward-char)

;;; C-h に割り当てられている関数 help-command を C-x C-h に割り当てる
(define-key global-map "\C-x\C-h" 'help-command)

;;; C-o に動的略語展開機能を割り当てる
(define-key global-map "\C-o" 'dabbrev-expand)
(setq dabbrev-case-fold-search nil) ; 大文字小文字を区別 

;;; OptionキーをMetaキーとしてつかう
;;; http://homepage.mac.com/zenitani/emacs-j.html
(setq mac-option-modifier 'meta)

;;;http://3daimenushi.blog112.fc2.com/blog-entry-126.html
;;;スタートメッセージを表示しない
(setq inhibit-startup-message t)

;;; 日本語・英語混じり文での区切判定
;;; http://www.alles.or.jp/~torutk/oojava/meadow/Meadow210Install.html
(defadvice dabbrev-expand
  (around modify-regexp-for-japanese activate compile)
  "Modify `dabbrev-abbrev-char-regexp' dynamically for Japanese words."
  (if (bobp)
      ad-do-it
    (let ((dabbrev-abbrev-char-regexp
           (let ((c (char-category-set (char-before))))
             (cond 
              ((aref c ?a) "[-_A-Za-z0-9]") ; ASCII
              ((aref c ?j) ; Japanese
               (cond
                ((aref c ?K) "\\cK") ; katakana
                ((aref c ?A) "\\cA") ; 2byte alphanumeric
                ((aref c ?H) "\\cH") ; hiragana
                ((aref c ?C) "\\cC") ; kanji
                (t "\\cj")))
              ((aref c ?k) "\\ck") ; hankaku-kana
              ((aref c ?r) "\\cr") ; Japanese roman ?
              (t dabbrev-abbrev-char-regexp)))))
      ad-do-it)))

;;; BS で選択範囲を消す
(delete-selection-mode 1)

;;; The local variables list in .emacs と言われるのを抑止
(add-to-list 'ignored-local-variables 'syntax) 

;;; リセットされた場合に UTF-8 に戻す
;;; http://0xcc.net/blog/archives/000041.html
(set-default-coding-systems 'utf-8)

;;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)

;;; "C-m"で改行とインデントを行う
(global-set-key (kbd "C-m") 'newline-and-indent)

;;; キーボードのキー設定
;;; http://cgi.netlaputa.ne.jp/~kose/diary/?20090806
(define-key global-map [165] nil)
(define-key global-map [67109029] nil)
(define-key global-map [134217893] nil)
(define-key global-map [201326757] nil)
(define-key function-key-map [165] [?\\])
(define-key function-key-map [67109029] [?\C-\\])
(define-key function-key-map [134217893] [?\M-\\])
(define-key function-key-map [201326757] [?\C-\M-\\])

;;; 日本語フォントをOsakaに
(set-fontset-font
 nil 'japanese-jisx0208
 (font-spec :family "Osaka"))

;;; multi-term
(when (require 'multi-term nil t)
  (setq term-unbind-key-list '("C-x" "C-c" "<ESC>"))
  (setq term-bind-key-alist
	'(("C-c C-c" . term-interrupt-subjob)
	  ("C-m" . term-send-raw)
	  ("M-f" . term-send-forward-word)
	  ("M-b" . term-send-backward-word)
	  ("M-o" . term-send-backspace)
	  ("M-p" . term-send-up)
	  ("M-n" . term-send-down)
	  ("M-M" . term-send-forward-kill-word)
	  ("M-N" . term-send-backward-kill-word)
	  ("M-r" . term-send-reverse-search-history)
	  ("M-," . term-send-input)
	  ("M-." . comint-dynamic-complete))))

;;; anything
;;; (auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   anything-idle-delay 0.3
   anything-input-idle-delay 0.2
   anything-candidate-number-limit 100
   anything-quick-update t
   anything-enable-shortcuts 'alphabet))

;; anything global keymap
(define-key global-map(kbd "\C-x b") 'anything)

(when (require 'anything-config nil t)
  (setq anything-su-or-sudo "sudo"))

(require 'anything-match-plugin nil t)

(when (and (executable-find "cmigemo")
	   (require 'migemo nil t))
  (require 'anything-migemo nil t))

(when (require 'anything-complete nil t)
  (anything-lisp-complete-symbol-set-timer 150))

(require 'anything-show-completion nil t)

(when (require 'auto-install nil t)
  (require 'anything-auto-install nil t))

(when (require 'descbinds-anything nil t)
  (descbinds-anything-install))

;;; auto-complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
	       "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;; elscreenの設定
(when (require 'elscreen nil t)
  (if window-system
      (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
    (define-key elscreen-map (kbd "C-z") 'suspend-emacs)))

;;; GitフロントエンドEggの設定
;;; https://github.com/bogolisk/egg/wiki
(when (executable-find "git")
  (require 'egg nil t))

;;; http://d.hatena.ne.jp/m2ym/20110120/1295524932
;;; https://github.com/m2ym/popwin-el/blob/master/README.md
;;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
;; anything
(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)
;; M-x dired-jump-other-window
(require 'dired-x)
(push '(dired-mode :position top) popwin:special-display-config)
;; grep
(push '("*grep*" :noselect t) popwin:special-display-config)
;; egg
(push '(egg-status-buffer-mode :position bottom :height 20) popwin:special-display-config)
(push '(egg-log-buffer-mode :position bottom :height 20) popwin:special-display-config)
(push '(egg-file-log-buffer-mode :position bottom :height 20) popwin:special-display-config)
(push '(egg-reflog-buffer-mode :position bottom :height 20) popwin:special-display-config)
(push '(egg-diff-buffer-mode :position bottom :height 20) popwin:special-display-config)
(push '(egg-commit-buffer-mode :position bottom :height 20) popwin:special-display-config)
(push '("*vc-change-log*" :position bottom :height 20) popwin:special-display-config)

;;; Ruby
(require 'ruby-electric nil t)
(when (require 'ruby-block nil t)
  (setq ruby-block-heighlight-toggle t))
(autoload 'run-ruby "inf-ruby"
  "Run as inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

(defun ruby-mode-hooks ()
  (inf-ruby-keys)
  (ruby-electric-mode t)
  (ruby-block-mode t))
(add-hook 'ruby-mode 'ruby-mode-hooks)

;;; rvm
;;; https://github.com/senny/rvm.el
(when (require 'rvm nil t)
  (rvm-use-default))

;;; Ruby flymake
(when (require 'flymake nil t)
  (defun flymake-ruby-init ()
    (list "ruby" (list "-c" (flymake-init-create-temp-buffer-copy
			     'flymake-create-temp-inplace))))

  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.rb\\'" flymake-ruby-init))
  (add-to-list 'flymake-err-line-patterns
	       '(\\"(.*\\):(\\([0-9]+\\)): \\(.*\\)" 1 2 nil 3)))

;;; javascript
(defun js-indent-hook()
  (setq js-indent-level 2
	js-expr-indent-offset 2
	indent-tabs-mode nil)
  (defun my-js-indent-line ()
    (intercactive)
    (let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
	   (offset (- (current-column) (current-identation)))
	   (indentation (js--proper-indentation parse-status)))
      (back-to-indentation)
      (if (looking-at "case\\s-")
	  (indeint-line-to (+ indentation 2))
	(js-indent-line))
      (when (> offset 0) (forward-char offset))))
  (set (make-level-variable 'indent-line-function) 'my-js-indent-line)
  )

(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
(add-hook 'js2-mode-hook 'js-indent-hook)
