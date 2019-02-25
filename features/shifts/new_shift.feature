Feature: New Shift
  Generate a shift for temps given a new request

Scenario Outline: New Shift
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     |role=Care Giver;verified=true    |
    |role=Nurse                          |role=Nurse;verified=true         |
  	|role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Mental Health |role=Nurse;speciality=Mental Health;verified=true |
  	


Scenario Outline: New Shift for preferred care givers
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given there is a user "<user>"
  Given the care home has a preferred care giver
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must be created for the preferred care giver for the request
  And the request broadcast status must change to "Sent"

  Examples:
    |request                             | user                            |
    |role=Care Giver                     |role=Care Giver;verified=true    |
    |role=Nurse                          |role=Nurse;verified=true         |
    |role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Mental Health |role=Nurse;speciality=Mental Health;verified=true |


Scenario Outline: New Shift for specialist users with no match
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                              | user                            |
    |role=Nurse;speciality=Generalist     |role=Care Giver;verified=true    |    
    |role=Care Giver;speciality=Generalist|role=Nurse;verified=true         |    
    |role=Nurse;speciality=Generalist     |role=Care Giver;speciality=Mental Health;verified=true  |
    |role=Nurse                           |role=Care Giver;speciality=Pediatric Care;verified=true |

Scenario Outline: New Shift for users not mapped to agency
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has no mapping to the agency
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request          | user                            |
    |role=Care Giver  |role=Care Giver;verified=true    |    
    |role=Nurse       |role=Nurse;verified=true         |    
    
    
Scenario Outline: New Shift for manual assignment care homes
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Given the request manual assignment is set to "false"
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
    |request                                      | user                          |
    |role=Nurse;manual_assignment_flag=true       |role=Nurse;verified=true       |    
    |role=Care Giver;manual_assignment_flag=true  |role=Care Giver;verified=true  |    


Scenario Outline: New Shift for unverified users
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the user is verified "false"
  And the shift creator job runs
  Then A shift must not be created for the user for the request

  Examples:
    |request                                        | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=false  |
    |start_code=1111;end_code=0000 | role=Nurse;verified=false       |


Scenario Outline: New Shift without care givers
  Given there is an agency
  Given there is a request "<request>"
  And the shift creator job runs
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                       | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=false  |
    |start_code=1111;end_code=0000 | role=Nurse;verified=false       |


Scenario Outline: New Shift when already rejected
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already rejected this request
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                        | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=true   |
    |start_code=1111;end_code=0000 | role=Nurse;verified=true        |

Scenario Outline: New Shift when already auto rejected
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already auto rejected this request
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                        | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=true   |
    |start_code=1111;end_code=0000 | role=Nurse;verified=true        |

Scenario Outline: New Shift to different user when already rejected
  Given there is an agency
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already rejected this request
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 
  
  Examples:
    |request                                        | user                            |
    |role=Care Giver;start_code=1111;end_code=0000  | role=Care Giver;verified=true   |
    |role=Nurse;start_code=1111;end_code=0000       | role=Nurse;verified=true        |


Scenario Outline: New Shift when already booked in the same time shift
  Given there is an agency
  Given there is a user "<user>"
  And the user has already accepted a request "<other_request>"
  And give the request has a start_time "8:00" and end time of "16:00"
  Given there is a request "<request>"
  And give the request has a start_time "8:00" and end time of "16:00"
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject
  
  Examples:
    |request          | user                            | other_request     |
    |role=Care Giver  | role=Care Giver;verified=true   | role=Care Giver   |
    |role=Care Giver  | role=Nurse;verified=true        | role=Care Giver   |
    |role=Care Giver  | role=Care Giver;verified=true   | role=Care Giver   |
  
Scenario Outline: New Shift for Sister Care Home
  Given there is an agency
  Given there is a request "<request>" for a sister care home
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
    |request                             | user                            |
    |care_home_id=2;role=Care Giver                     |role=Care Giver;verified=true    |
    |care_home_id=2;role=Nurse                          |role=Nurse;verified=true         |
    |care_home_id=3;role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |care_home_id=3;role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |care_home_id=3;role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |care_home_id=3;role=Nurse;speciality=Mental Health |role=Nurse;speciality=Mental Health;verified=true |
