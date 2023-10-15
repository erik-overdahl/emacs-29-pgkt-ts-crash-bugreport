;;; -*- lexical-binding: t; -*-

(require 'treesit)
(require 'print-emacs-info)

(add-to-list 'treesit-language-source-alist
             `(hcl . ("https://github.com/MichaHoffmann/tree-sitter-hcl"
                      ,(getenv "TREE_SITTER_HCL_REF")
                      "src")))

(unless (treesit-ready-p 'hcl)
  (treesit-install-language-grammar 'hcl))

(with-temp-buffer
  (when (string-equal "true" (getenv "PRINT_EMACS_INFO"))
    (print-emacs-info (current-buffer)))
  (insert-file-contents "example.hcl")
  ;; `treesit-parser-create' creates a parser for the buffer that is
  ;; then invoked lazily. Using `treesit-parse-string' to force parse.
  (treesit-parse-string (buffer-string) 'hcl)
  (princ "Parse successful\n"))
