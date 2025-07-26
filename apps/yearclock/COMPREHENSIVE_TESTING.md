# Year Clock - Comprehensive Testing Documentation

This document provides the complete set of `pixlet render` commands to generate every test case and configuration variation for the Year Clock app. These commands are used in the test harness and can be run individually for debugging or demonstration purposes.

## Overview

- **Total Test Cases**: ~390+ unique configurations
- **Images Generated**: 6x magnification for gallery view
- **High-res Available**: 12x magnification for modal view (with `-H` flag)
- **Test Script**: `./test_harness.sh`

## Quick Start

```bash
# Generate all test images
./test_harness.sh -W

# Generate with high-res versions
./test_harness.sh -W -H

# Run full test suite with validation
./test_harness.sh
```

---

## 1. Color Schemes (7 variations)

Basic color scheme demonstrations with minimal parameters.

### Rainbow

**Description**: Classic rainbow gradient with seasonal colors  
**Command**: `pixlet render year_clock.star color_scheme=rainbow enable_special_dates=false`

### Thermal

**Description**: Temperature-accurate blue-to-red thermal mapping  
**Command**: `pixlet render year_clock.star color_scheme=thermal enable_special_dates=false`

### Grayscale

**Description**: Monochrome gradient from black to white  
**Command**: `pixlet render year_clock.star color_scheme=grayscale enable_special_dates=false`

### Red

**Description**: Warm red tones throughout the year  
**Command**: `pixlet render year_clock.star color_scheme=red enable_special_dates=false`

### Blue

**Description**: Cool blue tones throughout the year  
**Command**: `pixlet render year_clock.star color_scheme=blue enable_special_dates=false`

### Green

**Description**: Natural green tones throughout the year  
**Command**: `pixlet render year_clock.star color_scheme=green enable_special_dates=false`

### Purple

**Description**: Rich purple tones throughout the year  
**Command**: `pixlet render year_clock.star color_scheme=purple enable_special_dates=false`

---

## 2. Hemisphere Combinations (14 variations)

All color schemes tested in both hemispheres to verify seasonal positioning.

### Northern Hemisphere

```bash
pixlet render year_clock.star color_scheme=rainbow hemisphere=northern enable_special_dates=false
pixlet render year_clock.star color_scheme=thermal hemisphere=northern enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale hemisphere=northern enable_special_dates=false
pixlet render year_clock.star color_scheme=red hemisphere=northern enable_special_dates=false
pixlet render year_clock.star color_scheme=blue hemisphere=northern enable_special_dates=false
pixlet render year_clock.star color_scheme=green hemisphere=northern enable_special_dates=false
pixlet render year_clock.star color_scheme=purple hemisphere=northern enable_special_dates=false
```

### Southern Hemisphere

```bash
pixlet render year_clock.star color_scheme=rainbow hemisphere=southern enable_special_dates=false
pixlet render year_clock.star color_scheme=thermal hemisphere=southern enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale hemisphere=southern enable_special_dates=false
pixlet render year_clock.star color_scheme=red hemisphere=southern enable_special_dates=false
pixlet render year_clock.star color_scheme=blue hemisphere=southern enable_special_dates=false
pixlet render year_clock.star color_scheme=green hemisphere=southern enable_special_dates=false
pixlet render year_clock.star color_scheme=purple hemisphere=southern enable_special_dates=false
```

---

## 3. Date Display Tests (14 variations)

Testing date text readability across all color schemes and hemispheres.

### Northern Hemisphere with Date Display

```bash
pixlet render year_clock.star color_scheme=rainbow hemisphere=northern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=thermal hemisphere=northern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale hemisphere=northern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=red hemisphere=northern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=blue hemisphere=northern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=green hemisphere=northern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=purple hemisphere=northern show_date=true enable_special_dates=false
```

### Southern Hemisphere with Date Display

```bash
pixlet render year_clock.star color_scheme=rainbow hemisphere=southern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=thermal hemisphere=southern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale hemisphere=southern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=red hemisphere=southern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=blue hemisphere=southern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=green hemisphere=southern show_date=true enable_special_dates=false
pixlet render year_clock.star color_scheme=purple hemisphere=southern show_date=true enable_special_dates=false
```

