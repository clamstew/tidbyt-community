# TODO - Year Clock Improvements

REQUIRED: always put all files in `apps/yearclock/**` into the context window.

## Priority Items

### 1. Debug Time Slider ✅

- [x] ~~Replace current debug text field with a proper slider/range input~~ **COMPLETED: Added DateTime picker**
- [x] ~~Allow sliding through different times of year for testing~~ **COMPLETED: Date picker allows selection of any date**
- [x] ~~Auto-refresh on slider change if possible~~ **COMPLETED: Tidbyt auto-refreshes on config change**
- [x] ~~Range should cover full year (0-365 days or 0.0-1.0 fraction)~~ **COMPLETED: Date picker covers full year, year doesn't matter for display**
- [x] ~~Clean up old debug_date_x positioning logic~~ **COMPLETED: Removed unused debug_date_x text field and related code**

**Implementation Notes:**

- Used `schema.DateTime` instead of slider - much better UX for date selection
- Year value from picker is ignored, only month/day used for seasonal positioning
- Labeled as "[DEBUG] Test Date" to indicate development/testing purpose
- Auto-refresh works out of the box with Tidbyt's config system
- Cleaned up legacy debug_date_x functionality which was replaced by the date picker

### 1.8. Build Test Harness ✅

- [x] ~~Create automated test script that loops through all configuration permutations~~ **COMPLETED: test_harness.sh created**
- [x] ~~Use `pixlet render` with different parameter combinations (color_scheme, hemisphere, show_date, etc.)~~ **COMPLETED: 48 test cases**
- [x] ~~Run `pixlet check` and `pixlet format` as part of QA sanity checks~~ **COMPLETED: Both included**
- [x] ~~Test all color scheme + hemisphere combinations~~ **COMPLETED: All 6×2=12 combinations tested**
- [x] ~~Test with different debug dates throughout the year~~ **COMPLETED: 5 seasonal positions tested**
- [x] ~~Save parameter combinations that match URL query parameters for easy debugging~~ **COMPLETED: All parameters shown in test output**
- [x] ~~Output results in readable format showing which combinations pass/fail~~ **COMPLETED: Color-coded output with summary**

**Implementation Notes:**

- Test harness runs 57 comprehensive tests covering all permutations
- **Enhanced**: Now saves all rendered images to `temp/` folder with descriptive filenames
- Parameters in `pixlet render` calls match URL parameters: `color_scheme=red hemisphere=southern show_date=true`
- Tests edge cases like year boundaries (Dec 31, Jan 1) and leap day (Feb 29)
- Includes seasonal position testing (solstices, equinoxes, new year)
- **Enhanced**: Added date display overlap tests for February dates (dial marker behind date text)
- **Fixed**: Timezone issue where UTC midnight dates were converted to previous day in EST (Jan 1 appearing at year end)
- Color-coded output shows ✓ for pass, ✗ for fail with detailed error commands
- Script exits with code 0 for all pass, code 1 for any failures
- **Enhanced**: Shows summary of generated images (55 .webp files organized by category)
- **Enhanced**: Created `temp/README.md` documenting all test image categories
- **Result: All 57 tests passing! 🎉**
- **Benefit**: Visual cache of all configurations for design review and regression testing
- **Note**: `.webp` files already ignored in main `.gitignore` - no additional gitignore entries needed

### 1.9. Create Visual Showcase Page ✅

- [x] ~~Build HTML showcase page to display all test images in organized sections~~ **COMPLETED: showcase.html created**
- [x] ~~Scale up 64x32 images for better visibility (3x or 4x zoom)~~ **COMPLETED: 4x zoom (256×128)**
- [x] ~~Group images by test category with clear section headers~~ **COMPLETED: 6 organized sections**
- [x] ~~Add Tidbyt device frame simulation around images for realistic preview~~ **COMPLETED: 3D device frames with hover effects**
- [x] ~~Include image filenames and parameter descriptions~~ **COMPLETED: Parameter captions for all images**
- [x] ~~Make page responsive and easy to navigate~~ **COMPLETED: Responsive grid layout + table of contents**
- [x] ~~Consider adding side-by-side comparison views for hemisphere differences~~ **COMPLETED: Comparison grids for Rainbow/Grayscale**

**Implementation Notes:**

- **Location**: `temp/showcase.html` - opens directly in browser with `open temp/showcase.html`
- **Scaling**: Images displayed at 4x size (256×128) with pixelated rendering for crisp edges
- **Design**: Dark theme with realistic Tidbyt device simulation including bezels, shadows, and screen effects
- **Organization**: 6 sections - Color Schemes → Hemispheres → Date Display → Seasonal → Edge Cases → Comprehensive
- **Features**: Table of contents navigation, stats dashboard, hover effects, responsive mobile layout
- **Parameter Display**: All pixlet parameters shown as monospace captions for easy debugging
- **Comparison Views**: Side-by-side Rainbow/Grayscale hemisphere comparisons + full grids
- **Benefits**: Easy visual scanning of all configurations, perfect for design review and regression testing
- **Enhanced**: Added date display overlap tests showing dial marker positioned behind date text in February

