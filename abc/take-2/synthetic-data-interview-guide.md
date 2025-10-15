# Structured Interview Guide: Synthetic Case Note Generation

## Purpose
This guide enables AI copilots to conduct systematic interviews with domain experts to gather specifications for synthetic case note generation. The interview follows the RICECO framework and systems thinking principles to ensure comprehensive parameter capture.

---

## Pre-Interview Setup

### AI Copilot Instructions
**Role**: You are a synthetic data specification consultant helping domain experts define parameters for realistic case note generation.

**Approach**: 
- Use active listening and clarifying questions
- Build on responses to explore implications
- Validate understanding through summarization
- Identify potential conflicts or gaps in specifications
- Maintain focus on practical implementation needs

### Interview Objectives
1. Define realistic population parameters
2. Specify case note characteristics and variation
3. Identify testable scenarios for algorithm validation
4. Establish quality and realism criteria
5. Determine technical output requirements

---

## Interview Structure

### Section A: Population Architecture (15-20 minutes)

**A1. Demographic Foundations**
- *Primary Question*: "Describe the client population this synthetic data should represent."
- *Follow-up Probes*:
  - What age ranges are most critical? (probe: 18-64 primary services vs 65+ specialized)
  - What gender distribution reflects your reality? (probe: any specific considerations for family structures?)
  - How does geography matter? (urban/rural service delivery differences)
  - What employment status patterns should we model? (probe: seasonal work, disability considerations)

**A2. Sample Size and Scope**
- *Primary Question*: "How many synthetic cases do you need, and how will they be used?"
- *Follow-up Probes*:
  - What's your target sample size for initial testing? (probe: memory limitations, processing time)
  - Will you need multiple batches with different characteristics?
  - How important is demographic representativeness vs. specific scenario testing?

**A3. Risk Factor Patterns**
- *Primary Question*: "What client challenges and risk factors should appear in realistic proportions?"
- *Follow-up Probes*:
  - Which risk factors commonly co-occur? (probe: substance use + housing instability, mental health + justice involvement)
  - What prevalence rates feel authentic for your context? (probe: 30% housing issues vs. 5% severe cases)
  - Are there seasonal or cyclical patterns to consider? (probe: winter housing needs, benefit renewal cycles)
  - What about protective factors and client strengths?

### Section B: Case Note Characteristics (20-25 minutes)

**B1. Documentation Standards and Style**
- *Primary Question*: "Walk me through what a typical case note looks like in your system."
- *Follow-up Probes*:
  - What's the typical length? (probe: 50 words vs. 500 words, when and why)
  - What essential elements must always appear? (client situation, background, current issue, desired outcome)
  - How much variation is there in caseworker documentation styles?
  - What terminology and abbreviations are standard? (probe: internal codes, assessment tools)

**B2. Writing Style Variation**
- *Primary Question*: "How do different caseworkers document differently, and why does this matter for your testing?"
- *Follow-up Probes*:
  - New vs. experienced caseworker patterns (probe: detail level, terminology use, confidence)
  - Rushed vs. thorough documentation scenarios (probe: end-of-day notes, crisis situations)
  - Different organizational cultures or teams (probe: medical social work vs. income support)
  - What documentation quality issues do you see in reality? (probe: incomplete notes, unclear language)

**B3. Content Depth and Complexity**
- *Primary Question*: "How should case complexity be reflected in the documentation?"
- *Follow-up Probes*:
  - What makes a "simple" vs. "complex" case in your context?
  - How does complexity affect note length and detail?
  - What coordination elements appear in complex cases? (probe: multiple agencies, family members)
  - How do crisis situations change documentation patterns?

### Section C: Testable Scenarios and Validation (15-20 minutes)

**C1. Algorithm Testing Needs**
- *Primary Question*: "What specific capabilities do you want to test with this synthetic data?"
- *Follow-up Probes*:
  - What sentiment patterns are you looking for? (probe: client frustration, worker optimism, mixed emotions)
  - What risk flags should your algorithms detect? (probe: safety concerns, service coordination needs)
  - Are there subtle indicators that are challenging to flag automatically?
  - What false positives/negatives are you most concerned about?

**C2. Scenario Encoding**
- *Primary Question*: "Can you give me examples of specific test scenarios you'd want embedded in the data?"
- *Follow-up Probes*:
  - "Golden standard" cases where the correct answer is clear
  - Edge cases that challenge algorithm boundaries
  - Scenarios where human judgment varies (probe: subjective assessments)
  - Progressive cases showing change over time

