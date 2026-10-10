from PIL import Image, ImageDraw


def draw_radar(size: int, bg: tuple[int, int, int, int] | None):
    img = Image.new("RGBA", (size, size), bg if bg else (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    cx = cy = size / 2

    rings = [
        (0.18, (10, 143, 138, 255), 0.045),
        (0.32, (10, 143, 138, 210), 0.032),
        (0.48, (10, 143, 138, 150), 0.028),
        (0.66, (232, 163, 23, 130), 0.022),
    ]
    for r_frac, color, w_frac in rings:
        r = size * r_frac
        w = max(2, int(size * w_frac))
        d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=color, width=w)

    br = size * 0.055
    d.ellipse([cx - br, cy - br, cx + br, cy + br], fill=(10, 143, 138, 255))

    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gr = size * 0.1
    gd.ellipse([cx - gr, cy - gr, cx + gr, cy + gr], fill=(10, 143, 138, 50))
    return Image.alpha_composite(glow, img)


def main() -> None:
    bg = (11, 18, 32, 255)
    full = draw_radar(1024, bg)
    full.save(r"C:\dev\Echo\assets\icon\app_icon.png")

    fg = draw_radar(1024, None)
    canvas = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    scaled = fg.resize((780, 780), Image.Resampling.LANCZOS)
    canvas.paste(scaled, ((1024 - 780) // 2, (1024 - 780) // 2), scaled)
    canvas.save(r"C:\dev\Echo\assets\icon\app_icon_foreground.png")
    print("wrote icons")


if __name__ == "__main__":
    main()