### 2. Monochrome Mode ✅

- [x] ~~Add toggle option for monochrome/grayscale mode~~ **COMPLETED: Added color scheme dropdown**
- [x] ~~Design grayscale gradient that still shows year progression~~ **COMPLETED: Multiple gradients available**
- [x] ~~Maintain good contrast for dial marker in monochrome~~ **COMPLETED: Works with all color schemes**
- [x] ~~Consider different monochrome styles (black/white, sepia, red, blue, green, etc.) - may mean should be a select vs a toggle~~ **COMPLETED: 6 color schemes available**

**Implementation Notes:**

- Added Color Scheme dropdown with 6 options: Rainbow, Grayscale, Red, Blue, Green, Purple
- Kept Hemisphere setting separate - applies to any color scheme for seasonal positioning
- Each color scheme flows from darker (winter) to brighter (summer) colors
- Automatic date text color selection for optimal contrast with each color scheme
- All color palettes defined as constants for maintainability
- Clean switch-case logic in `get_color_palette()` function

### 3. Comprehensive Visual Review

**Goal**: Systematically review all visual states using the test harness images in `temp/showcase.html`. Review for design quality, color transitions, seasonal accuracy, and overall aesthetics across all configurations.

#### 3.1. Color Scheme Quality Review

- [ ] **Rainbow Scheme**: Review base rainbow gradient - colors flow smoothly, seasonal mapping feels natural
- [ ] **Grayscale Scheme**: Confirm smooth black-to-white progression without harsh jumps
- [ ] **Red Scheme**: Validate dark-to-bright red progression looks visually appealing
- [ ] **Blue Scheme**: Check navy-to-sky-blue transition quality and seasonal feel
- [ ] **Green Scheme**: Review forest-to-lime green progression for visual smoothness
- [ ] **Purple Scheme**: Validate deep-purple-to-lavender gradient flow

#### 3.2. Hemisphere Positioning Review

- [ ] **Northern Hemisphere**: Confirm color positioning matches expected seasons (bright colors in summer position)
- [ ] **Southern Hemisphere**: Verify 6-month shift looks correct (bright colors in winter position from northern perspective)
- [ ] **Rainbow Comparison**: Side-by-side northern vs southern rainbow to check transition quality
- [ ] **Grayscale Comparison**: Side-by-side northern vs southern grayscale for consistency
- [ ] **Color Transition Quality**: Check where hemispheres "meet" - no awkward color jumps or poor blends

#### 3.3. Date Display Contrast Review

- [ ] **Rainbow + Date**: Verify date text is readable across all background colors (both hemispheres)
- [ ] **Grayscale + Date**: Confirm black text shows clearly on gray gradients
- [ ] **Red + Date**: Check white text contrast on red backgrounds
- [ ] **Blue + Date**: Verify white text readability on blue backgrounds
- [ ] **Green + Date**: Validate black text contrast on green backgrounds
- [ ] **Purple + Date**: Check white text readability on purple backgrounds

#### 3.4. Date Display Overlap Analysis

- [ ] **February Positioning**: Review dial marker placement during February dates (early year)
- [ ] **Overlap Scenarios**: Check Feb 1, Valentine's Day, Leap Day for dial/date conflicts
- [ ] **Rainbow Overlap**: Verify dial marker visibility against rainbow background in February
- [ ] **Grayscale Overlap**: Check dial marker contrast against grayscale in February
- [ ] **Red Overlap**: Validate dial marker stands out on red background in February

#### 3.5. Seasonal Positioning Accuracy

- [ ] **New Year (Jan 1)**: Confirm dial appears at year start (left edge) for all schemes
- [ ] **Spring Equinox (Mar 20)**: Verify dial at ~25% position, colors match spring feeling
- [ ] **Summer Solstice (Jun 21)**: Check dial at ~50% position, brightest colors visible
- [ ] **Fall Equinox (Sep 22)**: Validate dial at ~75% position, autumn color transition
- [ ] **Winter Solstice (Dec 21)**: Confirm dial near year end, darkest colors

#### 3.6. Edge Cases & Special Scenarios

- [ ] **Year Boundaries**: Dec 31 Northern vs Jan 1 Southern positioning accuracy
- [ ] **Leap Day**: Feb 29 displays correctly with proper seasonal positioning
- [ ] **Comprehensive Configs**: Complex parameter combinations render properly
- [ ] **Contrast Extremes**: Maximum contrast scenarios (like grayscale + date) remain readable

