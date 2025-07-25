#!/bin/bash

# Year Clock Test Harness
# Tests all configuration permutations to ensure everything works properly

# Parse command line flags
WRITE_ONLY=false
HIGH_RES=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -W|--write-only)
            WRITE_ONLY=true
            shift
            ;;
        -H|--high-res)
            HIGH_RES=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -W, --write-only    Skip sanity checks, only generate images"
            echo "  -H, --high-res      Generate both gallery (6x) and modal (12x) versions"
            echo "  -h, --help         Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 -W              Fast image generation (gallery only)"
            echo "  $0 -W -H           Fast generation with high-res modal versions"
            echo "  $0 -H              Full test suite with high-res images"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

echo "🌈 Year Clock Test Harness"
echo "=========================="
if [ "$WRITE_ONLY" = true ]; then
    if [ "$HIGH_RES" = true ]; then
        echo "Mode: Write-only with high-res (skipping sanity checks, generating 6x + 12x images)"
    else
        echo "Mode: Write-only (skipping sanity checks, generating 6x images only)"
    fi
else
    if [ "$HIGH_RES" = true ]; then
        echo "Mode: Full test suite with high-res (including sanity checks, generating 6x + 12x images)"
    else
        echo "Mode: Full test suite (including sanity checks, generating 6x images only)"
    fi
fi
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Image quality settings
MAGNIFY_FACTOR=6  # 6x magnification for crisp showcase images (384x192)

# Function to run a test and track results
run_test() {
    local test_name="$1"
    local command="$2"
    local output_file="$3"
    
    echo -n "Testing: $test_name... "
    TESTS_RUN=$((TESTS_RUN + 1))
    
    # Generate gallery version (6x magnification)
    local gallery_command="$command"
    if [[ "$gallery_command" == *"pixlet render"* ]]; then
        gallery_command="$gallery_command --magnify $MAGNIFY_FACTOR"
    fi
    
    # If output_file is provided, add it to the command
    if [ -n "$output_file" ]; then
        gallery_command="$gallery_command --output temp/$output_file"
    fi
    
    # Execute gallery version
    if eval "$gallery_command" > /dev/null 2>&1; then
        local success=true
        local files_generated="temp/$output_file"
        
        # Generate high-res version if flag is enabled
        if [ "$HIGH_RES" = true ] && [ -n "$output_file" ]; then
            local hires_file="${output_file%.*}_hires.${output_file##*.}"
            local hires_command="$command"
            if [[ "$hires_command" == *"pixlet render"* ]]; then
                hires_command="$hires_command --magnify 12"
            fi
            hires_command="$hires_command --output temp/$hires_file"
            
            if eval "$hires_command" > /dev/null 2>&1; then
                files_generated="$files_generated + temp/$hires_file"
            else
                success=false
                echo -e "${YELLOW}⚠${NC}"
                echo "  Gallery: ✓  High-res: ✗"
                echo "  High-res command failed: $hires_command"
            fi
        fi
        
        if [ "$success" = true ]; then
            echo -e "${GREEN}✓${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
            if [ -n "$output_file" ]; then
                echo "    → Saved: $files_generated"
            fi
        fi
    else
        echo -e "${RED}✗${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  Command: $gallery_command"
    fi
}

echo "${BLUE}1. Running sanity checks...${NC}"
if [ "$WRITE_ONLY" = true ]; then
    echo "Skipping sanity checks (write-only mode)"
else
    run_test "pixlet check" "pixlet check year_clock.star"
    run_test "pixlet format check" "pixlet format --dry-run year_clock.star"
fi
echo ""

echo "${BLUE}2. Testing all color schemes...${NC}"
COLOR_SCHEMES=("rainbow" "thermal" "grayscale" "red" "blue" "green" "purple")
for scheme in "${COLOR_SCHEMES[@]}"; do
    run_test "Color scheme: $scheme" "pixlet render year_clock.star color_scheme=$scheme enable_special_dates=false" "01_colorscheme_${scheme}.webp"
done
echo ""

echo "${BLUE}3. Testing hemisphere combinations...${NC}"
HEMISPHERES=("northern" "southern")
for scheme in "${COLOR_SCHEMES[@]}"; do
    for hemisphere in "${HEMISPHERES[@]}"; do
        run_test "$scheme + $hemisphere" "pixlet render year_clock.star color_scheme=$scheme hemisphere=$hemisphere enable_special_dates=false" "02_hemisphere_${scheme}_${hemisphere}.webp"
    done
