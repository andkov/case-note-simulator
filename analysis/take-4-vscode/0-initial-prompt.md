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

---

## RICECO Interview for Data Engineer Persona (ABC Workflow Adaptation)

To prepare a RICECO-compliant implementation prompt for the Data Engineer persona, please answer the following questions. These will guide the design of a modular, agentic workflow in VSCode, inspired by the ABC workflow structure and customized for a text-based system.

### 1. Role
- Who should the Data Engineer "be" in this workflow? (e.g., technical architect, domain specialist, etc.)
- Should they have domain knowledge (e.g., social services, synthetic data generation), or focus on technical implementation only?

### 2. Instruction
- What is the core task for the Data Engineer? (e.g., implement a modular pipeline, generate/validate/export synthetic case notes, etc.)
- Should the pipeline support specific agent-task cards as in ABC, or is it more generic?

### 3. Context
- What is the project background and key requirements? (e.g., adaptation of ABC workflow, VSCode environment, synthetic case note generation, validation targets, documentation styles)
- Are there specific ABC workflow elements to preserve or adapt (stages, agent roles, validation targets)?

### 4. Examples
- Provide sample card names, agent roles, or workflow steps from ABC that should be mirrored or customized.
- Are there example input/output files, folder structures, or data formats to use?

### 5. Constraints
- What are the boundaries for implementation? (e.g., card count limit, file types, reproducibility, modularity, traceability)
- Any technology, naming, or documentation standards to enforce?

### 6. Output Format
- How should the Data Engineer deliver the solution? (e.g., folder structure, sample card folders, template markdown/YAML files)
- Should outputs include code, documentation, or both?

---

*Please answer these questions to enable construction of a RICECO-compliant prompt for Data Engineer implementation. Your responses will be synthesized into a clear, actionable specification.*

---

## Data Engineer Implementation Design: Synthetic Case Note Workflow (VSCode)

### [R]ole
You are a Data Engineer specializing in synthetic data generation for social research. Your expertise includes designing modular, reproducible systems for agentic workflows in VSCode environments.

### [I]nstruction
Your task is to design—at a high level—a modular system for generating synthetic case notes based on population parameters. The system should support agentic implementation, allowing each workflow “card” to be run individually (with all required inputs) or as part of a complete workflow. Do not implement code yet; focus on architecture, folder structure, and how scripts, data, and artifacts will fit together.

### [C]ontext
This project adapts the ABC agentic workflow to a VSCode-based, text-driven system for synthetic case note generation. Each card represents a monothematic agent-task space, and must be independently executable and reviewable by humans. Cards may contain text, scripts, data, and other artifacts (e.g., images). The system must be reproducible and support iterative testing and refinement. See `ai/project` for additional background.

### [E]xamples
Reference the `abc-3-simulator.json` for examples of workflow stages and card naming conventions, but prioritize simplicity and parsimony. Use common sense and tidyverse standards for input/output files. Example card folders: `card11/`, `card12/`, etc. Example assets: `systemPrompt11.md`, `userPrompt11.md`, `input11-01.yml`, `output11-01.csv`, `artifact11-01.png`.

### [C]onstraints
- Limit to 100 cards maximum.
- All cards must be direct children of `./analysis/take-4-vscode/workflow/`.
- Each card must be independently runnable and reviewable.
- Use markdown, YAML, CSV, and image files as appropriate.
- Follow tidyverse standards for data files.
- Prioritize simplicity, modularity, and traceability.
- Do not mimic all ABC card properties; only include what is necessary.

### [O]utput Format
Provide:
- A folder structure for the workflow.
- Sample card folders and template markdown/YAML files for each card.
- Naming conventions that mimic the card structure of the ABC workflow (e.g., `card11/`, `systemPrompt11.md`).
- No code implementation yet—focus on design and structure.

---

*This prompt is for high-level design only. The goal is to clarify the architecture and workflow before implementation. Please review and refine as needed before proceeding to detailed development.*



# Reaction to the Above by Andriy

Good, but let's simplify. Let's create a verbal description of the workflow we want to implement. Here it is: 

# Logic
Every card has access to outputs of previous cards and the userPrompt.
Instructions in the most recent card (i.e. with higher id number) should supercede in authority over those with lower id number, unless specified otherwise.



# Stage 1: Population Architecture (Architects)
Card11 - Demographics Architect - Inputs user prompt  and outputs [[demographic profile]] of target population.

Card12 - Risk Factor Modeler - Inputs user prompt and demographic profile (card11) and defines [[risk factor profile]].

# Stage 2: Client Profile Assembly (Designers)
Card21 - Archetype Designer - Combines [[demographic profile]] and [[risk factor profile]]  to generate [[archetype descriptions]].

Card22 - Complexity Calibrator - Reviews [[archetype descriptions]] and finetunes the shape of complexity into [[calibrated archetypes]] to be used by the Writers.

# Stage 3: Case Note Generation (Writers)

Card31 - Primary Case Note Writer - Focusing on [[calibrated archetypes]] and mindful of all previous outputs,  generates authentic documentation that reflects real caseworker language, concerns, and observations while maintaining complete fictional status. Determines the distribution of work for the writers - writing quota- (i.e. what percent of cases requested by userPrompt should be written by each member of the writing team).

Card32 - Variation Writer - Using [[calibrated archetypes]] and mindful of all previous outputs, generates case notes that demonstrate realistic stylistic variation and human inconsistencies in documentation practices, according to the quota defined by the Primary Case Note Writer.

Card33 - Scenario Encoder - mindful of all previous output, generates case notes with specific embedded [[testing scenarios]] according to the quota defined by the Primary Case Note Writer.

# Stage 4: Scaling and Validation (Engineers)
Card41 - Data Engineer - Using all previous outputs, designs a pipeline of reproducible scripts (R or python or combination   to play on the strong parts of each language) a) to generate synthetic case notes at scale according to specified population parameters, b) validate the generated notes against predefined quality metrics, and c) export the final dataset in user-friendly formats (CSV, JSON).