"""
Applet: Year Clock
Summary: Rainbow year clock
Description: Displays a rainbow gradient representing the year with a retro dial marker showing today's position. Inspired by vintage rainbow wall clocks that track yearly progress with warmer colors for summer and cooler colors for winter.
Author: clamstew
"""

load("humanize.star", "humanize")
load("render.star", "render")
load("schema.star", "schema")
load("time.star", "time")

# Calendar conversion constants and data (borrowed from apps/calendars/calendars.star)
# Based on algorithms from "Mapping Time: the calendar and its history" by E.G. Richards

# Calendar parameter constants
Y = "y"  # Computational year in which J_1 falls
J = "j"  # Number of days that J_c falls before day zero
M = "m"  # Month number in a given calendar for which M' = 0
N = "n"  # Number of months in a year
R = "r"  # Number of years in a cycle of intercalation
P = "p"  # Number of days in a cycle of interacalation
Q = "q"  # Parameter required in calculating years
V = "v"  # Parameter required in calculating years
U = "u"  # Parameter required in calculating months
S = "s"  # Parameter required in calculating months
T = "t"  # Parameter required in calculating months
W = "w"  # Parameter required in calculating months
A = "A"  # Parameter used to handle Gregorian intercalation
B = "B"  # Parameter used to handle Gregorian intercalation
G = "G"  # Parameter used to handle Gregorian intercalation
IS_GREGORIAN = "is_gregorian"
IS_SAKA = "is_saka"

# Calendar systems data (subset of most useful ones for year clock)
CALENDAR_SYSTEMS = {
    "Gregorian": {
        Y: 4716,
        J: 1401,
        M: 3,
        N: 12,
        R: 4,
        P: 1461,
        Q: 0,
        V: 3,
        U: 5,
        S: 153,
        T: 2,
        W: 2,
        A: 184,
        B: 274277,
        G: -38,
        IS_GREGORIAN: True,
    },
    "Persian": {
        Y: 5348,
        J: 77,
        M: 10,
        N: 13,
        R: 1,
        P: 365,
        Q: 0,
        V: 0,
        U: 1,
        S: 30,
        T: 0,
        W: 0,
    },
    "Islamic": {
        Y: 5519,
        J: 7665,
        M: 1,
        N: 12,
        R: 30,
        P: 10631,
        Q: 14,
        V: 15,
        U: 100,
        S: 2951,
        T: 51,
        W: 10,
    },
    "Thai Buddhist": {
        # Saka calendar
        Y: 4794,
        J: 1348,
        M: 2,
        N: 12,
        R: 4,
        P: 1461,
        Q: 0,
        V: 3,
        U: 1,
        S: 31,
        T: 0,
        W: 0,
        A: 184,
        B: 274073,
        G: -36,
        IS_GREGORIAN: True,
        IS_SAKA: True,
    },
    "Ethiopian": {
        Y: 4720,
        J: 124,
        M: 1,
        N: 13,
        R: 4,
        P: 1461,
        Q: 0,
        V: 3,
        U: 1,
        S: 30,
        T: 0,
        W: 0,
    },
    "Coptic": {
        Y: 4996,
        J: 124,
        M: 1,
        N: 13,
        R: 4,
        P: 1461,
        Q: 0,
        V: 3,
        U: 1,
        S: 30,
        T: 0,
        W: 0,
    },
}

# Color Palette Constants - makes code more readable and maintainable
RAINBOW_PALETTE = [
    "#8A2BE2",  # Blue Violet (edges)
    "#4169E1",  # Royal Blue
    "#00BFFF",  # Deep Sky Blue
    "#00CED1",  # Dark Turquoise
    "#00FF7F",  # Spring Green
    "#ADFF2F",  # Green Yellow
    "#FFFF00",  # Yellow (bright center)
    "#FF8C00",  # Dark Orange (bright center)
    "#FF4500",  # Orange Red
    "#DC143C",  # Crimson
    "#B22222",  # Fire Brick
    "#8A2BE2",  # Blue Violet (edges)
]

GRAYSCALE_PALETTE = [
    "#1A1A1A",  # Very Dark Gray (Winter)
    "#2E2E2E",  # Dark Gray
    "#424242",  # Medium Dark Gray
    "#565656",  # Medium Gray
    "#6A6A6A",  # Light Medium Gray
    "#7E7E7E",  # Light Gray
    "#929292",  # Lighter Gray
    "#A6A6A6",  # Even Lighter Gray
    "#BABABA",  # Very Light Gray
    "#CECECE",  # Near White
    "#E2E2E2",  # Almost White
    "#1A1A1A",  # Very Dark Gray (back to winter)
]

RED_PALETTE = [
    "#2D0000",  # Very Dark Red
    "#4A0000",  # Dark Red
    "#660000",  # Darker Red
    "#800000",  # Maroon
    "#B30000",  # Medium Red
    "#CC0000",  # Bright Red
    "#FF0000",  # Pure Red
    "#FF3333",  # Light Red
    "#FF6666",  # Lighter Red
    "#FF9999",  # Pink Red
    "#FFCCCC",  # Very Light Pink
    "#2D0000",  # Very Dark Red (back to start)
]

BLUE_PALETTE = [
    "#000033",  # Very Dark Blue
    "#000066",  # Dark Navy
    "#000099",  # Navy
    "#0000CC",  # Medium Blue
    "#0033FF",  # Bright Blue
    "#3366FF",  # Light Blue
    "#6699FF",  # Lighter Blue
    "#99CCFF",  # Sky Blue
    "#CCE6FF",  # Very Light Blue
    "#E6F3FF",  # Pale Blue
    "#F0F8FF",  # Alice Blue
    "#000033",  # Very Dark Blue (back to start)
]

GREEN_PALETTE = [
    "#002200",  # Very Dark Green
    "#004400",  # Dark Green
    "#006600",  # Forest Green
    "#008800",  # Medium Green
    "#00AA00",  # Bright Green
    "#00CC00",  # Lime Green
    "#00FF00",  # Pure Green
    "#33FF33",  # Light Green
    "#66FF66",  # Lighter Green
    "#99FF99",  # Mint Green
    "#CCFFCC",  # Very Light Green
    "#002200",  # Very Dark Green (back to start)
]

PURPLE_PALETTE = [
    "#2D0033",  # Very Dark Purple
    "#4A0066",  # Dark Purple
    "#660099",  # Deep Purple
    "#8000CC",  # Purple
    "#9933FF",  # Bright Purple
    "#B366FF",  # Light Purple
    "#CC99FF",  # Lighter Purple
    "#E6CCFF",  # Lavender
    "#F0E6FF",  # Very Light Lavender
    "#F8F0FF",  # Pale Lavender
    "#FDFAFF",  # Almost White Lavender
    "#2D0033",  # Very Dark Purple (back to start)
]

