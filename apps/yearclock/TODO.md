# TODO - Year Clock Improvements

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

### 2. Southern Hemisphere Color Review

- [ ] Review southern hemisphere seasonal color mapping -- This would actually be much easier to do after we can slide the slider around because part of the reason I think that the colors are less optimal in the southern is because you have the right and left side from the northern hemisphere running together with their own colors and maybe they didn't totally lineup, but they kinda looked right on the left and right side of display but when they meet in the middle, maybe they don't look great
- [ ] Test colors across different times of year
- [ ] Fix awkward color transitions if present
- [ ] Ensure colors match actual southern hemisphere seasons

### 3. Monochrome Mode

- [ ] Add toggle option for monochrome/grayscale mode
- [ ] Design grayscale gradient that still shows year progression
- [ ] Maintain good contrast for dial marker in monochrome
- [ ] Consider different monochrome styles (black/white, sepia, red, blue, green, etc.) - may mean should be a select vs a toggle

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
