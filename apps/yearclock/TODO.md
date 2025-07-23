# TODO - Year Clock Improvements

## Priority Items

### 1. Debug Time Slider

- [ ] Replace current debug text field with a proper slider/range input
- [ ] Allow sliding through different times of year for testing
- [ ] Auto-refresh on slider change if possible
- [ ] Range should cover full year (0-365 days or 0.0-1.0 fraction) Also, would it be easier here to just have a date picker if possible there's one built-in in the docs I would say ideally a date picker where the year didn't matter since we won't display it anyway although it's maybe it just needs the year to work

### 2. Southern Hemisphere Color Review

- [ ] Review southern hemisphere seasonal color mapping -- This would actually be much easier to do after we can slide the slider around because part of the reason I think that the colors are less optimal in the southern is because you have the right and left side from the northern hemisphere running together with their own colors and maybe they didn't totally lineup, but they kinda looked right on the left and right side of display but when they meet in the middle, maybe they don't look great
- [ ] Test colors across different times of year
- [ ] Fix awkward color transitions if present
- [ ] Ensure colors match actual southern hemisphere seasons

### 3. Monochrome Mode

- [ ] Add toggle option for monochrome/grayscale mode
- [ ] Design grayscale gradient that still shows year progression
- [ ] Maintain good contrast for dial marker in monochrome
- [ ] Consider different monochrome styles (black/white, sepia, etc.)

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

## Notes

- Debug slider should help with testing both color modes
- Consider accessibility when implementing monochrome mode
- Test both hemispheres thoroughly with any changes