# Multi-language month names for international support
MONTH_NAMES = {
    "en": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
    "es": ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"],
    "fr": ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun", "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"],
    "de": ["Jan", "Feb", "Mär", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"],
    "pt": ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"],
    "it": ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic"],
    "ru": ["Yanv", "Fev", "Mar", "Apr", "May", "Iyun", "Iyul", "Avg", "Sen", "Okt", "Noy", "Dek"],
}

THERMAL_PALETTE = [
    "#0D1B2A",  # Deep winter blue (coldest)
    "#1B263B",  # Dark blue
    "#415A77",  # Steel blue
    "#778DA9",  # Light blue
    "#A2C4E0",  # Pale blue (cool spring)
    "#7209B7",  # Cool purple (transition)
    "#F72585",  # Hot pink (warming)
    "#FF8500",  # Hot orange (peak heat)
    "#FF0000",  # Pure red (maximum heat)
    "#8B0000",  # Dark red (late summer)
    "#2E1A47",  # Deep purple (cooling)
    "#0D1B2A",  # Deep winter blue (back to coldest)
]

# Special Date Color Palettes
HALLOWEEN_PALETTE = [
    "#1A0A00",  # Very Dark Brown
    "#330F00",  # Dark Brown
    "#4D1500",  # Medium Brown
    "#662000",  # Orange Brown
    "#B8860B",  # Dark Golden Rod
    "#FF8C00",  # Dark Orange
    "#FF6600",  # Orange
    "#FF4500",  # Orange Red
    "#FF0000",  # Red
    "#8B0000",  # Dark Red
    "#2F1B14",  # Very Dark Brown
    "#1A0A00",  # Very Dark Brown (back to start)
]

CHRISTMAS_PALETTE = [
    "#006400",  # Dark Green
    "#228B22",  # Forest Green
    "#32CD32",  # Lime Green
    "#00FF00",  # Bright Green
    "#90EE90",  # Light Green
    "#F5F5DC",  # Beige (neutral)
    "#FFB6C1",  # Light Pink
    "#FF69B4",  # Hot Pink
    "#FF0000",  # Red
    "#DC143C",  # Crimson
    "#8B0000",  # Dark Red
    "#006400",  # Dark Green (back to start)
]

NEWYEAR_PALETTE = [
    "#2F2F2F",  # Dark Gray
    "#4A4A4A",  # Medium Gray
    "#B8860B",  # Dark Golden Rod
    "#DAA520",  # Golden Rod
    "#FFD700",  # Gold
    "#FFFF99",  # Light Yellow
    "#FFFFFF",  # White (peak)
    "#E6E6FA",  # Lavender
    "#C0C0C0",  # Silver
    "#A9A9A9",  # Dark Gray
    "#696969",  # Dim Gray
    "#2F2F2F",  # Dark Gray (back to start)
]

PASSOVER_PALETTE = [
    "#4169E1",  # Royal Blue (traditional Jewish blue)
    "#6495ED",  # Cornflower Blue
    "#87CEEB",  # Sky Blue
    "#B0E0E6",  # Powder Blue
    "#F0F8FF",  # Alice Blue (very light)
    "#FFFFFF",  # White (purity, freedom)
    "#FFFACD",  # Lemon Chiffon
    "#FFD700",  # Gold (spring renewal)
    "#FFFF99",  # Light Yellow
    "#E6E6FA",  # Lavender
    "#9370DB",  # Medium Purple
    "#4169E1",  # Royal Blue (back to start)
]

HANUKKAH_PALETTE = [
    "#191970",  # Midnight Blue (deep winter night)
    "#4169E1",  # Royal Blue (traditional Jewish blue)
    "#6495ED",  # Cornflower Blue
    "#87CEEB",  # Sky Blue
    "#B0E0E6",  # Powder Blue
    "#F0F8FF",  # Alice Blue
    "#FFFFFF",  # White (Festival of Lights)
    "#C0C0C0",  # Silver
    "#FFD700",  # Gold (menorah lights)
    "#DAA520",  # Golden Rod
    "#4682B4",  # Steel Blue
    "#191970",  # Midnight Blue (back to start)
]

# Astronomical Event Color Palettes
SPRING_EQUINOX_PALETTE = [
    "#E6F3FF",  # Very Pale Blue (dawn)
    "#B3E0FF",  # Light Sky Blue
    "#80CCFF",  # Soft Blue
    "#66FFB3",  # Mint Green
    "#80FF80",  # Light Green
    "#B3FF66",  # Fresh Green
    "#E6FF4D",  # Spring Yellow
    "#FFFF66",  # Bright Yellow
    "#FFE066",  # Warm Yellow
    "#D4EDDA",  # Very Light Green
    "#C3F0CA",  # Pale Green
    "#E6F3FF",  # Very Pale Blue (back to dawn)
]

SUMMER_SOLSTICE_PALETTE = [
    "#FFD700",  # Gold
    "#FFCC00",  # Bright Gold
    "#FFB347",  # Peach
    "#FFA500",  # Orange
    "#FF8C00",  # Dark Orange
    "#FF6600",  # Red Orange
    "#FFFF00",  # Pure Yellow (peak brightness)
    "#FFFF33",  # Bright Yellow
    "#FFFF66",  # Light Yellow
    "#FFE55C",  # Golden Yellow
    "#FFD700",  # Gold
    "#FFD700",  # Gold (back to start)
]

FALL_EQUINOX_PALETTE = [
    "#8B4513",  # Saddle Brown
    "#A0522D",  # Sienna
    "#CD853F",  # Peru
    "#D2691E",  # Chocolate
    "#FF8C00",  # Dark Orange
    "#FF7F50",  # Coral
    "#FF6347",  # Tomato
    "#DC143C",  # Crimson
    "#B22222",  # Fire Brick
    "#8B0000",  # Dark Red
    "#654321",  # Dark Brown
    "#8B4513",  # Saddle Brown (back to start)
]

WINTER_SOLSTICE_PALETTE = [
    "#191970",  # Midnight Blue
    "#000080",  # Navy Blue
    "#0000CD",  # Medium Blue
    "#4169E1",  # Royal Blue
    "#6495ED",  # Cornflower Blue
    "#87CEEB",  # Sky Blue
    "#E6E6FA",  # Lavender (peak light)
    "#F0F8FF",  # Alice Blue
    "#FFFFFF",  # White
    "#C0C0C0",  # Silver
    "#708090",  # Slate Gray
    "#191970",  # Midnight Blue (back to start)
]

# Regional Holiday Color Palettes
INDEPENDENCE_DAY_PALETTE = [
    "#000080",  # Navy Blue (flag blue)
    "#0000CC",  # Dark Blue
    "#0033FF",  # Royal Blue
    "#4169E1",  # Royal Blue
    "#87CEEB",  # Sky Blue (transition)
    "#FFFFFF",  # Pure White (flag white)
    "#F0F0F0",  # Light Gray (white emphasis)
    "#FF1A1A",  # Bold Red (vibrant flag red)
    "#FF0000",  # Pure Red (flag red)
    "#DC143C",  # Crimson
    "#B22222",  # Fire Brick (bold red)
    "#000080",  # Navy Blue (back to start)
]

BASTILLE_DAY_PALETTE = [
    "#002654",  # Official French Blue (darker, richer than US blue)
    "#1B365D",  # Deep French Navy
    "#2E4F7F",  # Rich Blue
    "#4169E1",  # Royal Blue (transition)
    "#E8F0FF",  # Very light blue tint
    "#FFFFFF",  # Pure White (French flag blanc)
    "#FAFBFC",  # Ivory white
    "#FFFFFF",  # White emphasis (central to French flag)
    "#FFE8E8",  # Pale rose tint
    "#F5A3A3",  # Light French rose
    "#ED2939",  # Official French Red (deeper, more burgundy)
    "#B91C3C",  # Deep French crimson (darker than US red)
]

BOXING_DAY_PALETTE = [
    "#006400",  # Dark Green (traditional)
    "#228B22",  # Forest Green
    "#32CD32",  # Lime Green
    "#90EE90",  # Light Green
    "#F5F5DC",  # Beige (neutral transition)
    "#FFD700",  # Gold (Boxing Day gifts)
    "#FFF8DC",  # Cornsilk
    "#FFFACD",  # Lemon Chiffon
    "#F0F8FF",  # Alice Blue (winter)
    "#E6E6FA",  # Lavender
    "#C0C0C0",  # Silver
    "#006400",  # Dark Green (back to start)
]

MAY_DAY_PALETTE = [
    "#8B0000",  # Dark Red (workers' movement)
    "#DC143C",  # Crimson
    "#FF0000",  # Red (solidarity)
    "#FF4500",  # Orange Red
    "#FF6347",  # Tomato (transition to spring)
    "#90EE90",  # Light Green (spring renewal)
    "#32CD32",  # Lime Green
    "#00FF00",  # Bright Green
    "#ADFF2F",  # Green Yellow
    "#FFFF00",  # Yellow (spring sunshine)
    "#FFD700",  # Gold
    "#8B0000",  # Dark Red (back to start)
]

DIA_DE_LOS_MUERTOS_PALETTE = [
    "#FF8C00",  # Dark Orange (marigolds)
    "#FFA500",  # Orange
    "#FF7F50",  # Coral
    "#FF69B4",  # Hot Pink (celebration)
    "#FF1493",  # Deep Pink
    "#9932CC",  # Dark Orchid (vibrant purple)
    "#8A2BE2",  # Blue Violet
    "#BA55D3",  # Medium Orchid
    "#DA70D6",  # Orchid
    "#FFD700",  # Gold (celebration)
    "#FFFF00",  # Yellow (joy)
    "#FF8C00",  # Dark Orange (back to start)
]

# Multi-Calendar New Year Palettes
NOWRUZ_PALETTE = [
    "#E6F3FF",  # Very Pale Blue (dawn of spring)
    "#B3E0FF",  # Light Sky Blue
    "#80CCFF",  # Soft Blue (Persian sky)
    "#66FFB3",  # Mint Green (new growth)
    "#80FF80",  # Light Green (spring leaves)
    "#B3FF66",  # Fresh Green (Persian gardens)
    "#E6FF4D",  # Spring Yellow (Persian sun)
    "#FFFF66",  # Bright Yellow (spring equinox light)
    "#FFE066",  # Warm Yellow (Persian gold)
    "#FFD700",  # Gold (Persian tradition)
    "#FFA500",  # Orange (Persian saffron)
    "#E6F3FF",  # Very Pale Blue (back to dawn)
]

SONGKRAN_PALETTE = [
    "#000080",  # Deep Navy (traditional Thai blue)
    "#1E90FF",  # Dodger Blue (water festival)
    "#00BFFF",  # Deep Sky Blue (Thai sky)
    "#87CEEB",  # Sky Blue (water clarity)
    "#B0E0E6",  # Powder Blue (gentle water)
    "#E0F6FF",  # Very Light Blue (water splash)
    "#F0F8FF",  # Alice Blue (pure water)
    "#E6F3FF",  # Very Pale Blue (water mist)
    "#66FFB3",  # Mint Green (spring renewal)
    "#80FF80",  # Light Green (Thai spring)
    "#4169E1",  # Royal Blue (Thai tradition)
    "#000080",  # Deep Navy (back to start)
]

# Variable Date Regional Holidays
THANKSGIVING_PALETTE = [
    "#8B4513",  # Saddle Brown (autumn harvest)
    "#A0522D",  # Sienna
    "#CD853F",  # Peru (golden harvest)
    "#DEB887",  # Burlywood
    "#F4A460",  # Sandy Brown
    "#FFD700",  # Gold (golden corn)
    "#FFA500",  # Orange (pumpkins)
    "#FF8C00",  # Dark Orange
    "#FF6347",  # Tomato (cranberries)
    "#DC143C",  # Crimson (cranberry sauce)
    "#B22222",  # Fire Brick
    "#8B4513",  # Saddle Brown (back to start)
]

GOLDEN_WEEK_PALETTE = [
    "#FF69B4",  # Hot Pink (cherry blossoms)
    "#FFB6C1",  # Light Pink
    "#FFC0CB",  # Pink (sakura)
    "#FFCCCB",  # Light Pink
    "#FFE4E1",  # Misty Rose
    "#F0F8FF",  # Alice Blue (spring sky)
    "#E6E6FA",  # Lavender
    "#DDA0DD",  # Plum
    "#DA70D6",  # Orchid
    "#BA55D3",  # Medium Orchid
    "#9370DB",  # Medium Purple
    "#FF69B4",  # Hot Pink (back to start)
]

BLACK_FRIDAY_PALETTE = [
    "#000000",  # Pure Black (Black Friday theme)
    "#1C1C1C",  # Dark Gray
    "#2F2F2F",  # Medium Dark Gray
    "#FF0000",  # Red (sale prices)
    "#FF4500",  # Orange Red (hot deals)
    "#FFD700",  # Gold (special offers)
    "#FFFF00",  # Yellow (price tags)
    "#FFFFFF",  # White (contrast/excitement)
    "#FF69B4",  # Hot Pink (flash sales)
    "#00FF00",  # Green (savings/money)
    "#696969",  # Dim Gray
    "#000000",  # Pure Black (back to start)
]

# Accent Dot Color Constants - for different styles
ACCENT_DOT_STYLES = {
    "fixed_magenta": "#FF00FF",  # Original magenta (always visible)
    "fixed_cyan": "#00FFFF",  # Cyan alternative
    "fixed_white": "#FFFFFF",  # Classic white
    "fixed_yellow": "#FFFF00",  # High contrast yellow
}

# Adaptive accent dot colors per color scheme
ADAPTIVE_ACCENT_COLORS = {
    "rainbow": "#FF00FF",  # Magenta (good contrast across rainbow)
    "thermal": "#00FFFF",  # Cyan (complements thermal colors)
    "grayscale": "#FFFF00",  # Yellow (high contrast on gray)
    "red": "#00FFFF",  # Cyan (complementary to red)
    "blue": "#FFFF00",  # Yellow (complementary to blue)
    "green": "#FF00FF",  # Magenta (complementary to green)
    "purple": "#00FF00",  # Green (complementary to purple)
    "halloween": "#00FFFF",  # Cyan (contrasts with orange/brown)
    "christmas": "#FFFF00",  # Yellow (contrasts with red/green)
    "passover": "#FFD700",  # Gold (complements blue/white spring theme)
    "hanukkah": "#FFD700",  # Gold (complements blue/white winter theme)
    "newyear": "#FF00FF",  # Magenta (contrasts with gold/silver)
    "spring_equinox": "#8A2BE2",  # Purple (contrasts with light spring colors)
    "summer_solstice": "#0000FF",  # Blue (contrasts with bright yellows)
    "fall_equinox": "#00FFFF",  # Cyan (contrasts with autumn colors)
    "winter_solstice": "#FF4500",  # Orange Red (contrasts with blues/whites)
    "independence_day": "#FFD700",  # Gold (contrasts with red/white/blue)
    "boxing_day": "#FF00FF",  # Magenta (contrasts with green/gold)
    "may_day": "#00FFFF",  # Cyan (contrasts with red/green)
    "dia_de_los_muertos": "#00FF00",  # Green (contrasts with orange/purple)
    "thanksgiving": "#00FFFF",  # Cyan (contrasts with brown/orange harvest colors)
    "golden_week": "#0000FF",  # Blue (contrasts with pink cherry blossom colors)
    "black_friday": "#FFFF00",  # Yellow (contrasts with black, like a price tag)
    "nowruz": "#8A2BE2",  # Purple (contrasts with spring blues/greens/yellows)
    "songkran": "#FFD700",  # Gold (contrasts with water blues)
}

# Contrast-based accent colors (darker/lighter than background)
CONTRAST_ACCENT_COLORS = {
    "rainbow": "#000000",  # Black (darker contrast)
    "thermal": "#FFFFFF",  # White (lighter contrast)
    "grayscale": "#000000",  # Black (darker contrast)
    "red": "#800000",  # Dark red (darker contrast)
    "blue": "#000080",  # Navy (darker contrast)
    "green": "#006400",  # Dark green (darker contrast)
    "purple": "#4B0082",  # Indigo (darker contrast)
    "halloween": "#2F1B14",  # Very dark brown (darker contrast)
    "christmas": "#006400",  # Dark green (darker contrast)
    "passover": "#191970",  # Midnight blue (darker contrast on blue/white)
    "hanukkah": "#191970",  # Midnight blue (darker contrast on blue/white)
    "newyear": "#B8860B",  # Dark golden rod (darker contrast)
    "spring_equinox": "#2E8B57",  # Sea green (darker contrast)
    "summer_solstice": "#B8860B",  # Dark golden rod (darker contrast)
    "fall_equinox": "#8B4513",  # Saddle brown (darker contrast)
    "winter_solstice": "#191970",  # Midnight blue (darker contrast)
    "independence_day": "#000080",  # Navy blue (darker contrast)
    "boxing_day": "#006400",  # Dark green (darker contrast)
    "may_day": "#8B0000",  # Dark red (darker contrast)
    "dia_de_los_muertos": "#8B4513",  # Saddle brown (darker contrast)
    "thanksgiving": "#654321",  # Dark brown (darker contrast)
    "golden_week": "#8B008B",  # Dark magenta (darker contrast)
    "black_friday": "#2F2F2F",  # Dark gray (darker contrast on black theme)
    "nowruz": "#2E8B57",  # Sea green (darker contrast on light spring colors)
    "songkran": "#000080",  # Navy (darker contrast on light water blues)
}

# Calendar conversion functions (borrowed from apps/calendars/calendars.star)

def to_julian_day(day, month, year, calendar):
    """Algorithm E, page 323 - Convert calendar date to Julian day number"""
    year_ = year + calendar[Y] - (calendar[N] + calendar[M] - 1 - month) // calendar[N]
    month_ = (month - calendar[M] + calendar[N]) % calendar[N]
    day_ = day - 1
    c = (calendar[P] * year_ + calendar[Q]) // calendar[R]
    s = calendar[S]
    t = calendar[T]
    if calendar.get(IS_SAKA):
        z = month_ // 6
        s = 31 - z
        t = 5 * z
    d = (s * month_ + t) // calendar[U]
    g = 0
    if calendar.get(IS_GREGORIAN):
        g = 3 * ((year_ + calendar[A]) // 100) // 4 + calendar[G]
    return c + d + day_ - calendar[J] - g

def to_calendar_date(julian_day, calendar):
    """Algorithm F, page 324 - Convert Julian day number to calendar date"""
    g = 0
    if calendar.get(IS_GREGORIAN):
        g = (3 * ((4 * julian_day + calendar[B]) // 146097)) // 4 + calendar[G]
    j_ = julian_day + calendar[J] + g
    year_ = (calendar[R] * j_ + calendar[V]) // calendar[P]

    t_ = ((calendar[R] * j_ + calendar[V]) % calendar[P]) // calendar[R]
    s = calendar[S]
    w = calendar[W]
    if calendar.get(IS_SAKA):
        x = t_ // 365
        z = t_ // 185 - x
        s = 31 - z
        w = -5 * z
        day_ = (6 * x + ((calendar[U] * t_ + w) % s)) // calendar[U]
    else:
        day_ = ((calendar[U] * t_ + w) % s) // calendar[U]
    month_ = (calendar[U] * t_ + w) // s
    day = day_ + 1
    month = ((month_ + calendar[M] - 1) % calendar[N]) + 1
    year = year_ - calendar[Y] + ((calendar[N] + calendar[M] - 1 - month) // calendar[N])
    return day, month, year

def calculate_year_progress_for_calendar(now, calendar_system):
    """Calculate year progress (0.0 to 1.0) for any calendar system"""
    if calendar_system == "Gregorian":
        # Use existing Gregorian calculation for efficiency
        year_start = time.time(year = now.year, month = 1, day = 1, hour = 0, minute = 0, second = 0)
        year_end = time.time(year = now.year + 1, month = 1, day = 1, hour = 0, minute = 0, second = 0)
        year_duration = year_end - year_start
        elapsed = now - year_start
        return float(elapsed.seconds) / float(year_duration.seconds)

    # For other calendar systems, we need to convert dates
    calendar = CALENDAR_SYSTEMS[calendar_system]

    # Convert current Gregorian date to target calendar
    gregorian_julian = to_julian_day(now.day, now.month, now.year, CALENDAR_SYSTEMS["Gregorian"])
    _, _, alt_year = to_calendar_date(gregorian_julian, calendar)

    # Find start of year in this calendar system
    alt_year_start_julian = to_julian_day(1, 1, alt_year, calendar)
    alt_year_end_julian = to_julian_day(1, 1, alt_year + 1, calendar)

    # Calculate progress within the alternative calendar year
    year_length = alt_year_end_julian - alt_year_start_julian
    days_elapsed = gregorian_julian - alt_year_start_julian

    return float(days_elapsed) / float(year_length)

def get_alternative_calendar_date(now, calendar_system):
    """Get current date in alternative calendar system"""
    if calendar_system == "Gregorian":
        return None  # No alternative needed

    calendar = CALENDAR_SYSTEMS[calendar_system]
    gregorian_julian = to_julian_day(now.day, now.month, now.year, CALENDAR_SYSTEMS["Gregorian"])
    alt_day, alt_month, alt_year = to_calendar_date(gregorian_julian, calendar)

    # Simple month names for different calendar systems
    month_names = {
        "Persian": ["Far", "Ord", "Kho", "Tir", "Mor", "Sha", "Meh", "Aba", "Aza", "Dey", "Bah", "Esf", "Adj"],
        "Islamic": ["Muh", "Saf", "Rab I", "Rab II", "Jum I", "Jum II", "Raj", "Sha", "Ram", "Shaw", "Dhu I", "Dhu II"],
        "Thai Buddhist": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        "Ethiopian": ["Mes", "Tik", "Hed", "Tah", "Ter", "Yak", "Mag", "Miy", "Gen", "Sen", "Ham", "Neh", "Pag"],
        "Coptic": ["Tho", "Pao", "Ath", "Koi", "Tyo", "Mec", "Pha", "Pha", "Pas", "Pao", "Epi", "Mes", "Epa"],
    }

    month_name = month_names.get(calendar_system, ["M%d" % i for i in range(1, 14)])[alt_month - 1]
    return "%s %d, %d" % (month_name, alt_day, alt_year)

def main(config):
    # Get user's timezone for automatic date format detection (implements section 5 from TODO)
    timezone = config.get("$tz", "America/New_York")  # Special timezone variable from device

    # Get current time in user's local timezone, or use debug time if provided
    # Note: debug_date has no schema entry (hidden from UI) but works via URL/command line
    debug_date = config.get("debug_date")
    if debug_date:
        # Parse the debug date and use it instead of current time
        # For debug mode, we use a consistent timezone for testing
        now = time.parse_time(debug_date).in_location(timezone)
    else:
        # Use user's timezone for proper localization
        now = time.now().in_location(timezone)

    # Get color scheme and hemisphere settings
    color_scheme = config.get("color_scheme", "rainbow")
    hemisphere = config.get("hemisphere", "northern")
    accent_dot_style = config.get("accent_dot_style", "adaptive")

    # Get date display settings (implements sections 5.1 and 5.2 from TODO)
    date_format = config.get("date_format", "auto")
    language = config.get("language", "auto")

    # Get calendar system setting (implements section 5.4 from TODO)
    calendar_system = config.get("calendar_system", "Gregorian")

    # Check for special date overrides
    enable_special_dates = config.bool("enable_special_dates", True)
    enable_animations = config.bool("enable_animations", True)
    special_override = get_special_date_override(now, enable_special_dates, timezone)

    # Determine which holidays get animations
    animated_holidays = []
    if special_override == "newyears_eve":  # Dec 31 - sparkle animation
        animated_holidays.append("newyears_eve")
    elif special_override == "halloween":  # Oct 31 - flicker animation
        animated_holidays.append("halloween")
    elif special_override == "christmas":  # Dec 25 - snow animation
        animated_holidays.append("christmas")
    elif special_override == "red" and now.month == 2 and now.day == 14:  # Valentine's - hearts animation
        animated_holidays.append("valentine")

    if special_override:
        # Map both New Year's dates to the same color scheme
        if special_override in ["newyears_eve", "newyears_day"]:
            color_scheme = "newyear"
        else:
            color_scheme = special_override

        # For Pride Month, use rainbow but respect hemisphere choice
        if special_override == "pride":
            color_scheme = "rainbow"
            # Keep the user's hemisphere setting - don't override it

    # Calculate year progress (0.0 to 1.0) for selected calendar system
    year_fraction = calculate_year_progress_for_calendar(now, calendar_system)

    # Check if we should show holiday animations
    if animated_holidays and enable_special_dates and enable_animations:
        return create_holiday_animation(animated_holidays[0], year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config)
    else:
        return create_static_year_clock(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config)

def create_static_year_clock(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config):
    """Create the standard static year clock display"""

    # Create the gradient background
    gradient_children = []
    for x in range(64):
        # Calculate position in gradient (0.0 to 1.0)
        pos = x / 63.0

        # Get color for this position (with calendar-specific thermal peak)
        color = get_gradient_color(pos, color_scheme, hemisphere, calendar_system)

        # Create a vertical line for this x position
        gradient_children.append(
            render.Box(
                width = 1,
                height = 32,
                color = color,
            ),
        )

    # Calculate marker position with proper edge handling
    # Map year progress [0.0, 1.0) to marker positions [1, 62]
    # Jan 1st 00:00 → x=1 (left buffer), Dec 31st 23:59 → x=62 (right highlight at x=63)
    marker_x = min(62, int(year_fraction * 62) + 1)

    # Get accent dot color based on style and color scheme
    accent_dot_color = get_accent_dot_color(accent_dot_style, color_scheme)

    # Create the year progress display
    return render.Root(
        child = render.Stack(
            children = [
                # Rainbow gradient background
                render.Row(
                    children = gradient_children,
                ),
                # Dial marker
                render.Stack(
                    children = [
                        # Main dial line (white)
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#FFFFFF",
                            ),
                        ),
                        # Left shadow (darker)
                        render.Padding(
                            pad = (max(0, marker_x - 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#999999",
                            ),
                        ) if marker_x > 0 else render.Box(width = 0, height = 0),
                        # Right highlight (lighter)
                        render.Padding(
                            pad = (min(63, marker_x + 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#CCCCCC",
                            ),
                        ) if marker_x < 63 else render.Box(width = 0, height = 0),
                        # Top and bottom accent dots (now configurable!)
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Column(
                                children = [
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                    render.Box(width = 1, height = 30, color = "#00000000"),  # transparent spacer
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                ],
                            ),
                        ) if accent_dot_style != "none" else render.Box(width = 0, height = 0),
                    ],
                ),
                # Optional date display in bottom corner with automatic timezone-based formatting
                render.Padding(
                    pad = (1, 26, 0, 0),  # Hardcoded x=1 as planned
                    child = render.Column(
                        children = [
                            # Gregorian date (primary)
                            render.Text(
                                content = format_date_with_timezone_detection(now, timezone, date_format, language),
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ),
                            # Alternative calendar date (if different from Gregorian)
                            render.Text(
                                content = get_alternative_calendar_date(now, calendar_system) or "",
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ) if calendar_system != "Gregorian" and get_alternative_calendar_date(now, calendar_system) else render.Box(width = 0, height = 0),
                        ],
                    ),
                ) if config.bool("show_date", False) else render.Box(width = 0, height = 0),
            ],
        ),
    )

def create_new_years_animation(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config):
    """Create animated New Year's display with twinkling sparkles"""

    # Number of animation frames for sparkle effect
    num_frames = 8
    frame_delay = 50  # milliseconds between frames

    # Create list of animation frames
    frames = []

    for frame_idx in range(num_frames):
        # Create the gradient background (same for all frames)
        gradient_children = []
        for x in range(64):
            # Calculate position in gradient (0.0 to 1.0)
            pos = x / 63.0

            # Get color for this position (with calendar-specific thermal peak)
            color = get_gradient_color(pos, color_scheme, hemisphere, calendar_system)

            # Create a vertical line for this x position
            gradient_children.append(
                render.Box(
                    width = 1,
                    height = 32,
                    color = color,
                ),
            )

        # Calculate marker position with proper edge handling
        marker_x = min(62, int(year_fraction * 62) + 1)

        # Get accent dot color based on style and color scheme
        accent_dot_color = get_accent_dot_color(accent_dot_style, color_scheme)

        # Generate sparkles for this frame
        sparkle_children = generate_sparkles_for_frame(frame_idx)

        # Create the frame
        frame = render.Stack(
            children = [
                # Rainbow gradient background
                render.Row(
                    children = gradient_children,
                ),
                # Sparkle overlay
                render.Stack(
                    children = sparkle_children,
                ),
                # Dial marker
                render.Stack(
                    children = [
                        # Main dial line (white)
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#FFFFFF",
                            ),
                        ),
                        # Left shadow (darker)
                        render.Padding(
                            pad = (max(0, marker_x - 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#999999",
                            ),
                        ) if marker_x > 0 else render.Box(width = 0, height = 0),
                        # Right highlight (lighter)
                        render.Padding(
                            pad = (min(63, marker_x + 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#CCCCCC",
                            ),
                        ) if marker_x < 63 else render.Box(width = 0, height = 0),
                        # Top and bottom accent dots
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Column(
                                children = [
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                    render.Box(width = 1, height = 30, color = "#00000000"),  # transparent spacer
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                ],
                            ),
                        ) if accent_dot_style != "none" else render.Box(width = 0, height = 0),
                    ],
                ),
                # Optional date display
                render.Padding(
                    pad = (1, 26, 0, 0),
                    child = render.Column(
                        children = [
                            # Gregorian date (primary)
                            render.Text(
                                content = format_date_with_timezone_detection(now, timezone, date_format, language),
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ),
                            # Alternative calendar date (if different from Gregorian)
                            render.Text(
                                content = get_alternative_calendar_date(now, calendar_system) or "",
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ) if calendar_system != "Gregorian" and get_alternative_calendar_date(now, calendar_system) else render.Box(width = 0, height = 0),
                        ],
                    ),
                ) if config.bool("show_date", False) else render.Box(width = 0, height = 0),
            ],
        )

        frames.append(frame)

    # Return animated root with all frames
    return render.Root(
        delay = frame_delay,
        child = render.Animation(
            children = frames,
        ),
    )

def generate_sparkles_for_frame(frame_idx):
    """Generate sparkle pixels for a specific animation frame"""
    sparkles = []

    # Different sparkle patterns for each frame to create twinkling effect
    # Using frame index as a pseudo-random seed for consistent but varied patterns
    sparkle_patterns = [
        # Frame 0: scattered sparkles
        [(10, 5), (25, 12), (45, 8), (58, 20), (32, 25)],
        # Frame 1: different positions
        [(15, 15), (38, 7), (52, 18), (8, 28), (60, 10)],
        # Frame 2: more sparkles
        [(20, 22), (42, 4), (55, 15), (12, 8), (35, 30), (48, 25)],
        # Frame 3: fewer sparkles
        [(28, 18), (50, 11), (18, 25), (40, 6)],
        # Frame 4: shift pattern
        [(22, 10), (45, 20), (62, 14), (5, 18), (35, 5)],
        # Frame 5: bright moment
        [(30, 16), (46, 9), (58, 25), (15, 12), (38, 28), (52, 5)],
        # Frame 6: fade
        [(25, 20), (50, 15), (10, 30), (40, 8)],
        # Frame 7: minimal
        [(35, 12), (55, 22), (20, 6)],
    ]

    # Get sparkle positions for this frame
    frame_sparkles = sparkle_patterns[frame_idx % len(sparkle_patterns)]

    # Create sparkle pixels with different intensities
    sparkle_colors = ["#FFFFFF", "#FFFF99", "#FFD700", "#FFFFFF"]  # White, light yellow, gold, white

    for i, (x, y) in enumerate(frame_sparkles):
        # Vary sparkle intensity based on position in sequence
        color = sparkle_colors[i % len(sparkle_colors)]

        sparkles.append(
            render.Padding(
                pad = (x, y, 0, 0),
                child = render.Box(
                    width = 1,
                    height = 1,
                    color = color,
                ),
            ),
        )

    return sparkles

def create_holiday_animation(holiday_type, year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config):
    """Create animated holiday display - dispatcher for different holiday types"""

    if holiday_type == "newyears_eve":
        return create_new_years_animation(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config)
    elif holiday_type == "halloween":
        return create_halloween_flicker_animation(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config)
    elif holiday_type == "christmas":
        return create_christmas_snow_animation(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config)
    elif holiday_type == "valentine":
        return create_valentine_hearts_animation(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config)
    else:
        # Fallback to static display
        return create_static_year_clock(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config)

def create_halloween_flicker_animation(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config):
    """Create animated Halloween display with orange/black flickering effect"""

    # Number of animation frames for flicker effect
    num_frames = 6
    frame_delay = 120  # slower than sparkles for spooky effect

    # Create list of animation frames
    frames = []

    for frame_idx in range(num_frames):
        # Create the gradient background with flicker effect
        gradient_children = []
        for x in range(64):
            # Calculate position in gradient (0.0 to 1.0)
            pos = x / 63.0

            # Get base color for this position
            base_color = get_gradient_color(pos, color_scheme, hemisphere, calendar_system)

            # Apply flicker effect - darken certain frames to create spooky flicker
            flicker_intensity = [1.0, 0.7, 1.0, 0.5, 1.0, 0.8][frame_idx]

            # Parse base color and apply flicker
            base_rgb = hex_to_rgb(base_color)
            flickered_color = rgb_to_hex([
                int(base_rgb[0] * flicker_intensity),
                int(base_rgb[1] * flicker_intensity),
                int(base_rgb[2] * flicker_intensity),
            ])

            # Create a vertical line for this x position
            gradient_children.append(
                render.Box(
                    width = 1,
                    height = 32,
                    color = flickered_color,
                ),
            )

        # Calculate marker position with proper edge handling
        marker_x = min(62, int(year_fraction * 62) + 1)

        # Get accent dot color based on style and color scheme
        accent_dot_color = get_accent_dot_color(accent_dot_style, color_scheme)

        # Generate spooky flicker overlay for this frame
        flicker_children = generate_halloween_flicker_for_frame(frame_idx)

        # Create the frame
        frame = render.Stack(
            children = [
                # Halloween gradient background with flicker
                render.Row(
                    children = gradient_children,
                ),
                # Flicker overlay
                render.Stack(
                    children = flicker_children,
                ),
                # Dial marker
                render.Stack(
                    children = [
                        # Main dial line (white)
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#FFFFFF",
                            ),
                        ),
                        # Left shadow (darker)
                        render.Padding(
                            pad = (max(0, marker_x - 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#999999",
                            ),
                        ) if marker_x > 0 else render.Box(width = 0, height = 0),
                        # Right highlight (lighter)
                        render.Padding(
                            pad = (min(63, marker_x + 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#CCCCCC",
                            ),
                        ) if marker_x < 63 else render.Box(width = 0, height = 0),
                        # Top and bottom accent dots
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Column(
                                children = [
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                    render.Box(width = 1, height = 30, color = "#00000000"),  # transparent spacer
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                ],
                            ),
                        ) if accent_dot_style != "none" else render.Box(width = 0, height = 0),
                    ],
                ),
                # Optional date display
                render.Padding(
                    pad = (1, 26, 0, 0),
                    child = render.Column(
                        children = [
                            # Gregorian date (primary)
                            render.Text(
                                content = format_date_with_timezone_detection(now, timezone, date_format, language),
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ),
                            # Alternative calendar date (if different from Gregorian)
                            render.Text(
                                content = get_alternative_calendar_date(now, calendar_system) or "",
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ) if calendar_system != "Gregorian" and get_alternative_calendar_date(now, calendar_system) else render.Box(width = 0, height = 0),
                        ],
                    ),
                ) if config.bool("show_date", False) else render.Box(width = 0, height = 0),
            ],
        )

        frames.append(frame)

    # Return animated root with all frames
    return render.Root(
        delay = frame_delay,
        child = render.Animation(
            children = frames,
        ),
    )

def generate_halloween_flicker_for_frame(frame_idx):
    """Generate flickering overlay pixels for a specific Halloween animation frame"""
    flickers = []

    # Different flicker patterns for each frame to create spooky effect
    # Some frames have more random flickers, others are calmer
    flicker_patterns = [
        # Frame 0: scattered orange flickers
        [(12, 8), (28, 15), (45, 5), (58, 22)],
        # Frame 1: minimal flickers
        [(20, 18), (40, 10)],
        # Frame 2: intense flicker
        [(8, 12), (25, 6), (35, 20), (48, 14), (60, 8), (52, 25)],
        # Frame 3: calm
        [(30, 16), (50, 12)],
        # Frame 4: medium flicker
        [(15, 22), (38, 8), (55, 18)],
        # Frame 5: spooky finale
        [(22, 5), (42, 25), (18, 14), (45, 9)],
    ]

    # Get flicker positions for this frame
    frame_flickers = flicker_patterns[frame_idx % len(flicker_patterns)]

    # Create flicker pixels with orange/black colors
    flicker_colors = ["#FF6600", "#FF4500", "#1A0A00", "#FF8C00"]  # Orange, orange-red, dark brown, dark orange

    for i, (x, y) in enumerate(frame_flickers):
        # Vary flicker color based on position
        color = flicker_colors[i % len(flicker_colors)]

        flickers.append(
            render.Padding(
                pad = (x, y, 0, 0),
                child = render.Box(
                    width = 1,
                    height = 1,
                    color = color,
                ),
            ),
        )

    return flickers

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple"""
    hex_color = hex_color.lstrip("#")
    return [int(hex_color[i:i + 2], 16) for i in (0, 2, 4)]

def rgb_to_hex(rgb):
    """Convert RGB tuple to hex color"""
    r = max(0, min(255, rgb[0]))
    g = max(0, min(255, rgb[1]))
    b = max(0, min(255, rgb[2]))

    # Convert to hex manually since Starlark doesn't support format specifiers
    def to_hex(n):
        hex_chars = "0123456789abcdef"
        if n < 16:
            return "0" + hex_chars[n]
        return hex_chars[n // 16] + hex_chars[n % 16]

    return "#" + to_hex(r) + to_hex(g) + to_hex(b)

def create_christmas_snow_animation(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config):
    """Create animated Christmas display with falling snow effect"""

    # Number of animation frames for snow effect
    num_frames = 8
    frame_delay = 100  # Smooth snow falling

    # Create list of animation frames
    frames = []

    for frame_idx in range(num_frames):
        # Create the gradient background (Christmas colors)
        gradient_children = []
        for x in range(64):
            # Calculate position in gradient (0.0 to 1.0)
            pos = x / 63.0

            # Get color for this position
            color = get_gradient_color(pos, color_scheme, hemisphere, calendar_system)

            # Create a vertical line for this x position
            gradient_children.append(
                render.Box(
                    width = 1,
                    height = 32,
                    color = color,
                ),
            )

        # Calculate marker position with proper edge handling
        marker_x = min(62, int(year_fraction * 62) + 1)

        # Get accent dot color based on style and color scheme
        accent_dot_color = get_accent_dot_color(accent_dot_style, color_scheme)

        # Generate snow for this frame
        snow_children = generate_christmas_snow_for_frame(frame_idx)

        # Create the frame
        frame = render.Stack(
            children = [
                # Christmas gradient background
                render.Row(
                    children = gradient_children,
                ),
                # Snow overlay
                render.Stack(
                    children = snow_children,
                ),
                # Dial marker
                render.Stack(
                    children = [
                        # Main dial line (white)
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#FFFFFF",
                            ),
                        ),
                        # Left shadow (darker)
                        render.Padding(
                            pad = (max(0, marker_x - 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#999999",
                            ),
                        ) if marker_x > 0 else render.Box(width = 0, height = 0),
                        # Right highlight (lighter)
                        render.Padding(
                            pad = (min(63, marker_x + 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#CCCCCC",
                            ),
                        ) if marker_x < 63 else render.Box(width = 0, height = 0),
                        # Top and bottom accent dots
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Column(
                                children = [
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                    render.Box(width = 1, height = 30, color = "#00000000"),  # transparent spacer
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                ],
                            ),
                        ) if accent_dot_style != "none" else render.Box(width = 0, height = 0),
                    ],
                ),
                # Optional date display
                render.Padding(
                    pad = (1, 26, 0, 0),
                    child = render.Column(
                        children = [
                            # Gregorian date (primary)
                            render.Text(
                                content = format_date_with_timezone_detection(now, timezone, date_format, language),
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ),
                            # Alternative calendar date (if different from Gregorian)
                            render.Text(
                                content = get_alternative_calendar_date(now, calendar_system) or "",
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ) if calendar_system != "Gregorian" and get_alternative_calendar_date(now, calendar_system) else render.Box(width = 0, height = 0),
                        ],
                    ),
                ) if config.bool("show_date", False) else render.Box(width = 0, height = 0),
            ],
        )

        frames.append(frame)

    # Return animated root with all frames
    return render.Root(
        delay = frame_delay,
        child = render.Animation(
            children = frames,
        ),
    )

def generate_christmas_snow_for_frame(frame_idx):
    """Generate falling snow pixels for a specific Christmas animation frame"""
    snow = []

    # Different snow patterns for each frame to create falling effect
    # Snow "falls" by appearing at different Y positions across frames
    snow_patterns = [
        # Frame 0: snow at top
        [(8, 2), (15, 1), (28, 3), (35, 1), (42, 2), (55, 3), (62, 1)],
        # Frame 1: snow falling
        [(8, 5), (15, 4), (28, 6), (35, 4), (42, 5), (55, 6), (62, 4), (12, 1), (25, 2), (48, 1)],
        # Frame 2: snow continues falling
        [(8, 8), (15, 7), (28, 9), (35, 7), (42, 8), (55, 9), (62, 7), (12, 4), (25, 5), (48, 4), (5, 2), (38, 1)],
        # Frame 3: mid fall
        [(8, 11), (15, 10), (28, 12), (35, 10), (42, 11), (55, 12), (62, 10), (12, 7), (25, 8), (48, 7), (5, 5), (38, 4)],
        # Frame 4: continuing to fall
        [(8, 14), (15, 13), (28, 15), (35, 13), (42, 14), (55, 15), (62, 13), (12, 10), (25, 11), (48, 10), (5, 8), (38, 7), (20, 2), (52, 3)],
        # Frame 5: lower snow
        [(8, 17), (15, 16), (28, 18), (35, 16), (42, 17), (55, 18), (62, 16), (12, 13), (25, 14), (48, 13), (5, 11), (38, 10), (20, 5), (52, 6)],
        # Frame 6: near bottom
        [(8, 20), (15, 19), (28, 21), (35, 19), (42, 20), (55, 21), (62, 19), (12, 16), (25, 17), (48, 16), (5, 14), (38, 13), (20, 8), (52, 9)],
        # Frame 7: at bottom, new snow at top
        [(8, 23), (15, 22), (28, 24), (35, 22), (42, 23), (55, 24), (62, 22), (12, 19), (25, 20), (48, 19), (5, 17), (38, 16), (20, 11), (52, 12), (10, 1), (30, 2), (50, 1)],
    ]

    # Get snow positions for this frame
    frame_snow = snow_patterns[frame_idx % len(snow_patterns)]

    # Create snow pixels with white/light blue colors
    snow_colors = ["#FFFFFF", "#F0F8FF", "#E6F3FF", "#FFFAFA"]  # White, alice blue, very light blue, snow white

    for i, (x, y) in enumerate(frame_snow):
        # Keep snow within bounds
        if (0 <= x and x < 64) and (0 <= y and y < 32):
            # Vary snow color slightly
            color = snow_colors[i % len(snow_colors)]

            snow.append(
                render.Padding(
                    pad = (x, y, 0, 0),
                    child = render.Box(
                        width = 1,
                        height = 1,
                        color = color,
                    ),
                ),
            )

    return snow

def create_valentine_hearts_animation(year_fraction, color_scheme, hemisphere, calendar_system, accent_dot_style, now, timezone, date_format, language, config):
    """Create animated Valentine's display with pulsing hearts effect"""

    # Number of animation frames for heart pulsing effect
    num_frames = 6
    frame_delay = 150  # Slower, romantic pulse

    # Create list of animation frames
    frames = []

    for frame_idx in range(num_frames):
        # Create the gradient background (red/pink for Valentine's)
        gradient_children = []
        for x in range(64):
            # Calculate position in gradient (0.0 to 1.0)
            pos = x / 63.0

            # Get color for this position
            color = get_gradient_color(pos, color_scheme, hemisphere, calendar_system)

            # Create a vertical line for this x position
            gradient_children.append(
                render.Box(
                    width = 1,
                    height = 32,
                    color = color,
                ),
            )

        # Calculate marker position with proper edge handling
        marker_x = min(62, int(year_fraction * 62) + 1)

        # Get accent dot color based on style and color scheme
        accent_dot_color = get_accent_dot_color(accent_dot_style, color_scheme)

        # Generate hearts for this frame
        heart_children = generate_valentine_hearts_for_frame(frame_idx)

        # Create the frame
        frame = render.Stack(
            children = [
                # Valentine gradient background
                render.Row(
                    children = gradient_children,
                ),
                # Hearts overlay
                render.Stack(
                    children = heart_children,
                ),
                # Dial marker
                render.Stack(
                    children = [
                        # Main dial line (white)
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#FFFFFF",
                            ),
                        ),
                        # Left shadow (darker)
                        render.Padding(
                            pad = (max(0, marker_x - 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#999999",
                            ),
                        ) if marker_x > 0 else render.Box(width = 0, height = 0),
                        # Right highlight (lighter)
                        render.Padding(
                            pad = (min(63, marker_x + 1), 0, 0, 0),
                            child = render.Box(
                                width = 1,
                                height = 32,
                                color = "#CCCCCC",
                            ),
                        ) if marker_x < 63 else render.Box(width = 0, height = 0),
                        # Top and bottom accent dots
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Column(
                                children = [
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                    render.Box(width = 1, height = 30, color = "#00000000"),  # transparent spacer
                                    render.Box(width = 1, height = 1, color = accent_dot_color),
                                ],
                            ),
                        ) if accent_dot_style != "none" else render.Box(width = 0, height = 0),
                    ],
                ),
                # Optional date display
                render.Padding(
                    pad = (1, 26, 0, 0),
                    child = render.Column(
                        children = [
                            # Gregorian date (primary)
                            render.Text(
                                content = format_date_with_timezone_detection(now, timezone, date_format, language),
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ),
                            # Alternative calendar date (if different from Gregorian)
                            render.Text(
                                content = get_alternative_calendar_date(now, calendar_system) or "",
                                font = "tom-thumb",
                                color = get_date_color(color_scheme, hemisphere),
                            ) if calendar_system != "Gregorian" and get_alternative_calendar_date(now, calendar_system) else render.Box(width = 0, height = 0),
                        ],
                    ),
                ) if config.bool("show_date", False) else render.Box(width = 0, height = 0),
            ],
        )

        frames.append(frame)

    # Return animated root with all frames
    return render.Root(
        delay = frame_delay,
        child = render.Animation(
            children = frames,
        ),
    )

