#!/bin/bash

# 🌈 Year Clock - PR Creation Script
# Creates a clean directory with only the files needed for PR submission

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌈 Year Clock - PR Creation Script${NC}"
echo "================================="

# Parse command line arguments
INCLUDE_IMAGES=false
CLEAN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--images)
            INCLUDE_IMAGES=true
            shift
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -i, --images    Include select showcase images"
            echo "  -c, --clean     Clean existing PR directory first"
            echo "  -h, --help      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                    # Basic PR files only"
            echo "  $0 -i                # Include key images"
            echo "  $0 -c -i             # Clean and include images"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use -h for help"
            exit 1
            ;;
    esac
done

# Define directories
PR_DIR="year-clock-pr"
CURRENT_DIR=$(pwd)

# Clean existing PR directory if requested
if [[ "$CLEAN" == true && -d "$PR_DIR" ]]; then
    echo -e "${YELLOW}🧹 Cleaning existing PR directory...${NC}"
    rm -rf "$PR_DIR"
fi

# Create PR directory
echo -e "${BLUE}📁 Creating PR directory...${NC}"
mkdir -p "$PR_DIR"

# Copy essential files
echo -e "${BLUE}📋 Copying essential files...${NC}"

# Core app files (required)
cp year_clock.star "$PR_DIR/" && echo "  ✅ year_clock.star"
cp manifest.yaml "$PR_DIR/" && echo "  ✅ manifest.yaml"
cp README.md "$PR_DIR/" && echo "  ✅ README.md"

# Copy images if requested
if [[ "$INCLUDE_IMAGES" == true ]]; then
    echo -e "${BLUE}🖼️  Copying showcase images...${NC}"
    mkdir -p "$PR_DIR/images"
    
    # Check if temp directory exists
    if [[ ! -d "temp" ]]; then
        echo -e "${YELLOW}⚠️  Warning: temp/ directory not found. Run ./test_harness.sh first.${NC}"
    else
        # Essential showcase images
        declare -a key_images=(
            "01_colorscheme_rainbow.webp:Rainbow (Default)"
            "01_colorscheme_thermal.webp:Thermal Scheme"
            "01_colorscheme_grayscale.webp:Grayscale Elegance"
            "02_hemisphere_thermal_northern.webp:Northern Hemisphere"
            "02_hemisphere_thermal_southern.webp:Southern Hemisphere"
            "06_special_Christmas.webp:Christmas Theme"
            "06_special_Halloween.webp:Halloween Theme"
            "06_astronomical_SpringEquinox.webp:Spring Equinox"
            "06_astronomical_WinterSolstice.webp:Winter Solstice"
            "05_edge_Jan1_southern.webp:January 1st Edge Case"
            "05_edge_Dec31_northern.webp:December 31st Edge Case"
        )
        
        copied_count=0
        for item in "${key_images[@]}"; do
            IFS=':' read -r filename description <<< "$item"
            if [[ -f "temp/$filename" ]]; then
                cp "temp/$filename" "$PR_DIR/images/" && echo "  ✅ $description"
                ((copied_count++))
            else
                echo "  ⚠️  Missing: $filename"
            fi
        done
        
        echo -e "${GREEN}📊 Copied $copied_count showcase images${NC}"
    fi
fi

# Generate file list
echo -e "${BLUE}📊 PR Contents Summary:${NC}"
cd "$PR_DIR"

echo ""
echo "Core Files:"
ls -la *.star *.yaml *.md | awk '{printf "  📄 %-25s %s\n", $9, $5 " bytes"}'

if [[ "$INCLUDE_IMAGES" == true && -d "images" ]]; then
    echo ""
    echo "Showcase Images:"
    ls -la images/*.webp | awk '{printf "  🖼️  %-35s %s\n", $9, $5 " bytes"}' | sed 's/images\///'
    
    total_size=$(du -sh images/ | cut -f1)
    image_count=$(ls images/*.webp | wc -l)
    echo -e "${GREEN}  📊 Total: $image_count images, $total_size${NC}"
fi

cd "$CURRENT_DIR"

# Calculate total directory size
total_pr_size=$(du -sh "$PR_DIR" | cut -f1)
echo ""
echo -e "${GREEN}✅ PR directory ready: $PR_DIR/ ($total_pr_size)${NC}"

# Next steps
echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "1. Review files in $PR_DIR/"
echo "2. cd $PR_DIR && git init"
echo "3. git add . && git commit -m 'feat: Add Year Clock app'"
echo "4. Push to your tidbyt-community fork"
echo "5. Create pull request with description from PR-DRAFT.md"

# Optional: Show git commands
echo ""
echo -e "${YELLOW}💡 Quick Git Setup:${NC}"
echo "cd $PR_DIR"
echo "git init"
echo "git add year_clock.star manifest.yaml README.md"
if [[ "$INCLUDE_IMAGES" == true ]]; then
    echo "git add images/"
fi
echo "git commit -m 'feat: Add Year Clock app with multiple color schemes and special date themes'"

echo ""
echo -e "${GREEN}🎉 Ready for tidbyt-community submission!${NC}" 