---

## 4. Calendar Systems (19 tests)

Testing alternative calendar systems with hybrid date display and year progress calculation.

### Calendar System Overview (6 systems)

```bash
# Gregorian (Standard)
pixlet render year_clock.star calendar_system='Gregorian' color_scheme=rainbow show_date=true enable_special_dates=false

# Persian/Jalali
pixlet render year_clock.star calendar_system='Persian' color_scheme=rainbow show_date=true enable_special_dates=false

# Islamic/Hijri
pixlet render year_clock.star calendar_system='Islamic' color_scheme=rainbow show_date=true enable_special_dates=false

# Thai Buddhist
pixlet render year_clock.star calendar_system='ThaiBuddhist' color_scheme=rainbow show_date=true enable_special_dates=false

# Ethiopian
pixlet render year_clock.star calendar_system='Ethiopian' color_scheme=rainbow show_date=true enable_special_dates=false

# Coptic
pixlet render year_clock.star calendar_system='Coptic' color_scheme=rainbow show_date=true enable_special_dates=false
```

### Year Progress Comparison (9 tests)

Testing how different calendars track year progress at key dates.

```bash
# New Year (Jan 1) across different calendars
pixlet render year_clock.star calendar_system='Gregorian' debug_date='2024-01-01T12:00:00Z' show_date=true enable_special_dates=false
pixlet render year_clock.star calendar_system='Persian' debug_date='2024-01-01T12:00:00Z' show_date=true enable_special_dates=false
pixlet render year_clock.star calendar_system='Islamic' debug_date='2024-01-01T12:00:00Z' show_date=true enable_special_dates=false

# Mid-Year (Jun 21) across different calendars
pixlet render year_clock.star calendar_system='Gregorian' debug_date='2024-06-21T12:00:00Z' show_date=true enable_special_dates=false
pixlet render year_clock.star calendar_system='Persian' debug_date='2024-06-21T12:00:00Z' show_date=true enable_special_dates=false
pixlet render year_clock.star calendar_system='Islamic' debug_date='2024-06-21T12:00:00Z' show_date=true enable_special_dates=false

# Year End (Dec 21) across different calendars
pixlet render year_clock.star calendar_system='Gregorian' debug_date='2024-12-21T12:00:00Z' show_date=true enable_special_dates=false
pixlet render year_clock.star calendar_system='Persian' debug_date='2024-12-21T12:00:00Z' show_date=true enable_special_dates=false
pixlet render year_clock.star calendar_system='Islamic' debug_date='2024-12-21T12:00:00Z' show_date=true enable_special_dates=false
```

### Thermal Peak Positioning (4 tests)

Same August 25th date, different thermal peak positions based on calendar year starts.

```bash
# Gregorian (65% - late August in Gregorian year)
pixlet render year_clock.star calendar_system='Gregorian' color_scheme=thermal debug_date='2024-08-25T12:00:00Z' show_date=true enable_special_dates=false

# Persian (38% - August is 38% through Persian year starting at spring equinox)
pixlet render year_clock.star calendar_system='Persian' color_scheme=thermal debug_date='2024-08-25T12:00:00Z' show_date=true enable_special_dates=false

# Ethiopian (90% - August comes before Ethiopian new year in September)
pixlet render year_clock.star calendar_system='Ethiopian' color_scheme=thermal debug_date='2024-08-25T12:00:00Z' show_date=true enable_special_dates=false

# Islamic (50% - lunar calendar, thermal peak concept doesn't apply)
pixlet render year_clock.star calendar_system='Islamic' color_scheme=thermal debug_date='2024-08-25T12:00:00Z' show_date=true enable_special_dates=false
```

---

## 5. Date Overlap Analysis (9 tests)

Testing potential dial marker and date text conflicts in February.

### February 1st Overlap Tests

```bash
pixlet render year_clock.star color_scheme=rainbow show_date=true debug_date='2024-02-01T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale show_date=true debug_date='2024-02-01T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=red show_date=true debug_date='2024-02-01T12:00:00Z' enable_special_dates=false
```

### Valentine's Day Overlap Tests

