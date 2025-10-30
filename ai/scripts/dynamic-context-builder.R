# ==============================================================================
# Dynamic Context Builder for AI Support System - 3-Section System Only
# ==============================================================================
# 
# This script manages the 3-section AI context system:
# - Section 1: Core AI Instructions (static)
# - Section 2: Active Persona (dynamic)
# - Section 3: Additional Context (dynamic)
#
# Author: GitHub Copilot (with human analyst)
# Created: 2025-07-16
# Updated: 2025-10-29 - Cleaned up to remove old system, keep only 3-section approach
# Location: ai/scripts/dynamic-context-builder.R

# ==============================================================================
# ENHANCED 3-SECTION CONTEXT MANAGEMENT SYSTEM
# ==============================================================================

# Section structure for copilot-instructions.md:
# Section 1: General Instructions (static)
# Section 2: Active Persona (dynamic)  
# Section 3: Additional Context (dynamic)

# Resolve and validate file path
resolve_file_path <- function(file_path) {
  # If it's already a valid path, return it
  if (file.exists(file_path)) {
    return(file_path)
  }
  
  # Try with ./ prefix if not already there
  if (!startsWith(file_path, "./")) {
    prefixed_path <- paste0("./", file_path)
    if (file.exists(prefixed_path)) {
      return(prefixed_path)
    }
  }
  
  # Return original path (will be handled by caller)
  return(file_path)
}

# Generate context overview header
generate_context_overview <- function(persona_name, additional_context, 
                                     section1_kb, section1_tokens,
                                     section2_kb, section2_tokens,
                                     section3_kb, section3_tokens,
                                     total_kb, total_tokens) {
  
  # Generate compact overview with token estimates (more relevant for prompt limits)
  overview <- c(
    "<!-- CONTEXT OVERVIEW -->",
    paste0("Total size: ", sprintf("%4.1f", total_kb), " KB (~", format(total_tokens, big.mark = ","), " tokens)"),
    paste0("- 1: Core AI Onboarding  | ", sprintf("%3.1f", section1_kb), " KB (~", format(section1_tokens, big.mark = ","), " tokens)"),
    paste0("- 2: Active Persona: ", if (!is.null(persona_name) && persona_name != "") tools::toTitleCase(gsub("-", " ", persona_name)) else "None", " | ", sprintf("%3.1f", section2_kb), " KB (~", format(section2_tokens, big.mark = ","), " tokens)"),
    paste0("- 3: Additional Context     | ", sprintf("%3s", if (section3_kb == 0) "0" else sprintf("%.1f", section3_kb)), " KB (~", format(section3_tokens, big.mark = ","), " tokens)")
  )
  
  # Add detailed component breakdown if Section 3 has content
  if (!is.null(additional_context) && length(additional_context) > 0) {
    # Get persona default context for comparison
    persona_configs <- list(
      "developer" = c(),
      "project-manager" = c("./ai/project/mission.md", "./ai/project/method.md", "./ai/project/glossary.md"), 
      "casenote-analyst" = c("./ai/onboarding-ai.md")
    )
    
    default_for_persona <- if (!is.null(persona_name)) persona_configs[[persona_name]] else c()
    
    # Add component details
    for (i in seq_along(additional_context)) {
      resolved_path <- resolve_file_path(additional_context[i])
      
      if (file.exists(resolved_path)) {
        # Calculate individual file metrics
        file_lines <- readLines(resolved_path, warn = FALSE)
        file_text <- paste(file_lines, collapse = "\n")
        file_chars <- nchar(file_text, type = "chars")
        # Rough token estimate: ~4 chars per token for English text
        file_tokens <- round(file_chars / 4)
        file_kb <- round(file_chars / 1024, 1)
        
        # Check if this component is default for current persona
        is_default <- additional_context[i] %in% default_for_persona
        default_marker <- if (is_default) " (default)" else ""
        
        # Add component line with token estimate
        overview <- c(overview, 
                     paste0("  -- ", additional_context[i], default_marker, "  | ", 
                           sprintf("%3.1f", file_kb), " KB (~", 
                           format(file_tokens, big.mark = ","), " tokens)"))
      }
    }
  }
  
  overview <- c(overview, "")
  
  # Add management commands
  overview <- c(overview,
                "## 🔧 Management Commands",
                "",
                "```r",
                "# View current status",
                "show_context_status()",
                "",
                "# Switch personas", 
                "activate_developer()         # Technical focus (minimal context)",
                "activate_project_manager()   # Strategic oversight (full project context)",
                "activate_casenote_analyst()  # Domain expertise (specialized context)",
                "",
                "# Manage additional context",
                "add_context_file('path/to/file.md')     # Add context file",
                "remove_context_file('path/to/file.md')  # Remove context file", 
                "list_available_md_files('pattern')     # Discover available files",
                "```",
                "",
                "---",
                ""
  )
  
  return(overview)
}

