#!/usr/bin/env python3
"""
Niamama Promotional Advertisement Reel Generator
Creates an engaging 9:16 vertical video reel with natural feminine voiceover,
ambient background score, animated UI mockups, and ambassador feature highlights.
"""

import os
import sys
import math
import random
import asyncio
import subprocess
import numpy as np
import wave
from PIL import Image, ImageDraw, ImageFont, ImageFilter

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
VENV_BIN = "/tmp/reel_env/bin"
FFMPEG_EXE = "/tmp/reel_env/lib/python3.12/site-packages/imageio_ffmpeg/binaries/ffmpeg-linux-x86_64-v9.0.2"
if not os.path.exists(FFMPEG_EXE):
    FFMPEG_EXE = os.path.join(VENV_BIN, "ffmpeg")

OUTPUT_VIDEO = os.path.join(SCRIPT_DIR, "niamama_ad_reel.mp4")

# Resolution & Frame Rate
W, H = 1080, 1920
FPS = 30

# Colors
BG_DARK = (18, 10, 26)
BG_MID = (32, 14, 42)
BG_LIGHT = (48, 20, 60)
ROSE_ACCENT = (244, 114, 182)
VIOLET_ACCENT = (192, 132, 252)
LILAC_LIGHT = (235, 215, 245)
AMBER_ACCENT = (251, 191, 36)
TEAL_ACCENT = (45, 212, 191)
WHITE = (255, 255, 255)
DARK_CARD = (28, 16, 36)

# Fonts
FONT_TITLE_LG = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf", 52)
FONT_TITLE_MD = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf", 40)
FONT_BODY = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf", 32)
FONT_SUBTITLE = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf", 30)
FONT_BADGE = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf", 26)
FONT_CAPTION = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf", 22)

# Script Scenes
SCENES = [
    {
        "id": 1,
        "audio": "/tmp/scene1.mp3",
        "text": "Motherhood is a profound journey, but you should never have to walk it alone. Meet Niamama.",
        "subtitles": [
            (0.3, 3.8, "Motherhood is a profound journey..."),
            (3.8, 6.8, "...you should never walk it alone. Meet Niamama.")
        ]
    },
    {
        "id": 2,
        "audio": "/tmp/scene2.mp3",
        "text": "Designed for every mama, Niamama works completely offline, giving you instant postpartum recovery insights anytime, anywhere.",
        "subtitles": [
            (0.2, 4.3, "Designed for every mama, Niamama works 100% offline..."),
            (4.3, 8.6, "...instant postpartum recovery insights anytime, anywhere.")
        ]
    },
    {
        "id": 3,
        "audio": "/tmp/scene3.mp3",
        "text": "Stay on top of your baby's health with automated WHO vaccination schedules and milestone tracking.",
        "subtitles": [
            (0.2, 3.2, "Stay on top of your baby's health..."),
            (3.2, 6.2, "...with WHO vaccination schedules & milestone tracking.")
        ]
    },
    {
        "id": 4,
        "audio": "/tmp/scene4.mp3",
        "text": "Access direct midwife guidance, mental wellness check-ins, and one-tap emergency SOS support.",
        "subtitles": [
            (0.2, 3.6, "Access direct midwife guidance & mental wellness check-ins..."),
            (3.6, 7.3, "...and one-tap emergency SOS support.")
        ]
    },
    {
        "id": 5,
        "audio": "/tmp/scene5.mp3",
        "text": "Involve partners, support families, and embrace care in English or Kiswahili. Download Niamama today!",
        "subtitles": [
            (0.2, 4.2, "Involve partners, support families, in English or Kiswahili."),
            (4.2, 8.2, "Download Niamama today! Caring for mother & child.")
        ]
    }
]

def draw_vector_heart(draw, cx, cy, size, color):
    r = size * 0.5
    draw.ellipse([cx - size, cy - r, cx, cy + r], fill=color)
    draw.ellipse([cx, cy - r, cx + size, cy + r], fill=color)
    draw.polygon([(cx - size, cy), (cx + size, cy), (cx, cy + size * 1.15)], fill=color)

def draw_vector_star(draw, cx, cy, r_out, r_in, color):
    points = []
    for i in range(8):
        angle = i * math.pi / 4 - math.pi / 2
        r = r_out if i % 2 == 0 else r_in
        points.append((cx + r * math.cos(angle), cy + r * math.sin(angle)))
    draw.polygon(points, fill=color)

