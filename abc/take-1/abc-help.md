# A Comprehensive Guide to Building AI Agent Workflows

## Overview
The Agent Builder Console (ABC) allows you to create multi-stage AI workflows where agents and functions collaborate to process data, make decisions, and produce results.

---

## Stages
Your workflow is organized into **Stages**, where each stage can contain multiple agents and functions that run in parallel.

- **Add Stage**: Click the "Add Stage" button to create a new stage in your workflow.
- **Stage Order**: Stages execute sequentially from top to bottom (e.g., Stage 1, then Stage 2, etc.).
- **Parallel Execution**: All cards within the same stage run simultaneously.

---

## Agents & Functions
Build your workflow by dragging items from the **Library Panel** onto stages:

- **Agents**: AI-powered components that can reason, analyze, and generate content using various models (e.g., GPT-4, Claude, Gemini).
- **Functions**: Pre-built utilities like web scraping, API calls, Google search, weather data, file parsing, and more.
- **Excel Input**: A special input source that loads data from Excel files for batch processing.

---

## Using Placeholders: `{input}` and `{prompt}`
Placeholders can be used in agent prompts and function parameters to reference data:

- **`{input}`**:
    - **Stage 1**: Contains the original user input or trigger text.
    - **Later Stages**: Contains the concatenated outputs from all connected cards in previous stages.
- **`{prompt}`**:
    - **All Stages**: Always contains the original input from Stage 1.
    - **Use Case**: Access the initial user input even in later stages when `{input}` has been replaced with previous outputs.

### Example:
```plaintext
Stage 1 prompt: "Summarize this: {input}"
Stage 2 prompt: "Translate to French: {input}"
Stage 3 prompt: "Compare the original ({prompt}) with translation ({input})"
```

---

## Linking Cards
Connect cards between stages to pass data through your workflow:

1. **Click Output**: Click the circular connection point on the right edge of a source card.
2. **Click Input**: Click the connection point on the left edge of a target card in the next stage.
3. **Data Flow**: Connected cards pass their output as input to downstream cards.
4. **Multiple Connections**: A card can receive input from multiple sources (outputs are concatenated).
5. **Delete Links**: Click on a connection line and press Delete to remove it.

---

## Properties Panel
Click any card to view and edit its properties:

- **Agents**: Configure the name, system prompt, and user prompt template.
- **Functions**: Set required parameters based on the function type (e.g., URLs, search text, separators).
- **Output Preview**: View the execution results after running the workflow or individual agents/functions.
- **Real-time Updates**: Changes are saved automatically as you type.

---

## Toolbar Actions
- **Add Stage**: Create a new stage in your workflow.
- **Load**: Import a previously saved workflow from a JSON file.
- **Save**: Export your current workflow as a JSON file for backup or sharing.
- **Clear**: Remove all stages and reset the workflow to start fresh.
- **Run Workflow**: Execute your complete workflow from Stage 1 through to the end.

---

## Running Workflows
Execute your workflow to see results:

1. **Provide Input**: Enter your initial input text in the dialog that appears.
2. **Sequential Execution**: Stages run one after another, waiting for all cards in a stage to complete before moving to the next.
3. **Output Log**: View real-time execution progress and results in the output panel at the bottom.
4. **Card Outputs**: Click any card after execution to view its specific output in the Properties panel.

---

## Excel & File Upload
Extract text from files and add them to your input:

- **Upload Button**: Click "Upload Files" in the Input/Trigger section to select files.
- **Supported Formats**: Text files, PDFs, Word docs (.docx), Excel (.xlsx, .xls), code files, and more.
- **Excel Files**: When uploading Excel files, a selector appears to choose specific sheets and rows.
- **Text Extraction**: Extracted content is automatically added to the Input/Trigger field for use with `{input}` or `{prompt}`.

---

## Tips & Best Practices
- Start simple with 1-2 stages and test before adding complexity.
- Use descriptive names for agents to track their purpose.
- Test individual agents by clicking "Test Agent" in the properties panel.
- Save your workflows frequently to avoid losing work.
- Use parallel execution (multiple cards in one stage) for independent tasks.
- Chain stages for sequential processing (e.g., summarize → analyze → report).
- Monitor the output log to debug issues during execution.