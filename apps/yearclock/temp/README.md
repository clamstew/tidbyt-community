# Year Clock Test Images

This directory contains automatically generated test images from the Year Clock app test harness. Gallery images are rendered at **6x magnification (384×192 pixels)** for fast loading, with optional **12x magnification (768×384 pixels)** high-resolution versions for click-to-zoom modals.

## 🚀 Generating Images

Run the test harness from the parent directory to regenerate all images:

### Quick Image Generation (Recommended)

```bash
../test_harness.sh -W
# or
../test_harness.sh --write-only
```

**Benefits**: Fast execution, skips code validation checks, focuses only on gallery images (325+ tests).

### High-Resolution Gallery + Modal Images

```bash
../test_harness.sh -W -H
# or
../test_harness.sh --write-only --high-res
```

**Benefits**: Generates both gallery (6x) and modal (12x) versions for click-to-zoom functionality (650+ images total).

### Full Test Suite

```bash
../test_harness.sh
```

**Benefits**: Complete validation including code quality checks, slower but comprehensive (325+ tests).

### Help

```bash
../test_harness.sh --help
```

**Note**: Use `-W` flag when iterating on visual changes to avoid lint/format failures that don't affect image output.

### 🔍 High Resolution Images

The test harness supports two image quality modes:

**Gallery Mode (Default)**:

- **Gallery Images**: 384×192 pixels (6x magnification) - fast loading for showcase browsing
- **File naming**: Standard filenames (e.g., `01_colorscheme_rainbow.webp`)

**High-Resolution Mode (`-H` flag)**:

- **Gallery Images**: 384×192 pixels (6x magnification) - for fast showcase browsing
- **Modal Images**: 768×384 pixels (12x magnification) - for click-to-zoom detail viewing
- **File naming**: High-res versions include `_hires` suffix (e.g., `01_colorscheme_rainbow_hires.webp`)

**Image Quality Comparison**:

- **Default Tidbyt**: 64×32 pixels (tiny, pixelated on screens)
- **Gallery Images**: 384×192 pixels (6x magnified, crisp for galleries)
- **Modal Images**: 768×384 pixels (12x magnified, crystal clear for detailed inspection)

### 🖱️ Interactive Showcase Features

When high-resolution mode is enabled (`-H` flag), the `showcase.html` page includes:

- **Click-to-Zoom**: Click any image to open a high-resolution modal view
- **Smart Loading**: Gallery loads fast with 6x images, modal shows crystal-clear 12x versions on demand
- **Graceful Fallback**: If high-res image doesn't exist, modal shows the gallery version
- **Easy Navigation**: Close modal with X button, ESC key, or clicking outside the image

## File Naming Convention

Images are organized by test category with descriptive filenames:

### 🎨 01*colorscheme*\*.webp (7 files)

Basic color scheme tests - shows each color palette with default settings:

- `01_colorscheme_rainbow.webp` - Default rainbow gradient (aesthetic focus)
- `01_colorscheme_thermal.webp` - Thermal rainbow gradient (temperature logic: blue=cold, red=hot)
- `01_colorscheme_grayscale.webp` - Black to white gradient
- `01_colorscheme_red.webp` - Dark red to light red gradient
- `01_colorscheme_blue.webp` - Navy to sky blue gradient
- `01_colorscheme_green.webp` - Forest green to lime gradient
- `01_colorscheme_purple.webp` - Deep purple to lavender gradient

### 🌍 02*hemisphere*\*.webp (14 files)

Color scheme + hemisphere combinations - shows seasonal positioning:

- Format: `02_hemisphere_{colorscheme}_{hemisphere}.webp`
- Tests all 7 color schemes × 2 hemispheres (14 combinations)
- Southern hemisphere shifts colors by 6 months (seasonal inversion)
- Includes thermal scheme showing temperature-based seasonal positioning

### 📅 03*date*\*.webp (14 files)

Date display tests - shows text contrast with different backgrounds:

- Format: `03_date_{colorscheme}_{hemisphere}.webp`
- Tests all combinations with `show_date=true`
- Validates text color selection for optimal contrast

### 📅 03*overlap*\*.webp (9 files)

Date display overlap tests - shows dial marker positioned behind date text:

- Format: `03_overlap_{colorscheme}_{date}.webp`
- Tests February dates when dial marker could overlap with date display
- Includes Feb 1, Valentine's Day (Feb 14), and Leap Day (Feb 29)
- Tests with Rainbow, Grayscale, and Red color schemes

### 🗓️ 04*seasonal*\*.webp (10 files)

Seasonal position tests - shows dial marker at key dates:

