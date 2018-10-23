Feature: Shift Confirmation Email
  Generate a Shift Confirmation Email

Scenario Outline: Shift Confirmation Email sent
  Given there is a care_home "verified=true" with me as admin "role=Admin"
  Given there is a request "<request>"
  And the request start_date is "<time>" from now
  Given there is a user "<user>"
  And the user has already accepted this request
  And the shift has confirm_sent "<count>" times
  And the shift confirm job runs
  Then the user receives an email with "Shift Confirmation" in the subject
  

  Examples:
  	|request                           |user	           |time       | count |
  	|role=Care Giver                   |role=Care Giver  | 23.hours  | 0  |
  	|role=Nurse;speciality=Generalist  |role=Nurse       | 3.hours   | 1  |
    |role=Care Giver                   |role=Care Giver  | 55.minutes| 2  |
    |role=Nurse;speciality=Generalist  |role=Nurse       | 30.minutes| 2  |
    


Scenario Outline: Shift Confirmation Email not sent
  Given there is a care_home "verified=true" with me as admin "role=Admin"
  Given there is a request "<request>"
  And the request start_date is "<time>" from now
  Given there is a user "<user>"
  And the user has already accepted this request
  And the shift has confirm_sent "<count>" times
  And the shift confirm job runs
  Then the user receives no email

  Examples:
    |request                           |user             |time       | count |
    |role=Care Giver                   |role=Care Giver  | 25.hours  | 0  |
    |role=Nurse;speciality=Generalist  |role=Nurse       | 5.hours   | 1  |
    |role=Care Giver                   |role=Care Giver  | 70.minutes| 2  |
    |role=Nurse;speciality=Generalist  |role=Nurse       | 61.minutes| 2  |
   