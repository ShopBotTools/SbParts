
+-----------------------------------------------------------
|												
| ShopBot configuration file 
|
|-----------------------------------------------------------
|
| Who     When       What
| ======  ========== ========================================
| Tony M  22/06/2005 Written
| Brian M 08/07/2005 Modified to output feed uniTR correctly
| Brian M 14/07/2005 Modified to output 6 d.p
| BrianM   16/06/2006 Added NEW_SEGMENT section
|                     in case new tool has different 
|                     feedrates to first tool
| ScottJ  31/10/2007 setup file for PartWorks to keep look consistant
| ScottJ  12/05/2009 Fixed issue with mutiple toolpaths not remaining at Safe Z 
+-----------------------------------------------------------

POST_NAME = "ShopBot (inch)(*.sbp)"

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

 "'SHOPBOT FILE IN INCHES"
 "IF %(25)=1 THEN GOTO UNIT_ERROR	'check to see software is set to standard"
 "C#,90				 	'Lookup offset values"
  "'"
 "'Turning router ON"
 "SO,1,1"
 "PAUSE 2"
 "'"
 
 "'Toolpath Name = [TOOLPATH_NAME]"
 "'Tool Name   = [TOOLNAME]"
 "MS,[FC],[FP]"
 "JZ,[ZH]"
 "J2,[XH],[YH]"



+---------------------------------------------------
+  Commands output for rapid moves 
+---------------------------------------------------

begin RAPID_MOVE

"J3,[X],[Y],[Z]"

+---------------------------------------------------
+  Commands output for the first feed rate move
+---------------------------------------------------

begin FIRST_FEED_MOVE

"M3,[X],[Y],[Z]"

+---------------------------------------------------
+  Commands output for feed rate moves
+---------------------------------------------------

begin FEED_MOVE


"M3,[X],[Y],[Z]"


+---------------------------------------------------
+  Commands output for a new segment - toolpath
+  with same toolnumber but maybe different feedrates
+---------------------------------------------------

begin NEW_SEGMENT


"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name   = [TOOLNAME]"
"MS,[FC],[FP]"
"J3,[X],[Y],[ZH]"

+---------------------------------------------
+                 End of file
+---------------------------------------------

begin FOOTER

"JZ,[ZH]"
"'"
"'Turning router OFF"
"SO,1,0"
"J2,[XH],[YH]"
"END"
"UNIT_ERROR:"				
"C#,91					'Run file explaining unit error"
"END"
