# Agent Builder Console (ABC) Implementation Guide
## Expert-Guided Synthetic Case Note Generator

### Overview
This guide walks you through creating the synthetic case note generation workflow in Agent Builder Console (ABC) step-by-step. The goal is to build a 4-stage workflow that guides domain experts through systematic decisions to create realistic, controlled datasets for text analysis validation.

---

## 🎯 **Pre-Implementation Setup**

### What You'll Need Ready:
1. **Agent Builder Console** open and ready
2. **Original Vision**: Reference the `synthetic-case-note-generator.json` for the complete workflow concept
3. **Target Output**: Structured CSV with columns: person_oid, first_name, last_name, gender, age, case_note, complexity_level, archetype_id, writer_style, embedded_scenarios

### Key Workflow Concept:
- **Input**: Domain expert specifications and parameters
- **Output**: Realistic synthetic case note dataset ready for text analysis
- **Flow**: Population → Profiles → Case Notes → Quality Assurance → Export

---

## 📋 **Step-by-Step Build Instructions**

### **STAGE 1: Population Architecture**
*Purpose: Define demographic parameters and risk factor models*

#### Create Stage 1:
1. **Add New Stage** → Name: `Population Architecture`
2. **Set Description**: "Define demographic parameters and risk factor models"

#### Add Nodes to Stage 1:

**Node 1A: Demographics Architect**
- **Type**: Agent (Researcher)
- **Name**: `Demographics Architect`
- **System Prompt**: 
```
You are a demographic modeling expert specializing in Alberta-like social services populations. Guide users through realistic population parameter decisions.
```
- **User Prompt**:
```
Based on the user input: {input}

Help define demographic parameters for synthetic case note generation:
1. Age distribution patterns (18-64 primary, 65-80 secondary)
2. Gender distribution and family structures
3. Geographic spread (urban/rural patterns)
4. Employment status distributions
5. Housing stability patterns

Provide realistic Alberta-like demographic foundations while maintaining complete fictional status.
```

**Node 1B: Risk Factor Modeler**
- **Type**: Agent (Researcher)
- **Name**: `Risk Factor Modeler`
- **System Prompt**:
```
You are an expert in social services risk assessment and client complexity modeling. Focus on realistic co-occurrence patterns of client challenges.
```
- **User Prompt**:
```
Using the context: {input}

Define risk factor combinations and patterns:
1. Mental health challenge prevalence
2. Substance use patterns and co-occurrence
3. Housing instability factors
4. Medical complexity and hospital utilization
5. Justice system involvement patterns
6. Dependent care responsibilities
7. Employment barriers and gaps

Ensure realistic co-occurrence rates that mirror real social services populations.
```

**Node 1C: Reference Data Input**
- **Type**: Function
- **Function**: Excel Input (or File Upload)
- **Purpose**: Load any existing population templates or reference data

#### Stage 1 Execution:
- **Mode**: Parallel (all nodes run simultaneously)

---

### **STAGE 2: Client Profile Assembly**
*Purpose: Create distinct client archetypes with realistic variation*

#### Create Stage 2:
1. **Add New Stage** → Name: `Client Profile Assembly`
2. **Set Description**: "Create distinct client archetypes with realistic variation"

#### Add Nodes to Stage 2:

**Node 2A: Archetype Designer**
- **Type**: Agent (Custom)
- **Name**: `Archetype Designer`
- **System Prompt**:
```
You are a client profiling specialist who creates realistic, diverse client archetypes for social services contexts. Combine demographic and risk factor inputs into coherent client profiles.
```
- **User Prompt**:
```
Synthesize the demographic parameters and risk factors from previous stage: {input}

Create distinct client archetypes that:
1. Combine demographics with realistic risk factor patterns
2. Represent the full spectrum of client complexity
3. Include both typical and edge cases
4. Maintain internal consistency within each profile
5. Enable targeted scenario testing

Generate 8-12 distinct archetypes covering the complexity range.
```