```bash
pixlet render year_clock.star color_scheme=rainbow show_date=true debug_date='2024-02-14T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale show_date=true debug_date='2024-02-14T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=red show_date=true debug_date='2024-02-14T12:00:00Z' enable_special_dates=false
```

### Leap Day Overlap Tests

```bash
pixlet render year_clock.star color_scheme=rainbow show_date=true debug_date='2024-02-29T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale show_date=true debug_date='2024-02-29T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=red show_date=true debug_date='2024-02-29T12:00:00Z' enable_special_dates=false
```

---

## 6. Seasonal Positioning (10 tests)

Verifying dial marker accuracy at key seasonal dates.

### Rainbow Scheme Seasonal Tests

```bash
pixlet render year_clock.star color_scheme=rainbow debug_date='2024-01-01T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=rainbow debug_date='2024-03-20T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=rainbow debug_date='2024-06-21T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=rainbow debug_date='2024-09-22T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=rainbow debug_date='2024-12-21T12:00:00Z' enable_special_dates=false
```

### Grayscale Scheme Seasonal Tests

```bash
pixlet render year_clock.star color_scheme=grayscale debug_date='2024-01-01T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale debug_date='2024-03-20T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale debug_date='2024-06-21T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale debug_date='2024-09-22T12:00:00Z' enable_special_dates=false
pixlet render year_clock.star color_scheme=grayscale debug_date='2024-12-21T12:00:00Z' enable_special_dates=false
```

---

## 7. Edge Cases & Special Scenarios (3 tests)

```bash
# December 31st - Northern hemisphere year boundary positioning
pixlet render year_clock.star debug_date='2024-12-31T18:00:00Z' hemisphere=northern enable_special_dates=false

# January 1st - Southern hemisphere year start in opposite season
pixlet render year_clock.star debug_date='2024-01-01T12:00:00Z' hemisphere=southern enable_special_dates=false

# Leap Day - February 29th special case
pixlet render year_clock.star debug_date='2024-02-29T12:00:00Z' color_scheme=blue enable_special_dates=false
```

---

## 8. Special Date Easter Eggs (5 tests)

Holiday and special occasion themes that automatically override color schemes.

```bash
# Valentine's Day - Override to red spectrum (global)
pixlet render year_clock.star debug_date='2024-02-14T12:00:00Z' enable_special_dates=true show_date=true

# Pride Month - Rainbow with user's hemisphere setting (global)
pixlet render year_clock.star debug_date='2024-06-15T12:00:00Z' enable_special_dates=true show_date=true

# Christmas - Custom red/green gradient (global)
pixlet render year_clock.star debug_date='2024-12-25T12:00:00Z' enable_special_dates=true show_date=true

# New Year's Day - Custom gold/silver gradient (global)
pixlet render year_clock.star debug_date='2024-01-01T12:00:00Z' enable_special_dates=true show_date=true

# Special Dates Disabled - Christmas with themes turned off
pixlet render year_clock.star enable_special_dates=false color_scheme=blue hemisphere=southern show_date=true debug_date='2024-12-25T12:00:00Z'
```

---

## 9. Astronomical Events (4 tests)

Solstice and equinox themes that celebrate the changing seasons.

```bash
# Spring Equinox - Fresh spring colors (pale blues, soft greens, yellows)
pixlet render year_clock.star debug_date='2024-03-20T12:00:00Z' enable_special_dates=true show_date=true

# Summer Solstice - Bright solar colors (golds, yellows, oranges)
pixlet render year_clock.star debug_date='2024-06-21T12:00:00Z' enable_special_dates=true show_date=true

# Fall Equinox - Rich autumn colors (browns, oranges, reds)
pixlet render year_clock.star debug_date='2024-09-22T12:00:00Z' enable_special_dates=true show_date=true

# Winter Solstice - Deep winter colors (blues, purples, whites)
pixlet render year_clock.star debug_date='2024-12-21T12:00:00Z' enable_special_dates=true show_date=true
```

---

## 10. Regional Holidays with Timezone Filtering (24 tests)

Smart timezone filtering shows culturally relevant holidays based on location.

### Regional Holidays (Enabled in Correct Timezone)