done
echo ""

echo "${BLUE}4. Testing with date display...${NC}"
for scheme in "${COLOR_SCHEMES[@]}"; do
    for hemisphere in "${HEMISPHERES[@]}"; do
        run_test "$scheme + $hemisphere + date" "pixlet render year_clock.star color_scheme=$scheme hemisphere=$hemisphere show_date=true enable_special_dates=false" "03_date_${scheme}_${hemisphere}.webp"
    done
done
echo ""

echo "${BLUE}4.5. Testing date display with potential dial overlap (February)...${NC}"
# Test cases where dial marker could overlap with date display (early in year)
FEBRUARY_DATES=("2024-02-01T12:00:00Z" "2024-02-14T12:00:00Z" "2024-02-29T12:00:00Z")
FEBRUARY_NAMES=("Feb1" "ValentinesDay" "LeapDay")
OVERLAP_SCHEMES=("rainbow" "grayscale" "red")

for i in "${!FEBRUARY_DATES[@]}"; do
    date="${FEBRUARY_DATES[$i]}"
    name="${FEBRUARY_NAMES[$i]}"
    for scheme in "${OVERLAP_SCHEMES[@]}"; do
        run_test "Date overlap test: $scheme @ $name" "pixlet render year_clock.star color_scheme=$scheme show_date=true debug_date='$date' enable_special_dates=false" "03_overlap_${scheme}_${name}.webp"
    done
done
echo ""

echo "${BLUE}5. Testing seasonal positions (debug dates)...${NC}"
# Test key dates throughout the year (using UTC times that convert properly to EST/EDT)
TEST_DATES=("2024-01-01T12:00:00Z" "2024-03-20T12:00:00Z" "2024-06-21T12:00:00Z" "2024-09-22T12:00:00Z" "2024-12-21T12:00:00Z")
DATE_NAMES=("NewYear" "SpringEquinox" "SummerSolstice" "FallEquinox" "WinterSolstice")

for i in "${!TEST_DATES[@]}"; do
    date="${TEST_DATES[$i]}"
    name="${DATE_NAMES[$i]}"
    run_test "Rainbow @ $name" "pixlet render year_clock.star color_scheme=rainbow debug_date='$date' enable_special_dates=false" "04_seasonal_rainbow_${name}.webp"
    run_test "Grayscale @ $name" "pixlet render year_clock.star color_scheme=grayscale debug_date='$date' enable_special_dates=false" "04_seasonal_grayscale_${name}.webp"
done
echo ""

echo "${BLUE}6. Testing edge cases...${NC}"
# Test year boundary dates (using timezone-safe UTC times)
run_test "Dec 31 Northern" "pixlet render year_clock.star debug_date='2024-12-31T18:00:00Z' hemisphere=northern enable_special_dates=false" "05_edge_Dec31_northern.webp"
run_test "Jan 1 Southern" "pixlet render year_clock.star debug_date='2024-01-01T12:00:00Z' hemisphere=southern enable_special_dates=false" "05_edge_Jan1_southern.webp"
run_test "Leap day" "pixlet render year_clock.star debug_date='2024-02-29T12:00:00Z' color_scheme=blue enable_special_dates=false" "05_edge_LeapDay_blue.webp"
echo ""

echo "${BLUE}6.5. Testing special date easter eggs...${NC}"
# Test special date overrides with enable_special_dates=true
SPECIAL_DATES=("2024-02-14T12:00:00Z" "2024-03-17T12:00:00Z" "2024-06-15T12:00:00Z" "2024-10-31T12:00:00Z" "2024-12-25T12:00:00Z" "2024-01-01T12:00:00Z")
SPECIAL_NAMES=("ValentinesDay" "StPatricksDay" "PrideMonth" "Halloween" "Christmas" "NewYearsDay")
EXPECTED_SCHEMES=("red" "green" "rainbow" "halloween" "christmas" "newyear")

# Add astronomical events to special dates testing
ASTRONOMICAL_DATES=("2024-03-20T12:00:00Z" "2024-06-21T12:00:00Z" "2024-09-22T12:00:00Z" "2024-12-21T12:00:00Z")
ASTRONOMICAL_NAMES=("SpringEquinox" "SummerSolstice" "FallEquinox" "WinterSolstice")
ASTRONOMICAL_SCHEMES=("spring_equinox" "summer_solstice" "fall_equinox" "winter_solstice")

