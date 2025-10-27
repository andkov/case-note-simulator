# ./ai/README.md

This folder contains the **project-specific**  documents that build on the foundational philosophy from the project-generic `./philosophy/` folder to address the needs of this particular human–AI collaborative research project. 

This document overviews the **project-specific implementation** of FIDES (Framework for Interpretive Dialogue and Epistemic Symbiosis) - an extensible framework for the practical components of **human–AI collaborative data analysis**, where the human serves as **philosopher–scientist** and the AI functions as a **modal translator and analytic executor**.

The folder contains a comprehensive AI system including specialized personas, memory management, and project-specific guidance instrumental for directing the scope of AI assistance.

## 🚀 Quick Start
- **Default Ready**: Developer persona loads automatically for backend/infrastructure work
- **Domain Switch**: Use `activate_casenote_analyst()` for specialized case note analysis  
- **Full Guide**: See `./personas/persona-system-guide.md` for comprehensive documentation


## Project-Level FIDES Framework
| Directory/File         | Function                                          |
|---------------------------|---------------------------------------------|
| `project/`              | **Project Context Directory** - Strategic FIDES framework components |
| `project/mission.md`    | Project mission, research objectives, and strategic goals |
| `project/method.md`     | Research methodology and analytical frameworks |
| `project/glossary.md`   | Domain terminology and shared vocabulary |
| `onboarding-ai.md`      | AI agent onboarding and general project context |
| `vscode-tasks-reference.md` | Reference for VS Code task automation |

## AI Persona System
| Directory/File         | Function                                          |
|---------------------------|---------------------------------------------|
| `personas/`             | **Complete AI Persona System** - Specialized AI assistants for different work contexts |
| `personas/developer.md` | **Developer** [DEFAULT] - Backend systems and reproducible research specialist |
| `personas/project-manager.md` | **Project Manager** - Strategic oversight and project alignment |
| `personas/casenote-analyst.md` | **Case Note Analyst** - Social services data analysis and risk stratification |
| `personas/README.md`    | Persona system overview and quick reference |
| `personas/persona-system-guide.md` | Comprehensive guide for humans and AI agents |

### Automation: Persona Switching updates Context Overview
- Using the VS Code tasks (e.g., "Activate Developer Persona", "Activate Project Manager Persona", "Activate Case Note Analyst Persona", or "Activate Default Persona") not only switches the active persona but also updates the top CONTEXT OVERVIEW in `.github/copilot-instructions.md` so the "Active Persona" line reflects the current persona.
- If you switch personas via R directly, prefer:
	- `source('scripts/ai-context-management.R'); activate_developer();` (or other `activate_*()`), which performs the same update automatically.
	- `show_context_status()` to verify the active persona and loaded project context.

## Memory & Project Management (MPM) System
| File in `./ai/`         | Function                                          |
|---------------------------|---------------------------------------------|
| `memory-hub.md`         | Central memory coordination and project state |
| `memory-ai.md`          | AI agent memory and context tracking |
| `memory-human.md`       | Human decision logbook and project intentions |
| `memory-guide.md`       | Guide to using the memory system effectively |


## Project-generic philosophy 

| File in `./philosophy/`         | Function                                          |
|---------------------------|---------------------------------------------|
| `analysis-templatization.md` | Philosophy of template-based analysis for reproducibility |
| `causal-inference.md` | Guide to causal inference concepts in social sciences |
| `FIDES-example.md` | Example implementation of FIDES framework |
| `semiology.md` | Dialectical epistemology for AI-augmented research |
| `threats-to-validity.md` | Framework for addressing validity threats in research |




