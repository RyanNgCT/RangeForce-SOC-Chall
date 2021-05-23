# SOC Detection Challenge 1 (Splunk)

You are working in Commensurate Technology as a SOC analyst.

Commensurate Tech is using Windows Security (formerly Windows Defender) as the antivirus solution and the computers are configured to gather various events using Sysmon and Splunk forwarder in combination to send logs to a central Splunk server.

Monthly Security Health Check & Compliance Report indicates that Windows Security has been disabled on the host windows10.
You are tasked with making sure whether this issue is just a technical glitch or not. You are also provided with a list of possible indicators of compromise (IOCs) to aid in your intelligence gathering.

You need to find out whether it was disabled for malicious purposes and if so, what was done during the time the computer was compromised.

You will investigate the possible compromise using Splunk SIEM solution.


## 1. Restore Windows Security
You have been notified that the Windows Security AntiSpyware module has been disabled on windows10.

Since you have had issues with Windows Security before, you already have a procedure to re-enable it, along with some handy scripts in `C:\Tools\`.

### Instructions

a) Execute the following script: C:\Tools\01. Enable-WinSecurity-registry.ps1.
b) Go to Windows Security GUI and click on Restart Now in the Virus & threat protection pane.
c) Execute the following script: C:\Tools\02. Restore-WinSecurity-functionality.ps1.

\* *Note: After re-enabling Windows Security in registry, the change can take up to two minutes to reflect in the GUI. You might need to wait until the **Restart Now** button appears.*

### Methodology

Change into the Tools diectory and execute the first command in Powershell. Then launch Windows Defender GUI and under `Virus and Threat Protection`, click `Restart Now`. Thereafter, close Defender and enter the second command for execution in Powershell.

![img]()

---

## 2. Search for IOCs
You received an updated list of IOCs for today. Your daily process is to use Splunk to look for these IOCs and if any match in your environment.

```
192.168.0.126
192.168.0.157
192.168.0.212
192.168.0.214
```

#### Question: 	Which of the IOCs returned events?

This is a bit of a guessing game. We go go on splunk and under `Searching and Reporting`, search the IP addresses one by one. The answer is `192.168.0.212`.

---

## 3. Gather Intelligence

Now that you have the IOC-related events in Splunk, you can pivot and sift through them.

#### Question 1: What is the filename of the malware stager?

I got quite lost with this so someone suggested I look at the events in chronological order (Splunk displays it as reverse chronology by default). Sure enough, I was able to find a suspicious `LaunchPad.bat`.

#### Question 2:	
What type of startup method was used to execute the stager?

 - [ ] Registry
 - [ ] User Startup
 - [x] All Users Startup
 - [ ] WMI
 - [ ] Scheduled Tasks

This involved some digging through tools and knowledge of common IOCs (e.g. reg keys created for persistence or tasks scheduled). Opening Registry Editor, by running `Win+R` followed by `regedit`, I checked `HKLM` and `HKCU` hives for run keys, commonly found as described in [this article](
https://pentestlab.blog/2019/10/01/persistence-registry-run-keys/) at `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run` and `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run` but there was nothing.

![img]()
![img]()

Opening Task Scheduler also found no suspicious scheduled processes (looked like legit Microsoft Processes) as shown below.

![img]()
![img]()

I had some trouble opening WMI, but finally did it with `wmimgmt.svc`, and also found nothing substantial.

![img]()

[This article](https://superuser.com/questions/1010345/how-to-find-all-startup-programs-on-windows-10) suggested using autoruns to detect startup programs and surely, the suspicious batch file was found in another registry key `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Common Startup`!

![img]()

\----------------------------------------------------------------------------------------------------

Using the Splunk Console with the results of `192.168.0.212`, we can answer the following questions

#### Question 3: What is the full path of the archive that was created for data exfiltration?



---

## 4. 


---

## 5. Delete the Stager

Navigate to the corresponding directory and delete the `bat` file.



C:\Windows\Temp\g0nna3XF1l7h15.tAR

"C:\Windows\system32\net.exe" localgroup "Hyper-V Administrators" Palware /add

https://pentestlab.blog/2019/10/01/persistence-registry-run-keys/
