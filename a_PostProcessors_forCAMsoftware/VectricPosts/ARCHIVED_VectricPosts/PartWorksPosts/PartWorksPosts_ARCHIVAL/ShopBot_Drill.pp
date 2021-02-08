
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
| ScottJ  12/05/2009 Fixed issue with mutiple toolpaths not remaining at Safe Z 
+-----------------------------------------------------------

POST_NAME = "ShopBot AirDrill (*.sbp)"

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

var CUT_RATE    = [FC|A||1.2|0.0166]
var PLUNGE_RATE = [FP|A||1.2|0.0166]

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
 "'SHOPBOT AIR DRILL FILE IN INCHES"
 "IF %(25)=1 THEN GOTO UNIT_ERROR	'check to see software is set to standard"
 "C#,90				 	'Lookup offset values"
 "IF %(22)=1 THEN GOSUB PREVMODE	'check for move/cut mode, reset offsets if needed"
 "SA					'Set program to absolute coordinate mode"
 "&DRILL=[T]			 	'Show which drill is active"
 "JZ,[ZH]				'Jog Z axis to safe height"
 "J2,[XH],[YH]				'Return tool to home in x and y"
 "'-------------------"

+--------------------------------------------
+               Program moves
+--------------------------------------------

begin RAPID_MOVE

"J2,[X]-&my_XinDrilloffset_T[T],[Y]-&my_YinDrilloffset_T[T]"


+---------------------------------------------

begin FIRST_FEED_MOVE

"C8"


+---------------------------------------------

begin FEED_MOVE


"C8"


+---------------------------------------------------
+  Commands output for a new segment - toolpath
+  with same toolnumber but maybe different feedrates
+---------------------------------------------------

begin NEW_SEGMENT

"MS,[FC],[FP]"
"J3,[X],[Y],[ZH]"
+---------------------------------------------------
+  Commands output at toolchange
+---------------------------------------------------

begin TOOLCHANGE
"&DRILL=[T]			'Show which drill is active"

+---------------------------------------------
+                 End of file
+---------------------------------------------

begin FOOTER

"JZ,[ZH]"
"J2,[XH],[YH]"
"END"
 "'----------------------------------------------------------------"
 "'"
 "UNIT_ERROR:"				
 "C#,91					'Run file explaining unit error"
 "END"
"PREVMODE:"
 "&my_XinDrilloffset_T2=0			'These values must remain zero for the preview to display properly."    
 "&my_YinDrilloffset_T2=0"     
 "&my_XinDrilloffset_T3=0"	
 "&my_YinDrilloffset_T3=0"	
 "RETURN"