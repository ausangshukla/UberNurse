Feature: Registration
  Registration should work properly

Scenario Outline: User Registration Successfully
  Given there is an unsaved user "<user>"
  And I am at the registration page
  When I fill and submit the registration page
  Then I should see the "<msg1>"
  Then when I click the confirmation link
  Then the user should be confirmed
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg2>"
  Examples:
  	|user						  |msg1											                      |msg2		  |
  	|role=Care Giver	|Please check your email for verification link	|Welcome	|
    |role=Nurse       |Please check your email for verification link  |Welcome  |
    |role=Admin		    |Please check your email for verification link	|Register Care Home	|


Scenario Outline: Register a care home with cqc
  Given Im a logged in user "<user>"  
  And I am at the care homes registration page
  When I search for the care home "<care home>"
  And I click on the search result care home
  And When and submit the care homes registration page with "<care_home>"
  Then I should see the "<msg1>"
  And the care home should be unverified
  And I should be associated with the care home
  Examples:
    |user        |care home                         |msg1                                |
    |role=Admin  |name=Kingswood House Nursing Home |As part of our verification process, we will call your care home to verify your details|
    |role=Admin  |name=Little Haven                 |As part of our verification process, we will call your care home to verify your details|


Scenario Outline: Register a care home without cqc
  Given Im a logged in user "<user>"  
  And I am at the care homes registration page
  When I search for the care home "<care_home>"
  And I click "Register New Care Home"
  And I fill and submit the care homes registration page with  "<care_home>"
  Then I should see the "<msg1>"
  And the care home should be unverified
  And I should be associated with the care home
  Examples:
    |user        | care_home                       |msg1                                |
    |role=Admin  |name=Kingswood House Nursing Home|As part of our verification process, we will call your care home to verify your details|
    |role=Admin  |name=Little Haven                |As part of our verification process, we will call your care home to verify your details|


Scenario Outline: User Phone Verification
  Given Im a logged in user "<user>"  
  And I am at the phone verification page
  When I request a sms verification code
  Then an sms code must be generated
  Then when I submit the code
  Then the user should be phone verified
  Examples:
    |user                                                                    |
    |role=Care Giver;verified=false;phone_verified=false   |
    |role=Nurse;verified=false;phone_verified=false        |
    |role=Admin;verified=false;phone_verified=false        |
