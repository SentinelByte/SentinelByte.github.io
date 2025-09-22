---
layout: post
title: "CI/CD Pipeline Hardening: Securing GitHub Actions & GitLab CI/CD"
date: 2025-09-19
categories: DevSecOps
author: Dan.C
tags: [ci-cd, github-actions, gitlab-ci, devsecops, security, pipeline-hardening, pipeline-security]
excerpt: "Comprehensive guide to building secure and hardened CI/CD pipelines using GitHub Actions and GitLab CI/CD for DevSecOps teams."
cover: /assets/images/cicd-hardening.png
---

![Cover Image](/assets/images/cicd-hardening.png)

# CI/CD Pipeline Hardening: Securing GitHub Actions & GitLab CI/CD

## Table of Contents
- [Introduction](#introduction)
- [What is CI/CD?](#what-is-cicd)
- [CI/CD Platforms Overview](#ci-cd-platforms-overview)
- [Best Practices Checklist for CI/CD Security](#best-practices-checklist-for-ci-cd-security)
- [GitHub Actions CI/CD Pipelines](#github-actions-ci-cd-pipelines)
  - [Basic Workflow Structure](#basic-workflow-structure)
  - [Secrets Management](#secrets-management)
  - [Hardening GitHub Pipelines](#hardening-github-pipelines)
- [GitLab CI/CD Pipelines](#gitlab-ci-cd-pipelines)
  - [Basic Workflow Structure](#basic-workflow-structure-1)
  - [Secrets Management](#secrets-management-1)
  - [Hardening GitLab Pipelines](#hardening-gitlab-pipelines)
- [Conclusion](#conclusion)
- [Related Posts](#related-posts)

---

## Introduction

CI/CD (Continuous Integration / Continuous Deployment) pipelines are the backbone of modern software delivery. They allow teams to **build, test, and deploy code automatically**, increasing efficiency and reducing errors.  

However, pipelines are also **high-value attack vectors**. If compromised, attackers can:

* Inject malicious code into production.
* Exfiltrate secrets such as cloud credentials.
* Gain unauthorized access to servers or services.

This guide provides **practical, step-by-step instructions for security engineers** to secure CI/CD pipelines using **GitHub Actions** and **GitLab CI/CD**, from general best practices to platform-specific hardening.

---

## What is CI/CD?

CI/CD is a set of practices that **automate software delivery**:

* **Continuous Integration (CI):** Developers frequently merge code changes into a central repository. Automated builds and tests validate these changes early, reducing integration issues.
* **Continuous Deployment / Delivery (CD):** Changes that pass CI are automatically deployed to staging or production environments, eliminating repetitive manual steps.

**Benefits:**

* Faster and more reliable releases.
* Reduced human error during deployment.
* Continuous feedback through automated testing.

**Risks if misconfigured:**

* Leaked secrets.
* Compromised runners executing untrusted code.
* Supply chain attacks via third-party actions or dependencies.

---

## CI/CD Platforms Overview

Before diving into hardening pipelines, let’s compare **two primary CI/CD platforms**:

1. **GitHub Actions**
   * Integrated within GitHub repositories.
   * Uses YAML workflows in `.github/workflows/`.
   * Supports ephemeral runners, OIDC authentication, and secrets management.

2. **GitLab CI/CD**
   * Integrated within GitLab repositories.
   * Configured via `.gitlab-ci.yml`.
   * Supports shared and specific runners, protected variables, and built-in SAST/DAST.

> Both platforms allow automation of builds, tests, and deployments, but security configurations and best practices differ slightly. We will cover **platform-specific guidance** below.

---

## Best Practices Checklist for CI/CD Security

Implement these **step-by-step** to harden pipelines from scratch:

1. **Enforce least privilege for tokens and secrets**
* Use ephemeral credentials or OIDC instead of static keys.
* Limit access scope to only what the workflow needs.

2. **Pin third-party actions and Docker images**
* Avoid supply chain attacks by referencing **fixed versions or SHA digests**.

3. **Enable branch protection and PR reviews**
* Ensure only reviewed and tested code can reach main or production branches.

4. **Separate build, test, and deployment stages**
* Clear separation reduces blast radius if a stage is compromised.

5. **Use ephemeral runners or isolated containers**
* Prevent persistent malware or unauthorized access between jobs.

6. **Scan code, dependencies, and containers**
* Integrate SAST, DAST, dependency scanning, and container scanning.

7. **Monitor and audit secrets usage**
* Detect unauthorized access or misuse in pipelines.

8. **Rotate secrets and tokens regularly**
* Reduces risk from leaked or stale credentials.

9. **Enforce CI/CD workflow permissions**
* Grant only the minimum permissions required for each workflow.

> Implementing this checklist **before diving into platform-specific hardening** ensures a strong baseline.

---

## GitHub Actions CI/CD Pipelines

GitHub Actions allows automation **directly in GitHub**, with workflows defined in `.github/workflows/`.

### Basic Workflow Structure

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test
````

**Explanation:**

* `on:` defines events triggering the workflow.
* `jobs:` are isolated tasks; `runs-on:` sets the environment.
* `steps:` can run shell commands or call reusable actions.
* This is the **foundation** for building secure, automated pipelines.

---

### Secrets Management

Never store secrets in code. Use **GitHub encrypted secrets**:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

**Why:**

* Secrets are encrypted at rest and masked in logs.
* Only authorized jobs can access secrets.
* Using OIDC is preferable to static credentials when connecting to cloud providers.

---

### Hardening GitHub Pipelines

Key security measures:

1. **Use least privilege tokens**

   * Example: OIDC for cloud access instead of static PATs.

2. **Pin third-party actions**

   ```yaml
   uses: actions/checkout@v4 # pinned SHA to prevent supply chain attacks
   ```

3. **Restrict branch access**

   * Require PR reviews.
   * Enable status checks.
   * Disallow force pushes.

4. **Enable push protection & secret scanning**

   * Automatically blocks secrets in commits.

5. **Limit workflow permissions**

   ```yaml
   permissions:
     contents: read       # Only read repo content
     id-token: write      # Only required if using OIDC
   ```

6. **Use ephemeral runners or containers**

   * Reduces persistence of malicious code between jobs.

---

## GitLab CI/CD Pipelines

Configured via `.gitlab-ci.yml` in repo root.

### Basic Workflow Structure

```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  image: node:20
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - dist/

test:
  stage: test
  image: node:20
  script:
    - npm test
  dependencies:
    - build

deploy:
  stage: deploy
  image: amazon/aws-cli:2.13.3
  script:
    - aws s3 sync ./dist s3://my-bucket --delete
  only:
    - main
```

**Explanation:**

* `stages:` defines the pipeline order.
* Jobs run in **containerized environments** for isolation.
* `artifacts:` persist outputs between jobs.
* `only:` restricts deployment to main branch.

---

### Secrets Management

GitLab uses **CI/CD variables**:

```yaml
deploy:
  stage: deploy
  script:
    - echo "Deploying..."
    - aws s3 sync ./dist s3://my-bucket --delete
  only:
    - main
  variables:
    AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
```

**Best practices:**

* Mark variables as **masked** to prevent logging.
* Set `protected: true` to restrict usage to protected branches.

---

### Hardening GitLab Pipelines

1. **Least privilege runners** — dedicated runners for sensitive jobs.
2. **Limit job permissions** — avoid exposing admin credentials.
3. **Pin Docker images**

   ```yaml
   image: node:20@sha256:<digest>
   ```
4. **Protected branches** — only maintainers can merge or push.
5. **Security scanning** — enable SAST, DAST, dependency scanning.
6. **Audit CI/CD variables regularly** — rotate secrets and monitor usage.

---

## Conclusion

CI/CD pipelines accelerate software delivery, but **speed without security is risky**.

By following this guide, security engineers can:

* Secure secrets and credentials.
* Limit access and permissions.
* Harden workflow execution.
* Reduce supply chain risks.

Implementing these practices ensures automation **enhances productivity without introducing vulnerabilities**.

---

## Related Posts

* [Top Threat Modeling Frameworks](https://sentinelbyte.github.io/threat-modeling/top-threat-nodeling-frameworks/)
* [Terraform Security Best Practices](https://sentinelbyte.github.io/terraform/terraform-security-best-practice/)
* [Pig Butchering Scams: How Social Engineering Works](https://sentinelbyte.github.io/social-engineering/the-pig-butchering-scams/)

---

*Fast delivery shouldn’t mean fragile security.*
— Dan.C
