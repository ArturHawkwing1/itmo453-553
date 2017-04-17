(ns examplecom.etc.email
  (:require [riemann.email :refer :all]))

(def email (mailer {:host "smtp.gmail.com" :user "SolarusExcantum@gmail.com" :pass "lymAKb5Tj1Zab4AUwkVsgZf0fYsyNj" :tls true :port 587 :from "dnelson8@hawk.iit.edu"}))
; URL to IIT student email https://ots.iit.edu/email/student-mail

