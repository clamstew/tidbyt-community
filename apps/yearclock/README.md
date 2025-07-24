# 🌈 Year Clock

A meditative year progress tracker for your Tidbyt that displays the flow of time as a beautiful rainbow gradient.

## Overview

Year Clock transforms your Tidbyt into a slow-moving, year-long timepiece that reminds you time flows steadily, not in a blur. Inspired by [vintage rainbow wall clocks](https://odditymall.com/year-long-clock) and analog radio dials, this app maps out the entire year as a horizontal rainbow gradient with a retro-style dial marker that slides slowly across it.

## Features

- **Multiple Color Schemes**: Choose from Rainbow, Grayscale, Red, Blue, Green, or Purple gradients
- **Seasonal Color Mapping**: Colors flow from darker (winter) to brighter (summer) throughout the year
- **Hemisphere Support**: Northern and Southern hemisphere modes flip the seasonal positioning for any color scheme
- **Retro Dial Marker**: A white dial line with beveled edges and magenta accent dots shows today's position
- **Optional Date Display**: Shows current date in the corner (configurable)
- **Timezone Aware**: Uses your location for accurate local time calculations

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
- **Show Date**: Toggle the date display in the bottom corner
- **Location**: Set your location for proper timezone handling
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
