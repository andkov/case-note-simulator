# Population Parameters Reference Example
## Template for Synthetic Case Note Generation

### Purpose
This file provides example population parameters that the synthetic case note generator can use as reference patterns. These examples demonstrate the types of baseline data that can inform realistic demographic modeling and risk factor distributions.

---

## 🏘️ **Demographic Foundations**

### Age Distribution Patterns
```
Primary Service Population (18-64 years):
- 18-25 years: 15% (often new to services, housing transitions)
- 26-35 years: 28% (family formation, employment instability)
- 36-45 years: 25% (peak complexity, multiple stressors)
- 46-55 years: 20% (health challenges emerging, employment barriers)
- 56-64 years: 12% (pre-retirement vulnerabilities)

Secondary Population (65-80 years): 
- 65-70 years: 60% (early retirement adjustments)
- 71-75 years: 25% (increasing support needs)
- 76-80 years: 15% (complex care coordination)
```

### Gender and Family Structure
```
Gender Distribution:
- Female: 58% (higher service utilization)
- Male: 40% (underrepresentation in voluntary services)
- Non-binary/Other: 2% (emerging recognition)

Family Structures:
- Single, no dependents: 35%
- Single parent: 25%
- Couple, no dependents: 20% 
- Couple with dependents: 15%
- Extended family arrangements: 5%
```

### Geographic Distribution (Alberta-like)
```
Urban Centers (Calgary/Edmonton-like): 65%
- High service density
- Transportation access
- Employment opportunities but higher cost of living

Mid-size Cities (Red Deer/Lethbridge-like): 20%
- Moderate service availability
- Mixed urban/rural challenges
- Industrial employment patterns

Rural/Remote Communities: 15%
- Limited service access
- Travel barriers to appointments
- Seasonal employment patterns
- Stronger informal support networks
```

---

## ⚠️ **Risk Factor Prevalence & Co-occurrence**

### Individual Risk Factors (Base Rates)
```
Mental Health Challenges: 45%
- Anxiety/Depression: 30%
- Severe Mental Illness: 10%
- Trauma-related conditions: 15%

Substance Use Patterns: 35%
- Alcohol-related concerns: 20%
- Drug-related concerns: 18%
- Prescription medication issues: 8%

Housing Instability: 40%
- Temporary housing: 15%
- At risk of eviction: 12%
- Homeless/unsheltered: 8%
- Overcrowded conditions: 10%

Medical Complexity: 25%
- Chronic conditions requiring management: 18%
- Recent hospitalization: 8%
- Disability impacting daily function: 12%

Justice System Involvement: 20%
- Probation/parole: 8%
- Recent incarceration: 5%
- Outstanding legal issues: 10%

Employment Barriers: 55%
- Long-term unemployment: 25%
- Underemployment: 20%
- Work-limiting disability: 15%
- Lack of transportation: 12%
```

### Risk Factor Co-occurrence Patterns
```
High Co-occurrence Combinations:
- Housing Instability + Mental Health: 35% overlap
- Substance Use + Justice Involvement: 45% overlap
- Medical Complexity + Employment Barriers: 40% overlap
- Mental Health + Substance Use: 30% overlap

Medium Co-occurrence:
- Housing + Substance Use: 25% overlap
- Mental Health + Justice Involvement: 20% overlap
- Medical Complexity + Mental Health: 25% overlap

Protective Factor Patterns:
- Strong family support: 40% (reduces other risk factors)
- Stable housing history: 30% (predictive of engagement)
- Employment history: 35% (resilience indicator)
```

---

## 📝 **Case Documentation Patterns**

### Note Length Distributions
```
Brief Updates (50-150 words): 40%
- Routine check-ins
- Administrative updates
- Simple service connections

Standard Notes (150-400 words): 45%
- Assessment updates
- Service planning discussions
- Progress monitoring

Comprehensive Documentation (400+ words): 15%
- Initial assessments
- Crisis interventions
- Complex case coordination
```

