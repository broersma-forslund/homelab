# GitHub Copilot Instructions

This directory contains additional GitHub Copilot instruction files from the [awesome-copilot](https://github.com/github/awesome-copilot) repository.

These instruction files provide GitHub Copilot with best practices and guidelines for working with this homelab infrastructure repository.

## Installed Instructions

### Core Files

- **kubernetes-deployment-best-practices.instructions.md**
  - Comprehensive best practices for deploying and managing applications on Kubernetes
  - Covers Pods, Deployments, Services, Ingress, ConfigMaps, Secrets, health checks, resource limits, scaling, and security contexts
  - Essential for working with the Helm charts in the `apps/` directory

- **devops-core-principles.instructions.md**
  - Foundational instructions covering core DevOps principles, culture (CALMS), and key metrics (DORA)
  - Guides GitHub Copilot in understanding and promoting effective software delivery
  - Applicable to the overall GitOps approach used in this repository

- **containerization-docker-best-practices.instructions.md**
  - Best practices for creating optimized, secure, and efficient Docker images
  - Covers multi-stage builds, image layer optimization, security scanning, and runtime best practices
  - Useful for understanding containerization concepts used throughout the cluster

## Parent Instructions

The main copilot instructions file is located at `.github/copilot-instructions.md` and contains homelab-specific guidance including:
- Repository structure and organization
- Required tools (kubectl, Helm, talosctl)
- Validation and testing workflows
- Common commands reference

## Usage

These instruction files are automatically loaded by GitHub Copilot when working in this repository. They provide context-aware assistance for:
- Creating and modifying Helm charts
- Working with Kubernetes manifests
- Following DevOps best practices
- Understanding containerization concepts

## Source

All instruction files in this directory are sourced from:
https://github.com/github/awesome-copilot/tree/main/instructions

Last updated: October 2024
