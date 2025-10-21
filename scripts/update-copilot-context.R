# ==============================================================================
# Update Copilot Instructions Context
# ==============================================================================
# 
# This script automates the process of updating .github/copilot-instructions.md
# with the contents of foundational project files. It allows analysts to quickly
# refresh the AI context by typing: add_to_instructions("glossary", "mission", ...)
#
# Author: GitHub Copilot (with human analyst)
# Created: 2025-07-16
# Updated: 2025-08-15 - Modernized based on SDA-CEIS-Impact implementation

update_copilot_instructions <- function(file_list) {
  # Map friendly names to actual file paths (Books of Ukraine - updated)
  file_map <- list(
    "onboarding-ai" = "./ai/onboarding-ai.md",
    "mission" = "./ai/mission.md", 
    "method" = "./ai/method.md",
    "glossary" = "./ai/glossary.md",
  "semiology" = "./philosophy/semiology.md",
    "pipeline" = "./pipeline.md",
    "fides" = "./ai/FIDES.md",
    "handoff" = "./analysis/handoff.md",
    "memory-hub" = "./ai/memory-hub.md",
    "memory-human" = "./ai/memory-human.md",
    "memory-ai" = "./ai/memory-ai.md",
    "project-map" = "./ai/project-map.md",
    "input-manifest" = "./data-public/metadata/INPUT-manifest.md",
    "ua-admin-manifest" = "./data-public/metadata/ua-admin-manifest.md",
    # Generic agent persona - dynamically loaded
    "agent-persona" = get_active_persona_file()
  )
  
  instructions_path <- ".github/copilot-instructions.md"
  
  # Check if instructions file exists
  if (!file.exists(instructions_path)) {
    stop("Copilot instructions file not found at: ", instructions_path)
  }
  
  # Read the current copilot instructions
  current_content <- readLines(instructions_path, warn = FALSE)
  
  # Find the dynamic content section markers
  start_marker <- which(grepl("<!-- DYNAMIC CONTENT START -->", current_content))
  end_marker <- which(grepl("<!-- DYNAMIC CONTENT END -->", current_content))
  
  if (length(start_marker) == 0 || length(end_marker) == 0) {
    stop("Dynamic content markers not found in copilot instructions. Please add:\n<!-- DYNAMIC CONTENT START -->\n<!-- DYNAMIC CONTENT END -->")
  }
  
  # Build new content section with summary
  component_list <- paste(file_list, collapse=", ")
  new_content <- c(
    "<!-- DYNAMIC CONTENT START -->",
    "",
    paste("**Currently loaded components:**", component_list),
    ""
  )
  
  for (file_name in file_list) {
    if (file_name %in% names(file_map)) {
      file_path <- file_map[[file_name]]
      if (file.exists(file_path)) {
        file_content <- readLines(file_path, warn = FALSE)
        new_content <- c(
          new_content,
          paste0("### ", tools::toTitleCase(gsub("-", " ", file_name)), " (from `", file_path, "`)"),
          "",
          file_content,
          ""
        )
        message("✓ Added: ", file_path)
      } else {
        warning("✗ File not found: ", file_path)
      }
    } else {
      warning("✗ Unknown file alias: ", file_name, ". Available: ", paste(names(file_map), collapse=", "))
    }
  }
  
  # Replace the section (including both markers)
  updated_content <- c(
    current_content[1:(start_marker-1)],
    new_content,
    current_content[end_marker:length(current_content)]
  )
  
  # Write back
  writeLines(updated_content, instructions_path)
  
  # Ensure file ends with newline to prevent warnings
  if (length(updated_content) > 0 && !endsWith(updated_content[length(updated_content)], "\n")) {
    cat("\n", file = instructions_path, append = TRUE)
  }
  
  message("🔄 Updated .github/copilot-instructions.md with: ", paste(file_list, collapse=", "))
  message("📄 Total lines in updated file: ", length(updated_content))
}

