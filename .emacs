
(setq next-line-add-newlines nil)		; No infinite newlines
(setq make-backup-files nil)			; No backup files
(setq auto-save-default nil)			; No auto-save
(setq truncate-lines t)
(setq case-fold-search t)				; case-insensitive search by default
(setq inhibit-startup-screen t)			; Disable the welcome screen

(global-set-key "\M-g" 'goto-line)		; Alt-g is goto-line shortcut


;; reverse video
(set-face-background  'default   "black")
(set-face-foreground  'default   "white")

;;
;; Mode setup
;;
(setq default-major-mode 'text-mode)
(setq initial-major-mode 'text-mode)
(setq auto-mode-alist
	'(
		("\\.org$" . org-mode)			; .org files use org-mode
		("\\.*" . text-mode)			; Everything else in text-mode
	))


;;
;; Mac/OSX customization
;;
(setq mac-command-key-is-meta t)    ; Use cmd as meta on typical keyboard
(setq mac-command-modifier 'meta)

;(setq mac-option-key-is-meta nil)
;(setq mac-option-modifier nil)


;;
;; org mode
;;
(setq org-todo-keywords
      '((sequence "TODO" "PROG" "BLKD" "|" "DONE" "SKIP")))
(setq org-todo-keyword-faces
      '(("TODO" . "red")
        ("PROG" . "yellow")
	("BLKD" . "red")))
        ;("CANCELED" . (:foreground "blue" :weight bold))))
	

;;
;; TAB settings
;;
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84))
(define-key text-mode-map "	" 'tab-to-tab-stop)



;;
;; Personal macros
;;
(defun insert-file-header ()
	"Insert a C/C++ file header"
	(interactive)
	(goto-char (point-min))
	(let ((file-name (file-name-nondirectory (buffer-file-name))))
		(insert (format "//\n"))
		(insert (format "// %s\n" file-name))
		(insert (format "//\n"))
		(insert (format "// $Id$\n"))
		(insert (format "//\n\n"))))


(defun insert-include-guard ()
	"Insert a C/C++ preprocessor #include guard"
	(interactive)
	(let ((guard-name
			(read-from-minibuffer "#ifdef symbol: "
				(concat "_"
					(upcase
						(replace-regexp-in-string "\\." "_"
							(file-name-nondirectory (buffer-file-name)))))
				nil
				t)))
		(insert (format "#ifndef %s\n" guard-name))
		(insert (format "#define %s\n\n\n" guard-name))
		(insert "#endif\n")))


(defun insert-class-definition ()
	"Insert a C++ class"
	(interactive)
	(let ((class-name (read-from-minibuffer "class name: " (cons "_c" 0) nil t)))
		(insert (format "class   %s;\n" class-name))
		(insert (format "typedef %s *    %sp;\n" class-name class-name))
		(insert (format "typedef %sp *   %spp;\n" class-name class-name))
		(insert (format "typedef %s &    %sr;\n" class-name class-name))
		(insert (format "class   %s\n" class-name))
		(insert "\t{\n")
		(insert "\tprivate:\n\n")
		(insert "\tprotected:\n\n")
		(insert "\tpublic:\n")
		(insert (format "\t\t%s()\n" class-name))
		(insert "\t\t\t{ return; }\n")
		(insert (format "\t\t~%s()\n" class-name))
		(insert "\t\t\t{ return; }\n")
		(insert "\t};\n\n")))


(defun insert-struct-definition ()
	"Insert a C struct"
	(interactive)
	(let ((struct-name (read-from-minibuffer "struct name: " (cons "_s" 0) nil t)))
		(insert (format "struct  %s;\n" struct-name))
		(insert (format "typedef %s *    %sp;\n" struct-name struct-name))
		(insert (format "typedef %sp *   %spp;\n" struct-name struct-name))
		(insert (format "typedef %s &    %sr;\n" struct-name struct-name))
		(insert (format "struct  %s\n" struct-name))
		(insert "\t{\n")
		(insert "\t};\n\n")))


(defun insert-typedef ()
	"Insert a C/C++ typedef"
	(interactive)
	(let ((type-name (read-from-minibuffer "typedef: " (cons "_t" 0) nil t))
		  (real-type (read-from-minibuffer "real type: " (cons "int" 0) nil t)))
		(insert (format "typedef %s      %s;\n" type-name real-type))
		(insert (format "typedef %s *    %sp;\n" type-name type-name))
		(insert (format "typedef %sp *   %spp;\n" type-name type-name))
		(insert (format "typedef %s &    %sr;\n" type-name type-name))))


(defun intel-whitespace ()
	"Convert tabs to spaces and removes trailing whitespace"
	(interactive)
	(save-excursion
		(untabify (point-min) (point-max))		; remove all tabs
		(trim-whitespace)))


; This is Windows-specific
(defun make-writable ()
	"make-writable: mark the current buffer and its underlying file as writable"
	(interactive)
	(shell-command (concat "attrib -r " (buffer-name)))	; make the file writable
	(toggle-read-only nil))								; make the buffer writable, too


(defun trim-whitespace ()
	"trim-whitespace: removes any trailing whitespace from the current buffer"
	(interactive)
	(save-excursion
		(goto-char (point-min))
		(while (re-search-forward "[\t ]+$" nil t)	; remove all trailing whitespace
			(replace-match ""))))