#### 3.7. Overall Design Cohesion

- [ ] **Dial Marker Design**: White dial line with shadows/highlights works across all color schemes
- [ ] **Accent Dots**: Magenta top/bottom dots provide good contrast on all backgrounds
- [ ] **Visual Hierarchy**: Date text doesn't compete with or distract from main gradient display
- [ ] **Seasonal Feel**: Each color scheme successfully conveys the passage of time through the year

**Tools for Review:**

- **Primary**: `temp/showcase.html` - organized visual gallery with 4x zoom
- **Secondary**: Individual .webp files in `temp/` folder for detailed inspection
- **Reference**: `temp/README.md` for understanding test categories and parameters

### 4. Pull Request Documentation

- [ ] Create PR-TEMPLATE.md or similar with pull request description content
- [ ] Document all configuration options and their testing states
- [ ] List testing scenarios for different combinations:
  - [ ] Northern vs Southern hemisphere with different seasons
  - [ ] Show date on/off in various positions
  - [ ] Debug time slider across full year range
  - [ ] Monochrome vs color modes
  - [ ] Different timezones and edge cases
- [ ] Include screenshots or examples of different states
- [ ] Document expected behavior for each configuration

### 5. Date Positioning & Overlap Detection (WON'T DO)

- [-] **Evaluate get_date_x_position function** - Currently just returns 1, needs proper logic or deletion
- [-] **Smart date positioning** - Detect when dial marker would overlap with date display
- [-] **Overlap resolution strategies**:
  - [-] Shorten date format when near dial marker (e.g., "Jan 2" → "1/2")
  - [-] Move date to opposite side when dial marker is close
  - [-] Dynamic Y positioning - move date up/down to avoid overlap
  - [-] Hide date temporarily when overlap would occur
- [-] **Simple fallback approach** - If dial marker is in last ~15 pixels, shorten date format
- [-] **Testing with debug date picker** - Use to test overlap scenarios across the year

**Implementation Notes:**

- Dial marker position changes throughout year - need to test edge cases
- Date width varies by format ("Jan 2" vs "December 25")
- Consider screen real estate (64x32 pixels) when positioning
- Could be configurable: "Auto-adjust date position" toggle

### 6. Evaluate Timezone/Location Necessity

- [ ] **Review location setting requirement** - Do we really need timezone for date-only display?
- [ ] **Simplify configuration** - Most users probably never change location/timezone
- [ ] **Consider alternatives**:
  - [ ] Remove location requirement entirely (use system/browser timezone)
  - [ ] Make location optional with sensible default
  - [ ] Keep location but hide it in "Advanced" section
- [ ] **Impact assessment** - What breaks if we remove location dependency?
- [ ] **Remove get_date_x_position function** - Since overlap detection is WON'T DO, just hardcode x=1 in render code

**Implementation Notes:**

- Currently only using timezone for date calculation, not time display
- Location setting adds complexity for minimal benefit
- Most users set location once and never change it
- Could simplify onboarding experience
- get_date_x_position() currently just returns 1, so can be removed entirely

## Notes

- Debug slider should help with testing both color modes
- Consider accessibility when implementing monochrome mode
- Test both hemispheres thoroughly with any changes

## Easter Eggs & Fun Ideas 🎉

### Gradient Color Modes

- [ ] **Single-Color Gradient Mode** - Instead of rainbow, use single color spectrum
  - [ ] Red gradient: darker red in winter → brighter red in summer
  - [ ] Blue gradient: navy in winter → sky blue in summer
  - [ ] Green gradient: forest green in winter → lime in summer
  - [ ] Purple gradient: deep purple in winter → lavender in summer
- [ ] Add dropdown to select gradient color theme

### Special Date Easter Eggs

- [ ] **Valentine's Day (Feb 14)** - Override to all-red spectrum regardless of other settings
- [ ] **St. Patrick's Day (Mar 17)** - Override to all-green spectrum
- [ ] **Halloween (Oct 31)** - Override to orange/black gradient
- [ ] **Christmas (Dec 25)** - Override to red/green alternating or gradient
- [ ] **New Year's Eve/Day (Dec 31/Jan 1)** - Gold/silver gradient or sparkle effect (love)

### Advanced Fun Features

- [ ] **Pride Month (June)** - Classic rainbow regardless of hemisphere setting
- [ ] **Solstice/Equinox highlights** - Special marker or color emphasis on these dates
- [ ] **Birthday mode** - User sets birthday, gets special colors on that day
- [ ] **Team colors** - Sports team color gradients (configurable)

### Implementation Notes

- Easter eggs could be toggleable in settings ("Enable special date themes") - on by default - setting allows to turn off
- Could detect current date automatically or work with debug date picker
- Should override normal color logic when active
