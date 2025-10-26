# Repository Guardian Integration Test
# Tests the basic functionality of the Repository Guardian persona system

# ---- load-system ----
source('./scripts/update-copilot-context.R')

# ---- test-functions ----
test_repo_guardian_integration <- function() {
  cat("🧪 TESTING REPOSITORY GUARDIAN INTEGRATION\n")
  cat(paste(rep("=", 50), collapse = ""), "\n")
  
  # Test 1: Check persona file exists
  cat("📁 Test 1: Persona file existence...\n")
  persona_file <- "./ai/system-prompt-repo-guardian.md"
  if (file.exists(persona_file)) {
    cat("✅ Repository Guardian persona file found\n")
  } else {
    stop("❌ Repository Guardian persona file missing")
  }
  
  # Test 2: Check activation function exists
  cat("🔧 Test 2: Activation function availability...\n")
  if (exists("activate_repo_guardian")) {
    cat("✅ activate_repo_guardian() function available\n")
  } else {
    stop("❌ activate_repo_guardian() function missing")
  }
  
  # Test 3: Test persona activation
  cat("🎭 Test 3: Persona activation test...\n")
  tryCatch({
    activate_repo_guardian()
    cat("✅ Repository Guardian activated successfully\n")
  }, error = function(e) {
    stop("❌ Failed to activate Repository Guardian: ", e$message)
  })
  
  # Test 4: Check persona detection
  cat("🔍 Test 4: Persona detection in list...\n")
  persona_list <- capture.output(list_personas(), type = "message")
  if (any(grepl("repo-guardian", persona_list))) {
    cat("✅ Repository Guardian detected in persona list\n")
  } else {
    stop("❌ Repository Guardian not found in persona list")
  }
  
  # Test 5: Check persona content
  cat("📖 Test 5: Persona content validation...\n")
  persona_content <- readLines(persona_file)
  required_sections <- c("Role", "Objective/Task", "Tools/Capabilities", "Rules/Constraints")
  
  all_sections_found <- TRUE
  for (section in required_sections) {
    if (!any(grepl(paste0("## ", section), persona_content))) {
      cat("❌ Missing section:", section, "\n")
      all_sections_found <- FALSE
    }
  }
  
  if (all_sections_found) {
    cat("✅ All required persona sections present\n")
  } else {
    stop("❌ Persona content validation failed")
  }
  
  cat("\n🎉 ALL TESTS PASSED - Repository Guardian integration successful!\n")
  cat(paste(rep("=", 50), collapse = ""), "\n")
  
  # Provide usage summary
  cat("\n📋 USAGE SUMMARY:\n")
  cat("   activate_repo_guardian()     # Quick activation\n")
  cat("   list_personas()              # See all personas\n") 
  cat("   deactivate_persona()         # Return to default\n")
  cat("   See: ./guides/repo-guardian-persona-guide.md\n")
  
  return(TRUE)
}

# ---- run-test ----
if (interactive() || !exists(".test_mode")) {
  # Only run test if called interactively or not in test mode
  test_repo_guardian_integration()
}