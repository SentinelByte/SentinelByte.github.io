---
layout: post
title: "AiTM Phishing Bypass MFA"
date: 2026-02-22
categories: red-team
author: Dan.C
tags: [evilginx, phishing, AiTM, adversary-in-the-middle, mfa-bypass, session-hijacking, cybersecurity]
excerpt: "A technical overview of Evilginx, how it works, why attackers use it to bypass MFA, and how defenders can detect and mitigate it."
image: /assets/images/evilginx-overview.jpg
---
![Cover Image](/assets/images/evilginx-overview.jpg)

## AiTM Phishing Bypass MFA

## Table of Contents
1. [What Is Evilginx2?](#what-is-evilginx2)
2. [Why Attackers Use It](#why-attackers-use-it)
3. [How Evilginx2 Works ](#how-evilginx2-works)  
   - [Reverse Proxy Model](#reverse-proxy-model)
   - [Config setup and phishlets](#config-setup-and-phishlets)
   - [Credential Harvesting](#credential-harvesting)  
   - [Session Cookie Capture](#session-cookie-capture)  
   - [Session Replay](#session-replay)  
4. [Detection and Defensive Considerations](#detection-and-defensive-considerations)
5. [Limitations of the Technique](#limitations-of-the-technique)
6. [Conclusion](#conclusion)
7. [Related Posts](#related-posts)

---

## What Is Evilginx2?

Evilginx2 is an adversary-in-the-middle phishing framework that works as a reverse proxy between a victim and a legitimate website. Instead of creating a fake login page, it transparently forwards traffic to the real site while sitting in the middle. This allows an attacker to capture not only usernames & passwords, but also authenticated session cookies after the user successfully completes multi-factor authN (MFA). With those session tokens, the attacker can access vitim's account without the need of credentials or the second factor itself.


## Why Attackers Use It

Attackers use Evilginx2 because it allows them to bypass common MFA protections such as SMS codes or authenticator apps. Since the victim logs in to the real website through the attacker’s proxy, the authN process succeeds normally, and valid session cookies are generated. The attacker can then reuse those session tokens to access the account without triggering another MFA challenge. This makes the attack more effective than traditional phishing pages that only steal usernames and passwords.


## How Evilginx2 Works

### Reverse Proxy Model

:contentReference[oaicite:0]{index=0} operates as a reverse proxy between the victim and the legitimate website. When the victim accesses the phishing domain, requests are forwarded to the real site and responses are relayed back. This makes the session appear authentic because the user interacts with the genuine application, while the proxy transparently intermediates traffic.

### Config setup and phishlets

Configuration defines how the proxy handles domains and traffic routing. Phishlets are configuration files that describe how authN flows should be intercepted and how session data is extracted. 

1. Install Evilginx: `sudo apt install evilginx2`
2. Edit `/etc/hosts` file and add your domain, ip, subdomains (if any).
3. Add a phishlet file. i.e office365. `vim /usr/share/evilginx2/phishlets/office365.yaml`
4. Run the tool. `evilginx2 --developer` and config domain, IP, and phishlet:
- `config domain <your domain>`
- `config ipv4 <your ip>`
- `phishlets hostname <phishlet name> <your domain>`
- `phishlets enable <phishlet name>`
5. Run `phishlets` command to ensure the new phishlet is enabled and configured 
6. Create the phishing lure URL `lures create <phishlet name>`
7. Get the lure URL `lures get-url <phishlet index number>`

![Evilginx2 Setup](/assets/images/evilginx-setup-commands.jpg)

![2FA Request](/assets/images/evilginx-mfa.jpg)

### Credential Harvesting

During the login process, credentials submitted by the victim pass through the proxy before reaching the target service. Evilginx logs these creds as they transit. Since authN is processed by the real site, there are no obvious signs of compromise from the victim’s perspective. Nevertheless, the user will be redirected back to the real serive login page - prevent any suspicious from the victim that anything actually happened.

### Session Cookie Capture

After successful authN, modern web apps issue session cookies that represent the authenticated state. Because the proxy handles traffic, it can capture these cookies as they are issued by the legitimate server. These session tokens are valuable as they allow account access without requiring password or MFA.

![Session hijacking](/assets/images/evilginx-session-hijacking.jpg)

### Session Replay

With a valid session cookie, an attacker can import the token into their own browser session and impersonate the victim. The server treats the session as authenticated because the token remains valid. This enables account access until the session expires or is revoked by the user or security controls.

![Session cookie usage](/assets/images/cookie-usage.jpg)

![Account access](/assets/images/account-access.jpg)


## Detection and Defensive Considerations

Since AiTM attacks bypass MFA by stealing valid session tokens, defense must focus on phishing-resistant authN and strong session controls.

* **Phishing-Resistant MFA:** Use FIDO2/WebAuthn to bind autN to the legitimate domain.
* **Session Protection:** Enforce managed devices and revoke risky tokens in real time (e.g., CAE).
* **Behavior & Infrastructure Monitoring:** Detect impossible travel, suspicious proxies/ASNs, lookalike domains, and unexpected TLS certificates.


## Limitations of the Technique

AiTM attacks are effective against password and token-based authN, but they fail against phishing-resistant MFA such as FIDO2/WebAuthn, where creds are cryptographically bound to the legitimate domain. They also rely on users clicking malicious links, which strong in-house phishing awareness programs can reduce. Short session lifetimes, device binding, and continuous session monitoring further limit the attack window by quickly invalidating stolen tokens.


## Conclusion

AiTM demonstrates how to bypass traditional MFA by targeting session tokens instead of passwords. The technique highlights a key security gap: authN alone is not enough if session handling is weak. Orgs should move toward phishing-resistant MFA, strong session controls, and continuous monitoring to reduce the real-world impact of these attacks.


## Related Posts

{% include related-posts.html %}


---

*Modern attacks target sessions, not just passwords.*
- Dan.C
