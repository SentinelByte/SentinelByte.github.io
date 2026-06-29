---
layout: post
title: "How Cloudflare Scaled AI Security Reviews Beyond Pull Requests"
date: 2026-06-24
categories: ai-security
author: Dan.C
tags: [cloudflare, ai, llm, appsec, security-engineering, devsecops, hitl, ai-agents]
excerpt: "An analysis of Cloudflare's approach to scaling AI-powered security reviews beyond pull requests through automated discovery, validation, remediation, and human-in-the-loop workflows."
cover: /assets/images/cloudfalre-ai.jpg
--------------------------------------------------------

![Cover Image](/assets/images/cloudfalre-ai.jpg)

# How Cloudflare Scaled AI Security Reviews Beyond PRs

## Table of Contents

1. [The Problem With AI PR Reviews](#the-problem-with-ai-pr-reviews)
2. [From Skill to Security Pipeline](#from-skill-to-security-pipeline)
3. [Phase 1: Understanding Before Scanning](#phase-1-understanding-before-scanning)
4. [Phase 2: Vulnerability Discovery](#phase-2-vulnerability-discovery)
5. [A Second Model Checks the Work](#a-second-model-checks-the-work)
6. [AI-Driven Remediation](#ai-driven-remediation)
7. [Human-in-the-Loop Remains Critical](#human-in-the-loop-remains-critical)
8. [Results Across 100+ Repositories](#results-across-100-repositories)
9. [Why This Matters](#why-this-matters)
10. [Final Thoughts](#final-thoughts)
11. [Related Posts](#related-posts)

---

The cybersecurity industry has spent the last two years exploring how Large Language Models (LLMs) can improve application security workflows. One of the most popular use cases has been automated pull request reviews, where AI analyzes code changes and attempts to identify security issues before they reach production.

While the idea is compelling, a fundamental challenge emerges at scale.

Large organizations don't operate a handful of repositories. They operate hundreds or thousands of services, shared libraries, internal frameworks, and interconnected systems. Security risks rarely exist in isolation, and reviewing individual pull requests only provides a small piece of the bigger picture.

Cloudflare appears to have encountered this exact limitation.

What began as a security review "Skill" evolved into a much larger system capable of discovering, validating, prioritizing, and remediating vulnerabilities across an organization's repositories.

---

## The Problem With AI PR Reviews

Traditional AI-powered pull request reviews typically operate within a limited context:

* A specific code change
* A single repository
* Minimal architectural awareness
* Human-driven remediation

This works reasonably well for small-scale analysis but becomes increasingly difficult as organizations grow.

Security teams often need answers to broader questions:

* How do services interact?
* What trust relationships exist?
* Which repositories share sensitive components?
* How can vulnerabilities be prioritized across the entire environment?

Solving these problems requires more than a pull request reviewer.

It requires a workflow.

---

## From Skill to Security Pipeline

According to Cloudflare, their original Skill performed automated security reviews against pull requests.

The concept worked, but eventually ran into scalability limitations.

Rather than optimizing the Skill further, they transformed it into an automated pipeline capable of understanding codebases, finding vulnerabilities, validating findings, generating fixes, and routing recommendations to engineers.

A simplified view of the workflow looks like this:

```text
Repository Analysis
        │
        ▼
Vulnerability Discovery
        │
        ▼
Finding Validation
        │
        ▼
Fix Generation
        │
        ▼
Pull Request Creation
        │
        ▼
Human Approval
```

This approach shifts the focus away from individual pull requests and toward organization-wide security visibility.

---

## Phase 1: Understanding Before Scanning

One of the most interesting design decisions is that vulnerability detection is not the first step.

Before looking for security issues, the system attempts to understand the application itself.

This stage includes:

* Reading source code
* Understanding repository relationships
* Mapping service dependencies
* Building architectural context

Cloudflare described using multiple agents working together during this process.

This mirrors how experienced security engineers typically approach assessments. Understanding architecture and trust boundaries often provides far more value than blindly searching for vulnerabilities.

Without context, findings are frequently noisy.

With context, findings become actionable.

---

## Phase 2: Vulnerability Discovery

After building architectural awareness, the system begins actively searching for vulnerabilities.

This stage includes:

* Security analysis
* Vulnerability discovery
* Validation of findings
* Prioritization
* Report generation

The objective is not simply to generate a large number of findings.

The objective is to identify findings that are relevant, actionable, and worth an engineer's time.

Anyone who has worked with security scanners understands that reducing false positives is often more valuable than generating additional alerts.

---

## A Second Model Checks the Work

One particularly interesting design choice is the use of a separate model for validation.

Rather than relying entirely on the original model's conclusions, Cloudflare introduces a second validation stage.

```text
Model A
Discovers Findings
        │
        ▼
Model B
Validates Findings
```

The second model attempts to verify reported vulnerabilities and increase confidence in the results.

This separation helps reduce situations where a model reinforces its own mistakes and introduces an additional layer of quality control before findings reach engineers.

---

## AI-Driven Remediation

Many security tools stop after generating reports.

Cloudflare's workflow continues further.

Once findings are validated, the system attempts remediation by:

* Generating fixes
* Running tests
* Verifying functionality
* Opening pull requests

This transforms the system from a vulnerability detection platform into an engineering assistant.

The difference is significant.

A finding accompanied by a tested pull request is far more likely to be addressed than a finding buried inside a report waiting for manual remediation.

---

## Human-in-the-Loop Remains Critical

Despite the heavy use of automation, humans remain part of the decision-making process.

Cloudflare routes generated pull requests through a Human-in-the-Loop (HITL) workflow.

Engineers can:

* Approve proposed fixes
* Reject recommendations
* Request modifications

This model preserves accountability while still benefiting from automation.

The goal is not to replace security engineers.

The goal is to increase their effectiveness.

---

## Results Across 100+ Repositories

Cloudflare shared statistics from a run involving more than 100 repositories.

### Initial Output

* More than 20,000 findings generated

### After Validation

* Approximately 13,800 findings passed validation
* Around 5,000 findings were identified as duplicates
* Approximately 1,100 findings were classified as low risk

### Human Review Queue

After automated filtering and prioritization:

* Approximately 7,200 findings required human review

### Final High-Priority Findings

Following review by development and security teams:

* 41 Critical findings
* 777 High severity findings
* Remaining findings categorized as Medium or Low severity

These numbers highlight a reality many security teams already understand:

Finding vulnerabilities is rarely the hardest problem.

Filtering noise is.

---

## Why This Matters

The most interesting aspect of this workflow is not the use of AI itself.

Many organizations are experimenting with AI-powered security tooling.

What makes Cloudflare's approach notable is the structure surrounding the models.

Instead of building a smarter scanner, they built a system capable of:

1. Understanding the environment
2. Discovering vulnerabilities
3. Validating findings
4. Generating fixes
5. Creating pull requests
6. Keeping humans in control

This is likely closer to the future of practical AI security engineering than a single all-knowing security model.

---

## Final Thoughts

Security teams often focus heavily on detection.

Cloudflare's workflow demonstrates the value of optimizing the entire lifecycle instead.

A vulnerability only becomes meaningful when it can be trusted, prioritized, remediated, and ultimately resolved.

The organizations that successfully integrate AI into security operations will likely be those that focus less on individual models and more on designing scalable workflows around them.

For security engineers, that may be the most important lesson of all.

---

## Related Posts

{% include related-posts.html %}

---

*Stay curious. Keep building.*

* Dan.C
