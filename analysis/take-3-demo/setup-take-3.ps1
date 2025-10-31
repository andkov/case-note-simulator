# Take-3 Demo Setup Script
# Configures the analysis environment and validates prerequisites

param(
    [switch]$RunAnalysis,
    [switch]$GenerateReport,
    [switch]$CheckOnly
)

Write-Host "🚀 Take-3 Demo Setup & Validation" -ForegroundColor Cyan
Write-Host "=" * 50

# Set working directory to project root
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
Set-Location $projectRoot

Write-Host "📁 Working Directory: $((Get-Location).Path)" -ForegroundColor Green

# Check if synthetic data exists
Write-Host "`n🔍 Checking Prerequisites..." -ForegroundColor Yellow

$dataExists = $true
$csvPath = "./output/synthetic-case-notes.csv"
$jsonPath = "./output/synthetic-case-notes.json"

if (Test-Path $csvPath) {
    $csvSize = (Get-Item $csvPath).Length
    Write-Host "✅ Found synthetic-case-notes.csv ($([math]::Round($csvSize/1KB, 1)) KB)" -ForegroundColor Green
} else {
    Write-Host "❌ Missing synthetic-case-notes.csv" -ForegroundColor Red
    $dataExists = $false
}

if (Test-Path $jsonPath) {
    $jsonSize = (Get-Item $jsonPath).Length
    Write-Host "✅ Found synthetic-case-notes.json ($([math]::Round($jsonSize/1KB, 1)) KB)" -ForegroundColor Green
} else {
    Write-Host "❌ Missing synthetic-case-notes.json" -ForegroundColor Red
    $dataExists = $false
}

# Check R installation
Write-Host "`n🔍 Checking R Environment..." -ForegroundColor Yellow