# Available personas with their context loading configurations
get_persona_configs <- function() {
  list(
    "default" = list(
      file = "./ai/personas/default.md",
      default_context = c()  # No default additional context
    ),
    "developer" = list(
      file = "./ai/personas/developer.md",
      default_context = c()  # No default additional context
    ),
    "data-engineer" = list(
      file = "./ai/personas/data-engineer.md",
      default_context = c()  # No default additional context for focused data work
    ),
    "research-scientist" = list(
      file = "./ai/personas/research-scientist.md",
      default_context = c()  # No default additional context for focused analytical work
    ),
    "devops-engineer" = list(
      file = "./ai/personas/devops-engineer.md",
      default_context = c()  # No default additional context for focused operational work
    ),
    "frontend-architect" = list(
      file = "./ai/personas/frontend-architect.md",
      default_context = c()  # No default additional context for focused visualization work
    ),
    "project-manager" = list(
      file = "./ai/personas/project-manager.md", 
      default_context = c("./ai/project/mission.md", "./ai/project/method.md", "./ai/project/glossary.md")
    ),
    "casenote-analyst" = list(
      file = "./ai/personas/casenote-analyst.md",
      default_context = c("./ai/onboarding-ai.md")
    ),
    "prompt-engineer" = list(
      file = "./ai/personas/prompt-engineer.md",
      default_context = c()  # Minimal context for focused prompt work
    ),
    "reporter" = list(
      file = "./ai/personas/reporter.md",
      default_context = c()  # On-demand context loading as needed
    )
  )
}

# Get general instructions (Section 1) - static content
get_general_instructions <- function() {
  c(
    "<!-- SECTION 1: CORE AI INSTRUCTIONS -->",
    "",
    "# AI Assistant Core Instructions",
    "",
    "You are an expert AI programming assistant working with a user in a research and development environment. Your role is to provide sophisticated assistance while maintaining the highest standards of academic rigor and technical excellence.",
    "",
    "## 🎯 Core Principles",
    "",
    "- **Evidence-Based Reasoning**: Anchor all recommendations in established methodologies and best practices",
    "- **Contextual Awareness**: Adapt your approach based on the current project context and user needs",
    "- **Collaborative Excellence**: Work as a strategic partner, not just a code generator",
    "- **Quality Focus**: Prioritize correctness, maintainability, and reproducibility in all outputs",
    "",
    "## 🧠 Project Memory & Intent Detection",
    "",
    "**ALWAYS MONITOR** conversations for signs of creative intent, design decisions, or planning language. When detected, **proactively offer** to capture in project memory:",
    "",
    "- **Intent Markers**: \"TODO\", \"next step\", \"plan to\", \"should\", \"need to\", \"want to\", \"thinking about\"",
    "- **Decision Language**: \"decided\", \"chose\", \"because\", \"rationale\", \"strategy\", \"approach\"",
    "- **Uncertainty**: \"consider\", \"maybe\", \"perhaps\", \"not sure\", \"thinking\", \"wondering\"",
    "- **Future Work**: \"later\", \"eventually\", \"after this\", \"once we\", \"then we'll\"",
    "",
    "**When You Detect These**: Ask \"Should I capture this intention/decision in the project memory?\" and offer to use available memory management functions.",
    "",
    "## 🤖 Context & Automation Management",
    "",
    "**KEYPHRASE TRIGGERS**:",
    "- \"**context refresh**\" → Provide status and context refresh options",
    "- \"**scan context**\" → Same as above",
    "- \"**switch persona**\" → Show persona switching options",
    "- When discussing new project areas → Suggest relevant context loading",
    "",
    "## 🎭 Dynamic AI System",
    "",
    "This project uses a dynamic AI assistant system with three key components:",
    "",
    "1. **Core Instructions** (this section): Universal behavioral guidelines",
    "2. **Active Persona** (Section 2): Specialized expertise and focus area",
    "3. **Additional Context** (Section 3): Project-specific knowledge and resources",
    "",
    "The active persona in Section 2 defines your specialized expertise and approach. Additional context in Section 3 provides relevant background knowledge. Work within these parameters while maintaining the core principles above.",
    "",
    "## 📋 Response Guidelines",
    "",
    "- **Clarity**: Provide clear, actionable guidance appropriate to the user's expertise level",
    "- **Completeness**: Address the full scope of requests while staying focused",
    "- **Options**: Offer multiple approaches when appropriate (\"Would you like a diagram?\", \"Should I show the code?\")",
    "- **Traceability**: Surface uncertainties with evidence and suggest verification approaches",
    "- **Tool Usage**: Leverage available tools effectively rather than providing manual instructions",
    "- **Context Awareness**: Reference project-specific configurations and standards when relevant",
    "",
    "## 🚫 Boundaries & Constraints",
    "",
    "- Avoid speculation beyond defined project scope or available evidence",
    "- If conflicts arise between different information sources, pause and seek clarification",
    "- Maintain consistency with the active persona defined in Section 2",
    "- Respect the project's established methodologies and frameworks",
    ""
  )
}