# Convenience function for easy calling
add_to_instructions <- function(...) {
  file_list <- c(...)
  if (length(file_list) == 0) {
    message("Available file aliases:")
    file_map <- list(
      "onboarding-ai" = "./ai/onboarding-ai.md",
      "mission" = "./ai/mission.md", 
      "method" = "./ai/method.md",
      "glossary" = "./ai/glossary.md",
  "semiology" = "./philosophy/semiology.md",
      "pipeline" = "./pipeline.md",
      "fides" = "./ai/FIDES.md",
    "handoff" = "./analysis/handoff.md",
      "memory-hub" = "./ai/memory-hub.md",
      "memory-human" = "./ai/memory-human.md",
      "memory-ai" = "./ai/memory-ai.md",
      "project-map" = "./ai/project-map.md",
      "input-manifest" = "./ai/INPUT-manifest.md",
      "ua-admin-manifest" = "./ai/ua-admin-manifest.md",
      # Generic agent persona - dynamically loaded
      "agent-persona" = get_active_persona_file()
    )
    for (alias in names(file_map)) {
      exists_marker <- if (file.exists(file_map[[alias]])) "✓" else "✗"
      message("  ", exists_marker, " ", alias, " -> ", file_map[[alias]])
    }
    message("\nUsage: add_to_instructions('onboarding-ai','mission', 'glossary')")
  } else {
    update_copilot_instructions(file_list)
  }
}

# Quick alias for common combinations
add_core_context <- function() {
  add_to_instructions("onboarding-ai", "mission", "method")
}

add_full_context <- function() {
  add_to_instructions("onboarding-ai", "mission", "method", "glossary", "pipeline")
}

# Books of Ukraine specific context combinations
add_data_context <- function() {
  add_to_instructions("cache-manifest", "pipeline")
}

add_memory_context <- function() {
  add_to_instructions("memory-hub", "memory-human", "memory-ai")
}

remove_all_dynamic_instructions <- function() {
  instructions_path <- ".github/copilot-instructions.md"
  
  # Check if instructions file exists
  if (!file.exists(instructions_path)) {
    stop("Copilot instructions file not found at: ", instructions_path)
  }
  
  # Read the current copilot instructions
  current_content <- readLines(instructions_path, warn = FALSE)
  
  # Find the dynamic content section markers
  start_marker <- which(grepl("<!-- DYNAMIC CONTENT START -->", current_content))
  end_marker <- which(grepl("<!-- DYNAMIC CONTENT END -->", current_content))
  
  if (length(start_marker) == 0 || length(end_marker) == 0) {
    stop("Dynamic content markers not found in copilot instructions. Please add:\n<!-- DYNAMIC CONTENT START -->\n<!-- DYNAMIC CONTENT END -->")
  }
  
  # Create new content with just the markers and empty space between
  new_content <- c(
    "<!-- DYNAMIC CONTENT START -->",
    "",
    "<!-- DYNAMIC CONTENT END -->"
  )
  
  # Replace the section (including both markers)
  updated_content <- c(
    current_content[1:(start_marker-1)],
    new_content,
    current_content[(end_marker+1):length(current_content)]
  )
  
  # Write back
  writeLines(updated_content, instructions_path)
  
  # Ensure file ends with newline to prevent warnings
  if (length(updated_content) > 0 && !endsWith(updated_content[length(updated_content)], "\n")) {
    cat("\n", file = instructions_path, append = TRUE)
  }
  
  message("🗑️ Removed all dynamic content from .github/copilot-instructions.md")
  message("📄 Total lines in updated file: ", length(updated_content))
}

# ==============================================================================
# CONTEXT MANAGEMENT COMMANDS
# ==============================================================================

# Helper operator for string repetition
`%r%` <- function(str, times) paste(rep(str, times), collapse = "")

