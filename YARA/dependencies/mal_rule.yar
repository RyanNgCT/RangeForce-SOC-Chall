/*
Yara rule for execution of cmd args
*/

rule cmd_rule{
  meta:
    author: "RyanNgCT"
    purpose: "cmd yara rule for RangeForce SOC Challenge Level 2 Q2"

  strings:
    $cmd_rule = "cmd.exe /c \"%s\"
    
    
  condition:
    $cmd_rule
}
