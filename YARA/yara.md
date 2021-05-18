# YARA

```
$ strings --encoding=s -n 7 1 | wc -l
```

```
student@desktop:~$ yara -s /home/student/Desktop/rules/offset.yar /home/student/Desktop/sample/2
a /home/student/Desktop/sample/2
0x45534:$a: cmd.exe /c "%s"
```


```
student@desktop:~$ yara /home/student/Desktop/rules/pe.yar /home/student/Desktop/suspicious/
pe /home/student/Desktop/suspicious//193
pe /home/student/Desktop/suspicious//16
pe /home/student/Desktop/suspicious//84
pe /home/student/Desktop/suspicious//196
pe /home/student/Desktop/suspicious//25
pe /home/student/Desktop/suspicious//123
pe /home/student/Desktop/suspicious//55
pe /home/student/Desktop/suspicious//124
pe /home/student/Desktop/suspicious//187
pe /home/student/Desktop/suspicious//200
pe /home/student/Desktop/suspicious//42
pe /home/student/Desktop/suspicious//116
pe /home/student/Desktop/suspicious//161
pe /home/student/Desktop/suspicious//32
pe /home/student/Desktop/suspicious//194
pe /home/student/Desktop/suspicious//148
pe /home/student/Desktop/suspicious//15
pe /home/student/Desktop/suspicious//93
pe /home/student/Desktop/suspicious//133
pe /home/student/Desktop/suspicious//85
pe /home/student/Desktop/suspicious//72
pe /home/student/Desktop/suspicious//13
```
```
student@desktop:~$ yara /home/student/Desktop/rules/malware.yar /home/student/Desktop/suspicious
malware /home/student/Desktop/suspicious/64
malware /home/student/Desktop/suspicious/77
malware /home/student/Desktop/suspicious/172
malware /home/student/Desktop/suspicious/54
malware /home/student/Desktop/suspicious/112
malware /home/student/Desktop/suspicious/128
malware /home/student/Desktop/suspicious/192
malware /home/student/Desktop/suspicious/153
malware /home/student/Desktop/suspicious/152
malware /home/student/Desktop/suspicious/57
malware /home/student/Desktop/suspicious/62
malware /home/student/Desktop/suspicious/125
malware /home/student/Desktop/suspicious/97
malware /home/student/Desktop/suspicious/95
malware /home/student/Desktop/suspicious/140
malware /home/student/Desktop/suspicious/185
malware /home/student/Desktop/suspicious/23
```
