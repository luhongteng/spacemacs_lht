;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here


;;========================= additional packages ========================;;

(add-to-list 'load-path "~/.emacs.d/my_packages/")
(load "column-marker")

(setq my-favourite-package '(ace-link
   ace-window adaptive-wrap aggressive-indent anaconda-mode anzu archives
   async auto-compile auto-highlight-symbol
   avy bind-key bind-map clean-aindent-mode
    column-enforce-mode company counsel
    counsel-projectile cython-mode dash
    dash dash-functional define-word

    diminish dumb-jump elisp-slime-nav
    elpl elpy emmet-mode epl
    eval-sexp-fu evil evil-anzu evil-args evil-ediff
    evil-escape evil-exchange evil-iedit-state evil-indent-plus
    evil-lisp-state evil-matchit evil-mc evil-nerd-commenter
    evil-numbers evil-search-highlight-persist evil-surround
    evil-tutor evil-unimpaired evil-visual-mark-mode evil-visualstar
    exec-path-from-shell expand-region eyebrowse f fancy-battery
    fill-column-indicator flx flx-ido flycheck gh-md ghub git-commit
    golden-ratio google-translate goto-chg graphviz-dot-mode haml-mode helm
    helm-core helm-make highlight highlight-indentation highlight-numbers
    highlight-parentheses hl-todo hungry-delete hy-mode hydra
    iedit indent-guide ivy ivy-hydra link-hint linum-relative
    live-py-mode lorem-ipsum lv macrostep magit magit-popup
    markdown-mode markdown-toc mmm-mode move-text neotree
    open-junk-file org-bullets org-clock-convenience org-plus-contrib
    packed paradox parent-mode parrot pcre2el persp-mode pip-requirements
    pkg-info popup popwin powerline projectile pug-mode py-isort pyenv-mode
    pytest pythonic pyvenv rainbow-delimiters request restart-emacs s
    sass-mode scss-mode slim-mode smartparens smex spaceline spinner swiper
    tagedit toc-org transient treepy undo-tree use-package uuidgen vi-tilde-fringe
    volatile-highlights web-mode wgrep which-key winum with-editor ws-butler
    yapfify yasnippet thingatpt diff-hl
    helm-ag;;depend on ag: brew install ag

    ))


(package-initialize)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
; (mapc #'package-install my-favourite-package)
                                        ; (elpy-enable)


;;========================= additional packages ========================;;

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))
(setq elpy-rpc-ignored-buffer-size 204800)

(defconst spacemacs-version         "0.200.13" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))

(setq frame-title-format
      '(""
        "%b"
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format " in [%s]" project-name))))))

;; (setq frame-title-format
;;       (list (format "%s %%S: %%j " (system-name))
;;             '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;;========================= file path dir ========================;;
(defun my/copy-cur-file-dir ()
  "Copy the current directory into the kill ring."
  (interactive)
  (kill-new default-directory))

(defun my/open-cur-file-in-finder ()
  (interactive)
  (shell-command "open -R ."))
;;========================= file path dir ========================;;

;;========================= org-mode ========================;;

(setq-default org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3));;org agenda views clock report max level customlize

(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "STARTED(s)" "|" "DONE(d!)" "CANCELED(c@)")
        (sequence "PROJECT(P)" "DEV(e)" "WAIT(w@/!)" "|" "TESTING(T!)" "CANCELED(c@)" "DELEGATED(D@/!)" "DONE(d!)")
        (sequence "REPORT(r@/!)" "BUG(b@/!)" "|" "FIXED(f!)" "NOTBUG(n@/!)")
        (sequence "STUDY(S)" "LEARNING(l!)" "REVIEW(v!)" "|" "DONE(d!)")
        (sequence "Idle(I)" "|")
        )
      )
