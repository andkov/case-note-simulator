# Developer Persona Guide

## Overview
The **Developer** persona is the **default** AI assistant designed for backend development and reproducible research infrastructure. This persona serves as the primary technical steward for research repositories, combining expertise in reproducible research methodologies with robust backend development practices.

## When to Use Developer

The Developer persona is loaded **by default** when you start working. You may want to explicitly activate it when you need help with:

### 🏗️ Infrastructure & Backend Systems
- Setting up and maintaining research data pipelines
- Database design and SQL optimization  
- API development and integration
- File system management and data ingestion
- System architecture and scalability planning

### 🔄 Reproducible Research Workflows
- Implementing and debugging `flow.R` orchestration systems
- Setting up automated reporting with Quarto/R Markdown
- Creating robust ETL (Extract-Transform-Load) processes
- Environment management and dependency handling
- Version control workflows and best practices

### 🧪 Testing & Quality Assurance  
- Developing comprehensive testing frameworks
- Implementing data validation and quality checks
- Setting up continuous integration pipelines
- Error handling and logging systems
- Performance monitoring and optimization

### 📚 Documentation & Maintenance
- Technical documentation for systems and processes
- User guides and setup instructions
- Code review and refactoring recommendations
- Security and compliance considerations

## Quick Activation

### Using R Console
```r
# Load the context management system
source('./scripts/update-copilot-context.R')

# Activate Developer persona (though it's loaded by default)
activate_developer()
```

### Using VS Code Tasks
You can also run the "Load Memory Functions (R)" task from VS Code's task runner, then use the R console to activate the persona.

### Using Command Palette
Type "**context refresh**" in chat to see all available personas and activation options.

## What Repository Guardian Provides

### 🎯 Systems Thinking Approach
- Holistic problem analysis considering component interactions
- Long-term maintainability and scalability considerations
- Preventive rather than reactive problem-solving

### 🛠️ Technical Expertise
- **R Ecosystem**: Advanced R programming, package development, Shiny
- **Database Systems**: SQL design, optimization, multi-database integration  
- **DevOps**: CI/CD pipelines, containerization, deployment automation
- **Data Engineering**: ETL design, validation, format conversion
- **Performance**: Code optimization, memory management, scalability

### 📋 Research-Specific Knowledge
- Understanding of academic publication workflows
- Data sensitivity and privacy requirements
- Reproducibility standards and validation
- Research timeline and constraint awareness

## Example Use Cases

### Setting Up a New Research Pipeline
```r
activate_developer()
# Then ask: "Help me design a robust data pipeline for importing 
# survey data from multiple sources into our SQLite database with 
# proper validation and error handling."
```

### Debugging Flow.R Issues
```r
activate_developer()  
# Then ask: "Our flow.R script is failing during the Quarto rendering 
# phase. Can you help diagnose and fix the issue with better error handling?"
```

### Performance Optimization
```r
activate_developer()
# Then ask: "Our analysis scripts are running slowly on large datasets. 
# Can you review the code and suggest performance improvements?"
```

### System Architecture Review
```r
activate_developer()
# Then ask: "Please review our current repository structure and suggest 
# improvements for better maintainability and reproducibility."
```

## Integration with Other Personas

The Developer persona (default) works well in combination with:

- **Case Note Analyst** (`activate_casenote_analyst()`): For domain-specific analysis requirements that need robust backend support
- **Default Context**: Since Developer IS the default, deactivating returns to basic context

You can switch between personas as needed:
```r
activate_developer()        # Default backend/infrastructure persona (auto-loaded)
activate_casenote_analyst() # For domain-specific analysis
deactivate_persona()        # Return to basic context (no agent persona)
```

## Persona Management Commands

```r
list_personas()                              # See all available personas
get_current_persona()                        # Check which persona is active
set_persona('path/to/persona.md', 'name')   # Load any persona file
deactivate_persona()                         # Return to default context
```

## Best Practices

1. **Already Active**: Developer persona loads automatically - you're ready for backend work immediately
2. **Be Specific**: Provide clear context about your technical requirements and constraints  
3. **Include Error Details**: When troubleshooting, include full error messages and relevant code snippets
4. **Think Systems**: Frame questions in terms of overall system architecture and long-term maintainability
5. **Document Changes**: The Guardian will help create documentation for any changes or new systems

## Getting Help

For detailed help on any command:
```r
source('./scripts/update-copilot-context.R')
get_command_help('activate_developer')
```

For a complete overview of the persona system:
```r
context_refresh()  # Shows status and available commands
```