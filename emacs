;; .emacs

(set-face-attribute 'default nil :height 110)

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

(display-time-mode 1)
(global-set-key [(f9)] 'compile)
(setq compilation-finish-function
      (lambda (buf str)
	
        (if (string-match "exited abnormally" str)

            ;;there were errors
            (message "compilation errors, press C-x ` to visit")

          ;;no errors, make the compilation window go away in 0.5 seconds
          (run-at-time 0.5 nil 'delete-windows-on buf)
          (message "NO COMPILATION ERRORS!"))))


(require 'cc-mode)
(defun my-build-tab-stop-list (width)
  (let ((num-tab-stops (/ 80 width))
	(counter 1)
	(ls nil))
    (while (<= counter num-tab-stops)
      (setq ls (cons (* width counter) ls))
      (setq counter (1+ counter)))
    (set (make-local-variable 'tab-stop-list) (nreverse ls))))
(defun my-c-mode-common-hook ()
  (setq tab-width 4) ;; change this to taste
  (my-build-tab-stop-list tab-width)
  (setq c-basic-offset tab-width)
  (c-set-offset 'arglist-intro '+)
  (setq indent-tabs-mode nil)) ;; force only spaces for indentation
(add-hook 'c++-mode-hook 'my-c-mode-common-hook)
(c-set-offset 'innamespace 0)

;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/thepeg")
;;(load "ThePEG")

;auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(ac-config-default)
(setq ac-auto-show-menu 0.8)
(setq ac-use-menu-map t)
;; Default settings
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

;semantic
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (add-to-list 'ac-sources 'ac-source-semantic)
	    (semantic-mode 1)))

(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)

;nrepl
(setq nrepl-hide-special-buffers t)
(setq nrepl-popup-stacktraces nil)
(setq nrepl-popup-stacktraces-in-repl t)
(add-hook 'nrepl-mode-hook 'subword-mode)

;; Teach compile the syntax of the kibit output
(require 'compile)
(add-to-list 'compilation-error-regexp-alist-alist
         '(kibit "At \\([^:]+\\):\\([[:digit:]]+\\):" 1 2 nil 0))
(add-to-list 'compilation-error-regexp-alist 'kibit)

;; A convenient command to run "lein kibit" in the project to which
;; the current emacs buffer belongs to.
(defun kibit ()
  "Run kibit on the current project.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile "lein kibit"))

(defun kibit-current-file ()
  "Run kibit on the current file.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile (concat "lein kibit " buffer-file-name)))

(require 'clj-refactor)
(add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               (cljr-add-keybindings-with-prefix "C-c C-v")
                               ))

(add-to-list 'auto-mode-alist '("\\.cu$" . c++-mode))

(setq c-default-style "linux")
(setq-default c-basic-offset 8
              tab-width 8
              indent-tabs-mode t)
(setq-default show-trailing-whitespace t)