(setq org-tag-alist '(("@work" . ?w) ("@life" . ?l) ("@habit" . ?h) ("@task" . ?t)))
(setq org-capture-templates
      '(
        ;task inbox templates
        ("t" "task group")
        ("tw" "work item to inbox" entry (file+headline "~/Desktop/GTD/inbox.org" "work")
         "* TODO %?\n  %i")
        ("tt" "tech item to inbox" entry (file+headline "~/Desktop/GTD/inbox.org" "tech")
         "* TODO %?\n  %i")
        ("tl" "life item to inbox" entry (file+headline "~/Desktop/GTD/inbox.org" "life")
         "* TODO %?\n  %i")
        ("r" "remind" entry (file+datetree "~/Desktop/GTD/remind.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ;;time record template
        ("i" "idle group")
        ("is" "idle record smoke"  list (file+datetree "~/Desktop/GTD/idle.org" "smoke")
         "%?" :clock-in t :clock-resume t)
        ("in" "idle_record nothing" list (file+datetree "~/Desktop/GTD/idle.org" "nothing") "%?"
         :clock-in t :clock-resume t)
        ("ig" "idle_record game" list (file+datetree "~/Desktop/GTD/idle.org" "game") "%?"
         :clock-in t :clock-resume t)
        ("iv" "idle_record video" list (file+datetree "~/Desktop/GTD/idle.org" "video") "%?"
         :clock-in t :clock-resume t)
        ("ie" "idle_record eat" list (file+datetree "~/Desktop/GTD/idle.org" "eat") "%?"
         :clock-in t :clock-resume t)
        ("ii" "idle_record infomation" list (file+datetree "~/Desktop/GTD/idle.org" "infomation") "%?"
         :clock-in t :clock-resume t)
        ("ib" "idle_record bath" list (file+datetree "~/Desktop/GTD/idle.org" "bath") "%?"
         :clock-in t :clock-resume t)
        )

      )

(add-to-list 'default-frame-alist '(fullscreen . maximized));;configure the initial window size to full screen

(global-set-key (kbd "M-x") 'helm-M-x);;use helm-M-x instead

(defun lht/org-agenda-mode-fn ()
  (define-key org-agenda-mode-map
    (kbd "<S-up>") #'org-clock-convenience-timestamp-up)
  (define-key org-agenda-mode-map
    (kbd "<S-down>") #'org-clock-convenience-timestamp-down)
  (define-key org-agenda-mode-map
    (kbd "<S-f>") #'org-clock-convenience-fill-gap)
  (define-key org-agenda-mode-map
    (kbd "<S-F>") #'org-clock-convenience-fill-gap-both))
(add-hook 'org-agenda-mode-hook #'lht/org-agenda-mode-fn)

(add-hook 'org-mode-hook
          (lambda ()
            (define-key org-mode-map (kbd "C-c j") 'org-clock-in)
            (define-key org-mode-map (kbd "C-c k") 'org-clock-out)
            (define-key org-mode-map (kbd "C-c r") 'org-clock-update-time-maybe)
            )
          )


;; https://github.com/tumashu/cnfonts
(require 'cnfonts)
;; 让 cnfonts 随着 Emacs 自动生效。
(cnfonts-enable)
;; 让 spacemacs mode-line 中的 Unicode 图标正确显示。
;; (cnfonts-set-spacemacs-fallback-fonts)

;;========================= org-mode ========================;;


;;========================= key-binding =====================;;

(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)


;;text edit
(global-set-key (kbd "C-_") 'undo-tree-undo)
(global-set-key (kbd "C-+") 'undo-tree-redo)


;;↓↓↓↓↓↓↓↓↓↓↓↓↓ mark cur word ↓↓↓↓↓↓↓↓↓↓↓↓↓;;
(defun mark-whole-word (&optional arg allow-extend)
  "Like `mark-word', but selects whole words and skips over whitespace.
If you use a negative prefix arg then select words backward.
Otherwise select them forward.

If cursor starts in the middle of word then select that whole word.

If there is whitespace between the initial cursor position and the
first word (in the selection direction), it is skipped (not selected).

If the command is repeated or the mark is active, select the next NUM
words, where NUM is the numeric prefix argument.  (Negative NUM
selects backward.)"
  (interactive "P\np")
  (let ((num  (prefix-numeric-value arg)))
    (unless (eq last-command this-command)
      (if (natnump num)
          (skip-syntax-forward "\\s-")
        (skip-syntax-backward "\\s-")))
    (unless (or (eq last-command this-command)
                (if (natnump num)
                    (looking-at "\\b")
                  (looking-back "\\b")))
      (if (natnump num)
          (left-word)
        (right-word)))
    (mark-word arg allow-extend)))
(global-set-key [remap mark-word] 'mark-whole-word)
;;↑↑↑↑↑↑↑↑↑↑↑ mark cur word ↑↑↑↑↑↑↑↑↑↑↑↑↑;;

;;code navigating
(global-set-key (kbd "s-b") 'pop-tag-mark)
(global-set-key (kbd "C-c l") 'goto-line)
(global-set-key (kbd "C-a") 'back-to-indentation)


;;window or buffer managment
(global-set-key (kbd "C-x p") 'previous-buffer)
(global-set-key (kbd "C-x n") 'next-buffer)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "M-j") 'neotree)
(global-set-key (kbd "M-J") 'neotree-hide)
(global-set-key (kbd "C-x k") 'kill-buffer-and-window)



;;projectile
(global-set-key (kbd "C-c C-f") 'projectile--find-file)


;;imenu
(global-unset-key (kbd "C-c j"))
(global-set-key (kbd "C-c u") #'imenu)

;;search
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-c s") 'helm-do-ag-project-root)

;;highlight symbol key-binding
(global-set-key (kbd "C-c C-h") 'highlight-symbol)


;;comment
(global-set-key (kbd "C-c C-/") 'spacemacs/comment-or-uncomment-lines)
(global-set-key (kbd "C-{") 'shrink-window-horizontally)
(global-set-key (kbd "C-}") 'enlarge-window-horizontally)


;;========================= coding ===========================;;

(delete-selection-mode 1)

;;_不再是当做 word seperator 极度好用0.0
(defun underline-in-word () (modify-syntax-entry ?_ "w"))
(add-hook 'python-mode-hook 'underline-in-word)

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;;;80 column
(require 'column-marker)
(add-hook 'python-mode-hook (lambda () (interactive) (column-marker-1 121)))

;;;; 设置编辑环境
;; Enable line numbers globally
;;目前会导致 py 文件有两个line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
;; 设置为中文简体语言环境
(set-language-environment 'Chinese-GB)
;; 设置emacs 使用 utf-8
(setq locale-coding-system 'utf-8)
;; 设置键盘输入时的字符编码
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
;; 文件默认保存为 utf-8
(set-buffer-file-coding-system 'utf-8)
(set-default buffer-file-coding-system 'utf8)
(set-default-coding-systems 'utf-8)
;; 解决粘贴中文出现乱码的问题
(set-clipboard-coding-system 'utf-8)
;; 终端中文乱码
(set-terminal-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
;; 解决文件目录的中文名乱码
(setq-default pathname-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
;; 解决 Shell Mode(cmd) 下中文乱码问题
(defun change-shell-mode-coding ()

  (progn
    (set-terminal-coding-system 'gbk)
    (set-keyboard-coding-system 'gbk)
    (set-selection-coding-system 'gbk)
    (set-buffer-file-coding-system 'gbk)
    (set-file-name-coding-system 'gbk)
    (modify-coding-system-alist 'process "*" 'gbk)
    (set-buffer-process-coding-system 'gbk 'gbk)
    (set-file-name-coding-system 'gbk)
    )
  )


;;projectile https://docs.projectile.mx/projectile/configuration.html
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-project-search-path '("~/projects/"))
;;(setq projectile-sort-order 'recently-active);;To sort files by recently active buffers and then recently opened files:
(setq projectile-enable-caching t);;Since indexing a big project is not exactly quick (especially in Emacs Lisp), Projectile supports caching of the project’s files. The caching is enabled by default whenever native indexing is enabled.To enable caching unconditionally use this snippet of code:


;;========================= python ===========================;;
(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

(eval-after-load 'python
  '(progn
     (define-key python-mode-map (kbd "C-c C-f") nil)
     (define-key python-mode-map (kbd "C-c C-s") nil)
     ))
(eval-after-load 'python
  '(progn
     (define-key elpy-mode-map (kbd "C-c C-s") nil)))

(defun goto-def-or-helm-do-ag ()
  "Go to definition of thing at point or do an rgrep in project if that fails"
  (interactive)
  (condition-case nil (elpy-goto-assignment)
    (error (helm-do-ag-project-root (thing-at-point 'symbol)))))

(add-hook 'elpy-mode-hook
          (lambda ()
            (local-unset-key (kbd "M-TAB"))

            ;;code navigating
            (define-key elpy-mode-map (kbd "s-j") 'goto-def-or-helm-do-ag)
            )
          )

;;========================= coding ===========================;;

;;========================= window/buffer ===========================;;
(require 'ace-window)
(setq aw-ignore-on 1)
(setq neo-window-fixed-size nil)
(add-to-list 'aw-ignored-buffers "*NeoTree*")
(global-set-key (kbd "C-c o") 'ace-window)



(global-set-key (kbd "M-r") 'recentf-open-files)


;;↓↓↓↓↓↓↓↓↓ignore buffers when switch next or previous buffer
(defcustom my-skippable-buffers '("*Messages*" "*scratch*" "*Help*")
  "Buffer names ignored by `my-next-buffer' and `my-previous-buffer'."
  :type '(repeat string))

(defun my-change-buffer (change-buffer)
  "Call CHANGE-BUFFER until current buffer is not in `my-skippable-buffers'."
  (let ((initial (current-buffer)))
    (funcall change-buffer)
    (let ((first-change (current-buffer)))
      (catch 'loop
        (while (member (buffer-name) my-skippable-buffers)
          (funcall change-buffer)
          (when (eq (current-buffer) first-change)
            (switch-to-buffer initial)
            (throw 'loop t)))))))

(defun my-next-buffer ()
  "Variant of `next-buffer' that skips `my-skippable-buffers'."
  (interactive)
  (my-change-buffer 'next-buffer))

(defun my-previous-buffer ()
  "Variant of `previous-buffer' that skips `my-skippable-buffers'."
  (interactive)
  (my-change-buffer 'previous-buffer))

(global-set-key [remap next-buffer] 'my-next-buffer)
(global-set-key [remap previous-buffer] 'my-previous-buffer)
;;↑↑↑↑↑↑↑↑ignore buffers when switch next or previous buffer


;;========================= window/buffer ===========================;;



;;========================= shell ===========================;;
;;fix term '%' char after return
(setq system-uses-terminfo nil)
;;========================= shell ===========================;;

;;========================= helm ===========================;;
;;fix helm duplicate commands history
(setq history-delete-duplicates t)
(setq helm-ag-use-agignore 1)
;;========================= helm ===========================;;

;;========================= theme ========================;;
(load-theme 'misterioso)
;;========================= theme ========================;;

;;========================= tramp ========================;;
(setq tramp-verbose 10)
;;========================= tramp ========================;;

;;========================= neotree =========================;;
;;当执行 projectile-switch-project (C-c p p) 时，NeoTree 会自动改变根目录。
;;(setq projectile-switch-project-action 'neotree-projectile-action)
;;========================= neotree =========================;;

(defun my/uploadfile()
  (interactive)
  (_uploadfile)
  )

(defun _uploadfile()
    (setq command (concat "osascript /Users/admin/Desktop/other/scripts/workflow/transmit/upload_file.scpt " buffer-file-name))
    (async-shell-command command)
    )
(setq async-shell-command-display-buffer nil)


;;========================= auto-save =========================;;
(require 'auto-save)
(auto-save-enable)

(setq auto-save-interval 8)
(setq auto-save-silent t)   ; quietly save
(setq auto-save-delete-trailing-whitespace t)  ; automatically delete spaces at the end of the line when saving

;;; custom predicates if you don't want auto save.
;;; disable auto save mode when current filetype is an gpg file.
;; (setq auto-save-disable-predicates
;;       '((lambda ()
;;           (string-suffix-p
;;            "gpg"
;;            (file-name-extension (buffer-name)) t))))
(add-hook 'python-mode-hook
          (lambda()
            (add-hook 'after-save-hook '_uploadfile 'make-it-local)))

;;
(desktop-save-mode 1)

;;========================= auto-save =========================;;
