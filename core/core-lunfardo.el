(require 'core-package)
(require 'core-osx)
(require 'core-defun)
(require 'core-editor)
(require 'core-ui)
(require 'core-git)
(require 'core-flycheck)

(use-package helm
  :init
  (setq helm-M-x-fuzzy-match t
	helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t)
  :bind
  (("M-y" . helm-show-kill-ring)
   )
  :ensure t)

(use-package counsel
  :bind
  (("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("s-o" . counsel-find-file)
   ("C-c C-f" . counsel-git)
   ("s-O" . counsel-git)
   ("C-c f" . counsel-describe-function)
   ("C-c g" . counsel-git-grep)
   ("C-c a" . counsel-ag))
  :ensure t)

(use-package swiper
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-wrap t)
  :bind
  (("C-s" . swiper)
   ("C-x b" . ivy-switch-buffer))
  :ensure t)

(use-package ivy
  :config
  (defun ivy-imenu-get-candidates-from (alist  &optional prefix)
    (cl-loop for elm in alist
             nconc (if (imenu--subalist-p elm)
                       (ivy-imenu-get-candidates-from
                        (cl-loop for (e . v) in (cdr elm) collect
                                 (cons e (if (integerp v) (copy-marker v) v)))
                        (concat prefix (if prefix ".") (car elm)))
                     (and (cdr elm) ; bug in imenu, should not be needed.
                          (setcdr elm (copy-marker (cdr elm))) ; Same as [1].
                          (list (cons (concat prefix (if prefix ".") (car elm))
                                      (copy-marker (cdr elm))))))))

  (defun ivy-imenu-goto ()
    "Go to buffer position"
    (interactive)
    (let ((imenu-auto-rescan t) items)
      (unless (featurep 'imenu)
        (require 'imenu nil t))
      (setq items (imenu--make-index-alist t))
      (ivy-read "imenu items:"
                (ivy-imenu-get-candidates-from (delete (assoc "*Rescan*" items) items))
                :action (lambda (k) (goto-char k))))))

(use-package aggressive-indent
  :init
  (global-aggressive-indent-mode 1)
  :ensure t)

(use-package auto-package-update
  :init
  (setq auto-package-update-delete-old-versions t)
  (add-hook 'auto-package-update-before-hook
	    (lambda () (message "I will update packages now")))
  :config
  (auto-package-update-maybe)
  :ensure t)

(use-package company
  :init
  (global-company-mode)
  :config
  (defun company-complete-common-or-cycle-backward ()
    (interactive)
    (company-complete-common-or-cycle -1))
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 3
        company-show-numbers t
        company-tooltip-limit 10
        company-selection-wrap-around t
        company-tooltip-flip-when-above t)
  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "<S-tab>") 'company-complete-common-or-cycle-backward)
  (define-key company-active-map (kbd "<backtab>") 'company-complete-common-or-cycle-backward)
  (global-set-key "\t" 'company-indent-or-complete-common)
  :ensure t)

(use-package undo-tree
  :init (undo-tree-mode t)
  :ensure t)

(use-package expand-region
  :bind
  ("C-l" . er/expand-region)
  :ensure t)

(use-package multiple-cursors
  :bind
  (("s-d" . mc/mark-next-like-this)
   ("s-D" . mc/mark-previous-like-this)
   ("s-L" . mc/edit-lines)
   )
  :ensure t)

(use-package drag-stuff
  :init (drag-stuff-global-mode t)
  :ensure t)

(use-package hungry-delete
  :init (global-hungry-delete-mode t)
  :ensure t)

(use-package avy
  :bind
  ("C-c j" . avy-goto-word-or-subword-1)
  ("s-." . avy-goto-word-or-subword-1)
  :ensure t)

(use-package circe
  :config
  (setq circe-network-options
        '(("Freenode"
           :tls t
           :nick "unbalancedparen"
           :sasl-username "unbalancedparen"
           :sasl-password ""
           :channels ("#erlang" "#clojure")
           )))
  :ensure t)

;; languages
(use-package erlang
  :init
  (add-hook 'erlang-mode-hook (lambda () (run-hooks 'prog-mode-hook)))
  (add-hook 'erlang-mode-hook 'flycheck-mode)
  :mode
  ("\\.erl\\'" . erlang-mode)
  ("\\.hrl\\'" . erlang-mode)
  :ensure t)

(use-package web-mode
  :config
  (setq web-mode-enable-auto-pairing nil)
  :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.tpl\\.php\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)
   ("\\.html?\\'" . web-mode))
  :ensure t)

(provide 'core-lunfardo)