# Build 3-section copilot instructions with context overview
build_3_section_instructions <- function(persona_name = NULL, additional_context = NULL) {
  instructions_path <- ".github/copilot-instructions.md"
  
  # Build all sections first to calculate sizes
  section1_content <- get_general_instructions()
  section2_content <- c()
  section3_content <- c()
  
  # Section 2: Active Persona (if specified)
  if (!is.null(persona_name) && persona_name != "") {
    persona_configs <- get_persona_configs()
    
    if (persona_name %in% names(persona_configs)) {
      persona_file <- persona_configs[[persona_name]]$file
    } else {
      # Handle custom persona files
      persona_file <- persona_name
    }
    
    if (file.exists(persona_file)) {
      section2_content <- c(
        "<!-- SECTION 2: ACTIVE PERSONA -->\n",
        paste0("# Section 2: Active Persona - ", tools::toTitleCase(gsub("-", " ", persona_name))),
        "",
        paste0("**Currently active persona:** ", persona_name),
        "",
        paste0("### ", tools::toTitleCase(gsub("-", " ", persona_name)), " (from `", persona_file, "`)"),
        "",
        readLines(persona_file, warn = FALSE),
        ""
      )
    }
  }
  
  # Section 3: Additional Context (if specified)
  if (!is.null(additional_context) && length(additional_context) > 0) {
    section3_content <- c(
      "<!-- SECTION 3: ADDITIONAL CONTEXT -->\n",
      "# Section 3: Additional Context",
      ""
    )
    
    for (context_item in additional_context) {
      resolved_path <- resolve_file_path(context_item)
      
      if (file.exists(resolved_path)) {
        context_file_content <- readLines(resolved_path, warn = FALSE)
        section3_content <- c(section3_content,
                             paste0("### ", tools::toTitleCase(gsub("[/-]", " ", context_item)), " (from `", resolved_path, "`)"),
                             "",
                             context_file_content,
                             "")
      } else {
        message("⚠️  Context file not found: ", context_item, " (resolved to: ", resolved_path, ")")
      }
    }
  }
  
  # Calculate section sizes with token estimates
  section1_chars <- sum(nchar(section1_content, type = "chars"))
  section1_kb <- round(section1_chars / 1024, 1)
  section1_tokens <- round(section1_chars / 4)  # ~4 chars per token
  
  section2_chars <- sum(nchar(section2_content, type = "chars"))
  section2_kb <- round(section2_chars / 1024, 1)
  section2_tokens <- round(section2_chars / 4)
  
  section3_chars <- sum(nchar(section3_content, type = "chars"))
  section3_kb <- round(section3_chars / 1024, 1)  
  section3_tokens <- round(section3_chars / 4)
  
  total_chars <- section1_chars + section2_chars + section3_chars
  total_kb <- round(total_chars / 1024, 1)
  total_tokens <- section1_tokens + section2_tokens + section3_tokens
  
  # Generate context overview header
  context_overview <- generate_context_overview(
    persona_name, additional_context,
    section1_kb, section1_tokens,
    section2_kb, section2_tokens, 
    section3_kb, section3_tokens,
    total_kb, total_tokens
  )
  
  # Combine all content with overview header
  content <- c(context_overview, section1_content)
  
  # Add Section 2 content if present
  if (length(section2_content) > 0) {
    content <- c(content, section2_content)
  }
  
  # Add Section 3 content if present  
  if (length(section3_content) > 0) {
    content <- c(content, section3_content)
  }
  
  # Add footer marker
  content <- c(content, "<!-- END DYNAMIC CONTENT -->")
  
  return(content)
}

