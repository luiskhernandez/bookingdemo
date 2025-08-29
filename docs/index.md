# Documentation Structure

This document explains the organization and purpose of the documentation folder structure for the Booking Demo Rails application.

## Overview

The `docs/` folder contains all project documentation organized by purpose and domain, following a domain-driven structure that aligns with the application architecture.

## Folder Structure

### `/docs/context/`
Contains contextual information and background documentation for the project.

### `/docs/dev/`
Development-focused documentation including setup guides, development tools, and technical references.

**Files:**
- `tailwind-installation-guide.md` - Guide for setting up Tailwind CSS in the project

### `/docs/domains/`
Domain-driven documentation organized by business domains. Each domain contains its own comprehensive documentation structure.

#### `/docs/domains/account-profiles/`
Documentation for the account-profiles domain, which handles user accounts and profile management.

**Structure:**
- `index.md` - Domain overview and navigation
- `prd.md` - Product Requirements Document
- `plan.md` - Implementation plan and strategy
- `/adrs/` - Architecture Decision Records
  - `0001-use-uuid-keys.md` - Decision to use UUID primary keys
  - `0002-citext-for-emails.md` - Decision to use citext for email fields
- `/assets/` - Domain-specific assets and resources
- `/diagrams/` - Technical diagrams and visualizations
  - `erd.mmd` - Entity Relationship Diagram in Mermaid format
- `/tasks/` - Implementation tasks and work breakdown
  - `index.md` - Task overview and status
  - `task-001-db-extensions.md` - Database extensions setup
  - `task-003-user-model.md` - User model implementation
  - `task-009-tutor-onboarding.md` - Tutor onboarding workflow

### `/docs/prompt.md`
Project-specific prompts and AI assistant instructions.

### `/docs/setup/`
Project setup and configuration documentation.

## Documentation Principles

1. **Domain-Driven Organization**: Documentation follows the same domain boundaries as the application code
2. **Comprehensive Coverage**: Each domain includes PRD, implementation plan, ADRs, and task breakdown
3. **Living Documentation**: Documents are updated as the project evolves
4. **Visual Aids**: Diagrams and visual representations support textual documentation
5. **Task-Oriented**: Clear task breakdown with status tracking for implementation

## Navigation

- For domain-specific information, start with the relevant domain's `index.md`
- For development setup, check `/docs/dev/` and `/docs/setup/`
- For architectural decisions, review the ADRs in each domain's `/adrs/` folder
- For visual representations, explore the `/diagrams/` folders within each domain

## Contributing

When adding new documentation:
1. Place domain-specific docs in the appropriate domain folder
2. Use the established structure (index, prd, plan, adrs, tasks)
3. Update this index when adding new top-level folders or significant content
4. Follow the existing naming conventions and markdown formatting