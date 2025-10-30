# Manual Migration Template
# AI Support System Migration for Mixed-Language Research Repositories
# Compatible with: RAnalysisSkeleton-style projects

## Pre-Migration Checklist

### Target Repository Requirements
- [ ] Repository has `config.yml`
- [ ] Repository has `flow.R` 
- [ ] Repository has `README.md`
- [ ] Repository is a mixed-language research project (R, Python, etc.)
- [ ] You have backup of target repository

### Source Repository Assessment
- [ ] AI support system components identified
- [ ] Components selected for migration:
  - [ ] Persona system
  - [ ] Context management
  - [ ] Memory system
  - [ ] VSCode tasks integration
- [ ] Dependencies verified (R packages: yaml, config)

## Migration Impact Assessment

### Files to be Created
```
target-repo/
├── .copilot-persona                    # Persona tracking
├── .github/
│   └── copilot-instructions.md         # Dynamic AI context
├── ai/                                 # Main AI support directory
│   ├── ai-support-config.yml          # Configuration
│   ├── README.md                       # Documentation
│   ├── memory-human.md                 # Human-readable project memory
│   ├── core/
│   │   └── base-instructions.md        # Core AI instructions
│   ├── docs/                          # AI system documentation
│   │   ├── commands.md                 # Essential commands reference
│   │   ├── context-system.md           # Context management guide
│   │   ├── testing-guide.md            # System testing procedures
│   │   └── mcp-setup/                  # MCP integration setup
│   ├── personas/                       # AI personas (selected)
│   │   ├── developer.md
│   │   ├── project-manager.md
│   │   ├── persona-system-guide.md     # Persona usage guide
│   │   └── [other selected personas]
│   ├── project/                        # Project-specific context
│   │   ├── mission.md                  # Project purpose
│   │   ├── method.md                   # Methodology
│   │   └── glossary.md                 # Domain terminology
│   ├── scripts/                        # Portable logic
│   │   ├── ai-context-management.R     # Context switching
│   │   ├── ai-memory-functions.R       # Memory management
│   │   ├── dynamic-context-builder.R   # Context updates
│   │   ├── migration-utilities.R       # Migration helpers
│   │   ├── tests/                      # Test suite
│   │   └── wrappers/                   # R script wrappers
│   ├── memory/                         # Memory system
│   │   ├── memory-hub.md               # Memory integration hub
│   │   ├── memory-ai.md                # AI memory tracking
│   │   ├── memory-human.md             # Human memory tracking
│   │   ├── memory-guide.md             # Memory system guide
│   │   └── log/                        # Automated memory logs
│   ├── templates/                      # Migration templates
│   │   ├── manual-migration-template.md
│   │   └── ai-assisted-migration-template.md
│   └── vscode/
│       └── tasks-template.json         # VSCode task templates
```

### Files to be Modified
- [ ] `config.yml` - Add ai_support section (minimal)
- [ ] `.vscode/tasks.json` - Add AI-related tasks (if VSCode integration selected)
- [ ] Optional: `flow.R` - Add AI support integration (minimal)

### Potential Conflicts
- [ ] Check for existing `.copilot-persona` file
- [ ] Check for existing `.github/copilot-instructions.md`
- [ ] Check for existing `ai/` directory
- [ ] Check for conflicting VSCode task names

## Migration Steps

### Step 1: Pre-Migration Validation
```r
# In source repository
source("ai/scripts/ai-context-management.R")
assessment <- generate_migration_assessment(
  source_path = ".",
  target_path = "/path/to/target/repo",
  components = c("personas", "context", "memory", "vscode")
)
```

**Review Assessment Results:**
- [ ] All requirements met
- [ ] Conflicts identified and resolved
- [ ] Impact understood and approved