def generate_valentine_hearts_for_frame(frame_idx):
    """Generate pulsing heart pixels for a specific Valentine's animation frame"""
    hearts = []

    # Heart shapes using simple pixel patterns (since we can't draw curves)
    # We'll use different intensities to simulate pulsing
    heart_positions = [
        # Small hearts scattered around
        (12, 8),
        (28, 15),
        (45, 5),
        (58, 20),  # Single pixel hearts
        (20, 25),
        (40, 10),
        (55, 18),  # More single pixel hearts
    ]

    # Pulsing effect - hearts get brighter/dimmer across frames
    pulse_intensities = [0.6, 0.8, 1.0, 0.8, 0.6, 0.4]  # Smooth pulse
    intensity = pulse_intensities[frame_idx % len(pulse_intensities)]

    # Heart colors with varying intensities
    base_colors = ["#FF1493", "#FF69B4", "#FFB6C1", "#FF6347"]  # Deep pink, hot pink, light pink, tomato

    for i, (x, y) in enumerate(heart_positions):
        # Apply pulse intensity to color
        base_color = base_colors[i % len(base_colors)]
        base_rgb = hex_to_rgb(base_color)
        pulsed_color = rgb_to_hex([
            int(base_rgb[0] * intensity),
            int(base_rgb[1] * intensity),
            int(base_rgb[2] * intensity),
        ])

        hearts.append(
            render.Padding(
                pad = (x, y, 0, 0),
                child = render.Box(
                    width = 1,
                    height = 1,
                    color = pulsed_color,
                ),
            ),
        )

        # Add some larger heart shapes (2x2 pixels) for variety
        if i < 3:  # Only first 3 hearts get the larger treatment
            # Try to add a second pixel to create larger hearts
            if x + 1 < 64:  # Make sure we stay in bounds
                hearts.append(
                    render.Padding(
                        pad = (x + 1, y, 0, 0),
                        child = render.Box(
                            width = 1,
                            height = 1,
                            color = pulsed_color,
                        ),
                    ),
                )

    return hearts