for i in "${!SPECIAL_DATES[@]}"; do
    date="${SPECIAL_DATES[$i]}"
    name="${SPECIAL_NAMES[$i]}"
    expected="${EXPECTED_SCHEMES[$i]}"
    run_test "Special date: $name" "pixlet render year_clock.star debug_date='$date' enable_special_dates=true show_date=true" "06_special_${name}.webp"
done

# Test astronomical events
for i in "${!ASTRONOMICAL_DATES[@]}"; do
    date="${ASTRONOMICAL_DATES[$i]}"
    name="${ASTRONOMICAL_NAMES[$i]}"
    expected="${ASTRONOMICAL_SCHEMES[$i]}"
    run_test "Astronomical event: $name" "pixlet render year_clock.star debug_date='$date' enable_special_dates=true show_date=true" "06_astronomical_${name}.webp"
done

# Test regional holidays with timezone filtering (fixed dates)
REGIONAL_DATES=("2024-07-04T12:00:00Z" "2024-12-26T12:00:00Z" "2024-05-01T12:00:00Z" "2024-11-01T12:00:00Z")
REGIONAL_NAMES=("IndependenceDay" "BoxingDay" "MayDay" "DiaDeLosMuertos")
REGIONAL_ENABLED_TZ=("America/New_York" "Europe/London" "Europe/Paris" "America/Mexico_City")
REGIONAL_DISABLED_TZ=("Europe/London" "America/New_York" "America/New_York" "America/New_York")

# Test variable date regional holidays
VARIABLE_DATES=("2024-11-28T12:00:00Z" "2024-05-01T12:00:00Z")
VARIABLE_NAMES=("Thanksgiving" "GoldenWeek")
VARIABLE_ENABLED_TZ=("America/New_York" "Asia/Tokyo")
VARIABLE_DISABLED_TZ=("Europe/London" "America/New_York")

# Test regional holidays in correct timezones (should show special colors)
for i in "${!REGIONAL_DATES[@]}"; do
    date="${REGIONAL_DATES[$i]}"
    name="${REGIONAL_NAMES[$i]}"
    enabled_tz="${REGIONAL_ENABLED_TZ[$i]}"
    run_test "Regional holiday: $name (enabled)" "pixlet render year_clock.star debug_date='$date' enable_special_dates=true show_date=true '\$tz=$enabled_tz'" "06_regional_${name}_enabled.webp"
done

# Test regional holidays in wrong timezones (should show default colors)
for i in "${!REGIONAL_DATES[@]}"; do
    date="${REGIONAL_DATES[$i]}"
    name="${REGIONAL_NAMES[$i]}"
    disabled_tz="${REGIONAL_DISABLED_TZ[$i]}"
    run_test "Regional holiday: $name (filtered)" "pixlet render year_clock.star debug_date='$date' enable_special_dates=true show_date=true color_scheme=rainbow '\$tz=$disabled_tz'" "06_regional_${name}_filtered.webp"
done

# Test variable date regional holidays in correct timezones (should show special colors)
for i in "${!VARIABLE_DATES[@]}"; do
    date="${VARIABLE_DATES[$i]}"
    name="${VARIABLE_NAMES[$i]}"
    enabled_tz="${VARIABLE_ENABLED_TZ[$i]}"
    run_test "Variable holiday: $name (enabled)" "pixlet render year_clock.star debug_date='$date' enable_special_dates=true show_date=true '\$tz=$enabled_tz'" "06_variable_${name}_enabled.webp"
done

# Test variable date regional holidays in wrong timezones (should show default colors)
for i in "${!VARIABLE_DATES[@]}"; do
    date="${VARIABLE_DATES[$i]}"
    name="${VARIABLE_NAMES[$i]}"
    disabled_tz="${VARIABLE_DISABLED_TZ[$i]}"
    run_test "Variable holiday: $name (filtered)" "pixlet render year_clock.star debug_date='$date' enable_special_dates=true show_date=true color_scheme=rainbow '\$tz=$disabled_tz'" "06_variable_${name}_filtered.webp"
done

# Test that special dates can be disabled
run_test "Special dates disabled" "pixlet render year_clock.star debug_date='2024-12-25T12:00:00Z' enable_special_dates=false color_scheme=blue hemisphere=southern show_date=true" "06_special_disabled.webp"
echo ""