### Step 2: Directory Structure Creation
```powershell
# In target repository
New-Item -ItemType Directory -Path "ai" -Force
New-Item -ItemType Directory -Path "ai\core" -Force
New-Item -ItemType Directory -Path "ai\docs" -Force
New-Item -ItemType Directory -Path "ai\docs\mcp-setup" -Force
New-Item -ItemType Directory -Path "ai\personas" -Force
New-Item -ItemType Directory -Path "ai\project" -Force
New-Item -ItemType Directory -Path "ai\scripts" -Force
New-Item -ItemType Directory -Path "ai\scripts\tests" -Force
New-Item -ItemType Directory -Path "ai\scripts\wrappers" -Force
New-Item -ItemType Directory -Path "ai\memory" -Force
New-Item -ItemType Directory -Path "ai\memory\log" -Force
New-Item -ItemType Directory -Path "ai\templates" -Force
New-Item -ItemType Directory -Path "ai\vscode" -Force
New-Item -ItemType Directory -Path ".github" -Force
```

**Verification:**
- [ ] All directories created successfully
- [ ] No permission errors encountered

### Step 3: Core System Files
Copy these files from source to target:

```powershell
# Configuration and documentation
Copy-Item "ai\ai-support-config.yml" "target-repo\ai\"
Copy-Item "ai\README.md" "target-repo\ai\"
Copy-Item "ai\memory-human.md" "target-repo\ai\"
Copy-Item "ai\core\base-instructions.md" "target-repo\ai\core\"

# Documentation system
Copy-Item "ai\docs\commands.md" "target-repo\ai\docs\"
Copy-Item "ai\docs\context-system.md" "target-repo\ai\docs\"
Copy-Item "ai\docs\testing-guide.md" "target-repo\ai\docs\"
Copy-Item "ai\docs\mcp-setup\*" "target-repo\ai\docs\mcp-setup\" -Recurse
```

**Verification:**
- [ ] Configuration file copied
- [ ] Documentation copied  
- [ ] Base instructions copied

### Step 4: Persona System Migration
```powershell
# Copy core persona system files
Copy-Item "ai\personas\README.md" "target-repo\ai\personas\"
Copy-Item "ai\personas\persona-system-guide.md" "target-repo\ai\personas\"
Copy-Item "ai\personas\persona-template.md" "target-repo\ai\personas\"
Copy-Item "ai\personas\default.md" "target-repo\ai\personas\"

# Copy selected personas (choose what you need)
Copy-Item "ai\personas\developer.md" "target-repo\ai\personas\"
Copy-Item "ai\personas\project-manager.md" "target-repo\ai\personas\"
Copy-Item "ai\personas\casenote-analyst.md" "target-repo\ai\personas\"
# Add other personas as selected...
```

**Verification:**
- [ ] All selected personas copied
- [ ] Persona files readable and valid

### Step 5: Scripts and Logic Migration
```powershell
# Copy core scripts
Copy-Item "ai\scripts\ai-context-management.R" "target-repo\ai\scripts\"
Copy-Item "ai\scripts\ai-memory-functions.R" "target-repo\ai\scripts\"
Copy-Item "ai\scripts\dynamic-context-builder.R" "target-repo\ai\scripts\"
Copy-Item "ai\scripts\migration-utilities.R" "target-repo\ai\scripts\"

# Copy test suite and wrappers
Copy-Item "ai\scripts\tests\*" "target-repo\ai\scripts\tests\" -Recurse
Copy-Item "ai\scripts\wrappers\*" "target-repo\ai\scripts\wrappers\" -Recurse

# Copy project context files
Copy-Item "ai\project\*" "target-repo\ai\project\" -Recurse

# Copy templates and vscode integration
Copy-Item "ai\templates\*" "target-repo\ai\templates\" -Recurse
Copy-Item "ai\vscode\tasks-template.json" "target-repo\ai\vscode\"
```

**Verification:**
- [ ] All scripts copied
- [ ] R scripts have correct syntax