- Format: `04_seasonal_{colorscheme}_{season}.webp`
- Tests Rainbow and Grayscale at 5 key dates:
  - `NewYear` (Jan 1) - Year start position
  - `SpringEquinox` (Mar 20) - 25% through year
  - `SummerSolstice` (Jun 21) - 50% through year
  - `FallEquinox` (Sep 22) - 75% through year
  - `WinterSolstice` (Dec 21) - Near year end

### 📅 04*calendar*\*.webp (19 files)

Calendar system tests - validates alternative calendar support:

- Format: `04_calendar_{system}_rainbow.webp` (6 files)
  - Tests each calendar system with rainbow color scheme
  - Systems: Gregorian, Persian, Islamic, ThaiButdhist, Ethiopian, Coptic
- Format: `04_calendar_{system}_{date}.webp` (9 files)
  - Tests Gregorian, Persian, and Islamic calendars at 3 key dates:
    - `NewYear` (Jan 1) - Different year starts for each calendar
    - `MidYear` (Jun 21) - Shows year progress differences
    - `YearEnd` (Dec 21) - Year boundary variations
  - Shows hybrid date display (Gregorian + alternative calendar)
  - Demonstrates how dial position changes based on calendar year boundaries
- Format: `04_calendar_thermal_{system}_Aug25.webp` (4 files)
  - Tests thermal peak positioning across different calendar systems
  - All use same August 25th date but different thermal peak positions
  - Gregorian: Peak at 65%, Persian: Peak at 38%, Ethiopian: Peak at 90%, Islamic: Peak at 50%
  - Demonstrates calendar-aware seasonal alignment for thermal color scheme

### ⚠️ 05*edge*\*.webp (3 files)

Edge case tests - validates boundary conditions:

- `05_edge_Dec31_northern.webp` - Year end (Northern hemisphere)
- `05_edge_Jan1_southern.webp` - Year start (Southern hemisphere)
- `05_edge_LeapDay_blue.webp` - Feb 29 leap day (Blue scheme)

### 🎉 06*special*\*.webp (7 files)

Special Date Easter Eggs tests - validates holiday overrides:

- `06_special_ValentinesDay.webp` - Feb 14: Override to red spectrum
- `06_special_StPatricksDay.webp` - Mar 17: Override to green spectrum
- `06_special_PrideMonth.webp` - June: Rainbow regardless of hemisphere
- `06_special_Halloween.webp` - Oct 31: Custom orange/brown gradient
- `06_special_Christmas.webp` - Dec 25: Custom red/green gradient
- `06_special_NewYearsDay.webp` - Jan 1: Custom gold/silver gradient
- `06_special_disabled.webp` - Christmas with special dates disabled (blue southern)

### 🌌 06*astronomical*\*.webp (4 files)

Astronomical Event tests - validates solstice and equinox special themes:

- `06_astronomical_SpringEquinox.webp` - Mar 20: Fresh spring colors (pale blues, soft greens, yellows)
- `06_astronomical_SummerSolstice.webp` - Jun 21: Bright solar colors (golds, yellows, oranges)
- `06_astronomical_FallEquinox.webp` - Sep 22: Rich autumn colors (browns, oranges, reds)
- `06_astronomical_WinterSolstice.webp` - Dec 21: Deep winter colors (blues, purples, whites)

### ✨ 11*animation*\*.webp (11 files)

Holiday Animation tests - validates animated special date themes:

**New Year's Sparkle Animation (3 files)**:

- `11_animation_NewYearsEve.webp` - Dec 31: Party sparkle animation over gold/silver gradient
- `11_animation_NewYearsMidnight.webp` - Jan 1 midnight: Chill recovery mode (no animation)
- `11_animation_NewYearsDay.webp` - Jan 1 day: Calm gold/silver theme

**Individual Holiday Animations (3 files)**:

- `11_animation_Halloween.webp` - Oct 31: Spooky orange/black flicker animation (timezone-filtered)
- `11_animation_Christmas.webp` - Dec 25: Peaceful falling snow animation over Christmas gradient
- `11_animation_Valentine.webp` - Feb 14: Gentle pulsing heart animation over red spectrum

**Animation Controls (5 files)**:

- `11_animation_Halloween_Disabled.webp` - Halloween with animations disabled (keeps colors)
- `11_animation_Christmas_Disabled.webp` - Christmas with animations disabled (keeps colors)
- `11_animation_NewYears_RedOverride.webp` - New Year's animation overrides color scheme setting
- `11_animation_NewYears_Disabled.webp` - Special dates disabled (no animation or special colors)

**Animation Features:**

