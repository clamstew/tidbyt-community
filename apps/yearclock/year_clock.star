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

    # Get current time in user's timezone
    now = time.now().in_location(timezone)

    # Get hemisphere setting
    hemisphere = config.get("hemisphere", "northern")

    # Calculate year progress (0.0 to 1.0)
    year_start = time.time(year = now.year, month = 1, day = 1, hour = 0, minute = 0, second = 0, location = timezone)
    year_end = time.time(year = now.year + 1, month = 1, day = 1, hour = 0, minute = 0, second = 0, location = timezone)
    year_duration = year_end - year_start
    elapsed = now - year_start
    year_fraction = elapsed.seconds / year_duration.seconds

    # Create the rainbow gradient background
    gradient_children = []
    for x in range(64):
        # Calculate position in gradient (0.0 to 1.0)
        pos = x / 63.0

        # Get color for this position
        color = get_gradient_color(pos, hemisphere)

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
                    pad = (1, 26, 0, 0),
                    child = render.Text(
                        content = now.format("Jan 2"),
                        font = "tom-thumb",
                        color = "#FFFFFF",
                    ),
                ) if config.bool("show_date", True) else render.Box(width = 0, height = 0),
            ],
        ),
    )

def get_gradient_color(position, hemisphere):
    """
    Get color for a position (0.0 to 1.0) in the year gradient.
    Northern hemisphere: winter=cool, summer=warm
    Southern hemisphere: reversed
    """

    # Define color stops for the gradient
    # These represent the seasons with smooth transitions
    color_stops = [
        "#4169E1",  # Royal Blue (Winter)
        "#00CED1",  # Dark Turquoise (Late Winter/Early Spring)
        "#00FF7F",  # Spring Green (Spring)
        "#FFD700",  # Gold (Late Spring/Early Summer)
        "#FF8C00",  # Dark Orange (Summer)
        "#FF4500",  # Orange Red (Late Summer)
        "#DC143C",  # Crimson (Early Fall)
        "#8B0000",  # Dark Red (Late Fall)
        "#4169E1",  # Royal Blue (Back to Winter)
    ]

    # Reverse for southern hemisphere
    if hemisphere == "southern":
        # Shift by 6 months (0.5)
        position = (position + 0.5) % 1.0

    # Calculate which segment we're in
    num_segments = len(color_stops) - 1
    segment_size = 1.0 / num_segments
    segment = int(position / segment_size)
    segment = min(segment, num_segments - 1)

    # Calculate position within segment
    local_pos = (position % segment_size) / segment_size

    # Interpolate between colors
    color1 = color_stops[segment]
    color2 = color_stops[segment + 1]

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
            schema.Location(
                id = "location",
                name = "Location",
                desc = "Location for timezone",
                icon = "locationDot",
            ),
            schema.Dropdown(
                id = "hemisphere",
                name = "Hemisphere",
                desc = "Choose hemisphere for seasonal colors",
                icon = "globe",
                default = "northern",
                options = hemisphere_options,
            ),
            schema.Toggle(
                id = "show_date",
                name = "Show Date",
                desc = "Display current date in corner",
                icon = "calendar",
                default = True,
            ),
        ],
    )