# Test comprehensive combinations (sample)
echo "${BLUE}7. Testing comprehensive parameter combinations...${NC}"
run_test "All options enabled" "pixlet render year_clock.star color_scheme=purple hemisphere=southern show_date=true debug_date='2024-07-04T12:00:00Z' enable_special_dates=false" "07_comprehensive_all_options.webp"
run_test "Minimal options" "pixlet render year_clock.star enable_special_dates=false" "07_comprehensive_minimal.webp"
run_test "Max contrast test" "pixlet render year_clock.star color_scheme=grayscale show_date=true enable_special_dates=false" "07_comprehensive_contrast.webp"
echo ""

echo "${BLUE}8. Testing accent dot variations...${NC}"
# Test representative accent dot styles across key color schemes
ACCENT_STYLES=("adaptive" "contrast" "fixed_magenta" "fixed_cyan" "fixed_white" "fixed_yellow" "none")
ACCENT_TEST_SCHEMES=("rainbow" "grayscale" "red" "purple")

for style in "${ACCENT_STYLES[@]}"; do
    for scheme in "${ACCENT_TEST_SCHEMES[@]}"; do
        run_test "Accent: $style on $scheme" "pixlet render year_clock.star color_scheme=$scheme accent_dot_style=$style debug_date='2024-07-01T12:00:00Z' enable_special_dates=false" "08_accent_${style}_${scheme}.webp"
    done
done

# Test a few key comparisons for the showcase
run_test "Accent comparison: Purple adaptive vs contrast" "pixlet render year_clock.star color_scheme=purple accent_dot_style=adaptive debug_date='2024-07-01T12:00:00Z' enable_special_dates=false" "08_accent_compare_purple_adaptive.webp"
run_test "Accent comparison: Purple contrast" "pixlet render year_clock.star color_scheme=purple accent_dot_style=contrast debug_date='2024-07-01T12:00:00Z' enable_special_dates=false" "08_accent_compare_purple_contrast.webp"
echo ""

echo "${BLUE}9. Testing timezone-based date format detection...${NC}"
# Test timezone-based automatic date format detection
TEST_TIMEZONES=("America/New_York" "America/Los_Angeles" "Europe/London" "Europe/Paris" "Asia/Tokyo" "Canada/Eastern" "Canada/Pacific")
DATE_FORMATS=("auto" "us_format" "european_format" "iso_format")

echo "  Testing all date format options with different timezones..."
for format in "${DATE_FORMATS[@]}"; do
    echo "    🔸 Testing date_format=$format"
    for tz in "${TEST_TIMEZONES[@]}"; do
        tz_clean="${tz//\//_}"
        run_test "Timezone $tz with $format" "pixlet render year_clock.star show_date=true date_format=$format debug_date='2024-03-15T12:00:00Z'" "09_timezone_${format}_${tz_clean}.webp"
    done
done

# Add a few verification tests for key combinations
echo "  Testing timezone auto-detection verification..."
run_test "US timezone auto-detection" "pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z'" "09_verify_us_auto.webp"
run_test "European timezone auto-detection" "pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z'" "09_verify_european_auto.webp"
run_test "Asian timezone auto-detection" "pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z'" "09_verify_asian_auto.webp"
echo ""

# Output final results
echo "=========================="
echo "${BLUE}Test Results Summary:${NC}"
echo "  Tests Run: $TESTS_RUN"
echo -e "  Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "  Failed: ${RED}$TESTS_FAILED${NC}"

# Show generated files
if [ $TESTS_PASSED -gt 0 ]; then
    echo ""
    echo "${BLUE}Generated Images:${NC}"
    echo "  Location: temp/"
    echo "  Count: $(ls temp/*.webp 2>/dev/null | wc -l | tr -d ' ') images"
    echo "  Preview: ls temp/"
    ls -la temp/*.webp 2>/dev/null | head -10
    if [ $(ls temp/*.webp 2>/dev/null | wc -l) -gt 10 ]; then
        echo "  ... and $(($(ls temp/*.webp 2>/dev/null | wc -l) - 10)) more images"
    fi
fi

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n🎉 ${GREEN}All tests passed!${NC}"
    echo -e "🖼️  ${BLUE}Check temp/ folder for rendered images${NC}"
    exit 0
else
    echo -e "\n❌ ${RED}Some tests failed. Check output above.${NC}"
    exit 1
fi 