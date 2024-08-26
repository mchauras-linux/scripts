;; export-agenda.el
(require 'org)
(require 'org-agenda)
(require 'htmlize)

(setq org-agenda-files '("~/docs/scheduler/README.org"
			 "~/scripts/agenda/agenda.org"))  ; Adjust this to your org files

(setq org-agenda-span 'month)

;; Generate the agenda and export it to a file
(let ((output-file "/tmp/agenda.html"))  ; Change this to your desired output file
  (with-temp-buffer
    ;;(org-agenda-list)
    ;;(org-batch-agenda "a")
    (org-agenda-write output-file)))
