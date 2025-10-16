# Synthetic Case Notes - Usage Instructions

## File Structure

- `synthetic-case-notes.csv` - Primary dataset in CSV format
- `synthetic-case-notes.json` - Same data in JSON format with metadata
- `dataset-metadata.yml` - Generation parameters and quality metrics
- `validation-report.md` - Quality assurance summary
- `usage-instructions.md` - This file

## Data Fields

| Field | Type | Description |
|-------|------|-------------|
| person_oid | String | Unique client identifier (CN-001 to CN-500) |
| first_name | String | Fictional first name |
| last_name | String | Fictional last name |
| gender | String | Female/Male |
| age | Integer | Age in years (18-64) |
| case_note | String | Synthetic case note text |
| complexity_level | Integer | 1=Stable, 2=Moderate, 3=High, 4=Crisis |
| archetype_id | String | Client archetype identifier |
| writer_style | String | Caseworker experience level |
| embedded_scenarios | String | Comma-separated validation scenarios |

## Integration with SDA Workflows

### Loading Data in R
```r
# Load CSV
library(readr)
case_notes <- read_csv("synthetic-case-notes.csv")

# Load JSON
library(jsonlite)
json_data <- fromJSON("synthetic-case-notes.json")
case_notes <- json_data$synthetic_cases
metadata <- json_data$metadata
```

### Loading Data in Python
```python
import pandas as pd
import json

# Load CSV
df = pd.read_csv("synthetic-case-notes.csv")

# Load JSON
with open("synthetic-case-notes.json", 'r') as f:
    data = json.load(f)
    df = pd.DataFrame(data['synthetic_cases'])
    metadata = data['metadata']
```

## Algorithm Validation Use Cases

### Housing Crisis Detection
```r
housing_crisis_cases <- case_notes %>%
  filter(grepl("housing_crisis", embedded_scenarios))
```

### Mental Health Sentiment Analysis
```r
mental_health_cases <- case_notes %>%
  filter(grepl("mental_health_deterioration", embedded_scenarios))
```

### Service Connection Pattern Analysis
```r
success_cases <- case_notes %>%
  filter(grepl("successful_service_connection", embedded_scenarios))
```

## Data Privacy & Ethics

- All data is completely fictional
- No real client information used
- Safe for algorithm development and testing
- Appropriate for sharing within research teams
- Maintains realistic patterns while ensuring privacy

## Quality Assurance

- Demographic distributions match Alberta-like patterns
- Risk factor co-occurrence follows realistic probabilities
- Caseworker writing styles vary authentically
- Complexity levels distribute as specified
- Validation scenarios embedded at target rates

For questions about this dataset, refer to the validation report or contact the data generation team.
