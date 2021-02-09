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
| PACO    15/08/05   Added router control for SB3 Alpha and 
|                    router/spindle RPM dislay/prompt
| Tony    27/06/2006 Added NEW_SEGMENT section
|                    in case new tool has different 
|                    feedrates to first tool
| Brian M 14/07/2006 Added circular arc support
| ScottJ  31/10/2007 setup file for PartWorks to keep look consistant
| ScottJ  12/05/2009 Fixed issue with mutiple toolpaths not remaining at Safe Z 
+-----------------------------------------------------------

POST_NAME = "Shopbot(MM)(Toolchange)(w/speed)(*.sbp)"

FILE_EXTENSION = "sbp"

UNITS = "MM"

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

var SPINDLE_SPEED = [S|A||1.0]

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


+------------------------------------------------
+ Arc centre positions - incremental from arc start
+------------------------------------------------

VAR ARC_CENTRE_I_INC_POSITION = [I|A||1.6]
VAR ARC_CENTRE_J_INC_POSITION = [J|A||1.6]


+================================================
+
+    Block definitions for toolpath output
+
+================================================


+---------------------------------------------
+                Start of file
+---------------------------------------------

begin HEADER

"'File created in VCarve Wizard"
"'"
"'UNITS:MM"
"'"
"'For ShopBot Control: SB3 Alpha"
"'"
"IF %(25)=0 THEN GOTO UNIT_ERROR	'check to see software is set to standard"
"SA                             	'Set program to absolute coordinate mode"
"TR, [S]"
"'"
"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name   = [TOOLNAME]"
"&Tool =[T]                    'Jog Z axis to safe height"
"c9"
"TR,[S]"
"C6                   'Return tool to home in x and y"

"PAUSE,2"
"'"
"MS,[FC],[FP]"
"JZ,[ZH]"
"J2,[XH],[YH]"

+--------------------------------------------
+               Program moves
+--------------------------------------------

begin RAPID_MOVE

"J3,[X],[Y],[Z]"


+---------------------------------------------

begin FIRST_FEED_MOVE

"M3,[X],[Y],[Z]"


+---------------------------------------------

begin FEED_MOVE


"M3,[X],[Y],[Z]"



+---------------------------------------------------
+  Commands output for clockwise arc  move
+---------------------------------------------------

begin CW_ARC_MOVE

"CG, ,[X],[Y],[I],[J],T,1"



+---------------------------------------------------
+  Commands output for counterclockwise arc  move
+---------------------------------------------------

begin CCW_ARC_MOVE

"CG, ,[X],[Y],[I],[J],T,-1"



+---------------------------------------------------
+  Commands output for a new segment - toolpath
+  with same toolnumber but maybe different feedrates
+---------------------------------------------------

begin NEW_SEGMENT

"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name   = [TOOLNAME]"
"TR, [S]"

"MS,[FC],[FP]"
"J3,[X],[Y],[ZH]"
+---------------------------------------------------
+  Commands output at toolchange
+---------------------------------------------------

begin TOOLCHANGE
"C7"
"&TOOL=[T]"
"C9"
"TR, [S]"
"MS,[FC],[FP]"
"C6"	    

+---------------------------------------------
+                 End of file
+---------------------------------------------

begin FOOTER

"JZ,[ZH]"
"J2,[XH],[YH]"
"'"
"'Turning router OFF"
"C7"
"END"
"'"
"'"
"UNIT_ERROR:"				
"C#,91                            'Run file explaining unit error"
"END"