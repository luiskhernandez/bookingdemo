# Account & Profiles Domain

## Overview
This domain handles user authentication, multi-role profiles (Tutor/Student), and profile management for our tutoring marketplace platform.

## Domain Objectives
- Enable single sign-on with multiple role capabilities
- Support independent Tutor and Student profiles
- Provide seamless context switching between roles
- Establish foundation for future booking and payment features

## Key Components

### Core Documents
- **[Product Requirements](./prd.md)** - Business requirements and user stories
- **[Implementation Plan](./plan.md)** - Technical specification and architecture

### Tasks
- **[Task Overview](./tasks/index.md)** - Development tasks and progress tracking

### Architecture Decisions
- **[ADRs Directory](./adrs/)** - Architecture Decision Records

### Diagrams
- **[ERD](./diagrams/erd.mmd)** - Entity Relationship Diagram

## Domain Model

### Entities
- **User** - Core authentication entity (email, password, timezone)
- **Tutor** - Teaching profile with bio, display name, and settings
- **Student** - Learning profile with name and preferences
- **LessonType** - Course offerings (title, duration, active status)

### Key Features
1. **Authentication** - Email/password with Devise
2. **Profile Management** - Optional Tutor/Student profiles per user
3. **Context Switching** - Session-based role switching
4. **Onboarding** - Separate flows for Tutors and Students
5. **Authorization** - Role-based access with Pundit

## Status
**Current Phase:** Planning & Design
**Target Release:** MVP Phase 1

## Team
- **Product Owner:** Presto
- **Engineering Lead:** TBD
- **QA Lead:** TBD

## Related Domains
- **Booking System** (Phase 2) - Will depend on this domain
- **Payment Integration** (Phase 3) - Will integrate with profiles
- **Reviews & Ratings** (Phase 4) - Will extend profile capabilities