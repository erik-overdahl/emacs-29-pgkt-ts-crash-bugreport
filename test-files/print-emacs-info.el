;;; -*- lexical-binding: t; -*-

(defun print-emacs-info (buffer)
  (with-temp-buffer
    (emacs-build-description)
    (insert "Configured features:\n" system-configuration-features "\n\n")
    (insert "Important settings:\n")
    (mapc
     (lambda (var)
       (let ((val (getenv var)))
         (if val (insert (format "  value of $%s: %s\n" var val)))))
     '("EMACSDATA" "EMACSDOC" "EMACSLOADPATH" "EMACSNATIVELOADPATH" "EMACSPATH"
       "LC_ALL" "LC_COLLATE" "LC_CTYPE" "LC_MESSAGES"
       "LC_MONETARY" "LC_NUMERIC" "LC_TIME" "LANG" "XMODIFIERS"))
    (insert (format "  locale-coding-system: %s\n" locale-coding-system))
    (insert "\n")
    (insert (format "Major mode: %s\n"
                    (format-mode-line
                     (buffer-local-value 'mode-name buffer)
                     nil nil buffer)))
    (insert "\n")
    (insert "Minor modes in effect:\n")
    (dolist (mode minor-mode-list)
      (and (boundp mode) (buffer-local-value mode buffer)
           (insert (format "  %s: %s\n" mode
                           (buffer-local-value mode buffer)))))
    (insert "\n")
    (insert "Load-path shadows:\n")
    (let* ((msg "Checking for load-path shadows...")
           (result "done")
           (shadows (progn (message "%s" msg)
                           (condition-case nil (list-load-path-shadows t)
                             (error
                              (setq result "error")
                              "Error during checking")))))
      (message "%s%s" msg result)
      (insert (if (zerop (length shadows))
                  "None found.\n"
                shadows)))
    (insert (format "\nFeatures:\n%s\n" features))
    (fill-region (line-beginning-position 0) (point))

    (insert "\nMemory information:\n")
    (pp (garbage-collect) (current-buffer))

    (princ (buffer-string))))

(provide 'print-emacs-info)
