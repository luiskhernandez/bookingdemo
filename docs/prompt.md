Refactor the docs folder to a more domain-specific structure, e.g.:

``````
docs/
└── domains/
    └── account-profiles/
        ├── index.md                 # map of the domain (start here)
        ├── prd.md                   # Product Requirements
        ├── plan.md                  # Tech Implementation Plan (TIP/Spec merged)
        ├── tasks/
        │   ├── index.md             # map of the tasks (with status
        │   ├── task-1.md            # Task 1
        │   ├── task-2.md            # Task 2
        │   └── task-3.md            # Task 3
        ├── adrs/
        │   ├── 0001-use-uuid-keys.md
        │   └── 0002-citext-for-emails.md
        ├── assets/
        │   └── image-1.png
        │   └── custom-instructions.md
        └── diagrams/
            └── erd.mmd
```
