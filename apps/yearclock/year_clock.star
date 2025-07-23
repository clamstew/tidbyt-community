"""
Applet: Year Clock
Summary: Rainbow year progress tracker
Description: Displays a rainbow gradient representing the year with a retro dial marker showing today's position. Inspired by vintage rainbow wall clocks that track yearly progress with warmer colors for summer and cooler colors for winter.
Author: Community
"""

load("encoding/json.star", "json")
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

DEFAULT_LOCATION = """
{
	"lat": "40.6781784",
	"lng": "-73.9441579",
	"description": "Brooklyn, NY, USA",
	"locality": "Brooklyn",
	"place_id": "ChIJCSF8lBZEwokRhngABHRcdoI",
	"timezone": "America/New_York"
}
"""

def main(config):
    # Get timezone from location
    location = json.decode(config.get("location", DEFAULT_LOCATION))
    timezone = location["timezone"]

    # Get current time in user's timezone, or use debug time if provided
    debug_date = config.get("debug_date")
    if debug_date:
        # Parse the debug date and use it instead of current time
        now = time.parse_time(debug_date).in_location(timezone)
    else:
        now = time.now().in_location(timezone)

    # Get color scheme and hemisphere settings
    color_scheme = config.get("color_scheme", "rainbow")
    hemisphere = config.get("hemisphere", "northern")

    # Calculate year progress (0.0 to 1.0)
    year_start = time.time(year = now.year, month = 1, day = 1, hour = 0, minute = 0, second = 0, location = timezone)
    year_end = time.time(year = now.year + 1, month = 1, day = 1, hour = 0, minute = 0, second = 0, location = timezone)
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

    # Calculate marker position
    marker_x = int(year_fraction * 63)

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
                        # Top and bottom accent dots
                        render.Padding(
                            pad = (marker_x, 0, 0, 0),
                            child = render.Column(
                                children = [
                                    render.Box(width = 1, height = 1, color = "#FF00FF"),
                                    render.Box(width = 1, height = 30, color = "#00000000"),  # transparent spacer
                                    render.Box(width = 1, height = 1, color = "#FF00FF"),
                                ],
                            ),
                        ),
                    ],
                ),
                # Optional date display in bottom corner
                render.Padding(
                    pad = (get_date_x_position(), 26, 0, 0),
                    child = render.Text(
                        content = now.format("Jan 2"),
                        font = "tom-thumb",
                        color = get_date_color(color_scheme, hemisphere),
                    ),
                ) if config.bool("show_date", False) else render.Box(width = 0, height = 0),
            ],
        ),
    )

def get_date_color(color_scheme, hemisphere):
    """Get appropriate date text color based on color scheme and hemisphere"""

    if color_scheme == "rainbow":
        if hemisphere == "northern":
            return "#000000"  # Black text for better contrast on summer yellows/oranges
        else:
            return "#FFFFFF"  # White text works well on southern summer (darker colors)
    elif color_scheme == "grayscale":
        return "#000000"  # Black text for contrast on gray gradients
    elif color_scheme == "red":
        return "#FFFFFF"  # White text for contrast on red backgrounds
    elif color_scheme == "blue":
        return "#FFFFFF"  # White text for contrast on blue backgrounds
    elif color_scheme == "green":
        return "#000000"  # Black text for contrast on green backgrounds
    elif color_scheme == "purple":
        return "#FFFFFF"  # White text for contrast on purple backgrounds
    else:
        return "#000000"  # Default to black text

def get_date_x_position():
    """Get X position for date"""

    # Default position - left side for now
    # TODO: Add overlap detection later
    return 1

def get_color_palette(color_scheme):
    """Get the color palette for a given color scheme"""
    if color_scheme == "rainbow":
        return RAINBOW_PALETTE
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

    # Take only the bright half of the palette (center portion)
    # For a 12-color palette, use colors 3-8 (the bright summer colors)
    palette_length = len(color_stops)
    bright_start = palette_length // 4  # Start at 25% through palette
    bright_end = (3 * palette_length) // 4  # End at 75% through palette
    bright_colors = color_stops[bright_start:bright_end + 1]

    # Create mirrored gradient: bright colors in center, darker colors on edges
    # Position 0.0 = leftmost edge, 0.5 = center, 1.0 = rightmost edge
    # Map position to distance from center (0.0 at center, 0.5 at edges)
    distance_from_center = abs(position - 0.5) * 2.0

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

def get_schema():
    color_scheme_options = [
        schema.Option(
            display = "Rainbow",
            value = "rainbow",
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
            schema.Toggle(
                id = "show_date",
                name = "Show Date",
                desc = "Display current date in corner",
                icon = "calendar",
                default = False,
            ),
            schema.Location(
                id = "location",
                name = "Location",
                desc = "Location for timezone",
                icon = "locationDot",
            ),
            schema.DateTime(
                id = "debug_date",
                name = "[DEBUG] Test Date",
                desc = "Pick a date to preview colors (year doesn't matter)",
                icon = "calendar",
            ),
        ],
    )
