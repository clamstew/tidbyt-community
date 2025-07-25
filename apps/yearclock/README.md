# 🌈 Year Clock

A meditative year progress tracker for your Tidbyt that displays the flow of time as a beautiful rainbow gradient.

## Overview

Year Clock transforms your Tidbyt into a slow-moving, year-long timepiece that reminds you time flows steadily, not in a blur. Inspired by [vintage rainbow wall clocks](https://odditymall.com/year-long-clock) and analog radio dials, this app maps out the entire year as a horizontal rainbow gradient with a retro-style dial marker that slides slowly across it.

## Features

- **Multiple Color Schemes**: Choose from Rainbow, Grayscale, Red, Blue, Green, or Purple gradients
- **Seasonal Color Mapping**: Colors flow from darker (winter) to brighter (summer) throughout the year
- **Hemisphere Support**: Northern and Southern hemisphere modes flip the seasonal positioning for any color scheme
- **Configurable Dial Marker**: A white dial line with beveled edges and customizable accent dots shows today's position
- **Optional Date Display**: Shows current date in the corner (configurable)
- **Timezone-Based Date Formats**: Automatically detects appropriate date format from your timezone
- **International Support**: Zero-configuration localization that works globally

## Color Schemes

Choose from multiple color palettes, each following the natural flow of seasons:

**Rainbow (Default)**

- Winter: Deep blues and turquoise
- Spring: Greens and golds
- Summer: Yellows and oranges
- Fall: Reds and crimsons

**Monochrome Options**

- **Grayscale**: Smooth black to white gradient
- **Red**: Dark red to bright red/pink progression
- **Blue**: Navy to sky blue progression
- **Green**: Forest green to lime green progression
- **Purple**: Deep purple to lavender progression

**Hemisphere Settings**

- **Northern**: Colors flow with traditional seasons (dark winter → bright summer)
- **Southern**: Colors are shifted 6 months to match local climate patterns

## Configuration Options

- **Color Scheme**: Choose from Rainbow, Grayscale, Red, Blue, Green, or Purple
- **Hemisphere**: Choose Northern or Southern hemisphere for seasonal positioning
- **Accent Dot Style**: Configure how accent dots are colored on the dial marker
  - **Adaptive (Default)**: Dots automatically choose complementary colors based on the color scheme
  - **Contrast**: Dots use darker/lighter shades of the background for subtle contrast
  - **Fixed Colors**: Choose a specific color (Magenta, Cyan, White, Yellow) that never changes
  - **None**: Hide accent dots completely for a minimal aesthetic
- **Show Date**: Toggle the date display in the bottom corner
- **Date Format**: Choose date format or use automatic timezone-based detection
  - **Auto-detect (Default)**: Automatically chooses format based on your timezone
  - **US Format**: Month-day format (e.g., "Mar 15")
  - **European Format**: Day-month format (e.g., "15 Mar")
  - **ISO Format**: Numeric format (e.g., "03-15")
- **[DEBUG] Test Date**: Pick any date to preview how colors look throughout the year

## Special Date Themes 🎉

Year Clock automatically detects special dates and applies unique themed color overrides:

### Holiday Themes

- **Valentine's Day (Feb 14)**: Red spectrum regardless of hemisphere
- **St. Patrick's Day (Mar 17)**: Green spectrum
- **Halloween (Oct 31)**: Custom orange/brown autumn gradient
- **Christmas (Dec 25)**: Custom red/green holiday gradient
- **New Year's (Dec 31/Jan 1)**: Gold/silver celebration gradient
- **Pride Month (June)**: Classic rainbow with respect to hemisphere setting

### Astronomical Event Themes

- **Spring Equinox (Mar 20)**: Fresh spring colors with pale blues, soft greens, and bright yellows
- **Summer Solstice (Jun 21)**: Bright solar colors with golds, yellows, and oranges
- **Fall Equinox (Sep 22)**: Rich autumn colors with browns, oranges, and deep reds
- **Winter Solstice (Dec 21)**: Deep winter colors with blues, purples, and silvery whites

All special date themes are enabled by default but can be toggled off in the **"Enable Special Date Themes"** setting.

## 🌍 Timezone-Based Date Format Detection

Year Clock automatically detects the appropriate date format based on your device's timezone, providing a seamless international experience:

### Auto-Detection Logic

- **US Timezones** (`America/*`, `US/*`): Uses "Mar 15" format
- **European Timezones** (`Europe/*`): Uses "15 Mar" format
- **Asian Timezones** (`Asia/*`): Uses "03-15" ISO format
- **Canadian Timezones**: Mixed logic based on region
  - `Canada/Eastern`: Uses US format (proximity to US)
  - `Canada/Pacific`: Uses European format (Commonwealth influence)

### Benefits

- **🎯 Zero Configuration**: Works automatically for 90%+ of users worldwide
- **🔧 Manual Override**: Users can still force a specific format if desired
- **🌐 Global Coverage**: Handles major timezone patterns intelligently
- **⚡ Smart Defaults**: Uses existing timezone info - no additional setup required

### Manual Override Options

If you prefer a specific format regardless of your timezone:

- **Auto-detect**: Let the app choose based on your timezone (recommended)
- **US Format**: Always use "Mar 15" style
- **European Format**: Always use "15 Mar" style
- **ISO Format**: Always use "03-15" numeric style

## Inspiration

This app captures the meditative quality of watching time pass slowly - like observing a shadow move across a sundial. It's perfect for:

- Reflecting on yearly goals and progress
- Appreciating the steady passage of time
- Adding a beautiful, ever-changing display to your space
- Connecting with the natural rhythm of seasons

## Development

Built with Pixlet using Starlark, featuring:

- Smooth color interpolation across 64 pixels
- Real-time year progress calculation
- Responsive timezone handling
- Clean, minimalist retro aesthetic

---

_"A year is long — you're moving through it slowly, not speeding past it."_
