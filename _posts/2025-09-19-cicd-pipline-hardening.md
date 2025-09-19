---
layout: post
title: "CI/CD Pipeline Hardening: Securing GitHub Actions & GitLab CI/CD"
date: 2025-09-11
categories: DevSecOps
author: Dan.C
tags: [ci-cd, github-actions, gitlab-ci, devsecops, security, pipeline-hardening, Pipeline-Security]
excerpt: "Comprehensive guide to building secure and hardened CI/CD pipelines using GitHub Actions and GitLab CI/CD for DevSecOps teams."
cover: /assets/images/cicd-hardening.png
---

![Cover Image](/assets/images/cicd-hardening.png)

# CI/CD Pipeline Hardening: Securing GitHub Actions & GitLab CI/CD

## Table of Contents
- [Introduction](#introduction)
- [What is CI/CD?](#what-is-cicd)
- [Why CI/CD Security Matters](#why-cicd-security-matters)
- [GitHub Actions CI/CD Pipelines](#github-actions-ci-cd-pipelines)
  - [Basic Workflow Structure](#basic-workflow-structure)
  - [Secrets Management](#secrets-management)
  - [Hardening GitHub Pipelines](#hardening-github-pipelines)
- [GitLab CI/CD Pipelines](#gitlab-ci-cd-pipelines)
  - [Basic Workflow Structure](#basic-workflow-structure-1)
  - [Secrets Management](#secrets-management-1)
  - [Hardening GitLab Pipelines](#hardening-gitlab-pipelines)
- [Best Practices Checklist for CI/CD Security](#best-practices-checklist-for-ci-cd-security)
- [Conclusion](#conclusion)
- [Related Posts](#related-posts)

---

## Introduction

CI/CD (Continuous Integration / Continuous Deployment) pipelines are the backbone of modern software delivery. They allow teams to **build, test, and deploy code automatically**, increasing efficiency and reducing errors.  

However, CI/CD pipelines are also **high-value attack vectors**. If compromised, an attacker can inject malicious code, exfiltrate secrets, or gain access to production systems.  

This post is a practical, hands-on guide for **security engineers** to understand, build, and **harden CI/CD pipelines** in both GitHub Actions and GitLab CI/CD environments.

---

## What is CI/CD?

CI/CD is a set of practices that **automate the software delivery process**:

- **Continuous Integration (CI):** Developers regularly merge code changes into a central repository. Automated builds and tests validate these changes, catching bugs early.
- **Continuous Deployment / Delivery (CD):** Changes that pass CI tests are automatically deployed to production or staging environments, reducing manual steps and human error.

**Example benefits:**

- Faster releases and reduced lead time.
- Automated testing ensures higher code quality.
- Reduced human error during deployment.

---

## Why CI/CD Security Matters

CI/CD pipelines interact with:

- **Source code** — the intellectual property of your organization.
- **Secrets & credentials** — cloud keys, API tokens, and certificates.
- **Production infrastructure** — live servers and services.

**Risks include:**

- Secrets leakage via logs or code commits.
- Compromised third-party actions or runners.
- Privilege escalation inside the CI/CD environment.
- Unverified dependencies introducing supply chain risks.

Hardening pipelines ensures that **automation doesn’t become a security liability**.

---

## GitHub Actions CI/CD Pipelines

GitHub Actions allows automation of workflows **directly within GitHub**, using YAML files stored in `.github/workflows/`.

### Basic Workflow Structure

A typical GitHub Actions workflow looks like this:

```yaml
name: CI Pipeline

# Trigger pipeline on push to main or PR
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

* `on` specifies **events** that trigger the workflow.
* `jobs` contain tasks that run in isolation; `runs-on` defines the OS environment.
* `steps` define commands or actions; `uses` pulls community actions.

This is the foundation. From here, security hardening is crucial.

---

### Secrets Management

**Never store secrets in code.** Use GitHub's **encrypted secrets**:

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

**Why this matters:**

* `$ secrets` ensures credentials are **never exposed in plaintext**.
* Only jobs with explicit access can use these secrets.
* Avoid echoing secrets in logs.

---

### Hardening GitHub Pipelines

Key hardening steps:

1. **Use least privilege tokens** — Prefer OIDC for cloud access instead of static PATs.
2. **Pin third-party actions** to a **specific commit SHA**:

```yaml
uses: actions/checkout@v4 # pinned version to prevent supply chain risks
```

3. **Restrict branch access** — enforce branch protection rules:

* Require PR reviews.
* Enforce status checks.
* Disallow force pushes on `main`.

4. **Enable push protection and secret scanning**:

* Push protection blocks commits with known secrets.
* Secret scanning alerts on accidental leaks.

5. **Limit workflow permissions**:

```yaml
permissions:
  contents: read
  id-token: write  # Only allow OIDC if necessary
```

6. **Use ephemeral runners or containers** for isolated execution.

---

## GitLab CI/CD Pipelines

GitLab CI/CD is configured via `.gitlab-ci.yml` at the repo root.

### Basic Workflow Structure

```yaml
stages:
  - build
  - test
  - deploy

variables:
  NODE_ENV: production

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

* `stages` define the pipeline flow.
* Jobs run in defined stages, often in **containerized environments**.
* `artifacts` persist build outputs between stages.
* `only` restricts deployment to `main` branch.

---

### Secrets Management

GitLab uses **CI/CD variables**:

* Mask sensitive variables (cannot be printed in logs).
* Set `protected: true` to restrict access to protected branches.

Example:

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

**Why this matters:**

* Secrets remain encrypted in GitLab and accessible only in authorized pipelines.
* Protect variables from merge requests to prevent leaks.

---

### Hardening GitLab Pipelines

1. **Least privilege runners** — Use specific runners for sensitive deployments.
2. **Limit job permissions** — avoid exposing admin credentials.
3. **Pin Docker images** to a digest to avoid malicious image updates:

```yaml
image: node:20@sha256:<digest>
```

4. **Protected branches** for deployments:

* Only maintainers can push/merge.
* Enforce code reviews and CI passing checks.

5. **Pipeline-level security scanning**:

* Use GitLab's SAST, DAST, and dependency scanning features.
* Fail pipelines if vulnerabilities are detected.

6. **Audit CI/CD variables regularly**.

---

## Best Practices Checklist for CI/CD Security

* [ ] **Enforce least privilege** for tokens, secrets, and runners.
* [ ] **Pin third-party actions and images** to fixed versions or digests.
* [ ] **Enable branch protection** and PR reviews.
* [ ] **Use ephemeral environments** or containers for isolation.
* [ ] **Scan code and dependencies** automatically.
* [ ] **Monitor and audit secrets usage** regularly.
* [ ] **Use OIDC** instead of static cloud keys where possible.
* [ ] **Separate build, test, and deploy stages** clearly.
* [ ] **Regularly rotate secrets and tokens**.

---

## Conclusion

CI/CD pipelines accelerate software delivery—but **speed without security is dangerous**. By following these best practices for GitHub Actions and GitLab CI/CD:

* Secure secrets and credentials.
* Limit access and permissions.
* Harden workflow execution.
* Reduce supply chain risks.

Security engineers can ensure automation **enhances productivity without introducing vulnerabilities**.

---

## Related Posts

* [Top Threat Modeling Frameworks](https://sentinelbyte.github.io/cybersecurity/threat%20modeling/top-threat-nodeling-frameworks/)
* [Terraform Security Best Practices](https://sentinelbyte.github.io/terraform/terraform-security-best-practice/)
* [Pig Butchering Scams: How Social Engineering Works](https://sentinelbyte.github.io/social-engineering/the-pig-butchering-scams/)

---

*The earlier you model threats, the stronger your defenses will be.*
— Dan.C
