# Synthetic Case Note Simulation System

This directory contains the synthetic data generation engine for creating realistic but completely fictional social services case data.

## 🎯 Purpose

Generate synthetic datasets that mirror real-world complexity to support:
- Testing risk flagging algorithms
- Validating sentiment analysis workflows  
- Training pattern detection systems
- Benchmarking AI agent performance in `sda-casenote-reader`

## 📁 Directory Structure

### `input-specifications/`
**Expert-authored YAML configuration files**
- `client-profiles.yml` - Demographic patterns and risk factor combinations
- `case-complexity-levels.yml` - Service intensity and documentation patterns  
- `writing-style-guides.yml` - Caseworker documentation styles
- `project-scenarios/` - Testing configurations for specific SDA projects

### `generation-engine/`
**R scripts for synthetic data generation**
- `client-generator.R` - Creates client demographic profiles with realistic risk factors
- `note-generator.R` - Generates case note text with authentic writing styles
- `complexity-controller.R` - Orchestrates case complexity and service patterns
- `validation-framework.R` - Ensures quality and realism of generated data

### `output-datasets/`
**Generated synthetic datasets**
- Export-ready datasets formatted for `sda-casenote-reader` integration
- Multiple project scenarios with different characteristics
- Quality validation reports and metrics

### `testing-harness/`
**Quality assurance and testing framework**
- Validation scripts for ensuring realistic distributions
- Privacy protection verification (complete fictional status)
- Integration testing with SDA analytical pipelines

## 📖 Implementation Details

See **`implementation.md`** for comprehensive architecture documentation including:
- Expert-driven specification system
- Generation pipeline workflow
- Quality validation framework
- Integration with SDA workflows

## 🚀 Quick Start

1. **Configure specifications**: Edit YAML files in `input-specifications/`
2. **Generate data**: Run scripts in `generation-engine/`
3. **Validate output**: Check `output-datasets/` for generated files
4. **Test integration**: Use `testing-harness/` for quality assurance

## 🔧 Key Features

- **Expert-Driven**: Domain experts control parameters via YAML files
- **Completely Fictional**: No real client data, privacy-protected
- **Alberta-Like**: Realistic demographic patterns and terminology
- **SDA-Ready**: Export formats compatible with analytical workflows
- **Quality Assured**: Multi-level validation for realism and consistency

---
*For detailed implementation information, see `implementation.md`*