### Step 6: Memory System Migration
```powershell
# Copy memory system files
Copy-Item "ai\memory\memory-hub.md" "target-repo\ai\memory\"
Copy-Item "ai\memory\memory-ai.md" "target-repo\ai\memory\"
Copy-Item "ai\memory\memory-human.md" "target-repo\ai\memory\"
Copy-Item "ai\memory\memory-guide.md" "target-repo\ai\memory\"
# Note: log/ directory will be created automatically when system runs
```

```r
# Initialize memory system in target repository
source("ai/scripts/ai-memory-functions.R")
initialize_memory_system(project_root = ".", system_type = "ai")
```

**Verification:**
- [ ] Memory system files copied
- [ ] Memory directory structure functional
- [ ] Memory system initialized

### Step 7: Context Management Setup
```powershell
# Create GitHub Copilot integration
New-Item -ItemType File -Path ".github\copilot-instructions.md" -Force
New-Item -ItemType File -Path ".copilot-persona" -Force
```

```r
# Initialize context system
source("ai/scripts/ai-context-management.R")
activate_default()  # Sets up initial context
```

**Verification:**
- [ ] Copilot instructions file created
- [ ] Persona tracking file created
- [ ] Context system responds correctly

### Step 8: VSCode Integration (Optional)
```powershell
# Merge VSCode tasks
# Manual process - review existing .vscode/tasks.json and add AI tasks
```

**Verification:**
- [ ] VSCode tasks added without conflicts
- [ ] All AI tasks execute successfully

### Step 9: Configuration Integration
Edit `config.yml` to add:
```yaml
# AI Support System Configuration
ai_support:
  enabled: true
  system_type: "ai"
  personas_enabled: true
  memory_enabled: true
  context_management: true
```

**Verification:**
- [ ] Config file updated successfully
- [ ] YAML syntax valid
- [ ] No conflicts with existing configuration

## Post-Migration Testing

### Functionality Tests
```r
# Test persona system
source("ai/scripts/ai-context-management.R")
show_context_status()

# Test different personas
activate_developer()
activate_project_manager()
activate_default()
```

**Verification:**
- [ ] All personas activate successfully
- [ ] Context switching works
- [ ] No error messages

### Memory System Tests
```r
# Test memory system
source("ai/scripts/ai-memory-functions.R")
ai_memory_check()

# Test memory updates
simple_memory_update("Migration test entry")
human_memory_update("Migration completed successfully")
```

**Verification:**
- [ ] Memory system operational
- [ ] Memory updates work
- [ ] Files created correctly

### Integration Tests
```r
# Test full system integration
source("ai/scripts/ai-context-management.R")
source("ai/scripts/ai-memory-functions.R")

show_context_status()
ai_memory_check()
```

**Verification:**
- [ ] No conflicts between components
- [ ] All systems work together
- [ ] Performance acceptable

## Rollback Procedure

If migration fails or causes issues:

### Quick Rollback
```powershell
# Remove AI support system
Remove-Item -Recurse -Force "ai"
Remove-Item -Force ".copilot-persona"
Remove-Item -Force ".github\copilot-instructions.md"
```

### Restore from Backup
- [ ] Restore entire repository from backup
- [ ] Verify restoration complete
- [ ] Test core functionality

## Success Criteria

Migration is successful when:
- [ ] All selected components function correctly
- [ ] No conflicts with existing repository functionality
- [ ] AI support system enhances workflow without disruption
- [ ] Documentation and memory systems are operational
- [ ] VSCode integration works (if selected)
- [ ] Performance impact is minimal

## Troubleshooting

### Common Issues
1. **Persona switching fails**: Check file paths and permissions
2. **Memory system not found**: Verify directory structure and initialization
3. **VSCode tasks don't work**: Check task syntax and R path configuration
4. **Context updates fail**: Verify GitHub Copilot integration

### Getting Help
- Review `ai/README.md`
- Check error messages in R console
- Use `show_context_status()` for diagnostics
- Examine log files in `ai/memory/log/`

---

**Migration Template Version**: 1.0.0  
**Compatible with**: AI Support System v1.0.0  
**Target**: Mixed-language research repositories (RAnalysisSkeleton-style)