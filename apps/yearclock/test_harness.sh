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

echo "${BLUE}4.8. Testing calendar systems...${NC}"
# Test different calendar systems with date display
CALENDAR_SYSTEMS=("Gregorian" "Persian" "Islamic" "Thai Buddhist" "Ethiopian" "Coptic")
TEST_COLOR_SCHEMES=("rainbow" "thermal" "blue" "green")

for calendar in "${CALENDAR_SYSTEMS[@]}"; do
    # Test each calendar system with rainbow for basic functionality
    run_test "Calendar: $calendar (rainbow)" "pixlet render year_clock.star calendar_system='$calendar' color_scheme=rainbow show_date=true enable_special_dates=false" "04_calendar_${calendar//' '/}_rainbow.webp"
done

# Test calendar systems with seasonal dates to show year progress differences
CALENDAR_TEST_DATES=("2024-01-01T12:00:00Z" "2024-06-21T12:00:00Z" "2024-12-21T12:00:00Z")
CALENDAR_DATE_NAMES=("NewYear" "MidYear" "YearEnd")

for i in "${!CALENDAR_TEST_DATES[@]}"; do
    date="${CALENDAR_TEST_DATES[$i]}"
    name="${CALENDAR_DATE_NAMES[$i]}"
    # Test key calendar systems at different times of year
    for calendar in "Gregorian" "Persian" "Islamic"; do
        run_test "Calendar: $calendar @ $name" "pixlet render year_clock.star calendar_system='$calendar' debug_date='$date' show_date=true enable_special_dates=false" "04_calendar_${calendar}_${name}.webp"
    done
done

# Test thermal peak positioning across different calendar systems (late August date)
echo ""
echo "  Testing thermal peak positioning with late August date..."
THERMAL_TEST_DATE="2024-08-25T12:00:00Z"
for calendar in "Gregorian" "Persian" "Ethiopian" "Islamic"; do
    run_test "Thermal peak: $calendar @ Aug 25" "pixlet render year_clock.star calendar_system='$calendar' color_scheme=thermal debug_date='$THERMAL_TEST_DATE' show_date=true enable_special_dates=false" "04_calendar_thermal_${calendar}_Aug25.webp"
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
# Test special date overrides with enable_special_dates=true (global holidays only)
SPECIAL_DATES=("2024-02-14T12:00:00Z" "2024-06-15T12:00:00Z" "2024-12-25T12:00:00Z" "2024-01-01T12:00:00Z")
SPECIAL_NAMES=("ValentinesDay" "PrideMonth" "Christmas" "NewYearsDay")
EXPECTED_SCHEMES=("red" "rainbow" "christmas" "newyear")

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
REGIONAL_DATES=("2024-07-04T12:00:00Z" "2024-07-14T12:00:00Z" "2024-12-26T12:00:00Z" "2024-05-01T12:00:00Z" "2024-11-01T12:00:00Z" "2024-10-31T12:00:00Z" "2024-03-17T12:00:00Z" "2024-04-23T12:00:00Z" "2024-12-27T12:00:00Z" "2024-09-25T12:00:00Z" "2024-10-05T12:00:00Z" "2024-03-20T12:00:00Z" "2024-03-21T12:00:00Z" "2024-04-13T12:00:00Z" "2024-04-14T12:00:00Z" "2024-04-15T12:00:00Z")
REGIONAL_NAMES=("IndependenceDay" "BastilleDay" "BoxingDay" "MayDay" "DiaDeLosMuertos" "Halloween" "StPatricksDay" "Passover" "Hanukkah" "RoshHashanah" "YomKippur" "Nowruz_Mar20" "Nowruz_Mar21" "Songkran_Apr13" "Songkran_Apr14" "Songkran_Apr15")
REGIONAL_ENABLED_TZ=("America/New_York" "Europe/Paris" "Europe/London" "Europe/Paris" "America/Mexico_City" "America/New_York" "Europe/Dublin" "America/New_York" "America/New_York" "America/New_York" "America/New_York" "Asia/Tehran" "Asia/Tehran" "Asia/Bangkok" "Asia/Bangkok" "Asia/Bangkok")
REGIONAL_DISABLED_TZ=("Europe/London" "America/New_York" "America/New_York" "America/New_York" "America/New_York" "Europe/Paris" "Europe/Paris" "Asia/Tokyo" "America/Mexico_City" "Asia/Tokyo" "America/Mexico_City" "America/New_York" "America/New_York" "America/New_York" "America/New_York" "America/New_York")

# Test variable date regional holidays
VARIABLE_DATES=("2024-11-28T12:00:00Z" "2024-11-29T12:00:00Z" "2024-05-01T12:00:00Z")
VARIABLE_NAMES=("Thanksgiving" "BlackFriday" "GoldenWeek")
VARIABLE_ENABLED_TZ=("America/New_York" "America/New_York" "Asia/Tokyo")
VARIABLE_DISABLED_TZ=("Europe/London" "Europe/London" "America/New_York")

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