try {
    $rVersion = & Rscript --version 2>$null
    if ($rVersion) {
        Write-Host "✅ R is installed: $($rVersion)" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ R not found in PATH" -ForegroundColor Red
    Write-Host "   Please install R from https://cran.r-project.org/" -ForegroundColor Yellow
    exit 1
}

# Check Quarto installation
Write-Host "`n🔍 Checking Quarto Environment..." -ForegroundColor Yellow

try {
    $quartoVersion = & quarto --version 2>$null
    if ($quartoVersion) {
        Write-Host "✅ Quarto is installed: v$quartoVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Quarto not found - report generation will be limited" -ForegroundColor Yellow
    Write-Host "   Install from https://quarto.org/docs/get-started/" -ForegroundColor Yellow
}

# Check required R packages
Write-Host "`n🔍 Checking R Package Dependencies..." -ForegroundColor Yellow

$requiredPackages = @(
    "magrittr", "ggplot2", "dplyr", "tidyr", "patchwork", 
    "plotly", "DT", "jsonlite", "fs", "scales", "forcats",
    "stringr", "lubridate", "labelled", "readr", "kableExtra"
)

$missingPackages = @()

$packageCheckScript = "required_packages <- c('" + ($requiredPackages -join "', '") + "'); installed_packages <- rownames(installed.packages()); missing_packages <- setdiff(required_packages, installed_packages); if (length(missing_packages) > 0) { cat('MISSING:', paste(missing_packages, collapse = ', ')) } else { cat('ALL_INSTALLED') }"

$packageResult = & Rscript -e $packageCheckScript 2>$null

if ($packageResult -eq "ALL_INSTALLED") {
    Write-Host "✅ All required R packages are installed" -ForegroundColor Green
} elseif ($packageResult -like "MISSING:*") {
    $missing = $packageResult -replace "MISSING: ", ""
    Write-Host "❌ Missing R packages: $missing" -ForegroundColor Red
    
    Write-Host "`n📦 Installing missing packages..." -ForegroundColor Yellow
    $missingList = $missing -replace ', ', "', '"
    $installScript = "install.packages(c('$missingList'), repos='https://cran.rstudio.com/', dependencies=TRUE)"
    & Rscript -e $installScript
    
    Write-Host "✅ Package installation completed" -ForegroundColor Green
}

# Validate directory structure
Write-Host "`n🔍 Validating Directory Structure..." -ForegroundColor Yellow

$requiredDirs = @(
    "./analysis/take-3-demo/prints",
    "./analysis/take-3-demo/reports", 
    "./analysis/take-3-demo/figure-png-iso",
    "./analysis/take-3-demo/temp"
)

foreach ($dir in $requiredDirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "📁 Created directory: $dir" -ForegroundColor Green
    } else {
        Write-Host "✅ Directory exists: $dir" -ForegroundColor Green
    }
}

# Check analysis files
Write-Host "`n🔍 Checking Analysis Files..." -ForegroundColor Yellow

$analysisFiles = @(
    "./analysis/take-3-demo/take-3-synthetic-analysis.R",
    "./analysis/take-3-demo/functions-take-3.R",
    "./analysis/take-3-demo/take-3-dashboard.qmd"
)

foreach ($file in $analysisFiles) {
    if (Test-Path $file) {
        Write-Host "✅ Found: $(Split-Path -Leaf $file)" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing: $(Split-Path -Leaf $file)" -ForegroundColor Red
    }
}

# Exit if only checking
if ($CheckOnly) {
    Write-Host "`n✅ Setup validation completed" -ForegroundColor Green
    exit 0
}

# Generate synthetic data if missing
if (!$dataExists) {
    Write-Host "`n🔧 Generating synthetic data..." -ForegroundColor Yellow
    
    # Check if Python script exists
    if (Test-Path "./synthetic_case_note_generator.py") {
        Write-Host "   Running Python generator..." -ForegroundColor Gray
        
        # Check for Python virtual environment
        if (Test-Path "./.venv/Scripts/python.exe") {
            & ./.venv/Scripts/python.exe ./synthetic_case_note_generator.py
        } else {
            python ./synthetic_case_note_generator.py
        }
        
        if (Test-Path $csvPath) {
            Write-Host "✅ Synthetic data generated successfully" -ForegroundColor Green
            $dataExists = $true
        } else {
            Write-Host "❌ Failed to generate synthetic data" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "❌ Python generator script not found" -ForegroundColor Red
        exit 1
    }
}

# Run analysis if requested
if ($RunAnalysis -or $GenerateReport) {
    if (!$dataExists) {
        Write-Host "❌ Cannot run analysis without synthetic data" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "`n📊 Running Take-3 Analysis..." -ForegroundColor Yellow
    
    try {
        & Rscript ./analysis/take-3-demo/take-3-synthetic-analysis.R
        Write-Host "✅ Analysis completed successfully" -ForegroundColor Green
        
        if ($GenerateReport -and (Get-Command quarto -ErrorAction SilentlyContinue)) {
            Write-Host "`n📝 Generating Dashboard Report..." -ForegroundColor Yellow
            
            & quarto render ./analysis/take-3-demo/take-3-dashboard.qmd --to html --embed-resources --standalone
            
            if (Test-Path "./analysis/take-3-demo/take-3-dashboard.html") {
                Write-Host "✅ Dashboard report generated" -ForegroundColor Green
                Write-Host "   Location: ./analysis/take-3-demo/take-3-dashboard.html" -ForegroundColor Gray
            } else {
                Write-Host "⚠️  Dashboard generation may have failed" -ForegroundColor Yellow
            }
        }
        
    } catch {
        Write-Host "❌ Analysis failed: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Summary
Write-Host "`n" + "=" * 50
Write-Host "🎉 Take-3 Demo Setup Complete!" -ForegroundColor Green

if (Test-Path "./analysis/take-3-demo/reports/") {
    $reportCount = (Get-ChildItem "./analysis/take-3-demo/reports/" -File).Count
    Write-Host "📊 Generated $reportCount report files" -ForegroundColor Cyan
}

if (Test-Path "./analysis/take-3-demo/figure-png-iso/") {
    $figureCount = (Get-ChildItem "./analysis/take-3-demo/figure-png-iso/" -File -Filter "*.png").Count
    Write-Host "📈 Generated $figureCount visualization files" -ForegroundColor Cyan
}

Write-Host "`n🚀 Next Steps:" -ForegroundColor Yellow
Write-Host "   • View dashboard: ./analysis/take-3-demo/take-3-dashboard.html" -ForegroundColor Gray
Write-Host "   • Check reports: ./analysis/take-3-demo/reports/" -ForegroundColor Gray
Write-Host "   • Review figures: ./analysis/take-3-demo/figure-png-iso/" -ForegroundColor Gray

Write-Host "`n📋 Quick Commands:" -ForegroundColor Yellow
Write-Host "   • Run analysis only: .\setup-take-3.ps1 -RunAnalysis" -ForegroundColor Gray
Write-Host "   • Generate report: .\setup-take-3.ps1 -GenerateReport" -ForegroundColor Gray
Write-Host "   • Check setup: .\setup-take-3.ps1 -CheckOnly" -ForegroundColor Gray