# Quick context scan and refresh - triggered by keyphrase
context_refresh <- function() {
  message("🔍 DYNAMIC CONTEXT SCAN")
  message(paste(rep("=", 50), collapse = ""))
  
  # Check current persona
  current_persona <- get_current_persona()
  message("🎭 Active persona: ", current_persona)
  
  # Check current context
  instructions_path <- ".github/copilot-instructions.md"
  
  if (!file.exists(instructions_path)) {
    message("❌ Copilot instructions file not found")
    return()
  }
  
  content <- readLines(instructions_path, warn = FALSE)
  component_line <- content[grepl("\\*\\*Currently loaded components:\\*\\*", content)]
  
  if (length(component_line) == 0) {
    message("📋 Current status: NO dynamic content loaded")
  } else {
    components <- gsub(".*Currently loaded components:\\*\\* ", "", component_line)
    message("📋 Currently loaded: ", components)
  }
  
  # Check file freshness
  validate_context()
  check_context_size()
  
  # Quick project structure check
  required_dirs <- c("data-private", "data-public", "manipulation", "analysis", "scripts", "ai")
  missing_dirs <- required_dirs[!sapply(required_dirs, dir.exists)]
  
  if (length(missing_dirs) == 0) {
    message("✅ Project structure validated")
  } else {
    message("⚠️  Project structure issues detected:")
    message("    Missing directories: ", paste(missing_dirs, collapse = ", "))
  }

  message("\n🎭 PERSONA MANAGEMENT (Dynamic):")
  message("👤  Load persona: set_persona('path/to/persona.md', 'name')")
  message("📋  List personas: list_personas()")
  message("🔧  Quick switches: activate_casenote_analyst()")
  message("🔄  Deactivate: deactivate_persona()")
  
  message("\n🚀 QUICK REFRESH OPTIONS:")
  message("1️⃣  Core context: add_core_context()")
  message("2️⃣  Data context: add_data_context()")  
  message("3️⃣  Memory context: add_memory_context()")
  message("4️⃣  Full context: add_full_context()")
  message("5️⃣  Custom phase: suggest_context('phase')")
  message("🗑️  Reset: remove_all_dynamic_instructions()")
  message("\n🔧 TROUBLESHOOTING & ANALYSIS:")
  message("📊  Check CACHE status: check_cache_manifest()")
  message("🔍  Full project analysis: analyze_project_status()")
  message("💡  Get command help: get_command_help()")
  message("\n💡 Or specify custom files: add_to_instructions('file1', 'file2')")
}

# 1. Context Validation - Check if loaded content is still current
validate_context <- function() {
  instructions_path <- ".github/copilot-instructions.md"
  
  if (!file.exists(instructions_path)) {
    message("❌ Copilot instructions file not found")
    return(FALSE)
  }
  
  content <- readLines(instructions_path, warn = FALSE)
  
  # Find loaded components
  component_line <- content[grepl("\\*\\*Currently loaded components:\\*\\*", content)]
  
  if (length(component_line) == 0) {
    message("ℹ️ No dynamic content currently loaded")
    return(TRUE)
  }
  
  # Extract component list
  components <- gsub(".*Currently loaded components:\\*\\* ", "", component_line)
  component_list <- trimws(strsplit(components, ",")[[1]])
  
  # Map to file paths and check if files have been modified recently
  file_map <- list(
    "onboarding-ai" = "./ai/onboarding-ai.md",
    "mission" = "./ai/mission.md", 
    "method" = "./ai/method.md",
    "glossary" = "./ai/glossary.md",
  "semiology" = "./philosophy/semiology.md",
    "pipeline" = "./pipeline.md",
    "fides" = "./ai/FIDES.md",
     "handoff" = "./analysis/handoff.md",
    "memory-hub" = "./ai/memory-hub.md",
    "memory-human" = "./ai/memory-human.md",
    "memory-ai" = "./ai/memory-ai.md",
    "project-map" = "./ai/project-map.md"
  )
  
  message("🔍 Checking context freshness...")
  stale_files <- c()
  
  for (component in component_list) {
    if (component %in% names(file_map)) {
      file_path <- file_map[[component]]
      if (file.exists(file_path)) {
        file_time <- file.mtime(file_path)
        instructions_time <- file.mtime(instructions_path)
        if (file_time > instructions_time) {
          stale_files <- c(stale_files, component)
        }
      }
    }
  }
  
  if (length(stale_files) > 0) {
    message("⚠️ These components have been updated since last context load:")
    for (file in stale_files) {
      message("  📝 ", file)
    }
    message("💡 Consider running: add_to_instructions(", paste0('"', paste(component_list, collapse='", "'), '"'), ")")
    return(FALSE)
  } else {
    message("✅ All loaded components are current")
    return(TRUE)
  }
}

# 2. Smart Context Management - Auto-suggest relevant context based on analysis phase
suggest_context <- function(analysis_phase = NULL) {
  if (is.null(analysis_phase)) {
    message("🎯 Available analysis phases:")
    message("  📊 'data-setup' - Focus on data assembly and pipeline")
    message("  🔍 'exploration' - Focus on EDA and initial findings") 
    message("  📈 'modeling' - Focus on analysis and reporting")
    message("  🧠 'memory' - Focus on project memory and documentation")
    message("\nUsage: suggest_context('data-setup')")
    return()
  }
  
  suggestions <- switch(analysis_phase,
    "data-setup" = c("onboarding-ai", "pipeline", "cache-manifest", "input-manifest"),
    "exploration" = c("onboarding-ai", "mission", "method", "glossary"),
    "modeling" = c("mission", "method", "semiology", "fides"),
    "memory" = c("memory-hub", "memory-human", "memory-ai"),
    c("onboarding-ai", "mission", "method")
  )
  
  message("💡 Suggested context for '", analysis_phase, "' phase:")
  message("   add_to_instructions(", paste0('"', paste(suggestions, collapse='", "'), '"'), ")")
  
  # Auto-load option
  if (interactive()) {
    response <- readline("🤖 Load this context automatically? (y/n): ")
    if (tolower(trimws(response)) %in% c("y", "yes")) {
      do.call(add_to_instructions, as.list(suggestions))
    }
  }
}

