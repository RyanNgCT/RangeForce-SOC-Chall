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

---

## 2. Invoice Due Soon

Your accounting department got an invoice from an unknown company, luckily they forwarded the email to you for double-checking before they opened the attachment.

#### Question 1: What is the IP address that delivered the email to your email server?

```
Received: from contoso.com ([127.0.0.1])
	by contoso.com (contoso.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7GmWICpruD29 for <accounting@contoso.com>;
	Tue, 18 May 2021 04:00:18 UTC
Received: from oogw1333.ocn.ad.jp (oogw1333.ocn.ad.jp [153.153.62.99])
	by contoso.com (Postfix) with ESMTP id 64F33273D4
	for <accounting@contoso.com>; Tue, 18 May 2021 04:00:18 UTC
```

In this case, this would be the **first** IP address on the list (beside `127.0.0.1`), which refers to the local mail server on the computer, which id `152.153.62.99`.

#### Question 2: According to MX Toolbox, what is the SPF Alignment result?

![img]()
![img]()

Similar to the previous exercise, we can put the header in MXToolbox for analysis. The SPF alignment result is `Domain not found in SPF` (meaning that it is not registered and we should probably not trust it).

#### Question 3: According to VirusTotal in the categorization tags at the top of the results page, which scripting language is used by this malware?

![img]()

I kind of guessed this one. Since there was a pdf involved, I guessed that it had to do with `JavaScript`, but too bad pdfid and spidermonkey wasn't installed so we couldn't investigate further. (Source included [here](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/Email/dependencies/invoice_pdf.js))

---

## 3. Account Hacked

Lana Banana got a threatening letter saying her account has been hacked. Help her determine is that really the case.

#### Question: What is the origin "Received: from" FQDN?

We can simply gain the answer to this from the `Received` field of the email file [here](https://github.com/RyanNgCT/RangeForce-SOC-Chall/blob/main/Email/dependencies/acc_hacked.eml) -- `serv1.youarehackzed.ga`.

---

## 4. Urgent
Mark Bark got a Bitcoin demand letter from someone, you need to analyze the email to see if the threat is real.

#### Question 1: According to MX Toolbox, how long did it take for this email to arrive?

Again, we can use the headers to analyse and determine this. It took `24364799` seconds.

#### Question 2: What is the IP address that delivered the email to your email server?

Similar to the methodology used in Part 2 Question 1. 

```
Received: from vs.unitedrunway.org (www3189uj.sakura.ne.jp [133.242.140.203])
	by contoso.com (Postfix) with ESMTPS id 8063B139DC
	for <mark.bark@contoso.com>; Tue May 18 04:00:21 UTC 2021
```
Answer: `133.242.140.203`.

---

## 5. FedEx Billing

The accounting department got an email that looks like it came from FedEx. What are the signs that the FedEx Billing email is not what it appears to be?

#### Question 1: What is the first "Received: from" IP address of Fedex_Billing.eml?

```
Received: from  (
 [135.101.115.149])        by fm-dyn-118-136-233-177.fast.net.id with SMTP id
 8di6s528fo0t2lg.7.20200907205007; Tue, 18 May 2021 04:00:14 UTC
```
Answer: `135.101.115.149`

#### Question 2: According to MX Toolbox SuperTool, what is the actual FedEx mail server IP address?

We can do a reverse search to determine the IP (probably `mx.fedex.com`) which is `204.135.242.200`.

#### Question 3: If you scan the attached file with Virustotal, which CVE is being exploited?

When we upload the rtf file attached to the suspicious email to the platform, we can see that the vulnerability is registered as `CVE-2010-3333`.

---

## 6. Helpdesk Request

Tim Tram forwarded you an email where the helpdesk appears to be asking his credentials for. Company policy is not to give out your credentials to anybody, thus Tim is suspicious.

#### Question 1: The attached Helpdesk_Request.eml email appears to come from helpdesk@contoso.com, what is the message origin IP?

```
Received: from [117.4.117.46] (unknown [117.4.117.46])
	by contoso.com (Postfix) with ESMTP id 6AAD22739C
	for <tim.tram@contoso.com>; Tue, 18 May 2021 04:00:18 UTC
```

Answer: `117.4.117.46`.

#### Question 2: If you reply to this email, who will actually receive it? 

We can actually try this in Thunderbird and the destination email address is `helpdesk@contoso.com`.

#### Question 3: According to G Suite Toolbox, what is the result of "delivered after"?

The default delay period is `7 hours`.

---

## 7. New App Connected
Joe King forwarded you an email from Microsoft that says something about a new app connection. Is this a legitimate email or should Joe worry?

#### Question 1: What is the first "Received: from" IP address of 'New_app_connected_to_your_Microsoft_account.eml'?

```
Received: from accountprotection.microsoft.com (65.52.110.208) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19 via Frontend Transport; Tue, 18 May 2021 04:00:13 UTC
```

Answer: `65.52.110.208`.


#### Question 2: According to ipinfo.io, what is the the origin IP's company name?

Answer: `Microsoft Corporation`.

#### Question 3: According to MX Toolbox, what is the result of SPF Syntax Check and DKIM Syntax Check?

Answer:  `The record is valid` (for both questions)
