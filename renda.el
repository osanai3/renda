;;; renda.el ---  -*- lexical-binding: t; -*-

;; Copyright (C) 2021 by Koichi Osanai

;; Author: Koichi Osanai <osanai3@gmail.com>
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Inspired by smartchr.el, sequential-command.el

;; (global-set-key (kbd "C-a") (renda-pos '(beginning-of-line beginning-of-buffer)))
;; (global-set-key (kbd "C-e") (renda-pos '(end-of-line end-of-buffer)))
;; (global-set-key (kbd ">") (renda-str '(">" "->" "=>")))

;;; Code:

(defun renda-cycle-nth (n list)
  "Return Nth element of LIST as cyclic."
  (nth (% n (length list)) list))

(defun renda-call-with-count (fun)
  "Call FUN with sequential count."
  (let ((count 0))
    (lambda () (interactive)
      (setq count (if (eq real-this-command real-last-command) (+ count 1) 0))
      (funcall fun count))))

(defun renda-pos-func (ls)
  "Generate function with LS for 'renda-call-with-count'."
  (let* ((pos nil)
         (l (append ls (list (lambda () (goto-char pos))))))
    (lambda (count)
      (if (= count 0) (setq pos (point)))
      (funcall (renda-cycle-nth count l)))))

(defun renda-str-func (ls)
  "Generate function with LS for 'renda-call-with-count'."
  (let ((len (mapcar 'length ls)))
    (lambda (count)
      (if (> count 0) (delete-char (- (renda-cycle-nth (- count 1) len))))
      (insert (renda-cycle-nth count ls)))))

;;;###autoload
(defun renda-pos (list)
  "Generate sequential command.  LIST : point moving functions."
  (renda-call-with-count (renda-pos-func list)))

;;;###autoload
(defun renda-str (list)
  "Generate sequential command.  LIST : strings to be inserted."
  (renda-call-with-count (renda-str-func list)))

(provide 'renda)
;;; renda.el ends here
