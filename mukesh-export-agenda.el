;; export-agenda.el
(require 'org)
(require 'org-agenda)

(setq org-agenda-files '("~/docs/scheduler/README.org"
			 "~/scripts/agenda.org"))  ; Adjust this to your org files

(setq org-agenda-span 'week)

;; Generate the agenda and export it to a file
(let ((output-file "/tmp/agenda.txt"))  ; Change this to your desired output file
  (with-temp-buffer
    (org-agenda-list)
    (org-batch-agenda "a")
    (write-file output-file)))
