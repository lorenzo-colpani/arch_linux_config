# Brain

Global lessons. One per line. Format: `- [tag] lesson <!--id:N-->`.
Short sentences. Active voice. Present tense.
Repo-specific findings belong in each repo's docs/FINDINGS.md, not here.
- [rust] Rust middleware that may or may not consume a request body must carry both outcomes in one enum built before any use; moving the body in one if-branch then using it later trips E0382 conditional-move errors. <!--id:1-->
- [workflow] Plan registries are one committed SQLite file (plans.db) per repo; never generate markdown or YAML plan artifacts. Read state with plans_show; write with plans tools only. <!--id:2-->