# Set persona with defaults - main function for persona switching
set_persona_with_defaults <- function(persona_name) {
  persona_configs <- get_persona_configs()
  
  if (!persona_name %in% names(persona_configs)) {
    stop("Unknown persona: ", persona_name, ". Available personas: ", paste(names(persona_configs), collapse = ", "))
  }
  
  config <- persona_configs[[persona_name]]
  
  message("🎭 Setting persona: ", persona_name)
  message("📁 Persona file: ", config$file)
  
  if (length(config$default_context) > 0) {
    message("📚 Loading default context: ", paste(config$default_context, collapse = ", "))
    additional_context <- config$default_context
  } else {
    message("📚 No default context for this persona")
    additional_context <- NULL
  }
  
  # Build and write the 3-section instructions
  content <- build_3_section_instructions(persona_name, additional_context)
  instructions_path <- ".github/copilot-instructions.md"
  
  writeLines(content, instructions_path)
  
  if (length(content) > 0 && !endsWith(content[length(content)], "\n")) {
    cat("\n", file = instructions_path, append = TRUE)
  }
  
  message("✅ Persona activated: ", persona_name)
  message("📄 Total lines in updated file: ", length(content))
  
  return(invisible(TRUE))
}

# Add context file to Section 3
add_context_file <- function(file_path, section_name = NULL) {
  # Read current instructions
  instructions_path <- ".github/copilot-instructions.md"
  
  if (!file.exists(instructions_path)) {
    stop("Instructions file not found. Please set a persona first.")
  }
  
  current_content <- readLines(instructions_path, warn = FALSE)
  
  # Find current persona
  persona_line <- current_content[grepl("\\*\\*Currently active persona:\\*\\*", current_content)]
  if (length(persona_line) == 0) {
    stop("No active persona found. Please set a persona first.")
  }
  
  current_persona <- gsub(".*Currently active persona:\\*\\* ", "", persona_line)
  
  # Get current additional context
  section3_start <- which(grepl("<!-- SECTION 3: ADDITIONAL CONTEXT -->", current_content))
  end_marker <- which(grepl("<!-- END DYNAMIC CONTENT -->", current_content))
  
  current_additional_context <- c()
  if (length(section3_start) > 0 && length(end_marker) > 0) {
    # Extract existing context files from Section 3
    section3_content <- current_content[(section3_start[1]+1):(end_marker[1]-1)]
    context_headers <- section3_content[grepl("^### .* \\(from `.*`\\)$", section3_content)]
    
    for (header in context_headers) {
      # Extract file path from header
      file_match <- regmatches(header, regexpr("\\(from `.*`\\)", header))
      if (length(file_match) > 0) {
        current_file <- gsub("\\(from `|`\\)", "", file_match)
        current_additional_context <- c(current_additional_context, current_file)
      }
    }
  }
  
  # Resolve the new file path
  resolved_path <- resolve_file_path(file_path)
  
  if (!file.exists(resolved_path)) {
    stop("File not found: ", file_path, " (resolved to: ", resolved_path, ")")
  }
  
  # Add the new context file
  new_additional_context <- unique(c(current_additional_context, file_path))
  
  # Rebuild instructions with new context
  content <- build_3_section_instructions(current_persona, new_additional_context)
  writeLines(content, instructions_path)
  
  if (length(content) > 0 && !endsWith(content[length(content)], "\n")) {
    cat("\n", file = instructions_path, append = TRUE)
  }
  
  message("✅ Added context file: ", file_path)
  message("📄 Total lines in updated file: ", length(content))
  
  return(invisible(TRUE))
}