def get_special_date_override(now, enable_special_dates, timezone_name):
    """
    Detect if current date falls on a special date and return override color scheme.
    Returns None if no special date applies or if special dates are disabled.
    Regional holidays are filtered by timezone for cultural relevance.
    """
    if not enable_special_dates:
        return None

    month = now.month
    day = now.day

    # Valentine's Day (Feb 14) - Override to red spectrum
    if month == 2 and day == 14:
        return "red"

    # St. Patrick's Day (Mar 17) - Override to green spectrum (Irish diaspora only)
    if month == 3 and day == 17 and is_irish_diaspora_timezone(timezone_name):
        return "green"

    # Passover (Apr 23) - Override to blue/white/gold spring theme (US/Canada/Western only)
    if month == 4 and day == 23 and is_western_jewish_timezone(timezone_name):
        return "passover"

    # Halloween (Oct 31) - Override to orange/black gradient (US/Canada/Ireland/UK only)
    if month == 10 and day == 31 and is_halloween_timezone(timezone_name):
        return "halloween"

    # Christmas (Dec 25) - Override to red/green gradient
    if month == 12 and day == 25:
        return "christmas"

    # Hanukkah (Dec 27) - Override to blue/white/gold Festival of Lights theme (US/Canada/Western only)
    if month == 12 and day == 27 and is_western_jewish_timezone(timezone_name):
        return "hanukkah"

    # New Year's Eve (Dec 31) - Override to gold/silver gradient WITH sparkle animation
    if month == 12 and day == 31:
        return "newyears_eve"

    # New Year's Day (Jan 1) - Override to gold/silver gradient WITHOUT animation (chill recovery)
    if month == 1 and day == 1:
        return "newyears_day"

    # Pride Month (June) - Override to rainbow but respect hemisphere setting
    if month == 6:
        return "pride"

    # Astronomical Events - Special color themes for seasonal markers
    # Spring Equinox (Mar 20) - Fresh spring colors
    if month == 3 and day == 20:
        return "spring_equinox"

    # Summer Solstice (Jun 21) - Bright solar colors
    if month == 6 and day == 21:
        return "summer_solstice"

    # Fall Equinox (Sep 22) - Rich autumn colors
    if month == 9 and day == 22:
        return "fall_equinox"

    # Winter Solstice (Dec 21) - Deep winter colors
    if month == 12 and day == 21:
        return "winter_solstice"

    # Multi-Calendar New Year Celebrations

    # Persian New Year - Nowruz (Mar 20-21) - Spring equinox celebration
    if (month == 3 and (day == 20 or day == 21)) and is_persian_timezone(timezone_name):
        return "nowruz"

    # Thai New Year - Songkran (Apr 13-15) - Water festival
    if (month == 4 and (day >= 13 and day <= 15)) and is_thai_timezone(timezone_name):
        return "songkran"

    # Regional Holidays - Fixed Date Celebrations (timezone-filtered for cultural relevance)

    # Independence Day (Jul 4) - North American (US) patriotic colors
    if month == 7 and day == 4 and is_us_timezone(timezone_name):
        return "independence_day"

    # Bastille Day (Jul 14) - French national day with tricolor
    if month == 7 and day == 14 and is_french_timezone(timezone_name):
        return "bastille_day"

    # Boxing Day (Dec 26) - European/Commonwealth post-Christmas tradition
    if month == 12 and day == 26 and is_commonwealth_timezone(timezone_name):
        return "boxing_day"

    # May Day (May 1) - European/International workers' day + spring celebration
    # Note: US doesn't traditionally celebrate May Day as workers' holiday
    if month == 5 and day == 1 and is_may_day_timezone(timezone_name):
        return "may_day"

    # Día de los Muertos (Nov 1-2) - Latin American celebration of life
    if month == 11 and (day == 1 or day == 2) and is_latin_american_timezone(timezone_name):
        return "dia_de_los_muertos"

    # Variable Date Regional Holidays

    # Thanksgiving (4th Thursday in November) - US holiday
    if month == 11 and is_us_timezone(timezone_name):
        thanksgiving_day = calculate_thanksgiving(now.year)
        if day == thanksgiving_day:
            return "thanksgiving"

    # Black Friday (day after Thanksgiving) - US shopping holiday
    if is_us_timezone(timezone_name):
        black_friday_day, black_friday_month = calculate_black_friday(now.year)
        if month == black_friday_month and day == black_friday_day:
            return "black_friday"

    # Golden Week (April 29 - May 5) - Japanese holiday period
    if is_golden_week_date(month, day) and timezone_name.startswith("Asia/") and "Tokyo" in timezone_name:
        return "golden_week"

    return None