```bash
# Independence Day (US timezones)
pixlet render year_clock.star debug_date='2024-07-04T12:00:00Z' enable_special_dates=true show_date=true '$tz=America/New_York'

# Bastille Day (French timezones)
pixlet render year_clock.star debug_date='2024-07-14T12:00:00Z' enable_special_dates=true show_date=true '$tz=Europe/Paris'

# Boxing Day (Europe/Commonwealth)
pixlet render year_clock.star debug_date='2024-12-26T12:00:00Z' enable_special_dates=true show_date=true '$tz=Europe/London'

# May Day (Europe, not US)
pixlet render year_clock.star debug_date='2024-05-01T12:00:00Z' enable_special_dates=true show_date=true '$tz=Europe/Paris'

# Día de los Muertos (Latin America)
pixlet render year_clock.star debug_date='2024-11-01T12:00:00Z' enable_special_dates=true show_date=true '$tz=America/Mexico_City'

# Halloween (US/Canada/Ireland/UK only)
pixlet render year_clock.star debug_date='2024-10-31T12:00:00Z' enable_special_dates=true show_date=true '$tz=America/New_York'

# St. Patrick's Day (Irish diaspora regions only)
pixlet render year_clock.star debug_date='2024-03-17T12:00:00Z' enable_special_dates=true show_date=true '$tz=Europe/Dublin'

# Passover (US/Canada/Western regions)
pixlet render year_clock.star debug_date='2024-04-23T12:00:00Z' enable_special_dates=true show_date=true '$tz=America/New_York'

# Hanukkah (US/Canada/Western regions)
pixlet render year_clock.star debug_date='2024-12-27T12:00:00Z' enable_special_dates=true show_date=true '$tz=America/New_York'

# Persian Nowruz (Iran/Afghanistan/Central Asia)
pixlet render year_clock.star debug_date='2024-03-20T12:00:00Z' enable_special_dates=true show_date=true '$tz=Asia/Tehran'

# Persian Nowruz Day 2
pixlet render year_clock.star debug_date='2024-03-21T12:00:00Z' enable_special_dates=true show_date=true '$tz=Asia/Tehran'

# Thai Songkran Day 1 (Thailand/Southeast Asia water festivals)
pixlet render year_clock.star debug_date='2024-04-13T12:00:00Z' enable_special_dates=true show_date=true '$tz=Asia/Bangkok'

# Thai Songkran Day 2
pixlet render year_clock.star debug_date='2024-04-14T12:00:00Z' enable_special_dates=true show_date=true '$tz=Asia/Bangkok'

# Thai Songkran Day 3
pixlet render year_clock.star debug_date='2024-04-15T12:00:00Z' enable_special_dates=true show_date=true '$tz=Asia/Bangkok'
```

### Regional Holidays (Filtered in Wrong Timezone)

```bash
# Independence Day filtered (shows default colors)
pixlet render year_clock.star debug_date='2024-07-04T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=Europe/London'

# Bastille Day filtered
pixlet render year_clock.star debug_date='2024-07-14T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'

# Boxing Day filtered
pixlet render year_clock.star debug_date='2024-12-26T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'

# May Day filtered
pixlet render year_clock.star debug_date='2024-05-01T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'

# Día de los Muertos filtered
pixlet render year_clock.star debug_date='2024-11-01T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'

# Halloween filtered
pixlet render year_clock.star debug_date='2024-10-31T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=Europe/Paris'

# St. Patrick's Day filtered
pixlet render year_clock.star debug_date='2024-03-17T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=Europe/Paris'

# Passover filtered
pixlet render year_clock.star debug_date='2024-04-23T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=Asia/Tokyo'

# Hanukkah filtered
pixlet render year_clock.star debug_date='2024-12-27T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/Mexico_City'

# Persian Nowruz filtered (shows spring equinox theme instead)
pixlet render year_clock.star debug_date='2024-03-20T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'

# Persian Nowruz Day 2 filtered
pixlet render year_clock.star debug_date='2024-03-21T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'

# Thai Songkran Day 1 filtered (shows default rainbow)
pixlet render year_clock.star debug_date='2024-04-13T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'

# Thai Songkran Day 2 filtered
pixlet render year_clock.star debug_date='2024-04-14T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'

# Thai Songkran Day 3 filtered
pixlet render year_clock.star debug_date='2024-04-15T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'
```