# Remove context file from Section 3
remove_context_file <- function(file_path) {
  # Similar implementation to add_context_file but removes instead
  instructions_path <- ".github/copilot-instructions.md"
  
  if (!file.exists(instructions_path)) {
    stop("Instructions file not found.")
  }
  
  current_content <- readLines(instructions_path, warn = FALSE)
  
  # Find current persona
  persona_line <- current_content[grepl("\\*\\*Currently active persona:\\*\\*", current_content)]
  if (length(persona_line) == 0) {
    stop("No active persona found.")
  }
  
  current_persona <- gsub(".*Currently active persona:\\*\\* ", "", persona_line)
  
  # Get current additional context and remove the specified file
  section3_start <- which(grepl("<!-- SECTION 3: ADDITIONAL CONTEXT -->", current_content))
  end_marker <- which(grepl("<!-- END DYNAMIC CONTENT -->", current_content))
  
  current_additional_context <- c()
  if (length(section3_start) > 0 && length(end_marker) > 0) {
    section3_content <- current_content[(section3_start[1]+1):(end_marker[1]-1)]
    context_headers <- section3_content[grepl("^### .* \\(from `.*`\\)$", section3_content)]
    
    for (header in context_headers) {
      file_match <- regmatches(header, regexpr("\\(from `.*`\\)", header))
      if (length(file_match) > 0) {
        current_file <- gsub("\\(from `|`\\)", "", file_match)
        current_additional_context <- c(current_additional_context, current_file)
      }
    }
  }
  
  # Remove the specified file
  new_additional_context <- current_additional_context[current_additional_context != file_path]
  
  # Rebuild instructions
  content <- build_3_section_instructions(current_persona, new_additional_context)
  writeLines(content, instructions_path)
  
  if (length(content) > 0 && !endsWith(content[length(content)], "\n")) {
    cat("\n", file = instructions_path, append = TRUE)
  }
  
  message("✅ Removed context file: ", file_path)
  message("📄 Total lines in updated file: ", length(content))
  
  return(invisible(TRUE))
}

# List all available .md files in repository
list_available_md_files <- function(pattern = NULL) {
  all_md_files <- list.files(".", pattern = "\\.md$", recursive = TRUE, full.names = FALSE)
  
  # Filter out some system files
  filtered_files <- all_md_files[!grepl("node_modules|.git", all_md_files)]
  
  if (!is.null(pattern)) {
    filtered_files <- filtered_files[grepl(pattern, filtered_files, ignore.case = TRUE)]
  }
  
  message("📁 Available .md files in repository:")
  for (i in seq_along(filtered_files)) {
    message(sprintf("  %2d. %s", i, filtered_files[i]))
  }
  
  return(invisible(filtered_files))
}

# Show current context status
show_context_status <- function() {
  instructions_path <- ".github/copilot-instructions.md"
  
  if (!file.exists(instructions_path)) {
    message("❌ No context file found")
    return(invisible(NULL))
  }
  
  content <- readLines(instructions_path, warn = FALSE)
  
  message("📋 CURRENT CONTEXT STATUS")
  message(paste(rep("=", 50), collapse = ""))
  
  # Section 1 is always present
  message("📄 Section 1: General Instructions (static)")
  
  # Check for active persona
  persona_line <- content[grepl("\\*\\*Currently active persona:\\*\\*", content)]
  if (length(persona_line) > 0) {
    current_persona <- gsub(".*Currently active persona:\\*\\* ", "", persona_line)
    message("🎭 Section 2: Active Persona - ", current_persona)
  } else {
    message("🎭 Section 2: No active persona")
  }
  
  # Check for additional context
  section3_start <- which(grepl("<!-- SECTION 3: ADDITIONAL CONTEXT -->", content))
  if (length(section3_start) > 0) {
    end_marker <- which(grepl("<!-- END DYNAMIC CONTENT -->", content))
    section3_content <- content[(section3_start[1]+1):(end_marker[1]-1)]
    context_headers <- section3_content[grepl("^### .* \\(from `.*`\\)$", section3_content)]
    
    if (length(context_headers) > 0) {
      message("📚 Section 3: Additional Context (", length(context_headers), " files)")
      for (header in context_headers) {
        file_match <- regmatches(header, regexpr("\\(from `.*`\\)", header))
        if (length(file_match) > 0) {
          file_path <- gsub("\\(from `|`\\)", "", file_match)
          message("  - ", file_path)
        }
      }
    } else {
      message("📚 Section 3: No additional context")
    }
  } else {
    message("📚 Section 3: No additional context")
  }
  
  message("📊 Total file size: ", round(file.size(instructions_path)/1024, 1), " KB")
  message("📊 Total lines: ", length(content))
  
  return(invisible(TRUE))
}

