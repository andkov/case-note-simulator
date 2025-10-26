# Project Context Directory

This directory contains the **project-level FIDES framework** components that define the strategic context, methodology, and shared understanding for the case-note-simulator research project. These files provide the foundational context that informs all project work and persona interactions.

## 📁 Directory Structure

```
./ai/project/
├── README.md        # This file - project context overview
├── mission.md       # Project mission, objectives, and research goals
├── method.md        # Research methodology and analytical frameworks
└── glossary.md      # Domain terminology and key definitions
```

## 🎯 FIDES Framework Components

### 📋 Mission (`mission.md`)
**Purpose**: Defines the project's core purpose, research objectives, and intended impact  
**Contains**: Research questions, synthetic data generation goals, stakeholder value propositions  
**Used By**: Project Manager persona for strategic alignment and priority setting

### ⚙️ Method (`method.md`) 
**Purpose**: Articulates research methodology, analytical approaches, and quality standards  
**Contains**: Data generation methods, validation frameworks, reproducibility protocols  
**Used By**: Project Manager for methodological oversight, Case Note Analyst for analysis guidance

### 📖 Glossary (`glossary.md`)
**Purpose**: Provides shared vocabulary and domain-specific definitions  
**Contains**: Key terms, technical concepts, domain-specific terminology  
**Used By**: All personas for consistent terminology and concept understanding

## 🎭 Integration with Persona System

### Project Manager Persona
**Loads**: All project context files (`mission`, `method`, `glossary`)  
**Role**: Strategic oversight, ensuring alignment with project vision  
**Responsibility**: Translate project objectives into actionable guidance for other personas

### Developer Persona  
**Loads**: Minimal context (`agent-persona` only)  
**Role**: Technical implementation focused on system architecture and reproducibility  
**Coordination**: Receives strategic direction from Project Manager persona

### Case Note Analyst Persona
**Loads**: Domain-specific context (`agent-persona`, plus selective project context as needed)  
**Role**: Specialized analysis within the project's methodological framework  
**Coordination**: Operates within methodology defined in project context

## 🔄 Context Loading Strategy

The reorganized architecture follows this principle:
- **Project-Level Context**: Loaded by Project Manager for strategic oversight
- **Persona-Specific Context**: Each persona loads only what's needed for their specialized role
- **On-Demand Context**: Additional context can be loaded when cross-persona collaboration is needed

## 🛠️ Usage Patterns

### Strategic Planning Session
```r
activate_project_manager()  # Loads full project context
# Work on project planning, requirements analysis, risk assessment
```

### Technical Implementation Session  
```r
activate_developer()        # Loads minimal technical context
# Focus on system architecture, performance, reproducibility
```

### Cross-Functional Coordination
```r
activate_project_manager()  # Strategic oversight
# Define requirements and priorities
activate_developer()        # Technical implementation
# Execute based on strategic guidance
```

## 📚 Relationship to Philosophy Directory

The `../philosophy/` directory contains **project-generic** frameworks and methodological foundations that inform multiple projects. The `./project/` directory contains **project-specific** implementations of those frameworks tailored to the case-note-simulator research objectives.

## 🔧 Maintenance

These files should be updated when:
- Research objectives or scope change
- Methodological approaches are refined
- New domain terminology is introduced
- Stakeholder requirements evolve
- Project phases transition

## 📖 Related Documentation

- **Persona System**: `../personas/persona-system-guide.md` - How personas interact with project context
- **AI System Overview**: `../README.md` - Complete AI system architecture
- **Philosophy Framework**: `../../philosophy/README.md` - Generic methodological foundations

---
*The project context directory provides the strategic foundation that ensures all AI assistance remains aligned with research objectives while enabling specialized expertise through the persona system.*