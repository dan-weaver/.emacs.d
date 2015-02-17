;; TODO: Recall Why I had to do this!!
(setenv "PATH" (concat (getenv "PATH") ":/Users/dweaver/bin"))
(setq exec-path (append exec-path '("/Users/dweaver/bin")))

;; most important thing first: no tabs
(setq-default indent-tabs-mode nil)

(load-theme 'wombat)
(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)
(package-initialize)


(defvar my-packages 
  '(ace-jump-mode buffer-move cider 
                  queue pkg-info epl dash clojure-mode 
                  clojure-mode color-theme-sanityinc-tomorrow evil 
                  goto-chg undo-tree flycheck pkg-info epl dash goto-chg 
                  helm async js2-mode less-css-mode magit git-rebase-mode 
                  git-commit-mode paredit pkg-info epl powerline python-mode 
                  queue simpleclip undo-tree virtualenvwrapper s dash web-mode yasnippet))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

; evil
(setq evil-want-C-u-scroll t)
(evil-mode 1)

(tool-bar-mode -1)


; helm
(global-set-key (kbd "C-c h") 'helm-mini)
(helm-mode 1)


;js2-mode
(add-hook 'js-mode-hook 'js2-minor-mode)
(setq js2-highlight-level 3)
(setq js-indent-level 2)
(add-hook 'after-init-hook 'global-flycheck-mode)

;(setq mac-option-modifier 'meta)
;(setq mac-command-modifier 'super)
;(setq mac-pass-command-to-system nil)



(require 'simpleclip)

(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super) 

(global-set-key (kbd "s-v") 'simpleclip-paste)
(global-set-key (kbd "s-c") 'simpleclip-copy)



(require 'buffer-move)
(global-set-key (kbd "s-<up>")     'buf-move-up)
(global-set-key (kbd "s-<down>")   'buf-move-down)
(global-set-key (kbd "s-<left>")   'buf-move-left)
(global-set-key (kbd "s-<right>")  'buf-move-right)


(setq auto-save-default nil)
(setq make-backup-files nil)

(require 'yasnippet)
(yas-global-mode 1)


(defun delete-this-buffer-and-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))
(global-set-key (kbd "C-c k") 'delete-this-buffer-and-file)



;; magit
(global-set-key (kbd "C-x g") 'magit-status)
;(global-set-key (kbd "C-c C-k") 'kill-buffer-and-window)


;; ORG stuff
(global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-cc" 'org-capture)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)

(setq org-log-done 'time)


(setq org-capture-templates
      '(("i" "In List" entry (file+headline "~/org/gtd.org" "In List")
             "* TODO %?\n" :empty-lines-after 1)
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
             "* %?\nEntered on %U\n  %i\n")
	("l" "Tech Learning" entry (file+headline "~/org/gtd.org" "Technical Learning")
             "* TODO %?\n" :empty-lines-after 1)
	("s" "SuperVision" entry (file+headline "~/org/gtd.org" "SuperVision")
	     "* TODO %?\n %i\n")))

(setq org-agenda-files '("~/org"))

; open todos
(setq initial-buffer-choice "~/org/gtd.org")


(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))

(global-set-key (kbd "C-c /") 'comment-or-uncomment-region-or-line)
 
(set-register ?i (cons 'file "~/.emacs.d/init.el"))


(define-key evil-motion-state-map (kbd "SPC") #'evil-ace-jump-char-mode)
(setq visible-bell 1)


(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(require 'powerline)
(custom-set-faces
 '(mode-line-buffer-id ((t (:foreground "#008000" :bold t))))
 '(which-func ((t (:foreground "#008000"))))
 '(mode-line ((t (:foreground "#008000" :background "#dddddd" :box nil))))
 '(mode-line-inactive ((t (:foreground "#008000" :background "#bbbbbb" :box nil)))))

(defun powerline-simpler-vc-mode (s)
  (if s
      (replace-regexp-in-string "Git:" "" s)
    s))

(defun powerline-simpler-minor-display (s)
  (replace-regexp-in-string
   (concat " "
           (mapconcat 'identity '("Undo-Tree" "GitGutter" "Projectile"
                                  "Abbrev" "ColorIds" "MRev" "ElDoc" "Paredit"
                                  "+1" "+2" "FlyC" "Fly" ;; ":1/0"
                                  "Fill" "AC" "FIC") "\\|")) "" s))

(defun powerline-ha-theme ()
  "A powerline theme that removes many minor-modes that don't serve much purpose on the mode-line."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let*
                       ((active
                         (powerline-selected-window-active))
                        (mode-line
                         (if active 'mode-line 'mode-line-inactive))
                        (face1
                         (if active 'powerline-active1 'powerline-inactive1))
                        (face2
                         (if active 'powerline-active2 'powerline-inactive2))
                        (separator-left
                         (intern
                          (format "powerline-%s-%s" powerline-default-separator
                                  (car powerline-default-separator-dir))))
                        (separator-right
                         (intern
                          (format "powerline-%s-%s" powerline-default-separator
                                  (cdr powerline-default-separator-dir))))
                        (lhs
                         (list
                          (powerline-raw "%*" nil 'l)
                          ;; (powerline-buffer-size nil 'l)
                          (powerline-buffer-id nil 'l)
                          (powerline-raw " ")
                          (funcall separator-left mode-line face1)
                          (powerline-narrow face1 'l)
                          (powerline-simpler-vc-mode (powerline-vc face1))))
                        (rhs
                         (list
                          (powerline-raw mode-line-misc-info face1 'r)
                          (powerline-raw global-mode-string face1 'r)
                          (powerline-raw "%4l" face1 'r)
                          (powerline-raw ":" face1)
                          (powerline-raw "%3c" face1 'r)
                          (funcall separator-right face1 mode-line)
                          (powerline-raw " ")
                          (powerline-raw "%6p" nil 'r)
                          (powerline-hud face2 face1)))
                        (center
                         (list
                          (powerline-raw " " face1)
                          (funcall separator-left face1 face2)
                          (when
                              (boundp 'erc-modified-channels-object)
                            (powerline-raw erc-modified-channels-object face2 'l))
                          (powerline-major-mode face2 'l)
                          (powerline-process face2)
                          (powerline-raw " :" face2)

                          (powerline-simpler-minor-display (powerline-minor-modes face2 'l))

                          (powerline-raw " " face2)
                          (funcall separator-right face2 face1))))
                     (concat
                      (powerline-render lhs)
                      (powerline-fill-center face1
                                             (/
                                              (powerline-width center)
                                              2.0))
                      (powerline-render center)
                      (powerline-fill face1
                                      (powerline-width rhs))
                      (powerline-render rhs)))))))

(powerline-ha-theme)


(setq cider-show-error-buffer nil)