**Node 2B: Complexity Calibrator**
- **Type**: Agent (Custom)
- **Name**: `Complexity Calibrator`
- **System Prompt**:
```
You are a case complexity assessment expert. Assign realistic adversity levels and intervention intensity patterns to client profiles.
```
- **User Prompt**:
```
Based on the client archetypes: {input}

Calibrate complexity levels for each archetype:
1. Low complexity: Minimal barriers, straightforward interventions
2. Moderate complexity: Multiple interacting challenges
3. High complexity: Crisis-level, multi-system involvement
4. Variable complexity: Profiles that can fluctuate

Ensure complexity assignments drive realistic case note patterns and intervention frequencies.
```

#### Stage 2 Connections:
- **Stage 1 → Node 2A**: All Stage 1 outputs feed into Archetype Designer
- **Node 2A → Node 2B**: Archetype Designer output feeds Complexity Calibrator

#### Stage 2 Execution:
- **Mode**: Sequential (Archetype Designer first, then Complexity Calibrator)

---

### **STAGE 3: Case Note Synthesis**
*Purpose: Generate diverse case notes with controlled characteristics*

#### Create Stage 3:
1. **Add New Stage** → Name: `Case Note Synthesis`
2. **Set Description**: "Generate diverse case notes with controlled characteristics"

#### Add Nodes to Stage 3:

**Node 3A: Primary Note Writer**
- **Type**: Agent (Writer)
- **Name**: `Primary Note Writer`
- **System Prompt**:
```
You are an experienced social services caseworker who writes professional, realistic case notes. Use authentic social services terminology and documentation patterns.
```
- **User Prompt**:
```
Generate case notes for the client profiles: {input}

Create case notes that:
1. Follow professional social work documentation standards
2. Include client situation, background, current issue, and desired outcomes
3. Use authentic terminology from Alberta social services context
4. Vary in length and detail appropriately
5. Reflect the complexity level of each client profile

Generate multiple notes per archetype to show realistic variation.
```

**Node 3B: Variation Writer**
- **Type**: Agent (Writer)
- **Name**: `Variation Writer`
- **System Prompt**:
```
You are a documentation style specialist who creates realistic variation in caseworker writing approaches, from experienced professionals to newer staff, rushed vs thorough documentation.
```
- **User Prompt**:
```
Create alternative writing styles for the same client profiles: {input}

Generate variations representing:
1. Experienced vs newer caseworker documentation
2. Rushed vs thorough note-taking
3. Different organizational documentation cultures
4. Varying levels of detail and completeness
5. Different caseworker personalities and approaches

Maintain factual consistency while varying style and depth.
```

**Node 3C: Scenario Encoder**
- **Type**: Agent (Custom)
- **Name**: `Scenario Encoder`
- **System Prompt**:
```
You are a testing scenario specialist who embeds specific, measurable conditions into case notes for algorithm validation purposes.
```
- **User Prompt**:
```
Embed testable scenarios into subset of case notes: {input}

Create targeted scenarios for:
1. Specific sentiment patterns (positive/negative/mixed)
2. Risk flags (safety concerns, crisis indicators)
3. Service coordination needs
4. Outcome prediction challenges
5. Edge cases for algorithm testing

Ensure scenarios are realistic but clearly identifiable for validation purposes.
```

#### Stage 3 Connections:
- **Stage 2 → All Stage 3 Nodes**: Complexity Calibrator output feeds all three writers

#### Stage 3 Execution:
- **Mode**: Parallel (all three writers work simultaneously)

---

### **STAGE 4: Quality Assurance & Export**
*Purpose: Validate realism and format final dataset*

#### Create Stage 4:
1. **Add New Stage** → Name: `Quality Assurance & Export`
2. **Set Description**: "Validate realism and format final dataset"

#### Add Nodes to Stage 4:

**Node 4A: Realism Validator**
- **Type**: Agent (Validator)
- **Name**: `Realism Validator`
- **System Prompt**:
```
You are a quality assurance specialist for synthetic social services data. Validate authenticity while ensuring complete fictional status.
```
- **User Prompt**:
```
Validate the generated case notes: {input}

Check for:
1. Authentic social services terminology usage
2. Realistic client presentation patterns
3. Appropriate complexity-to-documentation alignment
4. Consistency across related notes
5. Absence of identifiable real-world references
6. Professional documentation standards compliance

Provide quality metrics and improvement recommendations.
```

