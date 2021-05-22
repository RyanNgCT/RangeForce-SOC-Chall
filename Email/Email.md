# Email
As a level 1 SOC Analyst, you want to test your skills concerning email threats to gauge your ability to find security threats associated with phishing.

## 1. Google Account
Open Mozilla Thunderbird and find an email from Lana Banana with the title "This looks weird".
Lana has attached an email that she received and something has triggered her spider-sense. Can you figure out what's going with the email by investigating it?

Alright, so this is my first time dealing with email forensics. I read online that we can use `Ctrl-U` to view the headers, which may contain valuable information.

#### Question 1: 	What is the email's IP address of the origin?

```
Received: from smtp.hughes.net (smtp.hughes.net [69.168.97.48])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by HOT-MX-Relayhost1.contoso.com (Postfix) with ESMTPS id 4BBjZ40qQZz1xmN
	for <lana.banana@contoso.com>; Tue May 18 04:00:21 UTC 2021
```

Looking at the last SMTP hop, we can determine that the origin IP (not sender's IP) is `69.168.97.48`.

#### Question 2: 	According to ipinfo.io, what is the the origin IP's company name?

![img]()

This was quite straightforward, we just have to paste the IP address obtained above into the IP address-related info provider. We will obtain `Syacor, Inc.` as a result of the company `name` field.

#### Question 3: 	According to G Suite Toolbox, what is the SPF status?

![img]()

Again, the tool is provided so we just have to copy-paste the header (again open using `Ctrl-U`) into G Suite. Looking at the results, the SPF status is `softfail` (ignore the "With unknown IP" portion).

#### Question 4: 	Which URL stands out as malicious in this email?

This can be found both in the email contents and the headers. It is `hxxp://router-12fb81e2-6c05-4ab8-9e28-8c2b3c44067d.eastus.cloudapp[.]azure.com` (url sanitized).

#### Question 5: 	If you scan the malicious URL with urlscan.io, what type of attack is this?

![img]()

Using the tool listed, we can view without visitig the page that it presents a login screen rather similar to Google. We can thus confirm that a `phishing` attack is likely in this case. You can view the results at [this link](https://urlscan.io/result/0a087340-31aa-4e0e-953c-5bc9fd794837/)


## Invoice Due Soon
Your accounting department got an invoice from an unknown company, luckily they forwarded the email to you for double-checking before they opened the attachment.
