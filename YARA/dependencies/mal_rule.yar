/*
Yara rule for execution of cmd args
*/

rule cmd_rule{
  meta:
    author: "RyanNgCT"
    purpose: "cmd yara rule for RangeForce SOC Challenge Level 2 Q2"

  strings:
    $cmd_rule = "cmd.exe /c \"%s\"
    $mb = {4D 5A}
    
  condition:
    $mb at 0 and $cmd_rule
}
