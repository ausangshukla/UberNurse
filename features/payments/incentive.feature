Feature: Incentive for Carers
  Ensure Care Givers get the incentive they deserve


@ignore
Scenario Outline: Compute incentive
 Given there is a user "<user>"
 Given that the user has completed "<number>" of shifts 
 Given the IncentiveJob is run for the month
 Then the incentive payment is generated for the user
 And the incentive amount is "<incentive_amount>"

Examples:
  	| user                            | number 	| incentive_amount 	|
  	| role=Care Giver;verified=true   |	3		| 7.5				|
  	| role=Care Giver;verified=true   |	5		| 25				|
  	| role=Care Giver;verified=true   |	8		| 80				|
	| role=Nurse;verified=true   	  |	3		| 45				|
  	| role=Nurse;verified=true   	  |	5		| 125				|
  	| role=Nurse;verified=true   	  |	8		| 400				|
  
@ignore
Scenario Outline: Compute no incentive
 Given there is a user "<user>"
 Given that the user has completed "<number>" of shifts 
 Given the IncentiveJob is run for the month
 Then the incentive payment is not generated for the user
 
Examples:
  	| user                            | number 	|
  	| role=Care Giver;verified=true   |	1		|
  	| role=Care Giver;verified=true   |	2		|
 	| role=Nurse;verified=true   |	1		|
  	| role=Nurse;verified=true   |	2		|
 