# Quick persona switching shortcuts (updated to use new system)
activate_casenote_analyst <- function() {
  set_persona_with_defaults("casenote-analyst")
}

activate_developer <- function() {
  set_persona_with_defaults("developer")
}

activate_project_manager <- function() {
  set_persona_with_defaults("project-manager")
}

activate_prompt_engineer <- function() {
  set_persona_with_defaults("prompt-engineer")
}

# ==============================================================================
# FILE CHANGE LOGGING FUNCTION
# ==============================================================================

# Log file changes to logbook with timestamp, user, and change description
log_file_change <- function(file_path, change_description = NULL) {
  logbook_path <- "./ai/memory-human.md"
  
  # Validate inputs
  if (missing(file_path)) {
    stop("❌ file_path is required. Usage: log_file_change('path/to/file.ext', 'description of changes')")
  }
  
  # Normalize file path (handle relative paths)
  if (!file.exists(file_path)) {
    # Try relative to project root
    alt_path <- file.path(".", file_path)
    if (file.exists(alt_path)) {
      file_path <- alt_path
    } else {
      stop("❌ File not found: ", file_path)
    }
  }
  
  # Get file information
  file_info <- file.info(file_path)
  file_name <- basename(file_path)
  file_ext <- tools::file_ext(file_path)
  mod_time <- format(file_info$mtime, "%Y-%m-%d %H:%M:%S")
  
  # Get user information (try multiple methods)
  user_name <- Sys.getenv("USERNAME", unset = Sys.getenv("USER", unset = "Unknown User"))
  
  # Create change description if not provided
  if (is.null(change_description)) {
    change_description <- paste("Modified", file_name)
  }
  
  # Create logbook entry
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  entry <- paste0(
    "\n## File Change Log - ", format(Sys.time(), "%Y-%m-%d"),
    "\n**File**: `", file_path, "`  ",
    "\n**Modified**: ", mod_time, "  ",
    "\n**Changed by**: ", user_name, "  ",
    "\n**Changes**: ", change_description, "  ",
    "\n**Logged**: ", timestamp, "\n"
  )
  
  # Check if logbook exists
  if (!file.exists(logbook_path)) {
    # Create basic logbook structure
    initial_content <- paste0(
      "# memory-human.md\n\n",
      "## Project Logbook\n",
      "Use this to document key decisions, model revisions, and reasoning transitions across modalities.\n"
    )
    writeLines(initial_content, logbook_path)
    message("📝 Created new logbook at: ", logbook_path)
  }
  
  # Append the entry to logbook
  cat(entry, file = logbook_path, append = TRUE)
  
  # Provide user feedback
  message("📝 Logged change to logbook:")
  message("   File: ", file_name, " (", file_ext, ")")
  message("   User: ", user_name)
  message("   Time: ", mod_time)
  message("   Description: ", change_description)
  
  # Return the entry for potential further use
  invisible(entry)
}

# Convenience function with shorter name
log_change <- function(file_path, description = NULL) {
  log_file_change(file_path, description)
}

# Auto-export functions for easy access  
if (!exists("copilot_context_initialized")) {
  cat("🤖 3-Section Context Management System Loaded\n")
  cat("📚 Core Functions:\n")
  cat("  - set_persona_with_defaults(persona_name) # Main persona switching function\n")
  cat("  - show_context_status()                   # Display current context status\n")
  cat("  - add_context_file('path/to/file.md')     # Add file to Section 3\n")
  cat("  - remove_context_file('path/to/file.md')  # Remove file from Section 3\n")
  cat("  - list_available_md_files(pattern)       # Discover available files\n")
  cat("🎭 Quick Persona Switches:\n")
  cat("  - activate_developer()       # Technical focus (minimal context)\n")
  cat("  - activate_project_manager() # Strategic oversight (full context)\n")
  cat("  - activate_casenote_analyst() # Domain expertise (specialized context)\n")
  cat("  - activate_prompt_engineer()  # Prompt optimization focus\n")
  cat("📝 File Change Logging:\n")
  cat("  - log_file_change('path', 'description') # Log file modifications\n")
  cat("  - log_change('path', 'desc')             # Short alias\n")
  
  copilot_context_initialized <- TRUE
}