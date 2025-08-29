Create the following docs/ structure:

What goes where?
docs/product/prds/

PRDs (Product Requirement Documents): user-facing needs, flows, business logic.

Format: Markdown, named like 2025-01-tutor-booking-prd.md.

docs/engineering/adrs/

Architecture Decision Records: one file per decision (small, immutable).

Format: ADR template
.

Example: 0001-database-use-postgres.md.

docs/engineering/specs/

Tech specs / Solution designs.

More detailed than ADRs, but not step-by-step like TIPs.

Example: lesson-scheduling-spec.md.

docs/engineering/tips/

Technical Implementation Plans (the thing we just wrote).

Task-oriented, actionable instructions for engineers or coding agents.

Example: 2025-02-user-management-tip.md.

docs/engineering/rfcs/

Requests for Comments: open proposals, before they become ADRs/specs.

docs/context/

Context engineering, prompt design, AI guardrails.

E.g. agent-prompts.md, ai-usage-policies.md.

docs/setup/ = environment setup, installation guides, troubleshooting, dev tools.
🧭 Best Practices

Naming convention: prefix with date or ADR number → easy chronological order.

Cross-link: Each TIP links to relevant PRD and ADRs. Example at top of a TIP:

Related:
- PRD: [Tutor Booking MVP](../product/prds/2025-01-tutor-booking-prd.md)
- ADR: [0002-use-uuid-keys.md](../engineering/adrs/0002-use-uuid-keys.md)


Index pages: Each folder should have an index.md (overview, links).

Docs ≠ code: Keep docs/ at the root, not mixed into app/, so devs know where to look.
