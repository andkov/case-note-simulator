# Dashboard Quick Reference

## 🚀 Generate Dashboard (One Command)
```bash
Rscript analysis/eda-2-casenote/eda-2-dashboard.R
```

## 📊 Output Files
- **PNG**: `prints/case-note-dashboard_YYYYMMDD_HHMM.png`
- **PDF**: `prints/case-note-dashboard_YYYYMMDD_HHMM.pdf`

## 🎨 Quick Customizations

### Change Colors
Edit lines 37-55 in `eda-2-dashboard.R`:
```r
colors_demographic <- c(
  "18-24" = "#your-color-here",
  # ... change hex codes
)
```

### Resize Dashboard  
Edit lines 32-35:
```r
dashboard_width <- 11     # change width
dashboard_height <- 8.5   # change height
base_font_size <- 10      # change text size
```

### Update Main Title
Edit line ~320:
```r
title = "YOUR CUSTOM TITLE HERE"
```

## 🔧 Common Fixes

### File Not Found
```r
# Update line 27 if data moved:
input_file <- "./path/to/your/synthetic-case-notes.csv"
```

### Missing Packages
```r
install.packages(c("tidyverse", "ggplot2", "patchwork"))
```

### Test Everything Works
```r
# Quick test:
file.exists("./abc/take-2/output/synthetic-case-notes-for-input.csv")
library(tidyverse); library(ggplot2); library(patchwork)
```

## 📱 Six Dashboard Panels
1. **Demographics** (age/gender stacked bars)
2. **Risk Factors** (horizontal bars) 
3. **Locations** (horizontal bars with %)
4. **Risk Heatmap** (age × risk type)
5. **Complexity** (risk tier bars)
6. **Documentation** (scatter + trend)

---
*For full documentation see README.md*