# 3. Context Size Management - Warn about large contexts
check_context_size <- function() {
  instructions_path <- ".github/copilot-instructions.md"
  
  if (!file.exists(instructions_path)) {
    return()
  }
  
  file_size <- file.size(instructions_path)
  line_count <- length(readLines(instructions_path, warn = FALSE))
  
  message("📊 Context file stats:")
  message("  📄 Size: ", round(file_size / 1024, 1), " KB")
  message("  📝 Lines: ", line_count)
  
  # Multi-tier warnings for better guidance
  if (file_size > 100000) { # ~100KB - Critical
    message("🚨 CRITICAL: Context file is very large (>100KB) - high risk of truncation")
    message("    Recommend: remove_all_dynamic_instructions() and use focused contexts")
  } else if (file_size > 50000) { # ~50KB - Warning
    message("⚠️ WARNING: Context file is getting large (>50KB) - may impact performance")
    message("    Recommend: consider using focused contexts for better efficiency")
  } else if (file_size > 25000) { # ~25KB - Caution
    message("💡 NOTICE: Context file approaching optimal size (>25KB)")
    message("    Consider: focused contexts for complex analysis tasks")
  } else {
    message("✅ Context file size is optimal for AI focus")
  }
}

# ============================================================================== 
# CACHE MANIFEST MANAGEMENT (DECOMMISSIONED AUTOMATION)
# ==============================================================================

# New canonical manifest location (human-authored)
cache_manifest_canonical_path <- function() {
  file.path("data-public", "metadata", "CACHE-MANIFEST.md")
}

# Backwards compatible stub (old signature). Never auto-writes now.
check_cache_manifest <- function(update_if_needed = TRUE) {
  path <- cache_manifest_canonical_path()
  exists <- file.exists(path)
  message("📋 CACHE Manifest (manual mode)")
  if (exists) {
    message("   ✅ Present at: ", path)
    message("   📅 Last modified: ", format(file.mtime(path), "%Y-%m-%d %H:%M:%S"))
    if (isTRUE(update_if_needed)) {
      message("   ℹ️ Automation disabled: no update attempted.")
    }
    return(list(status = "present", path = path, manifest_current = TRUE))
  } else {
    warning("   ❌ Missing expected manifest at: ", path,
            "\n   Create or copy a human-authored manifest before proceeding.")
    return(list(status = "missing", path = path, manifest_current = FALSE))
  }
}

# Deprecated writer: inform user and do nothing.
update_cache_manifest <- function(...) {
  path <- cache_manifest_canonical_path()
  message("� update_cache_manifest() is deprecated. Manual maintenance only.")
  if (file.exists(path)) {
    message("✅ Existing manifest detected at: ", path)
  } else {
    warning("❌ No manifest found at expected path: ", path,
            "\nCreate it manually (see README or data documentation template).")
  }
  invisible(path)
}

# Alias retained for any legacy calls
build_cache_manifest <- function(...) update_cache_manifest(...)

# ==============================================================================
# PROJECT ANALYSIS & COMMAND OVERVIEW SYSTEM  
# ==============================================================================