### Complexity Level Indicators
```
Level 1 - Stable/Maintenance (25%):
- Single service focus
- Predictable engagement
- Minimal crisis intervention

Level 2 - Moderate Complexity (45%):
- 2-3 concurrent services
- Some barriers to engagement
- Occasional crisis support

Level 3 - High Complexity (25%):
- Multiple service involvement
- Frequent crisis intervention
- Complex coordination needs

Level 4 - Crisis/Intensive (5%):
- Emergency response required
- Multiple systems involved
- Immediate safety concerns
```

---

## 👥 **Caseworker Writing Style Variations**

### Experience-Based Patterns
```
New Caseworkers (0-2 years): 30%
- More detailed documentation
- Frequent policy references
- Formal language patterns
- Uncertainty expressions ("client appears to...")

Experienced Workers (3-10 years): 50%
- Efficient, focused notes
- Professional but warmer tone
- Pattern recognition evident
- Solution-oriented language

Senior Workers (10+ years): 20%
- Concise documentation
- Systems thinking evident
- Advocacy language
- Historical context references
```

### Documentation Quality Variations
```
High Quality (70%):
- Clear, objective language
- Appropriate detail level
- Action-oriented
- Timeline clarity

Standard Quality (25%):
- Generally clear
- Some ambiguous language
- Adequate detail
- Minor inconsistencies

Concerning Quality (5%):
- Unclear language
- Missing key information
- Subjective judgments
- Poor organization
```

---

## 🎯 **Scenario Testing Targets**

### Algorithm Validation Scenarios
```
Sentiment Detection:
- Client frustration/resistance: 15% of notes
- Worker optimism/hope: 25% of notes
- Neutral/administrative: 60% of notes

Risk Flag Detection:
- Housing crisis indicators: 8% of notes
- Mental health deterioration: 6% of notes
- Safety concerns: 3% of notes
- Substance use escalation: 4% of notes

Service Connection Patterns:
- Successful referrals: 35% of notes
- Barriers to service access: 20% of notes
- Service coordination challenges: 15% of notes
```

### Progressive Case Examples
```
Improvement Trajectories (40%):
- Crisis → Stabilization → Independence
- Multiple barriers → Focused intervention → Success

Cyclical Patterns (35%):
- Stable → Crisis → Recovery → Stable
- Engagement → Disengagement → Re-engagement

Deterioration Patterns (15%):
- Stable → Gradual decline → Crisis
- Multiple failed interventions

Static/Maintenance (10%):
- Consistent moderate complexity
- Stable but ongoing needs
```

---

## 📊 **Technical Specifications**

### Output Structure
```csv
person_oid,first_name,last_name,gender,age,case_note,complexity_level,archetype_id,writer_style,embedded_scenarios
P001,Sarah,Johnson,Female,34,"Client attended appointment...",2,ARCH_03,experienced_worker,housing_stability
```

### Validation Metrics
```
Demographic Realism Check:
- Age distribution within 5% of target
- Gender ratios within realistic range
- Geographic spread appropriate

Content Quality Thresholds:
- Note length distribution matches pattern
- Terminology usage consistent
- Writing style variation evident
- Risk factor co-occurrence realistic

Scenario Coverage:
- Test scenarios embedded at target rates
- Edge cases represented appropriately
- Progressive patterns included
```

---

## 💡 **Usage Notes**

### For Domain Experts:
- Use these patterns as starting points for your specifications
- Modify percentages based on your specific population
- Add local terminology and service patterns
- Consider seasonal variations in your context

### For AI Generation:
- These parameters provide realistic bounds for synthetic data
- Maintain correlations between related factors
- Ensure individual profiles remain internally consistent
- Balance realism with clear fictional status

### Quality Assurance:
- Compare generated distributions to these benchmarks
- Flag deviations beyond acceptable variance
- Validate that individual cases remain realistic
- Ensure no identifiable patterns emerge