def is_us_timezone(timezone_name):
    """Check if timezone is in United States for Independence Day"""
    us_patterns = [
        "America/New_York",
        "America/Chicago",
        "America/Denver",
        "America/Los_Angeles",
        "US/Eastern",
        "US/Central",
        "US/Mountain",
        "US/Pacific",
        "America/Phoenix",
        "America/Anchorage",
        "Pacific/Honolulu",
    ]

    # Mexican timezones to exclude
    mexico_patterns = [
        "America/Tijuana",
        "America/Hermosillo",
        "America/Mazatlan",
        "America/Ciudad_Juarez",
        "America/Chihuahua",
        "America/Mexico_City",
        "America/Ojinaga",
        "America/Matamoros",
        "America/Cancun",
        "America/Bahia_Banderas",
        "America/Monterrey",
        "America/Merida",
    ]

    # Check if it's a known Mexican timezone
    if timezone_name in mexico_patterns:
        return False

    return timezone_name in us_patterns or timezone_name.startswith("America/")

def is_french_timezone(timezone_name):
    """Check if timezone is in France or Francophone regions for Bastille Day"""
    french_patterns = [
        "Europe/Paris",
        "Europe/Monaco",
        "America/Cayenne",  # French Guiana
        "America/Guadeloupe",
        "America/Martinique",
        "America/St_Barthelemy",
        "America/St_Pierre_and_Miquelon",
        "Indian/Reunion",
        "Indian/Mayotte",
        "Pacific/Noumea",  # New Caledonia
        "Pacific/Tahiti",  # French Polynesia
    ]
    return timezone_name in french_patterns or "French" in timezone_name

