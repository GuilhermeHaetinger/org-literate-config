;;; org-literate-config --- Literate Configuration Setter

;; Copyright (C) 2020 Guilherme Gomes Haetinger

;; Author: G. G. Haetinger <ghaetinger@gmail.com>
;; Version: 0.1
;; Package-Requires: ((org "9.4"))
;; Keywords: org, literate, configuration

;;; Commentary:
;;; This package provides a simple way to create a set of configuration files written in
;;; org-mode. A literate way to manage your text editor's attribute.
;;; Code:

(require 'org)

(defvar literate-config-ls)
(defvar main-literate-config)

(defun get-string-from-file (file-path)
  "Load the content under FILE-PATH as a string."
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun md5-from-file (file-path)
  "Generate a MD5 hash value from the content under FILE-PATH."
  (md5 (get-string-from-file file-path)))

(defun create-file-and-run (file-path func)
  "Create file under FILE-PATH and run arbritary function FUNC."
  (write-region "" nil file-path)
  (funcall func file-path))

(defun was-there-change (file-path)
  "Check if there was any change on the file under FILE-PATH.
Do this by looking at the cached Hash value and the processed one.
If there isn't such a file, create one and call was-there-change recursively."
  (let ((md5-file (concat (file-name-directory file-path)
                          (concat (file-name-base file-path) ".hash"))))
  (if (file-exists-p file-path)
      (not (string= (get-string-from-file md5-file)
                    (md5-from-file file-path)))
    (create-file-and-run file-path 'was-there-change))))

(defun save-and-load-lit-config (file-path)
  "Save (Tangle) the ORG file under FILE-PATH."
  (let ((md5-file (concat (file-name-directory file-path)
                          (concat (file-name-base file-path) ".hash")))
        (message-log-max nil))
  (write-region (md5-from-file file-path) nil md5-file)
  (org-babel-tangle-file file-path)))

(defun open-literate-config ()
  "Open the Literate Configuration file set."
  (interactive)
  (switch-to-buffer (find-file main-literate-config)))

(defun run-configs ()
  "Run the configs."
  (let ((list literate-config-ls) (file nil))
    (message "\n===== Checking Literate Config files =====")
    (while list
      (setq file (car list))
      (message (concat "\n=====[ ] " (concat file " =====\n")))
      (if (was-there-change file)
          (save-and-load-lit-config file))
      (org-babel-load-file file)
      (setq list (cdr list))
      (message (concat "\n=====[X] " (concat file " =====\n"))))
    (message "== Checked All Config files! ==\n")))

(provide 'org-literate-config)
;;; org-literate-config.el ends here
