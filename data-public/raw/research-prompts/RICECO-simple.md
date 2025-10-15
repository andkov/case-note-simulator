# RICECO: A Framework for Effective Prompting

RICECO shows how to ask in a way that gets back exactly what you need. You’ll refresh the six parts of RICECO—**Role, Instruction, Context, Examples, Constraints, Output**—and see how each one closes a common gap (e.g., audience specificity, word limits, allowed sources). You’ll practice writing a prompt you can reuse this week, with an emphasis on measurable output (e.g., “1 paragraph + 3-row table”) and source constraints (“official AB sources only”). The aim is fewer clarifying turns and a draft that’s easy to run through **T.R.U.S.T.**

## RICECO in Plain Language

- **R — Role**: Who the model is (and who it’s serving).
- **I — Instruction**: The task and the outcome you want.
- **C — Context**: Audience, jurisdiction, policy scope, reading level, etc.
- **E — Examples**: A tiny sample to set tone/structure when precision matters.
- **C — Constraints**: Allowed sources, privacy rules, length limits, words to avoid.
- **O — Output**: Exact sections, tables, bullet counts, or file structure.

## Copy-Ready RICECO Skeleton Prompts

Paste the following into the model:

```
R: You are a [role] serving [audience].
I: Do [task] to achieve [purpose].
C: Context: [jurisdiction/policy/privacy scope/plain language].
E: Example snippet: “[1–2 lines showing tone/structure].”
C: Constraints: [allowed sources/tone/length/words to avoid].
O: Output as [format: e.g., 120-char SMS + 80-word web blurb + bullet list of 3 actions].
```

## Watch-Outs & Tips

- **Don’t skip Output**: That’s the #1 cause of cleanup later.
- **Keep Examples short**: They guide, they don’t replace the task.
- For compliance-sensitive topics, put the constraints in **bold terms** (e.g., “No personal data. Use only [specific law/policy] as sources.”).