**Node 4B: Dataset Assembler**
- **Type**: Agent (Formatter)
- **Name**: `Dataset Assembler`
- **System Prompt**:
```
You are a data formatting specialist who creates structured datasets ready for analytical processing. Format synthetic case note data according to SDA specifications.
```
- **User Prompt**:
```
Assemble the final dataset from validated components: {input}

Create structured output with columns:
1. person_oid (unique identifier)
2. first_name (fictional)
3. last_name (fictional)
4. gender
5. age
6. case_note (full text)
7. complexity_level
8. archetype_id
9. writer_style
10. embedded_scenarios (if any)

Ensure format compatibility with text analysis tools and maintain traceability to generation parameters.
```

**Node 4C: Export Function**
- **Type**: Function
- **Function**: Export/File Output (CSV format)
- **Configuration**: 
  - Format: CSV
  - Filename: `synthetic_case_notes_[timestamp]`
  - Include metadata: Yes

#### Stage 4 Connections:
- **All Stage 3 → Node 4A**: All case note writers feed the validator
- **Node 4A → Node 4B**: Validator output feeds assembler
- **Node 4B → Node 4C**: Assembler output feeds export function

#### Stage 4 Execution:
- **Mode**: Sequential (Validator → Assembler → Export)

---

## 🔄 **Connection Overview**

### Inter-Stage Flow:
```
Stage 1 (Parallel) → Stage 2 (Sequential) → Stage 3 (Parallel) → Stage 4 (Sequential)
    ↓                    ↓                      ↓                    ↓
Demographics &       Archetypes &          Case Notes           Validated
Risk Factors         Complexity            (3 styles)           Dataset
```

### Key Connection Points:
1. **Stage 1 → Stage 2**: All demographic and risk factor outputs combine in Archetype Designer
2. **Stage 2 → Stage 3**: Complexity Calibrator output feeds all three note writers
3. **Stage 3 → Stage 4**: All note writer outputs combine in Realism Validator
4. **Within Stage 4**: Sequential validation → assembly → export

---

## 🎛️ **Configuration Settings**

### Workflow-Level Settings:
- **Workflow Name**: `Expert-Guided Synthetic Case Note Generator`
- **Description**: `Multi-stage workflow for generating realistic synthetic case notes with expert-defined parameters`
- **Input Prompt**: `Generate synthetic case notes for social services clients based on expert specifications`

### Execution Parameters:
- **Model Preference**: GPT-4 (for consistency across agents)
- **Output Format**: CSV with metadata
- **Quality Control**: Built-in validation and assembly steps

---

## 📤 **Post-Build Validation Checklist**

### Before Running:
- [ ] All 4 stages created with correct names
- [ ] All 10 nodes properly configured (3+2+3+3)
- [ ] Connections properly established between stages
- [ ] Agent prompts include `{input}` placeholders
- [ ] Export function configured for CSV output
- [ ] Workflow name and description set

### Test Run Preparation:
- [ ] Prepare sample input describing target population
- [ ] Have reference data ready (if using Excel input)
- [ ] Set expectations for ~8-12 client archetypes
- [ ] Plan for multiple case note variations per archetype

---

## 🚀 **Next Steps After Building**

1. **Export the JSON**: Once built in ABC, export the workflow JSON
2. **Submit for Review**: Share the exported JSON for comparison against original vision
3. **Iterative Refinement**: Use AI copilot feedback to adjust prompts, connections, and structure
4. **Test Run**: Execute workflow with sample data to validate output format
5. **Documentation**: Create user guide for operating the completed workflow

---

## 💡 **Tips for Success**

- **Build incrementally**: Complete one stage fully before moving to the next
- **Test connections**: Verify data flows correctly between stages
- **Prompt clarity**: Use specific, actionable language in agent prompts
- **Error handling**: Consider what happens if nodes fail or produce unexpected output
- **Scalability**: Design for different dataset sizes and complexity levels

This guide provides the complete blueprint for recreating your synthetic case note generator vision within the Agent Builder Console's native interface.