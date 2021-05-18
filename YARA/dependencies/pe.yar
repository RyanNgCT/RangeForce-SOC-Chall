/*
Yara rule for execution of Windows Portable Executables (Signature: MZ/4D5A)
*/

rule pe {
        meta:
                author: "RyanNgCT"
                purpose: "PE file yara rule for RangeForce SOC Challenge Level 2 Q4"
        strings:
                $mb = {4D 5A}
        condition:
                $mb at 0
}