# Comprehensive project analysis and command recommendations
analyze_project_status <- function() {
  cat("🔍 COMPREHENSIVE PROJECT ANALYSIS\n")
  cat("=" %r% 80, "\n")
  cat("Analyzing project memory, context, setup, and providing recommendations...\n\n")
  
  # === 1. PROJECT SETUP STATUS ===
  cat("📋 1. PROJECT SETUP STATUS\n")
  cat("-" %r% 40, "\n")
  
  # Basic project structure check
  required_dirs <- c("data-private", "data-public", "manipulation", "analysis", "scripts", "ai")
  required_files <- c("flow.R", "README.md")
  
  setup_ready <- TRUE
  missing_items <- c()
  
  for (dir in required_dirs) {
    if (!dir.exists(dir)) {
      setup_ready <- FALSE
      missing_items <- c(missing_items, paste("Directory:", dir))
    }
  }
  
  for (file in required_files) {
    if (!file.exists(file)) {
      setup_ready <- FALSE  
      missing_items <- c(missing_items, paste("File:", file))
    }
  }
  
  if (setup_ready) {
    cat("✅ Setup Status: READY\n")
  } else {
    cat("❌ Setup Status: ISSUES DETECTED\n")
    cat("   Missing items: ", length(missing_items), "\n")
    for (item in head(missing_items, 3)) {
      cat("   - ", item, "\n")
    }
    if (length(missing_items) > 3) {
      cat("   ... and ", length(missing_items) - 3, " more\n")
    }
  }
  
  # === 2. AI CONTEXT STATUS ===
  cat("\n📚 2. AI CONTEXT STATUS\n")
  cat("-" %r% 40, "\n")
  
  instructions_path <- ".github/copilot-instructions.md"
  component_line <- c()  # Initialize for later use
  
  if (file.exists(instructions_path)) {
    content <- readLines(instructions_path, warn = FALSE)
    component_line <- content[grepl("\\*\\*Currently loaded components:\\*\\*", content)]
    
    if (length(component_line) == 0) {
      cat("📄 Dynamic Context: NONE LOADED\n")
      cat("   🤖 Recommendation: Run add_core_context() to start\n")
    } else {
      components <- gsub(".*Currently loaded components:\\*\\* ", "", component_line)
      cat("📄 Dynamic Context: LOADED\n")
      cat("   Components: ", components, "\n")
      cat("   ✅ Status: CURRENT\n")
    }
    
    # Check file size
    file_size <- file.size(instructions_path)
    cat("   📊 Size: ", round(file_size / 1024, 1), " KB")
    if (file_size > 50000) {
      cat(" (⚠️  Large - may impact performance)")
    } else if (file_size > 25000) {
      cat(" (💡 Getting large - consider focused contexts)")
    } else {
      cat(" (✅ Optimal)")
    }
    cat("\n")
  } else {
    cat("❌ Copilot Instructions: NOT FOUND\n")
    cat("   🔧 Recommendation: Check repository structure\n")
  }
  
  # === 3. DATA STATUS ===
  cat("\n💾 3. DATA STATUS\n")
  cat("-" %r% 40, "\n")
  
  # Check for data files
  data_files <- c()
  data_dirs <- c("data-private/derived", "data-public/derived", "data-private/raw", "data-public/raw")
  
  for (dir in data_dirs) {
    if (dir.exists(dir)) {
      files <- list.files(dir, pattern = "\\.(rds|csv|xlsx)$", recursive = TRUE, full.names = TRUE)
      data_files <- c(data_files, files)
    }
  }
  
  cat("📊 Data Files: ", length(data_files), " found\n")
  
  if (length(data_files) == 0) {
    cat("   Status: NO DATA FILES\n")
    cat("   🚀 Recommendation: Run data processing scripts\n")
  } else {
    cat("   Status: DATA AVAILABLE\n")
    
    # Check data freshness
    if (length(data_files) > 0) {
      newest_data <- max(sapply(data_files, file.mtime))
      hours_old <- as.numeric(difftime(Sys.time(), newest_data, units = "hours"))
      
      if (hours_old > 24) {
        cat("   ⏰ Age: ", round(hours_old, 1), " hours old\n")
        cat("   💡 Consider refreshing if source data has changed\n")
      } else {
        cat("   ✅ Age: Recent (", round(hours_old, 1), " hours old)\n")
      }
    }
  }
  
  # === 4. ANALYSIS READINESS ===
  cat("\n📈 4. ANALYSIS READINESS\n")
  cat("-" %r% 40, "\n")
  
  analysis_ready <- setup_ready && length(data_files) > 0
  
  if (analysis_ready) {
    cat("🎯 Status: READY FOR ANALYSIS\n")
    cat("   Available data files: ", length(data_files), "\n")
    cat("   🚀 Next: Run analysis scripts or create new ones\n")
  } else {
    cat("⏳ Status: NOT READY\n")
    if (!setup_ready) {
      cat("   Blocker: Setup issues need resolution\n")
    }
    if (length(data_files) == 0) {
      cat("   Blocker: No data files available\n")
    }
  }
  
  # === 5. COMMAND REFERENCE ===
  cat("\n🛠️  5. AVAILABLE COMMANDS\n")
  cat("=" %r% 80, "\n")
  
  cat("\n📚 CONTEXT MANAGEMENT:\n")
  cat("├─ context_refresh()         │ Complete status scan + context options\n")
  cat("├─ add_core_context()        │ Load essential context (onboarding, mission, method)\n")
  cat("├─ add_data_context()        │ Load data-focused context (cache-manifest, pipeline)\n")
  cat("├─ add_memory_context()      │ Load memory-focused context (memory-hub, memory-human, memory-ai)\n")
  cat("├─ add_full_context()        │ Load comprehensive context set\n")
  cat("├─ suggest_context('phase')  │ Smart context suggestions by analysis phase\n")
  cat("├─ add_to_instructions()     │ Manual context loading with custom file selection\n")
  cat("├─ remove_all_dynamic_instructions() │ Reset/clear all dynamic context\n")
  cat("├─ validate_context()        │ Check if loaded context files are current\n")
  cat("├─ check_context_size()      │ Monitor context file size and performance impact\n")
  cat("└─ check_cache_manifest()    │ Verify manual CACHE manifest presence (no auto-update)\n")
  
  cat("\n📊 PROJECT ANALYSIS:\n")
  cat("├─ analyze_project_status()  │ THIS COMMAND - Complete project analysis\n")
  cat("└─ get_command_help('cmd')   │ Detailed help for specific commands\n")
  
  # === 6. RECOMMENDATIONS ===
  cat("\n🎯 6. INTELLIGENT RECOMMENDATIONS\n")
  cat("=" %r% 80, "\n")
  
  recommendations <- c()
  
  # Setup recommendations
  if (!setup_ready) {
    recommendations <- c(recommendations, 
      "🔧 CRITICAL: Fix missing project structure items")
  }
  
  # Context recommendations
  if (length(component_line) == 0) {
    recommendations <- c(recommendations,
      "🤖 Start with core AI context → add_core_context()")
  }
  
  # Data recommendations
  if (length(data_files) == 0) {
    recommendations <- c(recommendations,
      "💾 Generate initial data → run data processing scripts")
  }
  
  # Analysis phase recommendations
  if (analysis_ready) {
    recommendations <- c(recommendations,
      "📈 Ready for analysis → suggest_context('exploration') or suggest_context('modeling')",
      "🎯 Run analysis workflows → source('flow.R')")
  }
  
  if (length(recommendations) > 0) {
    cat("Based on current status, recommended next steps:\n\n")
    for (i in seq_along(recommendations)) {
      cat(sprintf("%d. %s\n", i, recommendations[i]))
    }
  } else {
    cat("🎉 Excellent! Your project is in great shape.\n")
    cat("💡 Consider running suggest_context() for phase-specific optimizations.\n")
  }
  
  cat("\n" %r% 80, "\n")
  cat("💡 Pro tip: Save this analysis → capture.output(analyze_project_status())\n")
  cat("🔄 Re-run anytime to get updated status and recommendations\n")
  cat("=" %r% 80, "\n")
}