def is_commonwealth_timezone(timezone_name):
    """Check if timezone is in Europe or Commonwealth countries for Boxing Day"""
    commonwealth_patterns = ["Europe/", "Canada/", "Australia/", "Pacific/Auckland", "Africa/Johannesburg"]
    for pattern in commonwealth_patterns:
        if timezone_name.startswith(pattern):
            return True
    return timezone_name in ["GMT", "UTC"]

def is_may_day_timezone(timezone_name):
    """Check if timezone celebrates May Day as workers' holiday (Europe, not US)"""

    # Europe celebrates May Day, but US traditionally doesn't (has Labor Day in September)
    if timezone_name.startswith("Europe/"):
        return True

    # Some other international locations that celebrate May Day
    may_day_locations = ["Asia/Manila", "Africa/Cairo", "Australia/", "Canada/"]
    for location in may_day_locations:
        if timezone_name.startswith(location):
            return True
    return False

def is_latin_american_timezone(timezone_name):
    """Check if timezone is in Latin America for Día de los Muertos"""

    # Mexico and Central/South America
    latin_patterns = [
        "America/Mexico",
        "America/Guatemala",
        "America/Bogota",
        "America/Lima",
        "America/Santiago",
        "America/Argentina",
        "America/Sao_Paulo",
    ]
    for pattern in latin_patterns:
        if timezone_name.startswith(pattern):
            return True
    return False

def is_halloween_timezone(timezone_name):
    """Check if timezone celebrates Halloween (US/Canada/Ireland/UK only)"""

    # Halloween is primarily celebrated in Anglo-Saxon cultures
    halloween_patterns = [
        "America/",  # United States and Canada (North America)
        "US/",  # US timezone aliases
        "Canada/",  # Canadian timezones
        "Europe/Dublin",  # Ireland
        "Europe/London",  # United Kingdom
        "Europe/Belfast",  # Northern Ireland
        "Europe/Edinburgh",  # Scotland
        "Europe/Cardiff",  # Wales
        "Europe/Isle_of_Man",  # Isle of Man
        "Europe/Jersey",  # Jersey
        "Europe/Guernsey",  # Guernsey
        "Atlantic/Reykjavik",  # Iceland (culturally similar)
    ]

    # Exclude Mexico from Americas (Halloween not traditionally celebrated)
    mexican_patterns = [
        "America/Tijuana",
        "America/Hermosillo",
        "America/Mazatlan",
        "America/Ciudad_Juarez",
        "America/Chihuahua",
        "America/Mexico_City",
        "America/Ojinaga",
        "America/Matamoros",
        "America/Cancun",
        "America/Bahia_Banderas",
        "America/Monterrey",
        "America/Merida",
    ]

    # Check if it's Mexican timezone (exclude these)
    if timezone_name in mexican_patterns:
        return False

    # Check if it matches Halloween-celebrating regions
    for pattern in halloween_patterns:
        if timezone_name.startswith(pattern) or timezone_name == pattern:
            return True
    return False

def is_irish_diaspora_timezone(timezone_name):
    """Check if timezone is in Irish diaspora regions for St. Patrick's Day"""

    # Irish diaspora primarily in Ireland, UK, US, Canada, Australia
    irish_diaspora_patterns = [
        # Ireland and UK
        "Europe/Dublin",  # Ireland
        "Europe/London",  # United Kingdom
        "Europe/Belfast",  # Northern Ireland
        "Europe/Edinburgh",  # Scotland
        "Europe/Cardiff",  # Wales

        # North America (large Irish populations)
        "America/",  # United States and Canada
        "US/",  # US timezone aliases
        "Canada/",  # Canadian timezones

        # Australia and New Zealand (significant Irish heritage)
        "Australia/",  # Australia
        "Pacific/Auckland",  # New Zealand

        # Argentina (some Irish settlement)
        "America/Argentina/Buenos_Aires",
    ]

    # Exclude Mexico and most of Latin America (limited Irish cultural influence)
    mexican_latin_patterns = [
        "America/Tijuana",
        "America/Hermosillo",
        "America/Mazatlan",
        "America/Ciudad_Juarez",
        "America/Chihuahua",
        "America/Mexico_City",
        "America/Ojinaga",
        "America/Matamoros",
        "America/Cancun",
        "America/Bahia_Banderas",
        "America/Monterrey",
        "America/Merida",
        "America/Guatemala",
        "America/Bogota",
        "America/Lima",
        "America/Santiago",
        "America/Sao_Paulo",
        "America/Caracas",
    ]

    # Check if it's a region with limited Irish cultural influence
    for excluded in mexican_latin_patterns:
        if timezone_name.startswith(excluded) or timezone_name == excluded:
            return False

    # Check if it matches Irish diaspora regions
    for pattern in irish_diaspora_patterns:
        if timezone_name.startswith(pattern) or timezone_name == pattern:
            return True
    return False

def is_western_jewish_timezone(timezone_name):
    """Check if timezone is in Western regions where Jewish holidays are widely recognized"""

    # Regions with significant Jewish populations and cultural recognition
    western_jewish_patterns = [
        # North America (large Jewish populations)
        "America/",  # United States and Canada
        "US/",  # US timezone aliases
        "Canada/",  # Canadian timezones

        # Western Europe (significant Jewish communities)
        "Europe/London",  # United Kingdom
        "Europe/Paris",  # France
        "Europe/Berlin",  # Germany
        "Europe/Vienna",  # Austria
        "Europe/Zurich",  # Switzerland
        "Europe/Amsterdam",  # Netherlands
        "Europe/Brussels",  # Belgium
        "Europe/Stockholm",  # Sweden
        "Europe/Oslo",  # Norway
        "Europe/Copenhagen",  # Denmark
        "Europe/Rome",  # Italy

        # Australia and New Zealand (Jewish communities)
        "Australia/",  # Australia
        "Pacific/Auckland",  # New Zealand

        # Israel (obviously)
        "Asia/Jerusalem",  # Israel/Palestine

        # South Africa (significant Jewish community)
        "Africa/Johannesburg",  # South Africa
    ]

    # Exclude regions with limited Jewish cultural presence
    limited_jewish_patterns = [
        "America/Tijuana",
        "America/Mexico_City",
        "America/Cancun",
        "America/Guatemala",
        "America/Bogota",
        "America/Lima",
        "America/Santiago",
        "America/Caracas",
        "America/Sao_Paulo",  # Brazil has Jewish communities but Hanukkah is summer there
    ]

    # Check if it's a region with limited Jewish cultural recognition
    for excluded in limited_jewish_patterns:
        if timezone_name.startswith(excluded) or timezone_name == excluded:
            return False

    # Check if it matches Western Jewish community regions
    for pattern in western_jewish_patterns:
        if timezone_name.startswith(pattern) or timezone_name == pattern:
            return True
    return False

def calculate_thanksgiving(year):
    """Dynamically calculate Thanksgiving date (4th Thursday in November) for any year"""

    # Use the approach from PR #2872: work backwards from November 30th
    nov_30 = time.time(year = year, month = 11, day = 30)

    # Get day of week using humanize (0=Sunday, 1=Monday, ..., 4=Thursday, 5=Friday, 6=Saturday)
    day_of_week = humanize.day_of_week(nov_30)

    # Calculate days back from Nov 30 to the 4th Thursday
    # Thursday is day 4 in humanize numbering
    calc = day_of_week - 4
    if calc >= 0:
        # Nov 30 is Thursday or later in week, simple subtraction
        day = 30 - calc
    else:
        # Nov 30 is earlier than Thursday, need to go back further
        day = 30 - (calc + 7)

    return day

def calculate_golden_week_start():
    """Calculate Golden Week start date (April 29 - Showa Day)"""

    # Golden Week runs April 29 - May 5 (approximately)
    # April 29 is Showa Day (always the start)
    return 29  # Always April 29th

def calculate_black_friday(year):
    """Calculate Black Friday date (day after Thanksgiving) for given year"""

    # Black Friday is always the day after Thanksgiving (4th Thursday)
    thanksgiving_day = calculate_thanksgiving(year)
    black_friday_day = thanksgiving_day + 1

    # Handle month rollover (if Thanksgiving is November 30, Black Friday is December 1)
    if black_friday_day > 30:  # November has 30 days
        return 1, 12  # December 1st
    else:
        return black_friday_day, 11  # Still November

def is_golden_week_date(month, day):
    """Check if date falls within Golden Week period (April 29 - May 5)"""
    if month == 4 and day >= 29:
        return True
    if month == 5 and day <= 5:
        return True
    return False

