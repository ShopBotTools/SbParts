+================================================
+                                                
+    Vectric machine output configuration file   
+                                                
+================================================
+                                                
+ History                                        
+                                                
+ Who    When       What                         
+ ======== ========== ===========================
+ BrianM   15/08/2005 Written                      
+ BrianM   16/06/2006 Added NEW_SEGMENT section
+                     in case new tool has different 
+                     feedrates to first tool
+ Brian M  14/07/2006 Added circular arc support
| ScottJ  31/10/2007 setup file for PartWorks to keep look consistant
| ScottJ  12/05/2009 Fixed issue with mutiple toolpaths not remaining at Safe Z 
+================================================

POST_NAME = "ShopBot (mm)(*.sbp)"

FILE_EXTENSION = "sbp"

UNITS = "MM"

+------------------------------------------------
+    Line terminating characters                 
+------------------------------------------------

LINE_ENDING = "[13][10]"


+================================================
+                                                
+    Formating for variables                     
+                                                
+================================================

VAR SPINDLE_SPEED = [S|A||1.0]
VAR CUT_RATE = [FC|C||1.1|0.0166]
VAR PLUNGE_RATE = [FP|C||1.1|0.0166]
VAR X_POSITION = [X|A||1.6]
VAR Y_POSITION = [Y|A||1.6]
VAR Z_POSITION = [Z|A||1.6]
VAR X_HOME_POSITION = [XH|A||1.6]
VAR Y_HOME_POSITION = [YH|A||1.6]
VAR Z_HOME_POSITION = [ZH|A||1.6]
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

 "'SHOPBOT FILE IN MM"
 "IF %(25)=0 THEN GOTO UNIT_ERROR	'check to see software is set to standard"
 "C#,90				 	'Lookup offset values"
  "'"
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


+---------------------------------------------------
+  Commands output at the end of the file
+---------------------------------------------------

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