# Detailed command help system
get_command_help <- function(command_name = NULL) {
  help_info <- list(
    "analyze_project_status" = list(
      description = "Comprehensive analysis of project status with intelligent recommendations",
      usage = "analyze_project_status()",
      purpose = "Complete project health check with actionable next steps",
      when_to_use = "Project onboarding, regular health checks, when unsure what to do next"
    ),
    
    "context_refresh" = list(
      description = "Complete project status scan with context management options",
      usage = "context_refresh()",
      purpose = "One-stop command for project overview + context management options",
      when_to_use = "Regular project status checks, when starting work sessions"
    ),
    
    "add_core_context" = list(
      description = "Load essential AI context (onboarding, mission, method)",
      usage = "add_core_context()",
      purpose = "Provides AI with fundamental project understanding",
      when_to_use = "Starting analysis work, when AI needs project background"
    ),
    
    "check_cache_manifest" = list(
      description = "Check CACHE manifest status and update if needed",
      usage = "check_cache_manifest(update_if_needed = TRUE)",
      purpose = "Analyzes data files and maintains up-to-date CACHE documentation",
      when_to_use = "After data processing, when data files change, during project setup"
    )
  )
  
  if (is.null(command_name)) {
    cat("📖 AVAILABLE COMMANDS FOR DETAILED HELP:\n")
    cat("=" %r% 50, "\n")
    for (cmd in names(help_info)) {
      cat("• get_command_help('", cmd, "')\n", sep = "")
    }
    cat("\nUsage: get_command_help('command_name')\n")
    return()
  }
  
  if (!command_name %in% names(help_info)) {
    cat("❌ Command not found: ", command_name, "\n")
    cat("Available commands: ", paste(names(help_info), collapse = ", "), "\n")
    return()
  }
  
  info <- help_info[[command_name]]
  cat("📖 COMMAND HELP: ", toupper(command_name), "\n")
  cat("=" %r% 60, "\n")
  cat("Description: ", info$description, "\n")
  cat("Usage:       ", info$usage, "\n")
  cat("Purpose:     ", info$purpose, "\n")
  cat("When to use: ", info$when_to_use, "\n")
  cat("=" %r% 60, "\n")
}

