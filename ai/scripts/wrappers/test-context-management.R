# Test Context Management System
# Quick script to verify persona switching functionality

cat("🧪 Testing AI Context Management System\n\n")

# Load context management functions
source("ai/scripts/ai-context-management.R")

# Show initial status
cat("🔍 Initial Context Status:\n")
show_context_status()
cat("\n", paste0(rep("─", 50), collapse = ""), "\n\n")

# Test switching to default (should be no-op if already default)
cat("🎯 Testing Default Persona Activation:\n")
activate_default()
cat("\n", paste0(rep("─", 50), collapse = ""), "\n\n")

cat("✅ Context management system test completed successfully!\n")
cat("🎭 Available personas:\n")
cat("  • Default - General assistance with minimal context\n")
cat("  • Developer - Technical focus with minimal context\n") 
cat("  • Project Manager - Strategic oversight with full project context\n")
cat("  • Case Note Analyst - Domain expertise with specialized context\n")
cat("\n💡 Use show_context_status() anytime to check current configuration\n")