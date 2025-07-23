#!/bin/bash

# Year Clock Test Harness
# Tests all configuration permutations to ensure everything works properly

echo "🌈 Year Clock Test Harness"
echo "=========================="
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

# Function to run a test and track results
run_test() {
    local test_name="$1"
    local command="$2"
    local output_file="$3"
    
    echo -n "Testing: $test_name... "
    TESTS_RUN=$((TESTS_RUN + 1))
    
    # If output_file is provided, add it to the command
    if [ -n "$output_file" ]; then
        command="$command --output temp/$output_file"
    fi
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        if [ -n "$output_file" ]; then
            echo "    → Saved: temp/$output_file"
        fi
    else
        echo -e "${RED}✗${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  Command: $command"
    fi
}

echo "${BLUE}1. Running sanity checks...${NC}"
run_test "pixlet check" "pixlet check year_clock.star"
run_test "pixlet format check" "pixlet format --dry-run year_clock.star"
echo ""

echo "${BLUE}2. Testing all color schemes...${NC}"
COLOR_SCHEMES=("rainbow" "grayscale" "red" "blue" "green" "purple")
for scheme in "${COLOR_SCHEMES[@]}"; do
    run_test "Color scheme: $scheme" "pixlet render year_clock.star color_scheme=$scheme" "01_colorscheme_${scheme}.webp"
done
echo ""

echo "${BLUE}3. Testing hemisphere combinations...${NC}"
HEMISPHERES=("northern" "southern")
for scheme in "${COLOR_SCHEMES[@]}"; do
    for hemisphere in "${HEMISPHERES[@]}"; do
        run_test "$scheme + $hemisphere" "pixlet render year_clock.star color_scheme=$scheme hemisphere=$hemisphere" "02_hemisphere_${scheme}_${hemisphere}.webp"
    done
done
echo ""

echo "${BLUE}4. Testing with date display...${NC}"
for scheme in "${COLOR_SCHEMES[@]}"; do
    for hemisphere in "${HEMISPHERES[@]}"; do
        run_test "$scheme + $hemisphere + date" "pixlet render year_clock.star color_scheme=$scheme hemisphere=$hemisphere show_date=true" "03_date_${scheme}_${hemisphere}.webp"
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
        run_test "Date overlap test: $scheme @ $name" "pixlet render year_clock.star color_scheme=$scheme show_date=true debug_date='$date'" "03_overlap_${scheme}_${name}.webp"
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
    run_test "Rainbow @ $name" "pixlet render year_clock.star color_scheme=rainbow debug_date='$date'" "04_seasonal_rainbow_${name}.webp"
    run_test "Grayscale @ $name" "pixlet render year_clock.star color_scheme=grayscale debug_date='$date'" "04_seasonal_grayscale_${name}.webp"
done
echo ""

echo "${BLUE}6. Testing edge cases...${NC}"
# Test year boundary dates (using timezone-safe UTC times)
run_test "Dec 31 Northern" "pixlet render year_clock.star debug_date='2024-12-31T18:00:00Z' hemisphere=northern" "05_edge_Dec31_northern.webp"
run_test "Jan 1 Southern" "pixlet render year_clock.star debug_date='2024-01-01T12:00:00Z' hemisphere=southern" "05_edge_Jan1_southern.webp"
run_test "Leap day" "pixlet render year_clock.star debug_date='2024-02-29T12:00:00Z' color_scheme=blue" "05_edge_LeapDay_blue.webp"
echo ""

# Test comprehensive combinations (sample)
echo "${BLUE}7. Testing comprehensive parameter combinations...${NC}"
run_test "All options enabled" "pixlet render year_clock.star color_scheme=purple hemisphere=southern show_date=true debug_date='2024-07-04T12:00:00Z'" "06_comprehensive_all_options.webp"
run_test "Minimal options" "pixlet render year_clock.star" "06_comprehensive_minimal.webp"
run_test "Max contrast test" "pixlet render year_clock.star color_scheme=grayscale show_date=true" "06_comprehensive_contrast.webp"
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