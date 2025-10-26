# 3-Section Context Management System Guide

The enhanced context management system provides structured, flexible control over AI assistant context through three distinct sections in the copilot instructions.

## 📋 Architecture Overview

### Context Configuration Overview (Header)
- **Purpose**: Real-time visibility into loaded context and file sizes
- **Content**: Section breakdown with KB/line counts, file listing, management commands
- **Updates**: Automatically regenerated each time context changes
- **Benefits**: Immediate understanding of current configuration and resource usage

### Section 1: Core AI Instructions (Static)
- **Purpose**: Core AI behavior, response guidelines, and system-wide instructions
- **Content**: Never changes, provides consistent baseline behavior
- **Includes**: Universal principles, memory detection, automation triggers, response guidelines

### Section 2: Active Role (Dynamic)
- **Purpose**: Single active persona defining specialized role and behavior
- **Content**: One persona file loaded at a time
- **Examples**: Developer (technical focus), Project Manager (strategic oversight), Case Note Analyst (domain expertise)

### Section 3: Additional Context (Dynamic) 
- **Purpose**: Flexible context files relevant to current work
- **Content**: Persona defaults + manually added files
- **Examples**: Project documentation, analysis guides, methodology files

## 🚀 Quick Start

### Basic Persona Switching
```r
# Load system
source('./scripts/update-copilot-context.R')

# Activate personas with their defaults
activate_developer()         # Technical focus, no additional context
activate_project_manager()   # Strategic oversight + mission/method/glossary  
activate_casenote_analyst()  # Domain analysis + onboarding guide

# Check current status
show_context_status()
```

### Advanced Context Management
```r
# Add specific context files
add_context_file('philosophy/analysis-templatization.md')
add_context_file('guides/custom-data-guide.md')

# Discover available files
list_available_md_files()           # All .md files
list_available_md_files('guide')    # Files matching pattern

# Remove context files
remove_context_file('philosophy/analysis-templatization.md')

# Check what's loaded
show_context_status()
```

## 🎭 Available Personas

### Developer (Default)
- **Focus**: Technical implementation, system architecture, reproducible research
- **Default Context**: None (minimal context for focused technical work)
- **Use For**: Backend development, R programming, system maintenance
- **Activation**: `activate_developer()`

### Project Manager
- **Focus**: Strategic oversight, project alignment, stakeholder coordination
- **Default Context**: Project mission, methodology, glossary (full FIDES framework)
- **Use For**: Planning, requirements analysis, project coordination
- **Activation**: `activate_project_manager()`

### Case Note Analyst  
- **Focus**: Domain-specific analysis, social services expertise
- **Default Context**: AI onboarding guide
- **Use For**: Case note analysis, domain-specific tasks
- **Activation**: `activate_casenote_analyst()`

## 📚 Context File Categories

### Project Framework Files
- `project/mission` - Project objectives and strategic vision
- `project/method` - Research methodology and analytical approach  
- `project/glossary` - Domain terminology and definitions
- `onboarding-ai` - AI system introduction and orientation

### Analysis & Methodology
- `philosophy/analysis-templatization.md` - Analysis framework and templates
- `philosophy/semiology.md` - Methodological foundations
- `philosophy/causal-inference.md` - Causal analysis principles

### Implementation Guides
- `guides/custom-data-guide.md` - Data handling procedures
- `guides/implementation-guide.md` - System implementation
- `guides/flow-usage.md` - Workflow usage patterns

### Memory & Documentation
- `memory-hub` - Central memory coordination
- `memory-human` - Human project memory
- `memory-ai` - AI learning and insights

## 🔧 Advanced Features

### File Discovery and Search
```r
# Find all guides
list_available_md_files('guide')

# Find philosophy files  
list_available_md_files('philosophy')

# Find analysis documentation
list_available_md_files('analysis')
```

### Context Status Monitoring
```r
show_context_status()
# Shows:
# - Section 1: Always present (general instructions) 
# - Section 2: Current active persona
# - Section 3: All additional context files with paths
# - Total file size and line count
```

### Built-In Context Overview
Every copilot-instructions.md file now starts with a **Context Configuration Overview** that provides:

- **Real-time metrics**: Total size (KB), line counts, generation timestamp
- **Section breakdown**: Individual size and status for each section
- **File inventory**: Detailed listing of all loaded context files with individual sizes
- **Quick commands**: Ready-to-use R commands for context management

This overview updates automatically every time you change persona or context, giving you immediate visibility into your current configuration without needing to run separate commands.

### Persona Defaults Configuration
Each persona defines its default context in `get_persona_configs()`:
```r
"project-manager" = list(
  file = "./ai/personas/project-manager.md",
  default_context = c("project/mission", "project/method", "project/glossary")
)
```

## 🎯 Usage Patterns

### Data Analysis Session
```r
activate_casenote_analyst()  # Domain expertise
add_context_file('philosophy/analysis-templatization.md')  # Analysis framework
add_context_file('guides/custom-data-guide.md')  # Data procedures
```

### System Development Session  
```r
activate_developer()  # Technical focus
add_context_file('guides/implementation-guide.md')  # Implementation guidance
# Keep context minimal for focused technical work
```

### Project Planning Session
```r
activate_project_manager()  # Strategic oversight (loads mission/method/glossary automatically)
add_context_file('memory-human')  # Project history
add_context_file('philosophy/semiology.md')  # Methodological foundation
```

### Cross-Functional Collaboration
```r
# Strategic planning phase
activate_project_manager()
# Define requirements and priorities

# Implementation phase  
activate_developer()
add_context_file('project/mission')  # Add just mission for alignment
# Execute with strategic context but technical focus
```

## 🔍 Context Size Management

The system provides clear visibility into context loading:
- **Developer**: ~12 KB (minimal for technical efficiency)
- **Project Manager**: ~28+ KB (full strategic context)
- **Custom Combinations**: Add only what's needed for specific tasks

Monitor context size with `show_context_status()` to optimize for:
- **Performance**: Smaller context loads faster
- **Relevance**: More context provides better domain understanding
- **Focus**: Right-sized context maintains task focus

## 🛠️ System Integration

### VS Code Integration
- Context changes update `.github/copilot-instructions.md` automatically
- GitHub Copilot reads updated instructions immediately
- No restart required, changes take effect instantly

### Backward Compatibility
- All existing `activate_*()` functions continue to work
- Legacy file aliases maintained (e.g., `mission` → `project/mission`)
- Gradual migration supported without breaking workflows

### File Organization
The system respects the project's organized structure:
```
ai/
├── personas/     # Section 2 content
├── project/      # FIDES framework for Section 3
└── [memory & other files]  # Available for Section 3

philosophy/       # Methodological context for Section 3
guides/          # Implementation context for Section 3  
```

## 📖 Next Steps

1. **Experiment with combinations**: Try different persona + context combinations for your specific tasks
2. **Create presets**: Consider saving frequently used context combinations
3. **Monitor performance**: Use `show_context_status()` to optimize context size for your needs
4. **Extend personas**: Create custom personas for specialized workflows

The 3-section system provides the flexibility to craft exactly the right context for any task while maintaining clear structure and efficient performance.