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
- **Multi-Language Support**: Intelligent timezone-based language detection with 6-language support
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
- **Language**: Choose display language or use automatic timezone-based detection
  - **Auto-detect (Default)**: Automatically chooses language based on your timezone
  - **English**: "Mar 15", "Dec 25"
  - **Español**: "Mar 15", "Dic 25"
  - **Français**: "15 Mar", "25 Déc"
  - **Deutsch**: "15 Mär", "25 Dez"
  - **Português**: "15 Mar", "25 Dez"
  - **Italiano**: "15 Mar", "25 Dic"
- **Enable Special Date Themes**: Toggle special holiday and astronomical event color overrides

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

### Regional Holiday Themes (Timezone-Filtered)

Year Clock intelligently shows regional holidays based on your timezone for cultural relevance:

- **Independence Day (Jul 4)**: Red, white, and blue patriotic colors (US timezones only)
- **Boxing Day (Dec 26)**: Traditional green and gold post-Christmas colors (Europe/Commonwealth timezones)
- **May Day (May 1)**: Workers' solidarity red transitioning to spring renewal greens (Europe/International, not US)
- **Día de los Muertos (Nov 1-2)**: Vibrant orange, purple, and gold celebration colors (Latin American timezones)

### Variable Date Regional Holidays (Timezone-Filtered)

Smart calculation of holidays with changing dates each year:

- **Thanksgiving (4th Thursday in November)**: Autumn harvest browns, golds, and cranberry reds (US timezones only)
- **Black Friday (day after Thanksgiving)**: Shopping theme with black, sale reds, and deal colors (US timezones only)
- **Golden Week (April 29 - May 5)**: Cherry blossom pinks and spring pastels (Japan/Asia/Tokyo timezone only)

**Smart Regional Filtering**: Regional holidays only appear for users in relevant timezones:

- 🇺🇸 Independence Day: `America/*` timezones (excluding Mexico)
- 🇬🇧 Boxing Day: `Europe/*`, `Canada/*`, `Australia/*`, and Commonwealth timezones
- 🌍 May Day: `Europe/*`, `Asia/*`, `Australia/*`, `Canada/*` (Europe celebrates workers' holiday, US has Labor Day in September)
- 🇲🇽 Día de los Muertos: `America/Mexico*` and Latin American timezones
- 🇺🇸 Thanksgiving: `America/*` timezones (excluding Mexico)
- 🛍️ Black Friday: `America/*` timezones (excluding Mexico)
- 🇯🇵 Golden Week: `Asia/Tokyo` and related Japanese timezones

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

## 🗣️ Multi-Language Support

Year Clock is the **first Tidbyt app** with intelligent timezone-based language detection, supporting 6 languages with zero configuration required for most users.

### Intelligent Language Detection

The app automatically detects the appropriate language based on your device's timezone, providing culturally accurate month names:

### Auto-Detection Logic

- **🇺🇸 English Regions**: `America/*` (except Mexico), `Canada/*`, `Australia/*` → English month names
- **🇪🇸 Spanish Regions**: `Europe/Madrid`, `America/Mexico*`, `America/Argentina*`, `America/Colombia*` → Spanish month names
- **🇫🇷 French Regions**: `Europe/Paris`, `Europe/Luxembourg`, `America/Montreal`, `Africa/Ouagadougou`, `Africa/Bamako`, `Africa/Dakar`, `Africa/Conakry`, `Africa/Abidjan` → French month names
- **🇩🇪 German Regions**: `Europe/Berlin`, `Europe/Vienna`, `Europe/Zurich` → German month names
- **🇧🇷 Portuguese Regions**: `America/Sao_Paulo`, `Europe/Lisbon` → Portuguese month names
- **🇮🇹 Italian Regions**: `Europe/Rome` → Italian month names

### Language Examples

**Same date in different languages:**

- 🇺🇸 **English**: "Mar 15", "Dec 25"
- 🇪🇸 **Spanish**: "Mar 15", "Dic 25"
- 🇫🇷 **French**: "15 Mar", "25 Déc"
- 🇩🇪 **German**: "15 Mär", "25 Dez"
- 🇧🇷 **Portuguese**: "15 Mar", "25 Dez"
- 🇮🇹 **Italian**: "15 Mar", "25 Dic"

### Revolutionary Features

- **🧠 Smart Auto-Detection**: Automatically detects language from timezone for 90%+ of users
- **🌍 6-Language Support**: English, Spanish, French, German, Portuguese, Italian
- **🔧 Manual Override**: Users can force specific language if desired
- **🎯 Cultural Accuracy**: Smart timezone-to-language correlation based on regional patterns
- **⚡ Zero Configuration**: No language setup required - works automatically
- **🏆 Tidbyt First**: Pioneering intelligent language detection in the Tidbyt ecosystem
- **🌍 Francophone Africa Coverage**: Expanded French language detection for Burkina Faso, Mali, Senegal, Guinea, and Ivory Coast (~300M people)

### Combined Intelligence

Language detection works seamlessly with date format detection:

- **🇺🇸 New York**: Auto → English + US format → "Dec 25"
- **🇪🇸 Madrid**: Auto → Spanish + European format → "25 Dic"
- **🇫🇷 Paris**: Auto → French + European format → "25 Déc"
- **🇩🇪 Berlin**: Auto → German + European format → "25 Dez"
- **🇧🇷 São Paulo**: Auto → Portuguese + European format → "25 Dez"
- **🇮🇹 Rome**: Auto → Italian + European format → "25 Dic"

### Manual Override Options

If you prefer a specific language regardless of your timezone:

- **Auto-detect**: Let the app choose based on your timezone (recommended)
- **English**: Always use English month names
- **Español**: Always use Spanish month names
- **Français**: Always use French month names
- **Deutsch**: Always use German month names
- **Português**: Always use Portuguese month names
- **Italiano**: Always use Italian month names

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
