# Agentic Workspace Design for VSCode Case Note Simulator

## Objective
Design a modular, agentic workspace structure for the Case Note Simulator that preserves the clarity and flow of the ABC workflow, while enabling reproducible, text-based development in VSCode.

## Rationale
The ABC approach excels at creating a clear mental model of sequential stages and parallel cards, making the flow of artifacts easy to visualize and reference. To translate this strength into a text-based, reproducible format, we propose a flat folder structure within a dedicated `workflow` subfolder. This supports modular development, agentic workflows, and unambiguous asset referencing, while keeping the main `take-4-vscode/` folder available for other scripts and resources.

## Proposed Structure

- Root: `./analysis/take-4-vscode/workflow/`
- Each "card" represents an agent-task space, in which one monothematic agent carries out one monothematic task.
- Cards: Subfolders named `card11/`, `card12/`, ..., up to `cardNN/` (N ≤ 100; two-digit numbering encodes stage and card, e.g., `card23` = stage 2, card 3).
- Each card folder contains modular assets:
  - `systemPromptXX.md` (system-level instructions for card XX)
  - `userPromptXX.md` (user-facing prompt for card XX)
  - `inputXX-YY.md` (inputs for card XX, component YY)
  - `outputXX-ZZ.md` (outputs for card XX, component ZZ)
  - Additional files as needed, always following the `XX-YY` or `XX-ZZ` convention for traceability.

## Guidance for Implementation

- Each card is a distinct unit of work, with clear boundaries and outputs.
- Assets should be referenced by their unique filenames in chat and documentation to support agentic workflows.
- The flat structure within `workflow/` is designed for rapid navigation, extensibility, and reproducibility.
- Limit the total number of cards to 100 to maintain clarity and manageability.
- All components should be documented and versioned to support collaborative development and review.