def is_persian_timezone(timezone_name):
    """Check if timezone is in Persian/Iranian regions for Nowruz celebration"""
    persian_patterns = [
        "Asia/Tehran",  # Iran
        "Asia/Kabul",  # Afghanistan
        "Asia/Dushanbe",  # Tajikistan
        "Asia/Samarkand",  # Uzbekistan (some Persian influence)
        "Asia/Tashkent",  # Uzbekistan
        "Asia/Bishkek",  # Kyrgyzstan (some Persian influence)
        "Asia/Almaty",  # Kazakhstan (some Persian influence)
        "Asia/Baku",  # Azerbaijan (Persian cultural ties)
        "Asia/Yerevan",  # Armenia (some Persian influence)
    ]

    return timezone_name in persian_patterns or timezone_name.startswith("Asia/Tehran")

def is_thai_timezone(timezone_name):
    """Check if timezone is in Thai regions for Songkran celebration"""
    thai_patterns = [
        "Asia/Bangkok",  # Thailand (main timezone)
        "Asia/Phnom_Penh",  # Cambodia (similar water festival)
        "Asia/Vientiane",  # Laos (similar water festival)
        "Asia/Yangon",  # Myanmar (similar water festival - Thingyan)
    ]

    return timezone_name in thai_patterns or timezone_name.startswith("Asia/Bangkok")

def get_date_color(color_scheme, hemisphere):
    """Get appropriate date text color based on color scheme and hemisphere"""

    if color_scheme == "rainbow":
        if hemisphere == "northern":
            return "#000000"  # Black text for better contrast on summer yellows/oranges
        else:
            return "#000000"  # Black text for better contrast on bright rainbow colors
    elif color_scheme == "thermal":
        if hemisphere == "northern":
            return "#000000"  # Black text for better contrast on thermal colors (includes light blues/pinks)
        else:
            return "#FFFFFF"  # White text for better contrast on thermal colors (includes light blues/pinks)
    elif color_scheme == "grayscale":
        return "#000000"  # Black text for contrast on gray gradients
    elif color_scheme == "red":
        return "#FFFFFF"  # White text for contrast on red backgrounds
    elif color_scheme == "blue":
        if hemisphere == "northern":
            return "#FFFFFF"  # White text for contrast on darker blue backgrounds
        else:
            return "#000000"  # Black text for better contrast on lighter blue areas (southern)
    elif color_scheme == "green":
        return "#000000"  # Black text for contrast on green backgrounds
    elif color_scheme == "purple":
        return "#000000"  # Black text for better contrast on light purple areas
    elif color_scheme == "halloween":
        return "#FFFFFF"  # White text for contrast on dark orange/brown backgrounds
    elif color_scheme == "christmas":
        return "#000000"  # Black text for contrast on green/red backgrounds
    elif color_scheme == "newyear":
        return "#000000"  # Black text for contrast on gold/silver backgrounds
    elif color_scheme == "spring_equinox":
        return "#000000"  # Black text for contrast on light spring colors
    elif color_scheme == "summer_solstice":
        return "#000000"  # Black text for contrast on bright solar colors
    elif color_scheme == "fall_equinox":
        return "#FFFFFF"  # White text for contrast on dark autumn colors
    elif color_scheme == "winter_solstice":
        return "#000000"  # Black text for contrast on light winter colors (includes whites)
    elif color_scheme == "nowruz":
        return "#000000"  # Black text for contrast on light spring colors
    elif color_scheme == "songkran":
        return "#000000"  # Black text for contrast on light water blues
    else:
        return "#000000"  # Default to black text

def get_color_palette(color_scheme):
    """Get the color palette for a given color scheme"""
    if color_scheme == "rainbow":
        return RAINBOW_PALETTE
    elif color_scheme == "thermal":
        return THERMAL_PALETTE
    elif color_scheme == "grayscale":
        return GRAYSCALE_PALETTE
    elif color_scheme == "red":
        return RED_PALETTE
    elif color_scheme == "blue":
        return BLUE_PALETTE
    elif color_scheme == "green":
        return GREEN_PALETTE
    elif color_scheme == "purple":
        return PURPLE_PALETTE
    elif color_scheme == "halloween":
        return HALLOWEEN_PALETTE
    elif color_scheme == "christmas":
        return CHRISTMAS_PALETTE
    elif color_scheme == "passover":
        return PASSOVER_PALETTE
    elif color_scheme == "hanukkah":
        return HANUKKAH_PALETTE
    elif color_scheme == "newyear":
        return NEWYEAR_PALETTE
    elif color_scheme == "spring_equinox":
        return SPRING_EQUINOX_PALETTE
    elif color_scheme == "summer_solstice":
        return SUMMER_SOLSTICE_PALETTE
    elif color_scheme == "fall_equinox":
        return FALL_EQUINOX_PALETTE
    elif color_scheme == "winter_solstice":
        return WINTER_SOLSTICE_PALETTE
    elif color_scheme == "independence_day":
        return INDEPENDENCE_DAY_PALETTE
    elif color_scheme == "bastille_day":
        return BASTILLE_DAY_PALETTE
    elif color_scheme == "boxing_day":
        return BOXING_DAY_PALETTE
    elif color_scheme == "may_day":
        return MAY_DAY_PALETTE
    elif color_scheme == "dia_de_los_muertos":
        return DIA_DE_LOS_MUERTOS_PALETTE
    elif color_scheme == "thanksgiving":
        return THANKSGIVING_PALETTE
    elif color_scheme == "golden_week":
        return GOLDEN_WEEK_PALETTE
    elif color_scheme == "black_friday":
        return BLACK_FRIDAY_PALETTE
    elif color_scheme == "nowruz":
        return NOWRUZ_PALETTE
    elif color_scheme == "songkran":
        return SONGKRAN_PALETTE
    else:
        # Default fallback
        return RAINBOW_PALETTE

def get_calendar_thermal_peak(calendar_system):
    """
    Calculate the thermal peak position (0.0 to 1.0) for different calendar systems.
    The thermal peak represents late August in the Northern Hemisphere (hottest months).

    Args:
        calendar_system: String identifying the calendar system

    Returns:
        Float from 0.0 to 1.0 representing when thermal peak occurs in that calendar year
    """
    if calendar_system == "Persian":
        # Persian calendar starts at spring equinox (March 20-21)
        # Late August is about 140 days after spring equinox
        # 140 days / 365 days ≈ 0.38 (38% through Persian year)
        return 0.38
    elif calendar_system == "Ethiopian" or calendar_system == "Coptic":
        # Ethiopian/Coptic calendars start around September 11
        # Late August is about 350 days after previous September 11
        # Which is about 350/365 ≈ 0.96, but wrapping to next year means ~0.04
        # Actually, August comes BEFORE the new year starts in September
        # So August is about 35 days before September 11
        # That means August is at about (365-35)/365 ≈ 0.90 (90% through Ethiopian year)
        return 0.90
    elif calendar_system == "Islamic":
        # Islamic calendar is lunar and drifts through solar seasons
        # Thermal peak concept doesn't apply - use a more neutral positioning
        # Place peak at middle of year for visual balance
        return 0.5
    else:
        # Gregorian, Thai Buddhist, and other January-based calendars
        # Late August is about 240 days after January 1
        # 240 days / 365 days ≈ 0.66, but we use 0.65 based on research
        return 0.65

