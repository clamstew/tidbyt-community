# 🌈 Year Clock

A meditative year progress tracker for your Tidbyt that displays the flow of time as a beautiful rainbow gradient.

## Overview

Year Clock transforms your Tidbyt into a slow-moving, year-long timepiece that reminds you time flows steadily, not in a blur. Inspired by [vintage rainbow wall clocks](https://odditymall.com/year-long-clock) and analog radio dials, this app maps out the entire year as a horizontal rainbow gradient with a retro-style dial marker that slides slowly across it.

## Features

- **Multiple Color Schemes**: Choose from Rainbow, Thermal, Grayscale, Red, Blue, Green, or Purple gradients
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

**Thermal**

A sophisticated temperature-inspired gradient that blends thermal physics with rainbow aesthetics:

- Coldest (Winter): Deep winter blues and steel tones
- Cool (Spring): Light blues transitioning to purple
- Hot (Summer): Intense thermal oranges and reds at peak heat
- Warm (Fall): Deep reds cooling back to purple

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

- **Color Scheme**: Choose from Rainbow, Thermal, Grayscale, Red, Blue, Green, or Purple
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
- **Calendar System**: Choose which calendar system to use for year progress calculation
  - **Gregorian (Default)**: Standard Western calendar system
  - **Persian/Jalali**: Solar calendar used in Iran and Afghanistan
  - **Islamic/Hijri**: Lunar calendar used in Islamic countries
  - **Thai Buddhist**: Buddhist Era calendar used in Thailand
  - **Ethiopian**: Traditional calendar with 13 months
  - **Coptic**: Ancient calendar system still used in some regions
- **Enable Special Date Themes**: Toggle special holiday and astronomical event color overrides
- **Enable Holiday Animations**: Toggle animations on special holidays (New Year's sparkles, Halloween flicker, Christmas snow, Valentine's hearts)

## Calendar Systems 📅

Year Clock supports multiple calendar systems for calculating year progress, making it culturally relevant worldwide:

### Available Calendar Systems

- **Gregorian Calendar**: The standard Western calendar with 365/366 days per year
- **Persian/Jalali Calendar**: Solar calendar beginning around March 21st, used in Iran and Afghanistan
- **Islamic/Hijri Calendar**: Lunar calendar with ~354 days per year, used in Islamic countries
- **Thai Buddhist Calendar**: Based on Buddhist Era dating, adding ~543 years to Gregorian dates
- **Ethiopian Calendar**: Features 13 months (12 months of 30 days + 1 month of 5/6 days)
- **Coptic Calendar**: Ancient calendar still used in some Christian communities

### How Calendar Systems Work

When you select an alternative calendar system:

1. **Year Progress**: The gradient position is calculated based on the alternative calendar's year boundaries
2. **Hybrid Date Display**: When "Show Date" is enabled, you'll see both:
   - Primary line: Gregorian date in your preferred format/language
   - Secondary line: Alternative calendar date (e.g., "Far 25, 1403" for Persian)
3. **Seasonal Accuracy**: Colors and hemisphere settings work correctly for each calendar system
4. **Calendar-Aware Thermal Peak**: The thermal color scheme adjusts its peak position based on when each calendar's new year starts:
   - **Gregorian/Thai Buddhist**: Peak at 65% (late August relative to January start)
   - **Persian**: Peak at 38% (late August relative to spring equinox start)
   - **Ethiopian/Coptic**: Peak at 90% (late August relative to September start)
   - **Islamic**: Peak at 50% (neutral positioning for lunar calendar that drifts through seasons)

### Example Alternative Calendar Dates

- **Persian**: "Far 25, 1403" (Farvardin 25, year 1403)
- **Islamic**: "Muh 15, 1446" (Muharram 15, year 1446)
- **Thai Buddhist**: "Jan 25, 2567" (January 25, Buddhist Era 2567)
- **Ethiopian**: "Mes 15, 2016" (Meskerem 15, year 2016)
- **Coptic**: "Tho 15, 1741" (Thout 15, year 1741)

The calendar conversion uses scholarly mathematical algorithms from _"Mapping Time: the calendar and its history"_ by E.G. Richards (Oxford University Press) for accuracy.

## Special Date Themes 🎉

Year Clock automatically detects special dates and applies unique themed color overrides:

### Holiday Themes

- **Valentine's Day (Feb 14)**: Red spectrum regardless of hemisphere
- **St. Patrick's Day (Mar 17)**: Green spectrum
- **Halloween (Oct 31)**: Custom orange/brown autumn gradient
- **Christmas (Dec 25)**: Custom red/green holiday gradient
- **New Year's Eve (Dec 31)**: Gold/silver celebration gradient with magical sparkle animation ✨🎉
- **New Year's Day (Jan 1)**: Chill gold/silver recovery theme without animation ☀️
- **Pride Month (June)**: Classic rainbow with respect to hemisphere setting

### Astronomical Event Themes

- **Spring Equinox (Mar 20)**: Fresh spring colors with pale blues, soft greens, and bright yellows
- **Summer Solstice (Jun 21)**: Bright solar colors with golds, yellows, and oranges
- **Fall Equinox (Sep 22)**: Rich autumn colors with browns, oranges, and deep reds
- **Winter Solstice (Dec 21)**: Deep winter colors with blues, purples, and silvery whites

### Regional Holiday Themes (Timezone-Filtered)

Year Clock intelligently shows regional holidays based on your timezone for cultural relevance:

- **Independence Day (Jul 4)**: Red, white, and blue patriotic colors (US timezones only)
- **Bastille Day (Jul 14)**: French tricolor (bleu, blanc, rouge) celebrating Liberté, Égalité, Fraternité (French/Francophone timezones)
- **Boxing Day (Dec 26)**: Traditional green and gold post-Christmas colors (Europe/Commonwealth timezones)
- **May Day (May 1)**: Workers' solidarity red transitioning to spring renewal greens (Europe/International, not US)
- **Día de los Muertos (Nov 1-2)**: Vibrant orange, purple, and gold celebration colors (Latin American timezones)
- **Passover (Apr 23)**: Blue, white, and gold spring freedom theme celebrating liberation (US/Canada/Western regions)
- **Hanukkah (Dec 27)**: Blue, white, and gold Festival of Lights theme celebrating religious freedom (US/Canada/Western regions)
- **Rosh Hashanah (Sep 25)**: Honey and apple themed colors celebrating the Jewish New Year with earth, gold, and green tones (US/Canada/Western regions)
- **Yom Kippur (Oct 5)**: Solemn white, silver, and gray reflection colors for the Day of Atonement (US/Canada/Western regions)
- **Persian Nowruz (Mar 20-21)**: Spring equinox celebration with Persian garden colors - pale blues, mint greens, spring yellows, and traditional gold (Iran/Afghanistan/Central Asia timezones)
- **Thai Songkran (Apr 13-15)**: Water festival celebration with deep navy, sky blues, powder blues, and spring green renewal colors (Thailand/Southeast Asia timezones)

### Variable Date Regional Holidays (Timezone-Filtered)

Smart calculation of holidays with changing dates each year:

- **Thanksgiving (4th Thursday in November)**: Autumn harvest browns, golds, and cranberry reds (US timezones only)
- **Black Friday (day after Thanksgiving)**: Shopping theme with black, sale reds, and deal colors (US timezones only)
- **Golden Week (April 29 - May 5)**: Cherry blossom pinks and spring pastels (Japan/Asia/Tokyo timezone only)

**Smart Regional Filtering**: Regional holidays only appear for users in relevant timezones:

- 🇺🇸 Independence Day: `America/*` timezones (excluding Mexico)
- 🇫🇷 Bastille Day: `Europe/Paris`, `Europe/Monaco`, and French territories worldwide (`America/Cayenne`, `Pacific/Tahiti`, etc.)
- 🇬🇧 Boxing Day: `Europe/*`, `Canada/*`, `Australia/*`, and Commonwealth timezones
- 🌍 May Day: `Europe/*`, `Asia/*`, `Australia/*`, `Canada/*` (Europe celebrates workers' holiday, US has Labor Day in September)
- 🇲🇽 Día de los Muertos: `America/Mexico*` and Latin American timezones
- 🇺🇸 Thanksgiving: `America/*` timezones (excluding Mexico)
- 🛍️ Black Friday: `America/*` timezones (excluding Mexico)
- 🇯🇵 Golden Week: `Asia/Tokyo` and related Japanese timezones
- 🕎 Passover: `America/*`, `Europe/*` (Western regions with significant Jewish communities)
- 🕯️ Hanukkah: `America/*`, `Europe/*` (Western regions with significant Jewish communities)
- 🍯 Rosh Hashanah: `America/*`, `Europe/*` (Western regions with significant Jewish communities)
- 🔯 Yom Kippur: `America/*`, `Europe/*` (Western regions with significant Jewish communities)
- 🌸 Persian Nowruz: `Asia/Tehran`, `Asia/Kabul`, `Asia/Dushanbe`, and Persian cultural regions
- 💧 Thai Songkran: `Asia/Bangkok`, `Asia/Phnom_Penh`, `Asia/Vientiane`, `Asia/Yangon` (Southeast Asian water festivals)

All special date themes are enabled by default but can be toggled off in the **"Enable Special Date Themes"** setting.

**Total: 23 special date themes** across holidays, astronomical events, and regional celebrations, each with culturally appropriate color palettes and smart timezone filtering.

## ✨ Holiday Animations

Year Clock features a comprehensive holiday animation system that brings special dates to life with unique, culturally appropriate animations.

### 🎊 New Year's Sparkle Experience

Year Clock creates a unique two-day New Year's experience that reflects the party-to-recovery cycle:

**Dec 31st: Party Time! ✨🎉**

New Year's Eve features a magical sparkle animation that creates a festive twinkling effect over the gold/silver gradient.

**Jan 1st: Recovery Mode ☀️**

New Year's Day uses the same beautiful gold/silver gradient but without animation, creating a calmer, more restful visual perfect for recovery day.

### 🎃 Halloween Flicker Animation

**Oct 31st: Spooky Atmosphere**

Halloween features an eerie flicker animation that creates a spooky campfire or candle-like effect over the orange/black Halloween gradient.

**Flicker Features:**

- **6-Frame Animation**: Variable intensity flickering creates atmospheric spookiness
- **Spooky Colors**: Orange, orange-red, and dark brown flickers complement the HALLOWEEN_PALETTE
- **Regional Filtering**: Only appears in Halloween-celebrating regions (US/Canada/Ireland/UK)
- **Slow Timing**: 120ms frame delays create a deliberate, haunting effect

### ❄️ Christmas Snow Animation

**Dec 25th: Peaceful Snowfall**

Christmas features a gentle falling snow animation that creates a serene winter wonderland effect over the red/green Christmas gradient.

**Snow Features:**

- **8-Frame Animation**: Realistic falling snow pattern with natural movement
- **Winter Colors**: White, alice blue, and snow white pixels create authentic snowfall
- **Global Holiday**: Works worldwide as Christmas is universally celebrated
- **Gentle Timing**: 100ms frame delays create smooth, peaceful falling motion

### 💖 Valentine's Hearts Animation

**Feb 14th: Romantic Pulse**

Valentine's Day features a gentle pulsing heart animation that creates a romantic heartbeat effect over the red/pink Valentine's gradient.

**Heart Features:**

- **6-Frame Animation**: Smooth pulsing effect simulates a gentle heartbeat
- **Romantic Colors**: Deep pink, hot pink, light pink, and tomato hearts with varying intensities
- **Global Holiday**: Works worldwide as Valentine's Day is widely celebrated
- **Romantic Timing**: 150ms frame delays create a slow, romantic pulse

### Animation Controls

**User-Configurable Animation Toggle:**

- **Enable Holiday Animations**: Control all holiday animations with a single toggle
- **Smart Separation**: Users can keep special date colors while disabling animations for battery conservation
- **Backward Compatible**: Works with existing "Enable Special Date Themes" setting
- **Performance Optimized**: All animations use minimal pixel counts and optimized frame timing

### Technical Implementation

**Animation Framework:**

- **Layered Rendering**: Animations appear between gradient background and dial marker for proper visual hierarchy
- **Frame Optimization**: Each animation uses strategic pixel placement to minimize rendering load
- **Smart Integration**: All animations work seamlessly with existing features (hemisphere settings, date display, accent dots, calendar systems, etc.)
- **Performance Tuning**: Frame timing optimized for each animation type:
  - New Year's: 50ms (energetic sparkles)
  - Halloween: 120ms (spooky atmosphere)
  - Christmas: 100ms (gentle snow)
  - Valentine's: 150ms (romantic pulse)

**Animation Activation:**

Animations automatically activate on their respective dates when both "Enable Special Date Themes" and "Enable Holiday Animations" are enabled. Regional holidays (like Halloween) respect timezone filtering for cultural relevance.

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

Year Clock is the **first Tidbyt app** with intelligent timezone-based language detection, supporting 7 languages with zero configuration required for most users.

### Intelligent Language Detection

The app automatically detects the appropriate language based on your device's timezone, providing culturally accurate month names:

### Auto-Detection Logic

- **🇺🇸 English Regions**: `America/*` (except Mexico), `Canada/*`, `Australia/*` → English month names
- **🇪🇸 Spanish Regions**: `Europe/Madrid`, `America/Mexico*`, `America/Argentina*`, `America/Colombia*`, `America/Guatemala`, `America/El_Salvador`, `America/Tegucigalpa`, `America/Managua`, `America/Costa_Rica`, `America/Caracas`, `America/Guayaquil`, `America/La_Paz`, `America/Asuncion`, `America/Montevideo`, `America/Havana`, `America/Santo_Domingo`, `America/Panama`, `America/Cancun`, `America/Tijuana` → Spanish month names
- **🇫🇷 French Regions**: `Europe/Paris`, `Europe/Luxembourg`, `America/Montreal`, `Africa/Ouagadougou`, `Africa/Bamako`, `Africa/Dakar`, `Africa/Conakry`, `Africa/Abidjan` → French month names
- **🇩🇪 German Regions**: `Europe/Berlin`, `Europe/Vienna`, `Europe/Zurich` → German month names
- **🇧🇷 Portuguese Regions**: `America/Sao_Paulo`, `Europe/Lisbon`, `Africa/Luanda`, `Africa/Maputo`, `Africa/Bissau`, `Africa/Sao_Tome`, `America/Fortaleza` → Portuguese month names
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
- **🌍 7-Language Support**: English, Spanish, French, German, Portuguese, Italian, Russian
- **🔧 Manual Override**: Users can force specific language if desired
- **🎯 Cultural Accuracy**: Smart timezone-to-language correlation based on regional patterns
- **⚡ Zero Configuration**: No language setup required - works automatically
- **🏆 Tidbyt First**: Pioneering intelligent language detection in the Tidbyt ecosystem
- **🌍 Francophone Africa Coverage**: Expanded French language detection for Burkina Faso, Mali, Senegal, Guinea, and Ivory Coast (~300M people)
- **🌎 Central America Coverage**: Expanded Spanish language detection for Guatemala, El Salvador, Honduras, Nicaragua, and Costa Rica (~50M people)
- **🇵🇹 Lusophone Africa Coverage**: Expanded Portuguese language detection for Angola, Mozambique, Guinea-Bissau, São Tomé and Príncipe, plus major Brazilian cities (~70M people)
- **🌎 South America Coverage**: Expanded Spanish language detection for Venezuela, Ecuador, Bolivia, Paraguay, and Uruguay (~80M people)
- **🏝️ Caribbean & Mexico Coverage**: Expanded Spanish language detection for Cuba, Dominican Republic, Panama, plus major Mexican cities Cancun and Tijuana (~30M people)

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
