#!/bin/bash

echo "🌍 Testing Timezone-Based Date Format Detection"
echo "=============================================="

# Create output directory
mkdir -p temp_timezone

# Test different timezones and all date format options
test_timezones=(
    "America/New_York"
    "America/Los_Angeles" 
    "Europe/London"
    "Europe/Paris"
    "Asia/Tokyo"
    "Canada/Eastern"
    "Canada/Pacific"
)

date_formats=(
    "auto"
    "us_format" 
    "european_format"
    "iso_format"
)

echo "Testing all date format options with different timezones..."
echo ""

for format in "${date_formats[@]}"; do
    echo "🔸 Testing date_format=$format"
    
    for tz in "${test_timezones[@]}"; do
        echo -n "  $tz: "
        
        # Generate image with show_date=true and specific timezone/format
        pixlet render year_clock.star \
            show_date=true \
            date_format=$format \
            debug_date="2024-03-15T12:00:00Z" \
            --magnify 6 \
            --output "temp_timezone/test_${format}_${tz//\//_}.webp" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "✓"
        else
            echo "✗ Failed"
        fi
    done
    echo ""
done

echo "📋 Summary of generated test images:"
echo "=================================="
echo "auto format:"
echo "  - US timezones should show 'Mar 15' format"
echo "  - European timezones should show '15 Mar' format" 
echo "  - Asian timezones should show '03-15' format"
echo ""
echo "us_format: All should show 'Mar 15'"
echo "european_format: All should show '15 Mar'"
echo "iso_format: All should show '03-15'"
echo ""
echo "Test images saved in temp_timezone/ directory"
echo "Check the date formats in the bottom-left corner of each image" 