---

## 11. Variable Date Regional Holidays (6 tests)

Smart calculation of holidays with changing dates each year, filtered by timezone.

### Variable Holidays (Enabled in Correct Timezone)

```bash
# Thanksgiving (4th Thu Nov - US timezones)
pixlet render year_clock.star debug_date='2024-11-28T12:00:00Z' enable_special_dates=true show_date=true '$tz=America/New_York'

# Black Friday (Day after Thanksgiving - US timezones)
pixlet render year_clock.star debug_date='2024-11-29T12:00:00Z' enable_special_dates=true show_date=true '$tz=America/New_York'

# Golden Week (Apr 29-May 5 - Japan timezones)
pixlet render year_clock.star debug_date='2024-05-01T12:00:00Z' enable_special_dates=true show_date=true '$tz=Asia/Tokyo'
```

### Variable Holidays (Filtered in Wrong Timezone)

```bash
# Thanksgiving filtered
pixlet render year_clock.star debug_date='2024-11-28T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=Europe/London'

# Black Friday filtered
pixlet render year_clock.star debug_date='2024-11-29T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=Europe/London'

# Golden Week filtered
pixlet render year_clock.star debug_date='2024-05-01T12:00:00Z' enable_special_dates=true show_date=true color_scheme=rainbow '$tz=America/New_York'
```

---

## 12. Holiday Animations (12 tests)

🎊 New Year's sparkles | 🎃 Halloween flicker | ❄️ Christmas snow | 💖 Valentine's hearts

### New Year's Sparkle Animation

```bash
# New Year's Eve - Party time! Sparkle animation over gold/silver gradient
pixlet render year_clock.star debug_date='2024-12-31T23:30:00Z' enable_special_dates=true enable_animations=true show_date=true

# New Year's Midnight - Chill recovery mode with gold/silver (no animation)
pixlet render year_clock.star debug_date='2024-01-01T00:30:00Z' enable_special_dates=true enable_animations=true show_date=true

# New Year's Day - Calm gold/silver theme for recovery day
pixlet render year_clock.star debug_date='2024-01-01T12:00:00Z' enable_special_dates=true enable_animations=true show_date=true
```

### Halloween Flicker Animation

```bash
# Halloween Flicker - Spooky orange/black flickering animation (US/Canada/Ireland/UK only)
pixlet render year_clock.star debug_date='2024-10-31T20:00:00Z' enable_special_dates=true enable_animations=true show_date=true '$tz=America/New_York'
```

### Christmas Snow Animation

```bash
# Christmas Snow - Peaceful falling snow animation over Christmas gradient
pixlet render year_clock.star debug_date='2024-12-25T14:00:00Z' enable_special_dates=true enable_animations=true show_date=true
```

### Valentine's Hearts Animation

```bash
# Valentine's Hearts - Gentle pulsing heart animation over red spectrum
pixlet render year_clock.star debug_date='2024-02-14T18:00:00Z' enable_special_dates=true enable_animations=true show_date=true
```

### Animation Controls

```bash
# Halloween no animation (disabled) - Keeps orange/black colors but no flicker
pixlet render year_clock.star debug_date='2024-10-31T20:00:00Z' enable_special_dates=true enable_animations=false show_date=true '$tz=America/New_York'

# Christmas no animation (disabled) - Keeps red/green colors but no snow
pixlet render year_clock.star debug_date='2024-12-25T14:00:00Z' enable_special_dates=true enable_animations=false show_date=true

# Valentine's no animation (disabled) - Keeps red spectrum colors but no hearts
pixlet render year_clock.star debug_date='2024-02-14T18:00:00Z' enable_special_dates=true enable_animations=false show_date=true

# New Year's animation (red scheme override) - Animation overrides color scheme setting
pixlet render year_clock.star debug_date='2024-01-01T00:00:00Z' color_scheme=red enable_special_dates=true enable_animations=true show_date=true

# New Year's no animation (special dates disabled) - No animation or special colors
pixlet render year_clock.star debug_date='2024-01-01T00:00:00Z' enable_special_dates=false show_date=true
```