# ==============================================================================
# PERSONA MANAGEMENT SYSTEM
# ==============================================================================

# Get the currently active persona file path
get_active_persona_file <- function() {
  persona_config <- "./.copilot-persona"
  
  if (file.exists(persona_config)) {
    config_lines <- readLines(persona_config, warn = FALSE)
    # Look for a line starting with "file:"
    file_line <- config_lines[grepl("^file:", config_lines)]
    if (length(file_line) > 0) {
      persona_file <- trimws(gsub("^file:", "", file_line[1]))
      if (file.exists(persona_file)) {
        return(persona_file)
      }
    }
  }
  
  # Default: no agent persona active
  return(NULL)
}

# Get current persona info
get_current_persona <- function() {
  persona_config <- "./.copilot-persona"
  
  if (file.exists(persona_config)) {
    config_lines <- readLines(persona_config, warn = FALSE)
    
    # Extract persona name
    name_line <- config_lines[grepl("^name:", config_lines)]
    persona_name <- if (length(name_line) > 0) {
      trimws(gsub("^name:", "", name_line[1]))
    } else {
      "unnamed-persona"
    }
    
    return(persona_name)
  }
  
  return("default")
}

# Set current persona with flexible file path
set_persona <- function(persona_file_path, persona_name = NULL, additional_context = c("mission", "method")) {
  persona_config <- "./.copilot-persona"
  
  # Validate persona file exists
  if (!file.exists(persona_file_path)) {
    message("❌ Persona file not found: ", persona_file_path)
    return(invisible(FALSE))
  }
  
  # Auto-generate persona name if not provided
  if (is.null(persona_name)) {
    persona_name <- tools::file_path_sans_ext(basename(persona_file_path))
    persona_name <- gsub("system-prompt-|prompt-", "", persona_name)
  }
  
  # Create persona configuration
  config_content <- c(
    paste("name:", persona_name),
    paste("file:", persona_file_path),
    paste("created:", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
    paste("additional_context:", paste(additional_context, collapse = ", "))
  )
  
  writeLines(config_content, persona_config)
  
  # Load the persona context
  context_components <- c("agent-persona", additional_context)
  
  message("🎭 Activating persona: ", persona_name)
  message("📁 Persona file: ", persona_file_path)
  message("📚 Loading context: ", paste(context_components, collapse = ", "))
  
  # Load the context
  do.call(add_to_instructions, as.list(context_components))
  
  message("✅ Persona activated: ", persona_name)
  return(invisible(TRUE))
}

# Show available personas and current status
list_personas <- function(scan_directory = NULL) {
  current <- get_current_persona()
  current_file <- get_active_persona_file()
  
  message("🎭 PERSONA SYSTEM STATUS")
  message("=" %r% 50)
  
  if (!is.null(current_file)) {
    message("🎯 ACTIVE PERSONA: ", current)
    message("   File: ", current_file)
    message("   Status: ✅ Loaded")
  } else {
    message("🎯 ACTIVE PERSONA: default (no agent persona loaded)")
    message("   Status: 🔄 Using general context only")
  }
  
  message("")
  message("📁 DISCOVERED PERSONA FILES:")
  
  # Scan for potential persona files
  persona_dirs <- c(
    "./analysis/eda-2-casenote/",
    "./ai/",
    "./guides/",
    if (!is.null(scan_directory)) scan_directory
  )
  
  found_personas <- c()
  
  for (dir in persona_dirs) {
    if (dir.exists(dir)) {
      # Look for system-prompt-*.md, prompt-*.md, or *-persona.md files
      persona_files <- list.files(dir, 
        pattern = "(system-prompt-.*\\.md|prompt-.*\\.md|.*-persona\\.md)", 
        full.names = TRUE, recursive = FALSE
      )
      
      for (file in persona_files) {
        persona_name <- tools::file_path_sans_ext(basename(file))
        persona_name <- gsub("system-prompt-|prompt-|-persona", "", persona_name)
        
        active_marker <- if (identical(file, current_file)) " (ACTIVE)" else ""
        message("   🤖 ", persona_name, active_marker)
        message("      📁 ", file)
        
        found_personas <- c(found_personas, file)
      }
    }
  }
  
  if (length(found_personas) == 0) {
    message("   📭 No persona files found in standard locations")
  }
  
  message("")
  message("💡 USAGE:")
  message("   set_persona('path/to/persona-file.md', 'optional-name')")
  message("   activate_casenote_analyst()  # Quick shortcut")
  message("   deactivate_persona()         # Switch back to default")
  message("   list_personas('custom/dir')  # Scan specific directory")
}

# Deactivate current persona (return to default)
deactivate_persona <- function() {
  persona_config <- "./.copilot-persona"
  
  if (file.exists(persona_config)) {
    file.remove(persona_config)
    message("🎭 Persona deactivated - returning to default context")
    
    # Load default context
    add_to_instructions("onboarding-ai", "mission", "method")
    return(invisible(TRUE))
  } else {
    message("ℹ️ No active persona to deactivate")
    return(invisible(FALSE))
  }
}

# Quick persona switching shortcuts
activate_casenote_analyst <- function() {
  set_persona("./analysis/eda-2-casenote/system-prompt-casenote-analyst.md", "casenote-analyst")
}

# Generic persona loader for any file
load_persona_from_file <- function(file_path, persona_name = NULL) {
  set_persona(file_path, persona_name)
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

# ==============================================================================
# AI MEMORY SYSTEM INTEGRATION
# ==============================================================================

# Load AI Memory System
if (file.exists("./scripts/ai-memory-functions-core.R")) {
  source("./scripts/ai-memory-functions-core.R")
} else if (file.exists("./scripts/ai-memory-functions.R")) {
  source("./scripts/ai-memory-functions.R")
}

# Auto-export functions for easy access
if (!exists("copilot_context_initialized")) {
  cat("🤖 Copilot Context Management System Loaded\n")
  cat("📚 Available functions:\n")
  cat("  - analyze_project_status() # 🆕 COMPREHENSIVE project analysis + recommendations\n")
  cat("  - context_refresh()     # Quick status + refresh options\n")
  cat("  - add_core_context()    # onboarding-ai, mission, method\n")
  cat("  - add_data_context()    # cache-manifest, pipeline\n")
  cat("  - add_memory_context()  # memory-hub, memory-human, memory-ai\n")
  cat("  - add_full_context()    # comprehensive set\n")
  cat("  - suggest_context()     # smart suggestions by phase\n")
  cat("  - add_to_instructions() # manual component selection\n")
  cat("  - remove_all_dynamic_instructions() # reset dynamic content\n")
  cat("  - check_cache_manifest()   # 🆕 Check CACHE manifest status & update if needed\n")
  cat("🎭 PERSONA SYSTEM (Dynamic):\n")
  cat("  - list_personas()       # 🆕 Show available persona files & status\n")
  cat("  - set_persona('file.md', 'name') # 🆕 Load any persona file\n")
  cat("  - get_current_persona() # 🆕 Check active persona\n")
  cat("  - deactivate_persona()  # 🆕 Return to default context\n")
  cat("  - activate_casenote_analyst() # 🆕 Quick shortcut\n")
  cat("  - load_persona_from_file()    # 🆕 Generic persona loader\n")
  cat("🧠 MEMORY SYSTEM:\n")
  cat("  - ai_memory_check()     # 🧠 Project memory & intent detection\n")
  cat("  - memory_status()       # Quick memory status\n")
  cat("  - log_file_change()     # 📝 Log file modifications to logbook\n")
  cat("  - log_change()          # 📝 Short alias for log_file_change()\n")
  cat("  - get_command_help('cmd') # 🆕 Detailed help for any command\n")
  
  copilot_context_initialized <- TRUE
}