echo "${BLUE}10. Testing language support and timezone-based language detection...${NC}"
# Test manual language override with different months to show translated month names
LANGUAGE_TEST_DATES=("2024-01-15T12:00:00Z" "2024-03-15T12:00:00Z" "2024-06-15T12:00:00Z" "2024-09-15T12:00:00Z" "2024-12-15T12:00:00Z")
LANGUAGE_TEST_MONTHS=("January" "March" "June" "September" "December")
LANGUAGES=("en" "es" "fr" "de" "pt" "it" "ru")

echo "  Testing manual language override across different months..."
for i in "${!LANGUAGE_TEST_DATES[@]}"; do
    date="${LANGUAGE_TEST_DATES[$i]}"
    month="${LANGUAGE_TEST_MONTHS[$i]}"
    for lang in "${LANGUAGES[@]}"; do
        run_test "Language $lang in $month" "pixlet render year_clock.star show_date=true language=$lang debug_date='$date' enable_special_dates=false" "10_language_${lang}_${month}.webp"
    done
done
echo ""

echo "  Testing timezone-based automatic language detection..."
# Test timezone-based language auto-detection with culturally appropriate timezones
LANGUAGE_AUTO_TIMEZONES=("America/New_York" "Europe/Madrid" "Europe/Paris" "Europe/Berlin" "America/Sao_Paulo" "Europe/Rome" "Europe/Moscow" "Asia/Yekaterinburg" "Asia/Vladivostok" "Europe/Minsk" "Asia/Almaty" "Africa/Ouagadougou" "Africa/Bamako" "Africa/Dakar" "Africa/Conakry" "Africa/Abidjan" "America/Guatemala" "America/El_Salvador" "America/Tegucigalpa" "America/Managua" "America/Costa_Rica" "Africa/Luanda" "Africa/Maputo" "Africa/Bissau" "Africa/Sao_Tome" "America/Fortaleza" "America/Caracas" "America/Guayaquil" "America/La_Paz" "America/Asuncion" "America/Montevideo" "America/Havana" "America/Santo_Domingo" "America/Panama" "America/Cancun" "America/Tijuana")
LANGUAGE_AUTO_NAMES=("English_US" "Spanish_Spain" "French_France" "German_Germany" "Portuguese_Brazil" "Italian_Italy" "Russian_Moscow" "Russian_Yekaterinburg" "Russian_Vladivostok" "Russian_Belarus" "Russian_Kazakhstan" "French_BurkinaFaso" "French_Mali" "French_Senegal" "French_Guinea" "French_IvoryCoast" "Spanish_Guatemala" "Spanish_ElSalvador" "Spanish_Honduras" "Spanish_Nicaragua" "Spanish_CostaRica" "Portuguese_Angola" "Portuguese_Mozambique" "Portuguese_GuineaBissau" "Portuguese_SaoTome" "Portuguese_BrazilFortaleza" "Spanish_Venezuela" "Spanish_Ecuador" "Spanish_Bolivia" "Spanish_Paraguay" "Spanish_Uruguay" "Spanish_Cuba" "Spanish_DominicanRepublic" "Spanish_Panama" "Spanish_MexicoCancun" "Spanish_MexicoTijuana")
EXPECTED_LANGUAGES=("en" "es" "fr" "de" "pt" "it" "ru" "ru" "ru" "ru" "ru" "fr" "fr" "fr" "fr" "fr" "es" "es" "es" "es" "es" "pt" "pt" "pt" "pt" "pt" "es" "es" "es" "es" "es" "es" "es" "es" "es" "es")

for i in "${!LANGUAGE_AUTO_TIMEZONES[@]}"; do
    tz="${LANGUAGE_AUTO_TIMEZONES[$i]}"
    name="${LANGUAGE_AUTO_NAMES[$i]}"
    expected_lang="${EXPECTED_LANGUAGES[$i]}"
    tz_clean="${tz//\//_}"
    run_test "Auto-detect: $name" "pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '\$tz=$tz'" "10_auto_language_${name}.webp"
done
echo ""

echo "  Testing language + format combinations..."
# Test combinations of language and date format to show the full localization
COMBO_CONFIGS=(
    "lang=es,format=us_format,desc=Spanish_US_Format"
    "lang=fr,format=european_format,desc=French_European_Format" 
    "lang=de,format=european_format,desc=German_European_Format"
    "lang=pt,format=us_format,desc=Portuguese_US_Format"
    "lang=it,format=european_format,desc=Italian_European_Format"
    "lang=ru,format=european_format,desc=Russian_European_Format"
    "lang=en,format=iso_format,desc=English_ISO_Format"
)