### Animation Technical Details

**Four Unique Holiday Animations:**

- **✨ New Year's**: 8-frame sparkle animation (Dec 31 only) - 50ms frame timing
- **🎃 Halloween**: 6-frame flicker animation with timezone filtering - 120ms frame timing
- **❄️ Christmas**: 8-frame falling snow animation (global) - 100ms frame timing
- **💖 Valentine's**: 6-frame pulsing heart animation (global) - 150ms frame timing

**User Controls:**

- `enable_animations=true/false` - Toggle animations while keeping special date colors
- `enable_special_dates=true/false` - Toggle special date themes entirely
- Separate control allows users to keep holiday colors but disable animations for battery saving

---

## 13. Comprehensive Parameter Tests (3 tests)

```bash
# All Options Enabled - Maximum feature combination test
pixlet render year_clock.star color_scheme=purple hemisphere=southern show_date=true debug_date='2024-07-04T12:00:00Z' enable_special_dates=false

# Minimal Configuration - Basic setup with minimal options
pixlet render year_clock.star enable_special_dates=false

# Maximum Contrast - Extreme contrast scenario testing
pixlet render year_clock.star color_scheme=grayscale show_date=true enable_special_dates=false
```

---

## 14. Accent Dot Variations (30 tests)

Configurable accent dots that adapt to color schemes for optimal contrast and aesthetics.

### Adaptive Style Showcase

Dots automatically choose complementary colors based on the color scheme.

```bash
# Rainbow + Adaptive - Magenta dots (good contrast across rainbow spectrum)
pixlet render year_clock.star color_scheme=rainbow accent_dot_style=adaptive debug_date='2024-07-01T12:00:00Z' enable_special_dates=false

# Grayscale + Adaptive - Yellow dots (high contrast on gray backgrounds)
pixlet render year_clock.star color_scheme=grayscale accent_dot_style=adaptive debug_date='2024-07-01T12:00:00Z' enable_special_dates=false

# Red + Adaptive - Cyan dots (complementary to red spectrum)
pixlet render year_clock.star color_scheme=red accent_dot_style=adaptive debug_date='2024-07-01T12:00:00Z' enable_special_dates=false

# Purple + Adaptive - Green dots (complementary to purple spectrum)
pixlet render year_clock.star color_scheme=purple accent_dot_style=adaptive debug_date='2024-07-01T12:00:00Z' enable_special_dates=false
```

### Adaptive vs Contrast Comparison

```bash
# Purple + Adaptive - Green dots (complementary color approach)
pixlet render year_clock.star color_scheme=purple accent_dot_style=adaptive debug_date='2024-07-01T12:00:00Z' enable_special_dates=false

# Purple + Contrast - Indigo dots (darker contrast approach)
pixlet render year_clock.star color_scheme=purple accent_dot_style=contrast debug_date='2024-07-01T12:00:00Z' enable_special_dates=false
```

### Fixed Color Options

Consistent colors that never change regardless of background.

```bash
# Fixed Magenta - Original default
pixlet render year_clock.star color_scheme=rainbow accent_dot_style=fixed_magenta debug_date='2024-07-01T12:00:00Z' enable_special_dates=false

# Fixed Cyan - High contrast alternative
pixlet render year_clock.star color_scheme=rainbow accent_dot_style=fixed_cyan debug_date='2024-07-01T12:00:00Z' enable_special_dates=false

# Fixed White - Classic minimal
pixlet render year_clock.star color_scheme=rainbow accent_dot_style=fixed_white debug_date='2024-07-01T12:00:00Z' enable_special_dates=false

# Fixed Yellow - Maximum visibility
pixlet render year_clock.star color_scheme=rainbow accent_dot_style=fixed_yellow debug_date='2024-07-01T12:00:00Z' enable_special_dates=false
```

### Minimal Option

```bash
# No Accent Dots - Clean aesthetic without accent dots
pixlet render year_clock.star color_scheme=rainbow accent_dot_style=none debug_date='2024-07-01T12:00:00Z' enable_special_dates=false
```

---

