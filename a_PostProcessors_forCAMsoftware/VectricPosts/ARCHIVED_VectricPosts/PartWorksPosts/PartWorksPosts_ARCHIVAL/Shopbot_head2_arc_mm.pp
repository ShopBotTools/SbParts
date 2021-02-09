+================================================
+                                                
+  ShopBot  -  Vectric machine output configuration file   
+                                                
+================================================
+                                                
+ History                                        
+                                                
+ Who      When       What                         
+ ======== ========== ===========================
+ Tony     20/02/2006 Written   
+ Tony     04/09/2005 Added Circular Arc support
+ Tony     08/11/2006 Fixed XY Offset for Arcs 
| ScottJ  31/10/2007 setup file for PartWorks to keep look consistant  
| ScottJ  12/05/2009 Fixed issue with mutiple toolpaths not remaining at Safe Z                
+================================================

POST_NAME = "ShopBot Head2(MM)(arcs) (*.sbp)"

FILE_EXTENSION = "sbp"

UNITS = "MM"

+------------------------------------------------
+    Line terminating characters                 
+------------------------------------------------

LINE_ENDING = "[13][10]"

+------------------------------------------------
+    Block numbering                             
+------------------------------------------------

LINE_NUMBER_START     = 0
LINE_NUMBER_INCREMENT = 10
LINE_NUMBER_MAXIMUM = 999999

+================================================
+                                                
+    Formating for variables                     
+                                                
+================================================

VAR LINE_NUMBER = [N|A|N|1.0]
VAR SPINDLE_SPEED = [S|A||1.0]
VAR CUT_RATE = [FC|C||1.1|0.0166]
VAR PLUNGE_RATE = [FP|C||1.1|0.0166]
VAR X_POSITION = [X|A||1.6]
VAR Y_POSITION = [Y|A||1.6]
VAR Z_POSITION = [Z|A||1.6]
VAR X_HOME_POSITION = [XH|A||1.6]
VAR Y_HOME_POSITION = [YH|A||1.6]
VAR Z_HOME_POSITION = [ZH|A||1.6]

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

+---------------------------------------------------
+  Commands output at the start of the file
+---------------------------------------------------

begin HEADER


 "'SHOPBOT FILE IN INCHES"
 "IF %(25)=0 THEN GOTO UNIT_ERROR	'check to see software is set to standard"
 "C#,90				 	'Lookup offset values"
  "'"
"'Turning router ON"
"SO,2,1"
"PAUSE 2"
"'"

"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name   = [TOOLNAME]"
"MS,[FC],,[FP]"
"JZ,[ZH]"
"JA,[ZH]"
"J2,[XH],[YH]"

+---------------------------------------------------
+  Commands output for rapid moves 
+---------------------------------------------------

begin RAPID_MOVE

"J4,[X]-&my_XmmHead2offset,[Y]-&my_YmmHead2offset,,[Z]"

+---------------------------------------------------
+  Commands output for the first feed rate move
+---------------------------------------------------

begin FIRST_FEED_MOVE

"M4,[X]-&my_XmmHead2offset,[Y]-&my_YmmHead2offset,,[Z]"

+---------------------------------------------------
+  Commands output for feed rate moves
+---------------------------------------------------

begin FEED_MOVE

"M4,[X]-&my_XmmHead2offset,[Y]-&my_YmmHead2offset,,[Z]"

+---------------------------------------------------
+  Commands output for clockwise arc  move
+---------------------------------------------------

begin CW_ARC_MOVE

"CG, ,[X]-&my_XmmHead2offset,[Y]-&my_YmmHead2offset,[I],[J],T,1"

+---------------------------------------------------
+  Commands output for counterclockwise arc  move
+---------------------------------------------------

begin CCW_ARC_MOVE

"CG, ,[X]-&my_XmmHead2offset,[Y]-&my_YmmHead2offset,[I],[J],T,-1"

+---------------------------------------------------
+  Commands output for a new segment - toolpath
+  with same toolnumber but maybe different feedrates
+---------------------------------------------------

begin NEW_SEGMENT

"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name   = [TOOLNAME]"
"MS,[FC],,[FP]"
"J4,[X],[Y],,[ZH]"

+---------------------------------------------------
+  		 End of the file
+---------------------------------------------------

begin FOOTER

"JZ,[ZH]"
"JA,[ZH]"
"'"
"'Turning router OFF"
"SO,1,0"
"J2,[XH],[YH]"
"'"
"END"
"UNIT_ERROR:"				
"C#,91					'Run file explaining unit error"
"END"