- **Four Unique Animations**: New Year's sparkles, Halloween flicker, Christmas snow, Valentine's hearts
- **User Control**: `enable_animations` toggle allows disabling animations while keeping special date colors
- **Performance Optimized**: Frame timing optimized for each animation type (50ms-150ms delays)
- **Smart Integration**: All animations work seamlessly with existing features

### 🔧 07*comprehensive*\*.webp (3 files)

Complex configuration tests:

- `07_comprehensive_all_options.webp` - All features enabled (Purple + Southern + Date + July 4th)
- `07_comprehensive_minimal.webp` - Default settings only
- `07_comprehensive_contrast.webp` - Maximum contrast scenario (Grayscale + Date)

### 🎨 08*accent*\*.webp (30 files)

Accent dot variation tests - shows configurable accent dot styles:

- Format: `08_accent_{style}_{colorscheme}.webp`
- Tests 7 accent styles × 4 color schemes (28 combinations):
  - **Adaptive Style**: `adaptive` - Complementary colors based on color scheme
  - **Contrast Style**: `contrast` - Darker/lighter shades for subtle effect
  - **Fixed Styles**: `fixed_magenta`, `fixed_cyan`, `fixed_white`, `fixed_yellow` - Consistent colors
  - **None Style**: `none` - No accent dots for minimal aesthetic
- Plus 2 comparison images: `08_accent_compare_purple_adaptive.webp` and `08_accent_compare_purple_contrast.webp`
- Demonstrates how different accent dot styles enhance or complement each color scheme

**Accent Dot Color Logic**:

- **Rainbow → Magenta**: Good contrast across rainbow spectrum
- **Grayscale → Yellow**: High contrast on gray backgrounds
- **Red → Cyan**: Complementary to red spectrum
- **Purple → Green**: Complementary to purple spectrum

### 🌍 09*timezone*\*.webp (31 files)

Timezone-based date format detection tests - validates automatic format selection and manual overrides:

**Auto-Detection Tests (7 files)**:

- `09_timezone_auto_America_New_York.webp` - US Eastern timezone (should show "Mar 15" format)
- `09_timezone_auto_America_Los_Angeles.webp` - US Pacific timezone (should show "Mar 15" format)
- `09_timezone_auto_Europe_London.webp` - UK timezone (should show "15 Mar" format)
- `09_timezone_auto_Europe_Paris.webp` - French timezone (should show "15 Mar" format)
- `09_timezone_auto_Asia_Tokyo.webp` - Japanese timezone (should show "03-15" format)
- `09_timezone_auto_Canada_Eastern.webp` - Canadian Eastern (should show "Mar 15" - US format due to proximity)
- `09_timezone_auto_Canada_Pacific.webp` - Canadian Pacific (should show "15 Mar" - European format due to Commonwealth)

**Format Override Tests (21 files)**: Each timezone tested with all 4 format options (auto, us_format, european_format, iso_format) for manual override validation.

**Verification Tests (3 files)**:

- `09_verify_us_auto.webp` - US timezone auto-detection verification
- `09_verify_european_auto.webp` - European timezone auto-detection verification
- `09_verify_asian_auto.webp` - Asian timezone auto-detection verification

All timezone tests use `show_date=true debug_date='2024-03-15T12:00:00Z'` to display date formats consistently.

## How Images Are Generated

These images are created by running:

```bash
./test_harness.sh
```

The test harness uses `pixlet render` with various parameter combinations and saves output to descriptively named files. This allows visual verification that all configuration combinations work correctly.

## Parameters Tested

All parameter combinations match URL query parameters:

- `color_scheme`: rainbow, thermal, grayscale, red, blue, green, purple
- `hemisphere`: northern, southern
- `accent_dot_style`: adaptive, contrast, fixed_magenta, fixed_cyan, fixed_white, fixed_yellow, none
- `show_date`: true, false
- `enable_special_dates`: true, false
- `debug_date`: Various ISO 8601 timestamps for testing seasonal positions

## Usage

These images serve as:

1. **Visual regression testing** - Compare against future changes
2. **Configuration validation** - Verify all combinations work
3. **Design review** - See how different settings look
4. **Documentation** - Show users what options are available

## Visual Showcase

For easy browsing of all images, open **`showcase.html`** in your browser:

```bash
open temp/showcase.html
```

The showcase page provides:

- **4x scaled images** (256×128) for comfortable viewing
- **Tidbyt device simulation** with realistic frames and shadows
- **Organized sections** with table of contents navigation
- **Parameter captions** showing exact pixlet render commands
- **Side-by-side comparisons** for hemisphere differences
- **Responsive design** that works on desktop and mobile

---

Generated by Year Clock Test Harness - Total: 650+ images covering 325+ test cases
