
+-----------------------------------------------------------
|												
| ShopBot configuration file 
|
|-----------------------------------------------------------
|
| Who     When       What
| ======  ========== ========================================
| Tony M  22/06/2005 Written
| Brian M 08/07/2005 Modified to output feed units correctly
| Brian M 14/07/2005 Modified to output 6 d.p
| BrianM   16/06/2006 Added NEW_SEGMENT section
|                     in case new tool has different 
|                     feedrates to first tool
|
| ScottJ  31/10/2007 Added the new PRS Drill commands
+-----------------------------------------------------------

POST_NAME = "ShopBot PRS Drill (*.sbp)"

FILE_EXTENSION = "sbp"

UNITS = "inches"

+------------------------------------------------
|    line terminating characters
+------------------------------------------------

LINE_ENDING = "[13][10]"

+------------------------------------------------
|    Block Numbering
+------------------------------------------------

LINE_NUMBER_START     = 0
LINE_NUMBER_INCREMENT = 10
LINE_NUMBER_MAXIMUM   = 999999

+================================================
+
+    default formating for variables
+
+================================================

+------------------------------------------------
+ Line numbering
+------------------------------------------------

var LINE_NUMBER   = [N|A|N|1.0]

+------------------------------------------------
+ Spindle Speed
+------------------------------------------------

var SPINDLE_SPEED = [S|A|S|1.0]

+------------------------------------------------
+ Feed Rate
+------------------------------------------------

var CUT_RATE    = [FC|A||1.1|0.0166]
var PLUNGE_RATE = [FP|A||1.1|0.0166]

+------------------------------------------------
+ Tool position in x,y and z
+------------------------------------------------

var X_POSITION = [X|A||1.6]
var Y_POSITION = [Y|A||1.6]
var Z_POSITION = [Z|A||1.6]

+------------------------------------------------
+ Home tool positions 
+------------------------------------------------

var X_HOME_POSITION = [XH|A||1.6]
var Y_HOME_POSITION = [YH|A||1.6]
var Z_HOME_POSITION = [ZH|A||1.6]


+================================================
+
+    Block definitions for toolpath output
+
+================================================


+---------------------------------------------
+                Start of file
+---------------------------------------------

begin HEADER
 "'----------------------------------------------------------------"
 "'SHOPBOT AIR DRILL FILE IN INCHES"
 "IF %(25)=1 THEN GOTO UNIT_ERROR	'check to see software is set to standard"
 "C#,90				 	'Lookup offset values"
 "IF %(22)=1 THEN GOSUB PREVMODE	'check for move/cut mode, reset offsets if needed"
 "SA					'Set program to absolute coordinate mode"
 "&DRILL=[T]			 	'Show which drill is active"
 "If &DRILL>32 then Goto Wrong_Post 	'run file with correct post"
 "MZ, [ZH]+&my_ZinDrilloffset_T[T]	'Move Z to safe height to activate Drill"
 "SO,&My_DrillOutput[T],1		'Turn on Correct Drill head"
 "MS,[FC],[FP]				'Set move and plunge rate"

"'----------------------------------------------------------------"

+--------------------------------------------
+               Program moves
+--------------------------------------------

begin RAPID_MOVE

"J3,[X]+&my_XinDrilloffset_T[T],[Y]+&my_YinDrilloffset_T[T],[Z]+&my_ZinDrilloffset_T[T]"


+---------------------------------------------

begin FIRST_FEED_MOVE

"M3,[X]+&my_XinDrilloffset_T[T],[Y]+&my_YinDrilloffset_T[T],[Z]+&my_ZinDrilloffset_T[T]"


+---------------------------------------------

begin FEED_MOVE


"M3,[X]+&my_XinDrilloffset_T[T],[Y]+&my_YinDrilloffset_T[T],[Z]+&my_ZinDrilloffset_T[T]"


+---------------------------------------------------
+  Commands output for a new segment - toolpath
+  with same toolnumber but maybe different feedrates
+---------------------------------------------------

begin NEW_SEGMENT

"MS,[FC],[FP]"
+---------------------------------------------------
+  Commands output at toolchange
+---------------------------------------------------

begin TOOLCHANGE
"&DRILL=[T]			'Show which drill is active"

+---------------------------------------------
+                 End of file
+---------------------------------------------

begin FOOTER

"'----------------------------------------------------------------"
"SO,&my_DrillOutput[T],0				'Turn off Drill"
"END"
"'----------------------------------------------------------------"
"'"
"UNIT_ERROR:"				
"C#,91					'Run file explaining unit error"
"END"
"PREVMODE:"
"'These values must remain zero for the preview to display properly." 
"&my_XinDrilloffset_T31=0"			   
"&my_YinDrilloffset_T31=0" 
"&my_ZinDrilloffset_T31=0"    
"&my_XinDrilloffset_T32=0"	
"&my_YinDrilloffset_T32=0"
"&my_ZinDrilloffset_T32=0"	
"&my_XinDrilloffset_T33=0"		   
"&my_YinDrilloffset_T33=0" 
"&my_ZinDrilloffset_T33=0"    
"&my_XinDrilloffset_T34=0"	
"&my_YinDrilloffset_T34=0"	
"&my_ZinDrilloffset_T34=0"	
"RETURN"
""
"Wrong_Post:"
"'You have selected a Post for the Main Head, Please choose PRS Drill Head2 Post Processor for you drill."
"Pause"
"END"