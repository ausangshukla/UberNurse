Feature: Shift Closing
  Ensure  a shift is closed properly

Scenario Outline: Close Shift
  Given there is a care_home "verified=true" with me as admin "role=Admin"
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already accepted this request
  Given jobs are being dispatched
  Then the user receives an email with "Shift Confirmed" as the subject
  And when the user enters the start and end code
  Given jobs are being dispatched
  Then the shift price is computed and stored
  Then the payment for the shift is generated
  Then the shift is marked as closed
  And the request is marked as closed 

  Examples:
  	|request	                         | user                            |
  	|role=Care Giver                     |role=Care Giver;verified=true    |
  	|role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |role=Nurse;speciality=Generalist    |role=Nurse;speciality=Pediatric Care;verified=true|



Scenario Outline: Add Start Code
  Given there is a care_home "verified=true" with me as admin "role=Admin"
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already accepted this request
  Given the user is logged in 
  And when the user enters the "start_code" "<start_code>" in the UI
  Then he must see the message "<msg>"
  Examples:
    |request                          | user                            | start_code  |  msg            |
    |role=Care Giver;start_code=1111  |role=Care Giver;verified=true    | 1111        | 1111   |
    |role=Nurse;start_code=1112       |role=Nurse;verified=true         | 1112        | 1112   |
    |role=Nurse;start_code=1113       |role=Nurse;verified=true         | 1111        | Start Code does not match|


Scenario Outline: Add End Code
  Given there is a care_home "verified=true" with me as admin "role=Admin"
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already accepted this request
  And the shift has a valid start code
  Given the user is logged in 
  And when the user enters the "end_code" "<end_code>" in the UI
  Then he must see the message "<msg>"
  Examples:
    |request                        | user                            | end_code  |  msg            |
    |role=Care Giver;end_code=1111  |role=Care Giver;verified=true    | 1111      | 1111   |
    |role=Nurse;end_code=1112       |role=Nurse;verified=true         | 1112      | 1112   |
    |role=Nurse;end_code=1113       |role=Nurse;verified=true         | 1111      | End Code does not match|
