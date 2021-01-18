;;; japanese.el --- Tools to add and display japanese vocabulary -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Pierre Glandon
;;
;; Author: Pierre Glandon <http://github/Luceurre>
;; Maintainer: Pierre Glandon <pglandon78@gmail.com>
;; Created: January 17, 2021
;; Modified: January 17, 2021
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/Luceurre/emacs-japanese-vocabulary
;; Package-Requires: ((emacs 27.1) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; Add vocabulary to your TOKNOW list from anywhere, anytime.
;; Then dump into an org file to learn or
;;
;;; Code:

(setq luceurre/japanese-vocabulary-directory "~/Documents/Japanese/Vocabulaire/")
(setq luceurre/japanese-names-filename "names.csv")
(setq luceurre/japanese-verbs-filename "verbs.csv")

(defun luceurre/japanese-get-names-filename ()
  "Return filename where names vocab are stored."
  (concat luceurre/japanese-vocabulary-directory luceurre/japanese-names-filename))

(defun luceurre/japanese-get-verbs-filename ()
  "Return filename where names vocab are stored."
  (concat luceurre/japanese-vocabulary-directory luceurre/japanese-verbs-filename))

(defun luceurre/japanese-load-csv-from-file (filename)
  "Return a double dimension list with csv filename data in it."
  (let ((buf (find-file-noselect filename t t)))
    (luceurre/japanese-csv-buffer-to-elisp buf)
    )
  )

(defun luceurre/japanese-load-csv-from-string (csv-string)
  "Return Lisp object from string with csv."
  (interactive "mcsv: ")
  (with-temp-buffer
    (insert csv-string)
    (luceurre/japanese-csv-buffer-to-elisp (current-buffer))
    )
  )

(defun luceurre/japanese-csv-buffer-to-elisp (csv-buffer)
  "Return Lisp object from buffer or buffer name with csv."
  (let ((buf csv-buffer)
        (result nil))
    (with-current-buffer buf
      (goto-char (point-min))
      (while (not (eobp))
        (let ((line (buffer-substring-no-properties
                     (line-beginning-position) (line-end-position))))
          (push (split-string line ",") result)
          )
        (forward-line 1)
        )
      )
    (reverse result)
    )
  )

(defun luceurre/japanese-dump-csv-to-file (filename csv-table)
  "dump csv-table in filename with csv convention."
  (with-temp-file filename
    (set-buffer-file-coding-system 'utf-8)
    (dolist (row csv-table)
      (dolist (data-cell row)
        (insert (decode-coding-string data-cell 'utf-8))
        (insert ",")
        )
      (delete-char -1)
      (insert "\n")
      )
    )
  )

(defun luceurre/japanese-dump-csv-to-buffer (csv-table buffer-name)
  "dump csv-table in filename with csv convention."
  (let ((buf (generate-new-buffer buffer-name)))
    (switch-to-buffer buf)
    (set-buffer-file-coding-system 'utf-8)
    (dolist (row csv-table)
      (dolist (data-cell row)
        (insert (decode-coding-string data-cell 'utf-8))
        (insert ",")
        )
      (delete-char -1)
      (insert "\n")
      )
    buf
    )
  )

(defun luceurre/japanese-add-name (french japanese kanji)
  "add word to name vocabulary list."
  (interactive "Mfrench: \nMjapanese: \nMkanji: ")

  (push (list french japanese kanji) luceurre/japanese-names)
  (luceurre/japanese-dump-csv-to-file (luceurre/japanese-get-names-filename) luceurre/japanese-names)
  )

(defun luceurre/japanese-add-verbs (french japanese group)
  "add word to name vocabulary list."
  (interactive "Mfrench: \nMjapanese: \nMgroup: ")

  (push (list french japanese group) luceurre/japanese-verbs)
  (luceurre/japanese-dump-csv-to-file (luceurre/japanese-get-verbs-filename) luceurre/japanese-verbs)
  )

;; (defun luceurre/japanese-import-names-from-org-table ()
;;   "if org-table under point, add it to the names vocabulary list."
;;   (interactive)

;;   (unless (org-at-table-p) (user-error "not at a table."))
;;   (let* ((table-begin (org-table-begin)) (table-end (org-table-end))
;;          (table (buffer-substring table-begin table-end)))
;;     (message (prin1-to-string (org-element-table-parser nil nil)))
;;     ))

(defun luceurre/japanese-dump-names-to-org-table ()
  "Dump names into a new org buffer in org-table format."
  (interactive)
  (let ((buf (luceurre/japanese-dump-csv-to-buffer luceurre/japanese-names "names")))
    (set-buffer buf)
    (org-mode)
    (org-table-convert-region (point-min) (point-max))
    )
  )

(defun luceurre/japanese-dump-verbs-to-org-table ()
  "Dump verbs into a new org buffer in org-table format."
  (interactive)
  (let ((buf (luceurre/japanese-dump-csv-to-buffer luceurre/japanese-verbs "verbs")))
    (set-buffer buf)
    (org-mode)
    (org-table-convert-region (point-min) (point-max))
    )
  )

(setq luceurre/japanese-names (luceurre/japanese-load-csv-from-file (luceurre/japanese-get-names-filename)))
(setq luceurre/japanese-verbs (luceurre/japanese-load-csv-from-file (luceurre/japanese-get-verbs-filename)))
(provide 'japanese-vocabulary)
;;; japanese.el ends here