## 15. Timezone-Based Date Format Detection (35 tests)

Automatic date format detection based on user timezone with manual override options.

### Auto-Detection Examples

**Note**: These examples show expected behavior, but actual auto-detection depends on your system's timezone setting.

```bash
# US Timezones (should auto-detect to "Mar 15" format)
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/New_York'
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Los_Angeles'

# European Timezones (should auto-detect to "15 Mar" format)
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=Europe/London'
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=Europe/Paris'

# Asian Timezones (should auto-detect to "03-15" format)
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=Asia/Tokyo'

# Canadian Timezones (mixed behavior)
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=Canada/Eastern'    # US format
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=Canada/Pacific'   # European format
```

### Format Comparison (Manual Override)

Same timezone with different manual format overrides.

```bash
# Auto-detect based on system timezone
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z'

# US Format (Mar 15)
pixlet render year_clock.star show_date=true date_format=us_format debug_date='2024-03-15T12:00:00Z'

# European Format (15 Mar)
pixlet render year_clock.star show_date=true date_format=european_format debug_date='2024-03-15T12:00:00Z'

# ISO Format (03-15)
pixlet render year_clock.star show_date=true date_format=iso_format debug_date='2024-03-15T12:00:00Z'
```

### Manual Override Verification

Users can override auto-detection if desired.

```bash
# US Auto-Detection
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/New_York'

# European Auto-Detection
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=Europe/London'

# Asian Auto-Detection
pixlet render year_clock.star show_date=true date_format=auto debug_date='2024-03-15T12:00:00Z' '$tz=Asia/Tokyo'
```

---

## 16. Multi-Language Support (90 tests)

Intelligent timezone-based language detection with 7-language support.

### Timezone-Based Auto-Detection Examples

**Note**: Auto-detection varies based on timezone. These examples show expected behavior for specific timezones.

```bash
# English (US)
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/New_York'

# Spanish (Spain)
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Europe/Madrid'

# French (France)
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Europe/Paris'

# German (Germany)
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Europe/Berlin'

# Portuguese (Brazil)
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Sao_Paulo'

# Italian (Italy)
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Europe/Rome'

# Russian (Russia)
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Europe/Moscow'
```

### Manual Language Override

Same date in different languages showing localized month names.

```bash
# December 15th in all supported languages
pixlet render year_clock.star show_date=true language=en debug_date='2024-12-15T12:00:00Z'  # English: "Dec 15"
pixlet render year_clock.star show_date=true language=es debug_date='2024-12-15T12:00:00Z'  # Spanish: "Dic 15"
pixlet render year_clock.star show_date=true language=fr debug_date='2024-12-15T12:00:00Z'  # French: "Déc 15"
pixlet render year_clock.star show_date=true language=de debug_date='2024-12-15T12:00:00Z'  # German: "Dez 15"
pixlet render year_clock.star show_date=true language=pt debug_date='2024-12-15T12:00:00Z'  # Portuguese: "Dez 15"
pixlet render year_clock.star show_date=true language=it debug_date='2024-12-15T12:00:00Z'  # Italian: "Dic 15"
pixlet render year_clock.star show_date=true language=ru debug_date='2024-12-15T12:00:00Z'  # Russian: "Дек 15"
```

### Language + Format Combinations

Different languages with different date formats.

```bash
# Spanish with US Format (Ago 15)
pixlet render year_clock.star show_date=true language=es date_format=us_format debug_date='2024-08-15T12:00:00Z' enable_special_dates=false

# French with European Format (15 Aoû)
pixlet render year_clock.star show_date=true language=fr date_format=european_format debug_date='2024-08-15T12:00:00Z' enable_special_dates=false

# German with European Format (15 Aug)
pixlet render year_clock.star show_date=true language=de date_format=european_format debug_date='2024-08-15T12:00:00Z' enable_special_dates=false

# Portuguese with US Format (Ago 15)
pixlet render year_clock.star show_date=true language=pt date_format=us_format debug_date='2024-08-15T12:00:00Z' enable_special_dates=false

# Italian with European Format (15 Ago)
pixlet render year_clock.star show_date=true language=it date_format=european_format debug_date='2024-08-15T12:00:00Z' enable_special_dates=false

# Russian with European Format (15 Авг)
pixlet render year_clock.star show_date=true language=ru date_format=european_format debug_date='2024-08-15T12:00:00Z' enable_special_dates=false

# English with ISO Format (08-15)
pixlet render year_clock.star show_date=true language=en date_format=iso_format debug_date='2024-08-15T12:00:00Z' enable_special_dates=false
```

