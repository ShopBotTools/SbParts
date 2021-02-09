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
| Brian M 14/07/2006 Added circular arC support
| ScottJ  31/10/2007 setup file for PartWorks to keep look consistant
| ScottJ  12/05/2009 Fixed issue with mutiple toolpaths not remaining at SaFE Z 
| ScottJ  11/12/2009 Added File info to headerChanged to simplified post format
| TedH    12/26/2010 Enable DIRECT for Beta ShopBotEASY
| RyanP   12/09/2011 Corrected return home after new segment. Removed JH replaced with PW variables for home position
| MattS	  2/19/2016  swapped y and z, removed arc, added MI commands, 
| MattS	  2/19/2016  swapped y and x to make work with a y-parallel indexer. 
+ MattS    5/6/2016   converted to mm
+ MattS   6/17/2016  updated %(25) check at begining to be in mm
+-----------------------------------------------------------

POST_NAME = "ShopBot Lathe Y-Parallel TC (mm)(*.sbp)"

FILE_EXTENSION = "sbp"

UNITS = "mm"

DIRECT_OUTPUT = "DIRECT to ShopBot|ShopBot_run.ini"

+------------------------------------------------
|    line terminating characteRS
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
"'SHOPBOT LATHE FILE IN MM"
"'GENERATED BY V-Carve or Aspire"
""
"'material size:"
"'Minimum extent in X = [XMIN] Minimum extent in Y = 0 Minimum extent in Z = [YMIN]"
"'Maximum extent in X = [XMAX] Maximum extent in Y = 0 Maximum extent in Z = [YMAX]"
"'Home Position Information = [XY_ORIGIN], [Z_ORIGIN] "
"'Home X = [XH] Home Y = [YH] Home Z = [ZH]"
"'Rapid clearance gap or Safe Z = [SAFEZ]"
"'UNITS:MM"
"IF %(25)=0 THEN GOTO UNIT_ERROR 'check to see software is set to mm"
"SA 'Set program to absolute coordinate mode"
"CN, 90"
"'New Path"
"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name   = [TOOLNAME]"
"&PWSafeZ = [SAFEZ]"
"&PWZorigin = [Z_ORIGIN]"
"&PWMaterial = [ZLENGTH]"
"'&ToolName = [34][TOOLNAME][34]"
"&Tool =[T] 'Tool number to change to"
"C9 'Change tool"
""
"INPUT [34]What direction would you like the indexer to rotate? Enter 1 for CW, -1 for CCW[34]: 1, &turn_direction 'gets user input, saves value as &turn_direction"	
"INPUT [34]Enter Desired RPM[34]: 150,&rpm 'gets user input, saves value as &rpm"
"MI,B,&turn_direction,&rpm 'start indexer spinning at 250 RPM"
"pause 1 'let indexer get up to speed"
"TR,[S] 'Set spindle RPM"	
"C6 'Spindle on"
"PAUSE 2 'give time for spindle to get to speed"
""
"MS,4,2 'increase move speeds for initial moves"
"MZ,[ZH] 'jog z to save height"
"M2,0,[XH],'move y to home position, x to zero before begining"


+--------------------------------------------
+               Program moves
+--------------------------------------------

begin RAPID_MOVE

"'J3 rapid move:" 
"M3,0,[X],[Y]"

+---------------------------------------------

begin FIRST_FEED_MOVE

"'first feed move:"
"MS,[FC],[FP]"
"M3,0,[X],[Y]"

+---------------------------------------------

begin FEED_MOVE

"M3,0,[X],[Y]"

+---------------------------------------------------
+  Commands output at toolchange
+---------------------------------------------------

begin TOOLCHANGE
""
"Toolchange"
"MI,O 'turn indexer off"
"C7"
"'New Path"
"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name = [TOOLNAME]"
"&TOOL=[T]"
"C9"
"INPUT [34]What direction would you like the indexer to rotate? Enter 1 for CW, -1 for CCW[34]: 1, &turn_direction 'gets user input, saves value as turn_direction"	
"MI,B,&turn_direction,250 'start indexer spinning at 250 RPM"
"pause 1 'let indexer get up to speed"
"TR, [S]"
"C6"

+---------------------------------------------------
+  Commands output for a new segment - toolpath
+  with same toolnumber but maybe different feedrates
+---------------------------------------------------

begin NEW_SEGMENT
""
"'New Path"
"TR, [S]"
"MS,4,2"
"MZ,[ZH]"
"MS,[FC],[FP]"

+---------------------------------------------
+                 end of file
+---------------------------------------------

begin FOOTER
""
"MS,4,2"
"MZ,[ZH]"
"MI,O 'turn indexer off"
"'"
"'Turning router OFF"
"C7"
"END"
"'"
"UNIT_ERROR:"				
"CN, 91 'Run file explaining unit error"