def get_gradient_color(position, color_scheme, hemisphere, calendar_system = "Gregorian"):
    """
    Get color for a position (0.0 to 1.0) in the year gradient.
    Creates a mirrored/symmetrical gradient that peaks based on calendar system.

    Args:
        position: Float from 0.0 to 1.0 representing position in year
        color_scheme: String identifying which color palette to use
        hemisphere: String "northern" or "southern" for seasonal positioning
        calendar_system: String identifying calendar system for thermal peak calculation
    """

    # Get the appropriate color palette
    color_stops = get_color_palette(color_scheme)

    # Handle southern hemisphere positioning (shift by 6 months for all color schemes)
    if hemisphere == "southern":
        position = (position + 0.5) % 1.0

    # Take a blue-weighted portion of the palette (more cool colors, less intense warm)
    # For a 12-color palette, use colors 2-7 (includes more blues, less intense oranges)
    palette_length = len(color_stops)
    bright_start = max(1, palette_length // 6)  # Start earlier to include more blues
    bright_end = bright_start + (palette_length // 2)  # Take about half the palette
    bright_colors = color_stops[bright_start:bright_end + 1]

    # Create mirrored gradient: bright colors peak at thermal maximum for this calendar
    # Position varies by calendar system (e.g., 0.65 for Gregorian, 0.38 for Persian)
    # This accounts for when different calendars experience their thermal peak
    peak_position = get_calendar_thermal_peak(calendar_system)

    # Calculate distance from peak, handling year wrap-around
    distance_from_peak = min(
        abs(position - peak_position),
        abs(position - peak_position + 1.0),
        abs(position - peak_position - 1.0),
    )

    # Scale to 0.0-1.0 range (0.0 = at peak, 1.0 = furthest from peak)
    max_distance = 0.5  # Maximum possible distance in circular year
    distance_from_center = min(distance_from_peak / max_distance, 1.0)

    # Map distance from center to bright color palette
    # 0.0 (center) = end of bright colors, 1.0 (edges) = start of bright colors
    bright_position = 1.0 - distance_from_center

    # Calculate which segment we're in using the bright position
    num_segments = len(bright_colors) - 1
    if num_segments == 0:
        return bright_colors[0]

    segment_size = 1.0 / num_segments
    segment = int(bright_position / segment_size)
    segment = min(segment, num_segments - 1)

    # Calculate position within segment
    local_pos = (bright_position % segment_size) / segment_size

    # Interpolate between colors
    color1 = bright_colors[segment]
    color2 = bright_colors[segment + 1]

    return interpolate_color(color1, color2, local_pos)

def interpolate_color(color1, color2, t):
    """Interpolate between two hex colors"""

    # Parse hex colors
    r1 = int(color1[1:3], 16)
    g1 = int(color1[3:5], 16)
    b1 = int(color1[5:7], 16)

    r2 = int(color2[1:3], 16)
    g2 = int(color2[3:5], 16)
    b2 = int(color2[5:7], 16)

    # Interpolate
    r = int(r1 + (r2 - r1) * t)
    g = int(g1 + (g2 - g1) * t)
    b = int(b1 + (b2 - b1) * t)

    # Convert back to hex using simple lookup table
    hex_chars = "0123456789ABCDEF"

    r_hex = hex_chars[r // 16] + hex_chars[r % 16]
    g_hex = hex_chars[g // 16] + hex_chars[g % 16]
    b_hex = hex_chars[b // 16] + hex_chars[b % 16]

    return "#" + r_hex + g_hex + b_hex

def get_accent_dot_color(accent_dot_style, color_scheme):
    """
    Get the appropriate accent dot color based on style and color scheme.

    Args:
        accent_dot_style: String indicating the accent dot style
        color_scheme: String indicating the current color scheme

    Returns:
        Hex color string for the accent dots
    """
    if accent_dot_style == "none":
        return "#00000000"  # Transparent (won't be rendered anyway)
    elif accent_dot_style == "adaptive":
        return ADAPTIVE_ACCENT_COLORS.get(color_scheme, "#FF00FF")  # Fallback to magenta
    elif accent_dot_style == "contrast":
        return CONTRAST_ACCENT_COLORS.get(color_scheme, "#000000")  # Fallback to black
    elif accent_dot_style in ACCENT_DOT_STYLES:
        return ACCENT_DOT_STYLES[accent_dot_style]
    else:
        # Fallback to original magenta
        return "#FF00FF"

def get_date_format_from_timezone(timezone_name):
    """
    Automatically determine date format based on timezone.
    Implements section 5.6.1 from TODO - timezone mapping for date formats.
    """

    # US timezone patterns - use "Jan 2" format
    us_timezones = [
        "America/New_York",
        "America/Chicago",
        "America/Denver",
        "America/Los_Angeles",
        "US/Eastern",
        "US/Central",
        "US/Mountain",
        "US/Pacific",
        "America/Phoenix",
        "America/Anchorage",
        "Pacific/Honolulu",
    ]

    # European timezone patterns - use "2 Jan" format
    european_timezones = [
        "Europe/London",
        "Europe/Paris",
        "Europe/Berlin",
        "Europe/Rome",
        "Europe/Madrid",
        "Europe/Amsterdam",
        "Europe/Stockholm",
        "Europe/Warsaw",
        "Europe/Vienna",
        "Europe/Zurich",
        "Europe/Dublin",
        "Europe/Brussels",
    ]

    # Check for exact matches first
    if timezone_name in us_timezones:
        return "us_format"  # "Jan 2"
    elif timezone_name in european_timezones:
        return "european_format"  # "2 Jan"
        # Check for timezone patterns

    elif timezone_name.startswith("America/"):
        # Most American timezones use US format
        return "us_format"
    elif timezone_name.startswith("Europe/"):
        # Most European timezones use European format
        return "european_format"
    elif timezone_name.startswith("Asia/"):
        # Default to ISO format for Asia
        return "iso_format"  # "01-02"
        # Special cases

    elif timezone_name.startswith("Canada/"):
        # Canadian timezones - mixed based on region
        if "Eastern" in timezone_name:
            return "us_format"  # Eastern Canada follows US style
        else:
            return "european_format"  # Rest of Canada follows European style

    # Default fallback
    return "us_format"

def get_language_from_timezone(timezone_name):
    """
    Automatically detect language based on timezone.
    Implements section 5.2 from TODO - intelligent language inference.
    """

    if timezone_name.startswith("Europe/Paris") or \
       timezone_name.startswith("Europe/Luxembourg") or \
       timezone_name.startswith("Africa/Casablanca") or \
       timezone_name.startswith("America/Montreal") or \
       timezone_name.startswith("Africa/Ouagadougou") or \
       timezone_name.startswith("Africa/Bamako") or \
       timezone_name.startswith("Africa/Dakar") or \
       timezone_name.startswith("Africa/Conakry") or \
       timezone_name.startswith("Africa/Abidjan") or \
       "French" in timezone_name:
        return "fr"
    elif timezone_name.startswith("Europe/Berlin") or \
         timezone_name.startswith("Europe/Vienna") or \
         timezone_name.startswith("Europe/Zurich") or \
         "German" in timezone_name:
        return "de"
    elif timezone_name.startswith("Europe/Madrid") or \
         timezone_name.startswith("America/Mexico") or \
         timezone_name.startswith("America/Argentina") or \
         timezone_name.startswith("America/Colombia") or \
         timezone_name.startswith("America/Lima") or \
         timezone_name.startswith("America/Santiago") or \
         timezone_name.startswith("America/Guatemala") or \
         timezone_name.startswith("America/El_Salvador") or \
         timezone_name.startswith("America/Tegucigalpa") or \
         timezone_name.startswith("America/Managua") or \
         timezone_name.startswith("America/Costa_Rica") or \
         timezone_name.startswith("America/Caracas") or \
         timezone_name.startswith("America/Guayaquil") or \
         timezone_name.startswith("America/La_Paz") or \
         timezone_name.startswith("America/Asuncion") or \
         timezone_name.startswith("America/Montevideo") or \
         timezone_name.startswith("America/Havana") or \
         timezone_name.startswith("America/Santo_Domingo") or \
         timezone_name.startswith("America/Panama") or \
         timezone_name.startswith("America/Cancun") or \
         timezone_name.startswith("America/Tijuana") or \
         "Spanish" in timezone_name:
        return "es"
    elif timezone_name.startswith("America/Sao_Paulo") or \
         timezone_name.startswith("Europe/Lisbon") or \
         timezone_name.startswith("Africa/Luanda") or \
         timezone_name.startswith("Africa/Maputo") or \
         timezone_name.startswith("Africa/Bissau") or \
         timezone_name.startswith("Africa/Sao_Tome") or \
         timezone_name.startswith("America/Fortaleza") or \
         "Portuguese" in timezone_name:
        return "pt"
    elif timezone_name.startswith("Europe/Rome") or \
         "Italian" in timezone_name:
        return "it"
    elif timezone_name.startswith("Europe/Moscow") or \
         timezone_name.startswith("Asia/Novosibirsk") or \
         timezone_name.startswith("Asia/Yekaterinburg") or \
         timezone_name.startswith("Asia/Irkutsk") or \
         timezone_name.startswith("Asia/Vladivostok") or \
         timezone_name.startswith("Asia/Magadan") or \
         timezone_name.startswith("Asia/Kamchatka") or \
         timezone_name.startswith("Asia/Sakhalin") or \
         timezone_name.startswith("Asia/Anadyr") or \
         timezone_name.startswith("Europe/Kaliningrad") or \
         timezone_name.startswith("Europe/Samara") or \
         timezone_name.startswith("Asia/Omsk") or \
         timezone_name.startswith("Asia/Krasnoyarsk") or \
         timezone_name.startswith("Asia/Yakutsk") or \
         timezone_name.startswith("Asia/Khandyga") or \
         timezone_name.startswith("Asia/Ust-Nera") or \
         timezone_name.startswith("Asia/Srednekolymsk") or \
         timezone_name.startswith("Asia/Almaty") or \
         timezone_name.startswith("Asia/Bishkek") or \
         timezone_name.startswith("Europe/Minsk") or \
         "Russian" in timezone_name:
        return "ru"
    else:
        return "en"

def format_date_with_timezone_detection(date, timezone_name, user_format_override = None, user_language_override = None):
    """
    Format date using timezone-based format and language detection with optional user overrides.
    Implements sections 5.1 and 5.2 from TODO - automatic date format and language localization.
    """

    # Determine format type
    if user_format_override and user_format_override != "auto":
        format_type = user_format_override
    else:
        format_type = get_date_format_from_timezone(timezone_name)

    # Determine language
    if user_language_override and user_language_override != "auto":
        language = user_language_override
    else:
        language = get_language_from_timezone(timezone_name)

    # Get localized month names
    month_names = MONTH_NAMES.get(language, MONTH_NAMES["en"])  # Fallback to English
    month_name = month_names[date.month - 1]  # Convert 1-based month to 0-based index

    # Format according to the selected format type
    if format_type == "us_format":
        return "%s %d" % (month_name, date.day)  # "Jan 2" or "Ene 2"
    elif format_type == "european_format":
        return "%d %s" % (date.day, month_name)  # "2 Jan" or "2 Ene"
    elif format_type == "iso_format":
        # Format with leading zeros manually since %02d isn't supported in Starlark
        month_str = "%d" % date.month if date.month >= 10 else "0%d" % date.month
        day_str = "%d" % date.day if date.day >= 10 else "0%d" % date.day
        return "%s-%s" % (month_str, day_str)  # "01-02" (no language needed)
    else:
        return "%s %d" % (month_name, date.day)  # Safe fallback to US format

def get_schema():
    color_scheme_options = [
        schema.Option(
            display = "Rainbow",
            value = "rainbow",
        ),
        schema.Option(
            display = "Thermal",
            value = "thermal",
        ),
        schema.Option(
            display = "Grayscale",
            value = "grayscale",
        ),
        schema.Option(
            display = "Red",
            value = "red",
        ),
        schema.Option(
            display = "Blue",
            value = "blue",
        ),
        schema.Option(
            display = "Green",
            value = "green",
        ),
        schema.Option(
            display = "Purple",
            value = "purple",
        ),
    ]

    hemisphere_options = [
        schema.Option(
            display = "Northern Hemisphere",
            value = "northern",
        ),
        schema.Option(
            display = "Southern Hemisphere",
            value = "southern",
        ),
    ]

    accent_dot_style_options = [
        schema.Option(
            display = "Adaptive (Color-based)",
            value = "adaptive",
        ),
        schema.Option(
            display = "Contrast (Darker/Lighter)",
            value = "contrast",
        ),
        schema.Option(
            display = "Fixed (Magenta)",
            value = "fixed_magenta",
        ),
        schema.Option(
            display = "Fixed (Cyan)",
            value = "fixed_cyan",
        ),
        schema.Option(
            display = "Fixed (White)",
            value = "fixed_white",
        ),
        schema.Option(
            display = "Fixed (Yellow)",
            value = "fixed_yellow",
        ),
        schema.Option(
            display = "None",
            value = "none",
        ),
    ]

    return schema.Schema(
        version = "1",
        fields = [
            schema.Dropdown(
                id = "color_scheme",
                name = "Color Scheme",
                desc = "Choose year gradient color",
                icon = "palette",
                default = "rainbow",
                options = color_scheme_options,
            ),
            schema.Dropdown(
                id = "hemisphere",
                name = "Hemisphere",
                desc = "Choose hemisphere for seasonal positioning",
                icon = "globe",
                default = "northern",
                options = hemisphere_options,
            ),
            schema.Dropdown(
                id = "accent_dot_style",
                name = "Accent Dot Style",
                desc = "Choose accent dots color",
                icon = "brush",
                default = "adaptive",
                options = accent_dot_style_options,
            ),
            schema.Toggle(
                id = "show_date",
                name = "Show Date",
                desc = "Display current date in corner",
                icon = "calendar",
                default = False,
            ),
            schema.Dropdown(
                id = "date_format",
                name = "Date Format",
                desc = "Choose date format (auto-detects from timezone)",
                icon = "calendarDays",
                default = "auto",
                options = [
                    schema.Option(
                        display = "Auto-detect from timezone",
                        value = "auto",
                    ),
                    schema.Option(
                        display = "US format (Jan 2)",
                        value = "us_format",
                    ),
                    schema.Option(
                        display = "European format (2 Jan)",
                        value = "european_format",
                    ),
                    schema.Option(
                        display = "ISO format (01-02)",
                        value = "iso_format",
                    ),
                ],
            ),
            schema.Dropdown(
                id = "language",
                name = "Language",
                desc = "Choose display language (auto-detects from timezone)",
                icon = "language",
                default = "auto",
                options = [
                    schema.Option(
                        display = "Auto-detect from timezone",
                        value = "auto",
                    ),
                    schema.Option(
                        display = "English",
                        value = "en",
                    ),
                    schema.Option(
                        display = "Español",
                        value = "es",
                    ),
                    schema.Option(
                        display = "Français",
                        value = "fr",
                    ),
                    schema.Option(
                        display = "Deutsch",
                        value = "de",
                    ),
                    schema.Option(
                        display = "Português",
                        value = "pt",
                    ),
                    schema.Option(
                        display = "Italiano",
                        value = "it",
                    ),
                    schema.Option(
                        display = "Русский",
                        value = "ru",
                    ),
                ],
            ),
            schema.Dropdown(
                id = "calendar_system",
                name = "Calendar System",
                desc = "Choose calendar system for year progress (Gregorian is standard)",
                icon = "calendarDays",
                default = "Gregorian",
                options = [
                    schema.Option(
                        display = "Gregorian (Standard)",
                        value = "Gregorian",
                    ),
                    schema.Option(
                        display = "Persian/Jalali",
                        value = "Persian",
                    ),
                    schema.Option(
                        display = "Islamic/Hijri",
                        value = "Islamic",
                    ),
                    schema.Option(
                        display = "Thai Buddhist",
                        value = "Thai Buddhist",
                    ),
                    schema.Option(
                        display = "Ethiopian",
                        value = "Ethiopian",
                    ),
                    schema.Option(
                        display = "Coptic",
                        value = "Coptic",
                    ),
                ],
            ),
            schema.Toggle(
                id = "enable_special_dates",
                name = "Enable Special Date Themes",
                desc = "Override colors on holidays",
                icon = "star",
                default = True,
            ),
            schema.Toggle(
                id = "enable_animations",
                name = "Enable Holiday Animations",
                desc = "Show animations on special holidays (New Year's sparkles, Halloween flicker, Christmas snow, Valentine's hearts)",
                icon = "star",
                default = True,
            ),
        ],
    )