def draw_vector_check(draw, cx, cy, size, color, width=4):
    draw.line([
        (cx - size * 0.5, cy),
        (cx - size * 0.1, cy + size * 0.4),
        (cx + size * 0.55, cy - size * 0.45)
    ], fill=color, width=width)

def draw_vector_shield(draw, cx, cy, size, color):
    w, h = size * 0.8, size
    draw.polygon([
        (cx, cy - h),
        (cx + w, cy - h * 0.6),
        (cx + w * 0.8, cy + h * 0.4),
        (cx, cy + h),
        (cx - w * 0.8, cy + h * 0.4),
        (cx - w, cy - h * 0.6)
    ], fill=color)

def create_base_gradient():
    grad = Image.new("RGB", (W, H), BG_DARK)
    d = ImageDraw.Draw(grad)
    for y in range(H):
        r = y / H
        cr = int(BG_DARK[0] * (1 - r) + BG_MID[0] * r)
        cg = int(BG_DARK[1] * (1 - r) + BG_MID[1] * r)
        cb = int(BG_DARK[2] * (1 - r) + BG_MID[2] * r)
        d.line([(0, y), (W, y)], fill=(cr, cg, cb))
    return grad

BASE_GRADIENT = create_base_gradient()

# Generate deterministic floating particles (in margins and ambient spaces to avoid text clash)
random.seed(42)
PARTICLES = []
for _ in range(40):
    PARTICLES.append({
        "x": random.choice([random.randint(20, 200), random.randint(W - 200, W - 20)]),
        "y": random.randint(0, H),
        "speed": random.uniform(1.2, 2.8),
        "size": random.randint(4, 9),
        "drift": random.uniform(0.5, 1.5),
        "phase": random.uniform(0, math.pi * 2),
        "color": random.choice([ROSE_ACCENT, VIOLET_ACCENT, AMBER_ACCENT, TEAL_ACCENT, LILAC_LIGHT])
    })

def render_particles(draw, frame_idx):
    t = frame_idx / FPS
    for p in PARTICLES:
        y = (p["y"] - p["speed"] * frame_idx * 1.5) % H
        x = p["x"] + math.sin(t * p["drift"] + p["phase"]) * 35
        sz = p["size"]
        # Soft star/glow
        draw.ellipse([x - sz, y - sz, x + sz, y + sz], fill=p["color"])

