# Finding Patterns with Yara Challenge

It is early 2017 and there is chatter on security forums about new malware spreading around like wildfire. You have gotten hold of some samples of the malware. Your goal is to analyze it and prepare yourself to be able to detect it in the future.

## 1. Strings

The samples are located in the /home/student/Desktop/sample directory and aptly named 1, 2 and 3.

Perform string analysis on the files and try to look for rare strings that might be unique to the malware.

Analyze the strings in sample/1 to answer the question.

#### Question: How many sequences of printable characters with the minimum length of 7 are there in the file sample/1? Assume printable characters to be single-7-bit-byte characters (ASCII, ISO 8859, etc.), including tab and space characters but no other whitespace characters.

```
$ strings --encoding=s -n 7 1 | wc -l
```

![img](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/images%20for%20yara/Screenshot%202021-05-18%20at%203.20.18%20PM.png)

![img](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/images%20for%20yara/Screenshot%202021-05-18%20at%205.22.33%20PM.png)

Here we use the strings command (someone suggested I look up the [manual page](https://man7.org/linux/man-pages/man1/strings.1.html)). We use `encoding=s`to select `s = single-7-bit-byte characters (ASCII, ISO 8859, etc., default)` and `-n 7` for the minimum of 7 characters.

The answer **varies each time** so it would be the ouput of the command. At the time of screenshot, it was `1767`.

---

## 2. Simple Rule

During the analysis, you noticed that there was an interesting string `cmd.exe /c "%s"`. You want to detect this in the other sample files with a Yara rule.

#### Question: Write a Yara rule to detect the presence of the string `cmd.exe /c "%s"`. Save the rule into the `/home/student/Desktop/rules/offset.yar` file.

For the yara rule, refer to [here](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/dependencies/offset.yar). 

```
student@desktop:~$ cd /home/student/Desktop/rules/ && nano offset.yar
```


## 3. Offset
Now it's time to test your new Yara rule with the sample/2 file.

#### Question: 	What is the offset of the string `cmd.exe /c "%s"` in the file sample/2? Provide an answer in the hex form prepended by 0x e.g. 0x1234.

![img](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/images%20for%20yara/Screenshot%202021-05-18%20at%205.22.53%20PM.png)

```
student@desktop:~$ yara -s /home/student/Desktop/rules/offset.yar /home/student/Desktop/sample/2
a /home/student/Desktop/sample/2
0x45534:$a: cmd.exe /c "%s"
```

The offset is `0x45534`.

## 4. Filetypes
Your colleagues from the IT department have collected a number of suspicious files and placed a copy of them into the Desktop/suspicious directory.

You need to check how many of the files are Windows executables (PE file format), but there are too many files to analyze manually. You can leverage the power of Yara to simplify your work.

#### Question: Write a Yara rule capable of detecting files that have a PE file format in the `/home/student/Desktop/suspicious` directory. Save the rule into the `/home/student/Desktop/rules/pe.yar` file.

For the yara rule, refer to [here](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/dependencies/pe.yar). 

```
student@desktop:~$ cd /home/student/Desktop/suspicious/ && nano pe.yar
```
We can then test the rule out by running it on the samples in the `suspicious` directory.

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

## 5. Detect the Malware
You have gotten a list of strings commonly present in the malware from a threat intelligence community online. These strings are found in the file Desktop/intel/strings.txt.

Create a Yara rule out of these strings to detect the malware. You can also leverage the knowledge from previous sample analysis. Figure out how many files in the Desktop/suspicious directory are this malware.

Create the rule file into the Desktop/rules directory and name the file malware.yar.

#### Question:  Write a Yara rule capable of detecting files that are actually malware in the /home/student/Desktop/suspicious directory. Create the Yara rule from the strings in /home/student/Desktop/intel/strings.txt to detect the malware. Save the rule into the /home/student/Desktop/rules/malware.yar file.

So in this case we have to use the strings (IOCs) given in [intel.txt](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/dependencies/intel_common.txt) in our yara rule constructed [here](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/dependencies/malware.yar). Besides that we also need to be aware of the `MZ` header.

Now we will run the yara rule to check which artifacts contain these strings and are thus likely the samples.

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


## Additional Investigations

We can also see if the files in sample or suspicious directories are malware by uploading them to virustotal. I have used the command below to generate a list of the type of each of the files in the suspicious directory for your reference.

```
student@desktop:~/Desktop$ file -r suspicious/* >| out.txt
```

For sample `1`, it is malware of type `bin` (binary), probably a windows 32-bit version of WannaCry.

![img](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/images%20for%20yara/Screenshot%202021-05-23%20at%2012.46.00%20PM.png)

For sample `2`, it is malware of type Trojan (which has got to do with what variants of WannaCry disguise themselves as.

![img](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/images%20for%20yara/Screenshot%202021-05-23%20at%2012.46.47%20PM.png)

For sample `3`, it is the service that ensures persistence.

![img](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/images%20for%20yara/Screenshot%202021-05-23%20at%2012.47.15%20PM.png)

Further analysis of one of the detected samples of `193` in the suspicious folder shows that it is probably a compressed executable that cannot be detected by Virustotal so in this case, yara will come in handy in detecting the strings used.

![img](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/YARA/images%20for%20yara/Screenshot%202021-05-23%20at%2012.51.52%20PM.png)