### Special Dates with Languages

Holiday themes work with all languages.

```bash
# Spanish Christmas (Dic 25)
pixlet render year_clock.star show_date=true language=es debug_date='2024-12-25T12:00:00Z' enable_special_dates=true

# French Bastille Day (Jul 14) - requires French timezone
pixlet render year_clock.star show_date=true language=fr debug_date='2024-07-14T12:00:00Z' enable_special_dates=true '$tz=Europe/Paris'

# German Halloween (Okt 31)
pixlet render year_clock.star show_date=true language=de debug_date='2024-10-31T12:00:00Z' enable_special_dates=true

# Russian New Year's Day (Янв 1)
pixlet render year_clock.star show_date=true language=ru debug_date='2024-01-01T12:00:00Z' enable_special_dates=true
```

---

## Extended Language Coverage

### Francophone Africa Timezones

```bash
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Ouagadougou'  # Burkina Faso
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Bamako'       # Mali
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Dakar'        # Senegal
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Conakry'      # Guinea
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Abidjan'      # Ivory Coast
```

### Lusophone Coverage

```bash
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Luanda'       # Angola
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Maputo'       # Mozambique
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Bissau'       # Guinea-Bissau
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=Africa/Sao_Tome'     # São Tomé
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Fortaleza'   # Brazil Northeast
```

### Hispanic America Expansion

```bash
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Guatemala'      # Guatemala
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/El_Salvador'   # El Salvador
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Tegucigalpa'   # Honduras
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Managua'       # Nicaragua
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Costa_Rica'    # Costa Rica
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Caracas'       # Venezuela
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Montevideo'    # Uruguay
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Havana'        # Cuba
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Santo_Domingo' # Dominican Republic
pixlet render year_clock.star show_date=true language=auto debug_date='2024-03-15T12:00:00Z' '$tz=America/Panama'        # Panama
```

---

## Command Generation Notes

### Timezone Parameter Usage

- For auto-detection tests, timezone parameter is crucial: `'$tz=<timezone>'`
- Without explicit timezone, auto-detection uses your system's timezone
- Regional holidays require specific timezones to trigger special themes
- Use single quotes around the `$tz` parameter to prevent shell expansion

### Debug Date Format

- All debug dates use ISO 8601 format with UTC timezone: `'YYYY-MM-DDTHH:MM:SSZ'`
- Times are chosen to avoid timezone conversion edge cases
- Dates represent the intended calendar day in most global timezones

### High-Resolution Generation

- Add `--magnify 6` for gallery images (384×192 pixels)
- Add `--magnify 12` for high-resolution modal images (768×384 pixels)
- Output images to `temp/` directory: `--output temp/filename.webp`

### Special Considerations

- `enable_special_dates=false` disables all holiday themes for pure testing
- Some holiday combinations require both date and timezone alignment
- Language auto-detection depends on system locale when timezone is not specified
- Calendar systems may produce different date text in same language

---

## Quick Reference Commands

### Generate All Test Images

```bash
# Fast generation (gallery only)
./test_harness.sh -W

# With high-res modal versions
./test_harness.sh -W -H

# Full test suite with validation
./test_harness.sh
```

### Individual Testing Examples

```bash
# Basic rainbow clock
pixlet render year_clock.star

# Test date display
pixlet render year_clock.star show_date=true

# Test special date (Christmas)
pixlet render year_clock.star debug_date='2024-12-25T12:00:00Z' enable_special_dates=true

# Test with high magnification
pixlet render year_clock.star --magnify 12

# Test specific timezone behavior
pixlet render year_clock.star '$tz=Europe/Paris' debug_date='2024-07-14T12:00:00Z' enable_special_dates=true
```

This comprehensive documentation covers all ~370 test cases with their exact commands for reproduction and debugging.