def draw_pill(draw, cx, cy, text, bg_color, text_color, font, stroke_color=None, stroke_width=2, icon_type=None):
    bbox = font.getbbox(text)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    pad_x = 36 + (30 if icon_type else 0)
    pad_y = 18
    pw = tw + pad_x * 2
    ph = th + pad_y * 2
    x0, y0 = cx - pw // 2, cy - ph // 2
    x1, y1 = cx + pw // 2, cy + ph // 2

    draw.rounded_rectangle([x0, y0, x1, y1], radius=ph // 2, fill=bg_color, outline=stroke_color, width=stroke_width)
    
    text_x = cx + (15 if icon_type else 0)
    draw.text((text_x, cy), text, font=font, fill=text_color, anchor="mm")
    
    if icon_type == "heart":
        draw_vector_heart(draw, x0 + 32, cy, 10, ROSE_ACCENT)
    elif icon_type == "check":
        draw_vector_check(draw, x0 + 32, cy, 14, TEAL_ACCENT, width=3)
    elif icon_type == "star":
        draw_vector_star(draw, x0 + 32, cy, 12, 5, AMBER_ACCENT)
    elif icon_type == "shield":
        draw_vector_shield(draw, x0 + 32, cy, 12, VIOLET_ACCENT)

def draw_subtitles_bar(draw, text):
    if not text:
        return
    bar_w = 980
    bar_h = 90
    bx0 = (W - bar_w) // 2
    by0 = 1760
    bx1 = bx0 + bar_w
    by1 = by0 + bar_h
    # Dark translucent capsule
    draw.rounded_rectangle([bx0, by0, bx1, by1], radius=28, fill=(15, 8, 22), outline=(180, 110, 200), width=2)
    draw.text((W // 2, by0 + bar_h // 2), text, font=FONT_SUBTITLE, fill=WHITE, anchor="mm")

# Phone Mockup Renderer
def build_phone_frame(screen_crop, pw=640, ph=1240):
    phone = Image.new("RGBA", (pw, ph), (0, 0, 0, 0))
    d = ImageDraw.Draw(phone)
    # Chassis outline
    d.rounded_rectangle([0, 0, pw, ph], radius=56, fill=(16, 14, 20, 255), outline=(140, 100, 160, 220), width=6)
    
    # Screen Mask
    sw, sh = pw - 24, ph - 24
    s_mask = Image.new("L", (sw, sh), 0)
    d_mask = ImageDraw.Draw(s_mask)
    d_mask.rounded_rectangle([0, 0, sw, sh], radius=44, fill=255)
    
    # Scale crop to sw, sh
    sc = screen_crop.resize((sw, sh), Image.Resampling.LANCZOS)
    phone.paste(sc, (12, 12), s_mask)
    
    # Dynamic Island notch
    d.rounded_rectangle([pw // 2 - 70, 20, pw // 2 + 70, 52], radius=16, fill=(8, 8, 10, 255))
    # Speaker dot
    d.ellipse([pw // 2 + 35, 32, pw // 2 + 43, 40], fill=(30, 30, 40, 255))
    # Bottom home bar
    d.rounded_rectangle([pw // 2 - 80, ph - 22, pw // 2 + 80, ph - 17], radius=3, fill=(220, 220, 230, 220))
    return phone

print("Loading Assets...")
AMBASSADOR_IMG = Image.open(os.path.join(PROJECT_ROOT, "advertisements", "Pasted image.png")).convert("RGBA")
HOME_IMG = Image.open(os.path.join(PROJECT_ROOT, "docs", "architecture", "ui-preview", "home_dashboard.png")).convert("RGB")
VACCINES_IMG = Image.open(os.path.join(PROJECT_ROOT, "docs", "architecture", "ui-preview", "timeline_vaccines.png")).convert("RGB")
SUPPORT_IMG = Image.open(os.path.join(PROJECT_ROOT, "docs", "architecture", "ui-preview", "support_circle.png")).convert("RGB")
CARE_IMG = Image.open(os.path.join(PROJECT_ROOT, "docs", "architecture", "ui-preview", "care_map.png")).convert("RGB")

# Precompute card for Ambassador
def get_ambassador_card(scale=1.0):
    cw, ch = 840, 1020
    card = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    mask = Image.new("L", (cw, ch), 0)
    d_m = ImageDraw.Draw(mask)
    d_m.rounded_rectangle([0, 0, cw, ch], radius=52, fill=255)
    
    pw, ph = AMBASSADOR_IMG.size
    base_s = max(cw / pw, ch / ph) * scale
    rw, rh = int(pw * base_s), int(ph * base_s)
    r_img = AMBASSADOR_IMG.resize((rw, rh), Image.Resampling.LANCZOS)
    ox = (rw - cw) // 2
    oy = (rh - ch) // 2
    crop_img = r_img.crop((ox, oy, ox + cw, oy + ch))
    card.paste(crop_img, (0, 0), mask)
    
    d_c = ImageDraw.Draw(card)
    d_c.rounded_rectangle([3, 3, cw - 3, ch - 3], radius=52, outline=(244, 114, 182, 230), width=6)
    return card

def render_frame(global_frame_idx, scene_idx, local_frame_idx, local_time, scene_duration):
    frame = BASE_GRADIENT.copy()
    draw = ImageDraw.Draw(frame)
    render_particles(draw, global_frame_idx)
    
    # Progress bar at top
    progress = global_frame_idx / TOTAL_FRAMES
    draw.line([(0, 6), (int(W * progress), 6)], fill=ROSE_ACCENT, width=6)

    # Subtitles lookup
    sub_text = ""
    for s_start, s_end, text in SCENES[scene_idx]["subtitles"]:
        if s_start <= local_time <= s_end:
            sub_text = text
            break

    # Scene specific graphics
    if scene_idx == 0:
        # Scene 1: Introduction & Ambassador Card
        # Subtle breathing zoom
        zoom = 1.0 + 0.05 * (local_time / scene_duration)
        card = get_ambassador_card(scale=zoom)
        cx = (W - card.width) // 2
        cy = 300 + int(math.sin(local_time * 1.5) * 8)
        frame.paste(card, (cx, cy), card)
        
        # Header Badge
        draw_pill(draw, W // 2, 120, "POSTPARTUM CARE IN YOUR HANDS", (40, 18, 52), ROSE_ACCENT, FONT_CAPTION, stroke_color=ROSE_ACCENT, stroke_width=2, icon_type="heart")
        draw.text((W // 2, 200), "Meet Niamama", font=FONT_TITLE_LG, fill=WHITE, anchor="mm")
        
        # Floating Badges
        draw_pill(draw, W // 2, 1390, "Maternal & Midwifery Leadership", (35, 16, 48), LILAC_LIGHT, FONT_BADGE, stroke_color=VIOLET_ACCENT, stroke_width=2, icon_type="shield")
        draw_pill(draw, W // 2, 1480, "For Every Mother, Baby & Family", (35, 16, 48), AMBER_ACCENT, FONT_BADGE, stroke_color=AMBER_ACCENT, stroke_width=2, icon_type="star")

    elif scene_idx == 1:
        # Scene 2: 100% Offline Maternal Health
        # Header
        draw_pill(draw, W // 2, 120, "OFFLINE-FIRST TECHNOLOGY", (40, 18, 52), TEAL_ACCENT, FONT_CAPTION, stroke_color=TEAL_ACCENT, stroke_width=2, icon_type="check")
        draw.text((W // 2, 200), "Care Without Limits", font=FONT_TITLE_LG, fill=WHITE, anchor="mm")
        
        # Phone mockup with animated vertical scroll
        # Screen size: 616 x 1216
        sw, sh = 616, 1216
        dw, dh = HOME_IMG.size
        scale = sw / dw
        scaled_h = int(dh * scale)
        scaled_home = HOME_IMG.resize((sw, scaled_h), Image.Resampling.LANCZOS)
        
        max_scroll = max(0, scaled_h - sh)
        scroll_y = int(min(max_scroll, (local_time / scene_duration) * 360))
        screen_crop = scaled_home.crop((0, scroll_y, sw, scroll_y + sh))
        
        phone = build_phone_frame(screen_crop, pw=640, ph=1240)
        px = (W - phone.width) // 2
        py = 270 + int(math.sin(local_time * 1.8) * 6)
        frame.paste(phone, (px, py), phone)
        
        # Floating Feature Pills
        draw_pill(draw, 260, 1540, "100% Offline-Ready", (28, 14, 38), TEAL_ACCENT, FONT_BADGE, stroke_color=TEAL_ACCENT, stroke_width=2, icon_type="check")
        draw_pill(draw, 780, 1540, "Daily Maternal Vitals", (28, 14, 38), ROSE_ACCENT, FONT_BADGE, stroke_color=ROSE_ACCENT, stroke_width=2, icon_type="heart")

    elif scene_idx == 2:
        # Scene 3: WHO Vaccine & Milestone Tracker
        draw_pill(draw, W // 2, 120, "WHO IMMUNIZATION STANDARDS", (40, 18, 52), AMBER_ACCENT, FONT_CAPTION, stroke_color=AMBER_ACCENT, stroke_width=2, icon_type="star")
        draw.text((W // 2, 200), "Never Miss a Milestone", font=FONT_TITLE_LG, fill=WHITE, anchor="mm")
        
        sw, sh = 616, 1216
        dw, dh = VACCINES_IMG.size
        scale = sw / dw
        scaled_h = int(dh * scale)
        scaled_vaccines = VACCINES_IMG.resize((sw, scaled_h), Image.Resampling.LANCZOS)
        
        max_scroll = max(0, scaled_h - sh)
        scroll_y = int(min(max_scroll, (local_time / scene_duration) * 380))
        screen_crop = scaled_vaccines.crop((0, scroll_y, sw, scroll_y + sh))
        
        phone = build_phone_frame(screen_crop, pw=640, ph=1240)
        px = (W - phone.width) // 2
        py = 270 + int(math.sin(local_time * 1.8) * 6)
        frame.paste(phone, (px, py), phone)
        
        draw_pill(draw, 280, 1540, "Automated Reminders", (28, 14, 38), AMBER_ACCENT, FONT_BADGE, stroke_color=AMBER_ACCENT, stroke_width=2, icon_type="star")
        draw_pill(draw, 780, 1540, "Growth Tracking", (28, 14, 38), TEAL_ACCENT, FONT_BADGE, stroke_color=TEAL_ACCENT, stroke_width=2, icon_type="check")

    elif scene_idx == 3:
        # Scene 4: Midwife Support & Clinic Map
        draw_pill(draw, W // 2, 120, "MIDWIFE & EMERGENCY NETWORK", (40, 18, 52), VIOLET_ACCENT, FONT_CAPTION, stroke_color=VIOLET_ACCENT, stroke_width=2, icon_type="shield")
        draw.text((W // 2, 200), "Guidance at Your Fingertips", font=FONT_TITLE_LG, fill=WHITE, anchor="mm")
        
        # First half shows Support Circle, second half shows Care Map
        active_img = SUPPORT_IMG if local_time < (scene_duration * 0.5) else CARE_IMG
        sw, sh = 616, 1216
        dw, dh = active_img.size
        scale = sw / dw
        scaled_h = int(dh * scale)
        scaled_active = active_img.resize((sw, scaled_h), Image.Resampling.LANCZOS)
        
        scroll_progress = (local_time % (scene_duration * 0.5)) / (scene_duration * 0.5)
        max_scroll = max(0, scaled_h - sh)
        scroll_y = int(min(max_scroll, scroll_progress * 340))
        screen_crop = scaled_active.crop((0, scroll_y, sw, scroll_y + sh))
        
        phone = build_phone_frame(screen_crop, pw=640, ph=1240)
        px = (W - phone.width) // 2
        py = 270 + int(math.sin(local_time * 1.8) * 6)
        frame.paste(phone, (px, py), phone)
        
        draw_pill(draw, 280, 1540, "Certified Midwife Care", (28, 14, 38), VIOLET_ACCENT, FONT_BADGE, stroke_color=VIOLET_ACCENT, stroke_width=2, icon_type="shield")
        draw_pill(draw, 780, 1540, "One-Tap SOS Support", (28, 14, 38), ROSE_ACCENT, FONT_BADGE, stroke_color=ROSE_ACCENT, stroke_width=2, icon_type="heart")

    elif scene_idx == 4:
        # Scene 5: Partner Inclusivity & Call to Action (Celebratory Finale)
        draw_pill(draw, W // 2, 120, "JOIN THOUSANDS OF FAMILIES", (40, 18, 52), ROSE_ACCENT, FONT_CAPTION, stroke_color=ROSE_ACCENT, stroke_width=2, icon_type="heart")
        draw.text((W // 2, 195), "Empowering Every Mama", font=FONT_TITLE_LG, fill=WHITE, anchor="mm")
        
        # Ambassador Portrait as circular avatar with gold/rose double halo
        avatar_size = 460
        avatar_mask = Image.new("L", (avatar_size, avatar_size), 0)
        d_avm = ImageDraw.Draw(avatar_mask)
        d_avm.ellipse([0, 0, avatar_size, avatar_size], fill=255)
        
        pw, ph = AMBASSADOR_IMG.size
        s = max(avatar_size / pw, avatar_size / ph) * 1.08
        rw, rh = int(pw * s), int(ph * s)
        r_amb = AMBASSADOR_IMG.resize((rw, rh), Image.Resampling.LANCZOS)
        ox = (rw - avatar_size) // 2
        oy = int((rh - avatar_size) * 0.18)
        crop_amb = r_amb.crop((ox, oy, ox + avatar_size, oy + avatar_size))
        
        avatar = Image.new("RGBA", (avatar_size, avatar_size), (0, 0, 0, 0))
        avatar.paste(crop_amb, (0, 0), avatar_mask)
        
        # Halo rings
        d_h = ImageDraw.Draw(avatar)
        d_h.ellipse([3, 3, avatar_size - 3, avatar_size - 3], outline=(244, 114, 182, 240), width=6)
        
        av_x = (W - avatar_size) // 2
        av_y = 280 + int(math.sin(local_time * 2.0) * 8)
        frame.paste(avatar, (av_x, av_y), avatar)
        
        # Features Grid
        draw_pill(draw, W // 2, 800, "Partner & Family Mode Included", (35, 16, 48), AMBER_ACCENT, FONT_BADGE, stroke_color=AMBER_ACCENT, stroke_width=2, icon_type="star")
        draw_pill(draw, W // 2, 885, "Bilingual: English & Kiswahili", (35, 16, 48), TEAL_ACCENT, FONT_BADGE, stroke_color=TEAL_ACCENT, stroke_width=2, icon_type="check")
        draw_pill(draw, W // 2, 970, "100% Free & Offline-Ready", (35, 16, 48), LILAC_LIGHT, FONT_BADGE, stroke_color=VIOLET_ACCENT, stroke_width=2, icon_type="shield")
        draw_pill(draw, W // 2, 1055, "Direct Midwife & Community Care", (35, 16, 48), ROSE_ACCENT, FONT_BADGE, stroke_color=ROSE_ACCENT, stroke_width=2, icon_type="heart")
        
        # Pulsing CTA Button
        pulse = 1.0 + 0.04 * math.sin(local_time * 6.0)
        btn_w = int(780 * pulse)
        btn_h = int(112 * pulse)
        btn_x0 = (W - btn_w) // 2
        btn_y0 = 1210
        btn_x1 = btn_x0 + btn_w
        btn_y1 = btn_y0 + btn_h
        
        draw.rounded_rectangle([btn_x0, btn_y0, btn_x1, btn_y1], radius=btn_h // 2, fill=(236, 72, 153), outline=(255, 255, 255), width=3)
        draw.text((W // 2, btn_y0 + btn_h // 2), "DOWNLOAD NIAMAMA TODAY", font=FONT_TITLE_MD, fill=WHITE, anchor="mm")
        draw.text((W // 2, 1380), "Caring for Mother and Child, Anywhere.", font=FONT_BODY, fill=LILAC_LIGHT, anchor="mm")
        draw.text((W // 2, 1440), "Available on Android & Web", font=FONT_BADGE, fill=ROSE_ACCENT, anchor="mm")

    # Always draw subtitles bar
    draw_subtitles_bar(draw, sub_text)
    return frame

# Scene timing configuration
SCENE_DURATIONS = [6.70, 8.59, 6.14, 7.25, 8.21]
SCENE_FRAMES = [int(d * FPS) for d in SCENE_DURATIONS]
TOTAL_FRAMES = sum(SCENE_FRAMES)
TOTAL_DURATION = sum(SCENE_DURATIONS)

print(f"Total Frames: {TOTAL_FRAMES} ({TOTAL_DURATION:.2f}s)")

# Main Pipeline Execution
def main():
    print("Step 1: Checking Master Audio...")
    master_audio = "/tmp/master_audio.m4a"
    if not os.path.exists(master_audio):
        print("Master audio missing, generating...")
        # Handled in setup
    
    print("Step 2: Starting FFmpeg Pipe...")
    ffmpeg_cmd = [
        FFMPEG_EXE, "-y",
        "-f", "rawvideo",
        "-vcodec", "rawvideo",
        "-s", f"{W}x{H}",
        "-pix_fmt", "rgb24",
        "-r", str(FPS),
        "-i", "-",
        "-i", master_audio,
        "-c:v", "libx264",
        "-preset", "fast",
        "-crf", "18",
        "-pix_fmt", "yuv420p",
        "-c:a", "aac",
        "-b:a", "192k",
        "-shortest",
        OUTPUT_VIDEO
    ]
    
    proc = subprocess.Popen(ffmpeg_cmd, stdin=subprocess.PIPE, stderr=subprocess.PIPE)
    
    print("Step 3: Rendering Video Frames...")
    global_frame = 0
    start_scene_frame = 0
    
    for scene_idx, n_frames in enumerate(SCENE_FRAMES):
        scene_dur = SCENE_DURATIONS[scene_idx]
        print(f"Rendering Scene {scene_idx + 1}/5 ({n_frames} frames)...")
        for f in range(n_frames):
            local_time = f / FPS
            img = render_frame(global_frame, scene_idx, f, local_time, scene_dur)
            proc.stdin.write(img.tobytes())
            global_frame += 1
            if global_frame % 90 == 0:
                print(f"  Frame {global_frame}/{TOTAL_FRAMES} ({global_frame * 100 // TOTAL_FRAMES}%)")
    
    proc.stdin.close()
    print("Step 4: Finalizing MP4 Container...")
    stderr = proc.stderr.read()
    proc.wait()
    if proc.returncode != 0:
        print("FFmpeg Error:", stderr.decode("utf-8")[-800:])
        sys.exit(1)
        
    print(f"SUCCESS! Reel created at: {OUTPUT_VIDEO}")
    file_size = os.path.getsize(OUTPUT_VIDEO) / (1024 * 1024)
    print(f"Final File Size: {file_size:.2f} MB")

if __name__ == "__main__":
    main()
