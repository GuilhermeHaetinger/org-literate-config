(require 'org-literate-config)

;;; Code:
(ert-deftest test-string-from-file ()
  "Test if the function loads a file as string correctly."
  (should (string= (get-string-from-file "res/sample.txt")
                   "This is a sample text.")))

(ert-deftest test-md5-from-file ()
  (should (string= (md5-from-file "res/sample.txt")
                   "a1fc87ae17cb8b1bce85cb6faa3bdf90")))
