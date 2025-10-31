# Improved User Prompt for Agent 5.1 (Developer - Python Data Generation)

**Task**: Generate a complete, self-contained Python script that creates synthetic case note datasets for algorithm validation testing.

## Primary Objective
Create a fully functional `generate_synthetic_data.py` script that generates 500 synthetic case notes following Alberta social services patterns, without requiring any external input files or dependencies.

## Required Script Structure

### 1. Core Class Implementation
Implement `SyntheticCaseNoteGenerator` class with these essential methods:

```python
class SyntheticCaseNoteGenerator:
    def __init__(self):
        # Initialize population parameters, archetypes, templates
        pass
    
    def generate_demographics(self, target_count: int):
        # Create 500 client profiles with realistic demographics
        pass
    
    def generate_embedded_scenarios(self, clients):
        # Add validation scenarios: 15% housing crisis, 8% mental health, 12% success
        pass
    
    def generate_case_note(self, client):
        # Generate case note text based on complexity and writer style
        pass
    
    def generate_synthetic_dataset(self, target_count=500):
        # Orchestrate full generation pipeline
        pass
    
    def export_data(self, df, metadata, output_dir="./output"):
        # Export to CSV, JSON, YAML, and create documentation
        pass
```

### 2. Required Data Fields
Each generated case must include:
- `person_oid`: Sequential ID (CN-001, CN-002, etc.)
- `first_name`, `last_name`: Fictional names
- `gender`: Female/Male (55%/45% split)
- `age`: Realistic distribution (18-64 primary)
- `case_note`: Generated case note text
- `complexity_level`: 1-4 scale (25%/45%/25%/5% distribution)
- `archetype_id`: Client type identifier
- `writer_style`: new_worker/experienced_worker/senior_worker
- `embedded_scenarios`: Comma-separated scenario list

### 3. Case Note Generation Requirements
Create realistic case notes that vary by:
- **Complexity Level**: Stable(1) → Crisis(4) with appropriate detail level
- **Writer Experience**: New workers write longer, detailed notes; senior workers write brief, clinical notes
- **Embedded Scenarios**: Modify base templates to include housing crisis indicators, mental health deterioration signs, or successful service connections

### 4. Export Package Requirements
Generate these files in `./output/` directory:
1. `synthetic-case-notes.csv` - Primary dataset
2. `synthetic-case-notes.json` - Structured data with metadata
3. `dataset-metadata.yml` - Generation parameters and statistics
4. `validation-report.md` - Quality assurance summary
5. `usage-instructions.md` - Integration guidance

### 5. Simple Main Function
```python
def main():
    print("🚀 Starting Synthetic Case Note Generation")
    print("=" * 50)
    
    generator = SyntheticCaseNoteGenerator()
    df, metadata = generator.generate_synthetic_dataset(target_count=500)
    output_paths = generator.export_data(df, metadata)
    
    print("\n" + "=" * 50)
    print("✅ Generation Complete!")
    print(f"📊 Generated {len(df)} synthetic case notes")
    print(f"📁 Files saved in: ./output/")
    # Display summary statistics

if __name__ == "__main__":
    main()
```

## Critical Success Criteria

### ✅ The script MUST:
- Execute immediately with `python generate_synthetic_data.py`
- Generate all data internally (no external file dependencies)
- Create exactly 500 realistic case notes
- Export 5 files with proper formatting
- Display completion summary with statistics

### ❌ DO NOT:
- Create consolidation methods expecting external CSV files
- Implement complex argument parsing for non-existent inputs
- Reference outputs from other agents
- Leave main() function incomplete or commented out

## Population Parameters to Implement

### Demographics
- **Age Distribution**: 18-24 (15%), 25-34 (20%), 35-44 (25%), 45-54 (25%), 55-64 (15%)
- **Gender Split**: Female 55%, Male 45%
- **Location**: Urban 75%, Rural 25%

### Client Archetypes
Implement these 8 client types with appropriate age ranges and complexity:
- urban_young_adult, rural_single_parent, urban_middle_aged
- complex_older_adult, crisis_client, stable_worker
- rural_isolated, young_family

### Case Note Templates
Create realistic templates for each complexity level and writer style combination, ensuring authentic social services language and terminology.

## Quality Validation
The generated dataset should demonstrate:
- Realistic demographic distributions matching Alberta patterns
- Appropriate complexity level distribution
- Embedded validation scenarios at target rates (15%, 8%, 12%)
- Varied caseworker documentation styles
- Complete fictional status with no real person identifiers

## Expected Output
A complete Python script that runs successfully and produces a high-quality synthetic dataset suitable for algorithm validation testing, with comprehensive documentation and metadata for reproducible research.