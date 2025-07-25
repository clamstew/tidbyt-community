"""
Applet: Year Clock
Summary: Rainbow year clock
Description: Displays a rainbow gradient representing the year with a retro dial marker showing today's position. Inspired by vintage rainbow wall clocks that track yearly progress with warmer colors for summer and cooler colors for winter.
Author: clamstew
"""

load("render.star", "render")
load("schema.star", "schema")
load("time.star", "time")

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
    "newyear": "#FF00FF",  # Magenta (contrasts with gold/silver)
    "spring_equinox": "#8A2BE2",  # Purple (contrasts with light spring colors)
    "summer_solstice": "#0000FF",  # Blue (contrasts with bright yellows)
    "fall_equinox": "#00FFFF",  # Cyan (contrasts with autumn colors)
    "winter_solstice": "#FF4500",  # Orange Red (contrasts with blues/whites)
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
    "newyear": "#B8860B",  # Dark golden rod (darker contrast)
    "spring_equinox": "#2E8B57",  # Sea green (darker contrast)
    "summer_solstice": "#B8860B",  # Dark golden rod (darker contrast)
    "fall_equinox": "#8B4513",  # Saddle brown (darker contrast)
    "winter_solstice": "#191970",  # Midnight blue (darker contrast)
}

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

    # Check for special date overrides
    enable_special_dates = config.bool("enable_special_dates", True)
    special_override = get_special_date_override(now, enable_special_dates)
    if special_override:
        color_scheme = special_override

        # For Pride Month, use rainbow but respect hemisphere choice
        if special_override == "pride":
            color_scheme = "rainbow"
            # Keep the user's hemisphere setting - don't override it

    # Calculate year progress (0.0 to 1.0)
    # Use local time for year boundaries
    year_start = time.time(year = now.year, month = 1, day = 1, hour = 0, minute = 0, second = 0)
    year_end = time.time(year = now.year + 1, month = 1, day = 1, hour = 0, minute = 0, second = 0)
    year_duration = year_end - year_start
    elapsed = now - year_start
    year_fraction = elapsed.seconds / year_duration.seconds

    # Create the gradient background
    gradient_children = []
    for x in range(64):
        # Calculate position in gradient (0.0 to 1.0)
        pos = x / 63.0

        # Get color for this position
        color = get_gradient_color(pos, color_scheme, hemisphere)

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
                    child = render.Text(
                        content = format_date_with_timezone_detection(now, timezone, config.get("date_format", "auto")),
                        font = "tom-thumb",
                        color = get_date_color(color_scheme, hemisphere),
                    ),
                ) if config.bool("show_date", False) else render.Box(width = 0, height = 0),
            ],
        ),
    )

def get_special_date_override(now, enable_special_dates):
    """
    Detect if current date falls on a special date and return override color scheme.
    Returns None if no special date applies or if special dates are disabled.
    """
    if not enable_special_dates:
        return None

    month = now.month
    day = now.day

    # Valentine's Day (Feb 14) - Override to red spectrum
    if month == 2 and day == 14:
        return "red"

    # St. Patrick's Day (Mar 17) - Override to green spectrum
    if month == 3 and day == 17:
        return "green"

    # Halloween (Oct 31) - Override to orange/black gradient
    if month == 10 and day == 31:
        return "halloween"

    # Christmas (Dec 25) - Override to red/green gradient
    if month == 12 and day == 25:
        return "christmas"

    # New Year's (Dec 31 or Jan 1) - Override to gold/silver gradient
    if (month == 12 and day == 31) or (month == 1 and day == 1):
        return "newyear"

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

    return None

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
    else:
        # Default fallback
        return RAINBOW_PALETTE

def get_gradient_color(position, color_scheme, hemisphere):
    """
    Get color for a position (0.0 to 1.0) in the year gradient.
    Creates a mirrored/symmetrical gradient that peaks in the center.

    Args:
        position: Float from 0.0 to 1.0 representing position in year
        color_scheme: String identifying which color palette to use
        hemisphere: String "northern" or "southern" for seasonal positioning
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

    # Create mirrored gradient: bright colors peak in August/September (hottest months)
    # Position 0.0 = Jan 1, 0.65 = late August peak, 1.0 = Dec 31
    # Shift the center from summer solstice (0.5) to late summer (0.65)
    peak_position = 0.65  # Late August/early September

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

def format_date_with_timezone_detection(date, timezone_name, user_override = None):
    """
    Format date using automatic timezone-based format detection.
    Allows user override if specified.
    """
    if user_override and user_override != "auto":
        format_type = user_override
    else:
        format_type = get_date_format_from_timezone(timezone_name)

    if format_type == "us_format":
        return date.format("Jan 2")
    elif format_type == "european_format":
        return date.format("2 Jan")
    elif format_type == "iso_format":
        return date.format("01-02")
    else:
        return date.format("Jan 2")  # Safe fallback

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
                desc = "Choose color palette for the year gradient",
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
                desc = "Choose how accent dots are colored",
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
                icon = "calendar-days",
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
            schema.Toggle(
                id = "enable_special_dates",
                name = "Enable Special Date Themes",
                desc = "Override colors on holidays",
                icon = "star",
                default = True,
            ),
        ],
    )
