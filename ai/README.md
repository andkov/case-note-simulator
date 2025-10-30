# AI Support System

**Exportable AI-augmented research infrastructure for reproducible research projects**

## Overview

This system provides a portable, modular AI support infrastructure designed for mixed-language research repositories (R, Python, etc.). It separates AI support functionality from core research reproducibility, enabling easy migration between projects while maintaining scientific rigor.

## Architecture Principles

- **Storage/Logic Separation**: Memory artifacts remain project-specific; memory logic is portable
- **Minimal Target Disruption**: Light integration with existing `config.yml`, `flow.R`, and VSCode configurations  
- **Mandatory Assessment**: Built-in migration impact analysis prevents disruption
- **Component Modularity**: Export only the components you need (personas, memory, tasks, etc.)

## Core Components (Priority Order)

### 1. Persona System 🎭
**Location**: `personas/`  
**Priority**: Highest  
**Exportable**: ✅

Specialized AI personas for different research roles:
- `developer.md` - Backend systems and reproducible infrastructure
- `project_manager.md` - Strategic oversight and coordination  
- `casenote_analyst.md` - Domain-specific case note analysis
- `data_engineer.md` - Data pipeline architecture
- `research_scientist.md` - Scientific methodology and analysis
- And 7 more specialized personas...

**Integration Points**:
- `.github/copilot-instructions.md` (dynamic context switching)
- `.copilot-persona` (active persona tracking)
- VSCode tasks for persona activation

### 2. Context Management 🔄
**Location**: `core/`  
**Priority**: High  
**Exportable**: ✅

Dynamic AI context management system:
- Automatic persona switching via `dynamic-context-builder.R`
- Context status monitoring and validation
- GitHub Copilot instruction updates with file mapping
- Cross-session context preservation
- Portable persona switching with auto-detection

**Key Files**:
- `base-instructions.md` - Core AI behavioral guidelines
- `dynamic-context-builder.R` - Core context building engine (63KB)
- Context management scripts in `scripts/`

### 3. Memory System 🧠
**Location**: `scripts/` (logic) + `memory/` (storage)  
**Priority**: Medium  
**Exportable**: ✅ (logic only)

**Storage/Logic Separation**:
- **Exportable Logic**: Memory management functions, validation, integration
- **Project-Specific Storage**: Actual memory files (`memory-ai.md`, `memory-human.md`, etc.)

This design allows memory functionality to be portable while keeping project memories isolated.

### 4. Testing & Verification 🧪
**Location**: `scripts/tests/`  
**Priority**: Medium  
**Exportable**: ✅

Comprehensive testing suite for AI support system components:
- Individual component tests (personas, memory, context)  
- Integration tests (cross-component functionality)
- Automated test runner with detailed reporting
- VSCode task integration for easy execution

**Test Coverage**:
- Persona activation and switching
- Context management system integrity
- Mini-EDA system functionality  
- Memory system operations
- Cross-component integration validation

### 5. VSCode Integration ⚙️
**Location**: `vscode/`  
**Priority**: Medium  
**Exportable**: ✅

Pre-configured VSCode tasks for:
- Persona activation (12 specialized personas)
- Memory system management
- Context status monitoring  
- System validation and testing

## Migration Options

### Manual Migration (with Mandatory Assessment)
1. **Pre-migration Check**: Validates target repository compatibility
2. **Impact Assessment**: Detailed analysis of changes and potential conflicts
3. **Manual Review**: Human approval required before proceeding
4. **Guided Installation**: Step-by-step installation with validation
5. **Post-migration Testing**: Ensures all components work correctly

### AI-Assisted Migration
- Automatic compatibility detection
- Smart conflict resolution
- Adaptive integration based on target repo structure
- Built-in rollback capability

## Target Repository Compatibility

**Primary Target**: Mixed-language research repositories (RAnalysisSkeleton-style)

**Required Structure**:
- `config.yml`
- `flow.R` 
- `README.md`

**Optional Enhancements**:
- `.vscode/tasks.json`
- `.github/` directory
- Existing AI support (will be assessed for conflicts)

## Installation Impact

**Minimal Disruption Approach**:
- `config.yml`: Additions only (new `ai_support` section)
- `flow.R`: Optional minimal modifications
- `.vscode/tasks.json`: Task additions only
- New directories: `ai-support-system/`, `ai/` (if needed)

## Usage Examples

### Exporting Persona System Only
```r
# Export just the persona system to another repo
export_ai_components(
  components = "personas",
  target_repo = "path/to/target",
  mode = "manual"  # Triggers mandatory assessment
)
```

### Full AI Support Migration
```r
# Migrate entire AI support system
migrate_ai_support(
  from = "case-note-simulator",
  to = "aim-2025-sandbox", 
  mode = "ai_assisted",
  components = c("personas", "context", "memory", "vscode")
)
```

## Quick Start

1. **Assessment**: Run compatibility check on target repository
2. **Selection**: Choose components to export (personas, memory, tasks, etc.)
3. **Review**: Examine impact assessment (mandatory for manual mode)
4. **Install**: Execute migration with chosen method
5. **Validate**: Confirm all components work in target environment

## Documentation

### 📚 User Documentation (ai/docs/)
- **`commands.md`** - Essential commands for AI system operations
- **`context-system.md`** - AI context management and persona system guide
- **`mcp-setup/`** - Model Context Protocol setup instructions
- **`testing-guide.md`** - Testing framework documentation

### 🚀 Quick Start
1. **Load system**: `source('ai/scripts/ai-context-management.R')`
2. **Check status**: `show_context_status()`
3. **Switch persona**: `activate_project_manager()` (or other persona)
4. **Get help**: See `ai/docs/commands.md`

## File Structure

```
ai/
├── ai-support-config.yml      # Main configuration
├── README.md                  # This file
├── core/                      # Context management
├── personas/                  # AI personas (12 specialized)
│   ├── developer.md
│   ├── project-manager.md
│   └── ...
├── scripts/                   # Portable logic
│   ├── dynamic-context-builder.R   # Core context building engine
│   ├── ai-context-management.R     # Persona switching with auto-detection  
│   ├── ai-memory-functions.R       # Memory system with storage/logic separation
│   ├── tests/                      # Testing & verification
│   └── wrappers/                   # VSCode task wrapper scripts
├── memory/                    # Project memory system
├── project/                   # Project-specific context
├── templates/                 # Templates and examples
├── vscode/                    # VSCode integration
└── docs/                      # User Documentation
    ├── commands.md             # Command reference
    ├── context-system.md       # Context management guide
    ├── mcp-setup/             # MCP setup instructions
    └── testing-guide.md       # Testing documentation
```

## Philosophy

This system embodies the principle that **AI support infrastructure should be as portable and reusable as research methodology itself**. By separating concerns and maintaining minimal integration footprints, researchers can evolve their AI-augmented workflows across projects while preserving the scientific integrity of their core research processes.

---

*For detailed migration instructions, see `docs/migration-guide.md`*  
*For troubleshooting, see `docs/troubleshooting.md`*