for config in "${COMBO_CONFIGS[@]}"; do
    # Parse the config string
    lang=$(echo "$config" | sed 's/.*lang=\([^,]*\).*/\1/')
    format=$(echo "$config" | sed 's/.*format=\([^,]*\).*/\1/')
    desc=$(echo "$config" | sed 's/.*desc=\([^,]*\).*/\1/')
    
    run_test "Combo: $desc" "pixlet render year_clock.star show_date=true language=$lang date_format=$format debug_date='2024-08-15T12:00:00Z' enable_special_dates=false" "10_combo_${desc}.webp"
done
echo ""

echo "  Testing language support with special dates..."
# Test how different languages work with special date themes
SPECIAL_LANG_DATES=("2024-12-25T12:00:00Z" "2024-07-14T12:00:00Z" "2024-10-31T12:00:00Z" "2024-01-01T12:00:00Z")
SPECIAL_LANG_NAMES=("Christmas" "BastilleDay" "Halloween" "NewYearsDay")
SPECIAL_LANG_LANGS=("es" "fr" "de" "ru")
SPECIAL_LANG_TIMEZONES=("" "Europe/Paris" "" "")  # Only Bastille Day needs French timezone to trigger regional holiday

for i in "${!SPECIAL_LANG_DATES[@]}"; do
    date="${SPECIAL_LANG_DATES[$i]}"
    name="${SPECIAL_LANG_NAMES[$i]}"
    lang="${SPECIAL_LANG_LANGS[$i]}"
    timezone="${SPECIAL_LANG_TIMEZONES[$i]}"
    
    if [ -n "$timezone" ]; then
        run_test "Special date with $lang: $name" "pixlet render year_clock.star show_date=true language=$lang debug_date='$date' enable_special_dates=true '\$tz=$timezone'" "10_special_lang_${lang}_${name}.webp"
    else
        run_test "Special date with $lang: $name" "pixlet render year_clock.star show_date=true language=$lang debug_date='$date' enable_special_dates=true" "10_special_lang_${lang}_${name}.webp"
    fi
done
echo ""

echo "${BLUE}11. Testing holiday animations...${NC}"

# Test New Year's sparkle animation
echo "  Testing New Year's sparkle animation..."
NEWYEAR_DATES=("2024-12-31T23:30:00Z" "2024-01-01T00:30:00Z" "2024-01-01T12:00:00Z")
NEWYEAR_NAMES=("NewYearsEve" "NewYearsMidnight" "NewYearsDay")

for i in "${!NEWYEAR_DATES[@]}"; do
    date="${NEWYEAR_DATES[$i]}"
    name="${NEWYEAR_NAMES[$i]}"
    run_test "New Year's animation: $name" "pixlet render year_clock.star debug_date='$date' enable_special_dates=true enable_animations=true show_date=true" "11_animation_${name}.webp"
done

# Test Halloween flicker animation
echo "  Testing Halloween flicker animation..."
run_test "Halloween flicker animation" "pixlet render year_clock.star debug_date='2024-10-31T20:00:00Z' enable_special_dates=true enable_animations=true show_date=true \$tz=America/New_York" "11_animation_Halloween.webp"

# Test Christmas snow animation
echo "  Testing Christmas snow animation..."
run_test "Christmas snow animation" "pixlet render year_clock.star debug_date='2024-12-25T14:00:00Z' enable_special_dates=true enable_animations=true show_date=true" "11_animation_Christmas.webp"

# Test Valentine's hearts animation
echo "  Testing Valentine's hearts animation..."
run_test "Valentine's hearts animation" "pixlet render year_clock.star debug_date='2024-02-14T18:00:00Z' enable_special_dates=true enable_animations=true show_date=true" "11_animation_Valentine.webp"

# Test animation toggle - disabled animations
echo "  Testing animation toggle..."
run_test "Halloween no animation (disabled)" "pixlet render year_clock.star debug_date='2024-10-31T20:00:00Z' enable_special_dates=true enable_animations=false show_date=true \$tz=America/New_York" "11_animation_Halloween_Disabled.webp"
run_test "Christmas no animation (disabled)" "pixlet render year_clock.star debug_date='2024-12-25T14:00:00Z' enable_special_dates=true enable_animations=false show_date=true" "11_animation_Christmas_Disabled.webp"
run_test "Valentine's no animation (disabled)" "pixlet render year_clock.star debug_date='2024-02-14T18:00:00Z' enable_special_dates=true enable_animations=false show_date=true" "11_animation_Valentine_Disabled.webp"

# Test that animations still work with different color scheme overrides
echo "  Testing animation with color scheme overrides..."
run_test "New Year's animation (red scheme override)" "pixlet render year_clock.star debug_date='2024-01-01T00:00:00Z' color_scheme=red enable_special_dates=true enable_animations=true show_date=true" "11_animation_NewYears_RedOverride.webp"

# Legacy tests - special dates disabled (for backwards compatibility)
run_test "New Year's no animation (special dates disabled)" "pixlet render year_clock.star debug_date='2024-01-01T00:00:00Z' enable_special_dates=false show_date=true" "11_animation_NewYears_Disabled.webp"
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