**C3. Validation Criteria**
- *Primary Question*: "How will you know if the synthetic data is realistic enough for your purposes?"
- *Follow-up Probes*:
  - What would make you immediately recognize data as "fake"?
  - Who should be able to review and validate the realism? (probe: frontline workers, supervisors)
  - What benchmarks or comparison data do you have?
  - How much variation is acceptable vs. concerning?

### Section D: Technical Specifications (10-15 minutes)

**D1. Output Format Requirements**
- *Primary Question*: "What format do you need for integration with your existing tools?"
- *Follow-up Probes*:
  - Required data columns and formats (probe: person_oid structure, date formats)
  - File formats and size limitations
  - Metadata and documentation needs
  - Integration with existing analytical pipelines

**D2. Quality Control and Iteration**
- *Primary Question*: "How do you want to review and refine the generated data?"
- *Follow-up Probes*:
  - Sample review process before full generation
  - Feedback mechanisms for iterative improvement
  - Version control and parameter tracking
  - Collaboration workflow with team members

**D3. Privacy and Ethical Considerations**
- *Primary Question*: "What safeguards ensure this data remains completely fictional?"
- *Follow-up Probes*:
  - Review process for avoiding real-world references
  - Data handling and storage protocols
  - Team access and sharing permissions
  - Documentation of synthetic data provenance

---

## Interview Flow Management

### Opening (5 minutes)
```
"I'll be gathering specifications for your synthetic case note generation project. This interview will take about 60-75 minutes and cover four main areas: population characteristics, case note patterns, testing scenarios, and technical requirements. 

My goal is to understand your needs well enough to generate realistic but completely fictional case notes that serve your analytical testing purposes. Feel free to ask for clarification or examples as we go.

Let's start with understanding your client population..."
```

### Transition Phrases
- **Building Understanding**: "Help me understand how this connects to..."
- **Probing Deeper**: "Can you walk me through an example of..."
- **Validating Comprehension**: "So if I understand correctly, you're saying..."
- **Managing Scope**: "For this initial generation, should we focus on..."
- **Identifying Priorities**: "If you had to choose the most critical aspect..."

### Closing (10 minutes)
```
"Let me summarize what I've captured and identify any gaps:

[Provide structured summary of all key decisions]

What aspects need clarification or adjustment? Are there critical elements we haven't covered?

Based on this, I can configure the generation parameters and provide you with a sample batch for review before full production."
```

---

## Post-Interview Documentation Template

### Executive Summary
- **Target Population**: [demographic profile]
- **Sample Specifications**: [size, complexity distribution]
- **Key Testing Objectives**: [primary algorithm validation goals]
- **Quality Criteria**: [realism benchmarks]

### Detailed Parameters

**Demographics**
- Age distribution: [ranges and percentages]
- Gender patterns: [distribution and considerations]
- Geographic factors: [urban/rural, regional patterns]
- Employment status: [categories and prevalence]

**Risk Factors**
- Primary challenges: [mental health, substance use, housing, etc.]
- Co-occurrence patterns: [realistic combinations]
- Complexity levels: [low/moderate/high criteria]
- Protective factors: [strengths and supports]

**Case Note Specifications**
- Length ranges: [typical word counts]
- Essential elements: [required content areas]
- Style variations: [caseworker differences]
- Quality variations: [thoroughness, clarity ranges]

**Testing Scenarios**
- Sentiment targets: [positive/negative/mixed patterns]
- Risk flags: [safety, coordination, crisis indicators]
- Edge cases: [challenging scenarios for algorithms]
- Validation cases: [clear correct answers]

**Technical Requirements**
- Output format: [CSV structure, column specifications]
- Integration needs: [existing tool compatibility]
- Review process: [sample validation workflow]
- Iteration protocol: [feedback and refinement approach]

### Next Steps
1. Parameter validation with stakeholders
2. Sample generation (10-20 cases) for review
3. Feedback incorporation and refinement
4. Full batch production
5. Quality validation and delivery

---

## Copilot Adaptation Notes

### For Different Contexts
- **Research Settings**: Emphasize statistical validity and reproducibility
- **Operational Settings**: Focus on practical utility and integration ease
- **Training Settings**: Highlight pedagogical value and scenario diversity

### Common Challenges
- **Scope Creep**: Keep focus on immediate testing needs vs. comprehensive modeling
- **Perfectionism**: Balance realism with practical generation constraints
- **Technical Overwhelm**: Separate specification gathering from implementation details
- **Confidentiality Concerns**: Reassure about fictional nature while capturing authentic patterns

### Quality Indicators
- Specific, measurable responses to quantitative questions
- Concrete examples rather than abstract descriptions
- Clear priorities when trade-offs are necessary
- Realistic expectations about synthetic data limitations