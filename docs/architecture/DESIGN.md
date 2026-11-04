---
name: Nurture & Bloom
colors:
  surface: '#f7faf5'
  surface-dim: '#d8dbd6'
  surface-bright: '#f7faf5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f4f0'
  surface-container: '#ecefea'
  surface-container-high: '#e6e9e4'
  surface-container-highest: '#e0e3df'
  on-surface: '#191c1a'
  on-surface-variant: '#424942'
  inverse-surface: '#2d312e'
  inverse-on-surface: '#eff2ed'
  outline: '#727972'
  outline-variant: '#c1c8c0'
  surface-tint: '#41674c'
  primary: '#3e644a'
  on-primary: '#ffffff'
  primary-container: '#567d62'
  on-primary-container: '#f6fff4'
  inverse-primary: '#a7d1b0'
  secondary: '#6b5b50'
  on-secondary: '#ffffff'
  secondary-container: '#f4dfd0'
  on-secondary-container: '#716156'
  tertiary: '#964327'
  on-tertiary: '#ffffff'
  tertiary-container: '#b55b3d'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c2edcb'
  primary-fixed-dim: '#a7d1b0'
  on-primary-fixed: '#00210f'
  on-primary-fixed-variant: '#294e36'
  secondary-fixed: '#f4dfd0'
  secondary-fixed-dim: '#d7c3b5'
  on-secondary-fixed: '#241911'
  on-secondary-fixed-variant: '#52443a'
  tertiary-fixed: '#ffdbd0'
  tertiary-fixed-dim: '#ffb59e'
  on-tertiary-fixed: '#390b00'
  on-tertiary-fixed-variant: '#7a2f15'
  background: '#f7faf5'
  on-background: '#191c1a'
  surface-variant: '#e0e3df'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 23px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 19px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  margin: 1.25rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system embodies a grounding, restorative companion tailored for new mothers during the fragile, sleep-deprived windows of postpartum recovery and infant development (0–24 months). The interface balances quiet emotional safety with functional clarity, avoiding sterile medical aesthetics, hyper-stimulating gamification, or anxiety-inducing alert styles. 

The aesthetic is **Tactile Warm Minimalism**:
- Generous breathing room that respects low cognitive bandwidth and sensory fatigue.
- Organic softness expressed through deep rounded geometries and warm, physical paper-and-linen card metaphors.
- Empathy-first hierarchy where vital infant logging and maternal self-care prompts sit side by side without guilt-inducing friction.
- Calm, human-paced micro-interactions designed to be operated single-handedly in dim nursery lighting.

## Colors

The palette grounds the product in earthy, non-clinical tranquility:

- **Primary (`#5B8266` — Sage Herbal):** Represents healing, renewal, and calm balance. Used for primary calls to action, completed milestone states, active bottom navigation states, and soothing visual anchors.
- **Secondary (`#E8D3C5` — Warm Blush Sand):** An embracing, tender secondary tone. Used for resting surfaces, soft category chips, gentle background tints, and progress tracks.
- **Tertiary (`#D97757` — Terracotta Earth):** A tender, warm warning and notification tone. Completely replaces harsh clinical reds for missed logs, scheduled medication reminders, and pediatric check-up prompts to avoid triggering maternal distress.
- **Neutral (`#2D312E` — Soft Charcoal):** An accessible, deep organic dark tone with green-brown undertones. Provides WCAG AAA contrast against the cream canvas while avoiding the sharp, digital harshness of pure black (`#000000`).
- **Canvas Base (`#FAF8F5` — Oat Cream):** Replaces clinical pure white with a warm, restorative milk-and-oat background that reduces eye strain during 3:00 AM feedings.
- **Card Surface (`#FFFFFF` — Clean Linen):** Subtle pure white elevation overlays set against the oat cream canvas for content separation.

## Typography

Typography relies entirely on **Plus Jakarta Sans**, chosen for its friendly, rounded terminals, open counters, and high legibility at micro sizes. The type system eliminates sharp, rigid geometric cuts in favor of warmth and human approachability.

- **Headlines:** Set with confident semi-bold and bold weights, maintaining snug negative tracking to anchor maternal summaries, developmental leaps, and wellness logs.
- **Body Text:** Uses balanced line heights (1.5x–1.55x) to facilitate skim-reading during exhaustion. Paragraphs avoid long line lengths to prevent reading fatigue.
- **Labels & Timestamps:** Employs medium-to-semibold weights with subtle letter spacing for rapid scanning of feeding timers, sleep durations, and diaper counts.

## Layout & Spacing

The layout is built around a mobile-first, single-handed ergonomics philosophy, utilizing a fluid 4-column grid on mobile (expanding to 8 columns on tablet viewports):

- **Single-Hand Usability:** Key interactive triggers (quick-log timers, nursing switchers, save actions) sit within the lower 40% "thumb zone" of the screen.
- **Generous Safe Padding:** The canvas utilizes `margin-mobile: 1rem` (16px) with an inner card cushion of `space-md` (16px) to `space-lg` (24px), preserving breathing room around dense tracking data.
- **Touch Targets:** All interactive triggers maintain an absolute minimum touch zone of 48×48px, preventing mis-taps while cradling an infant.
- **Rhythm:** Layout stacks follow vertical units based on `space-sm` (8px) increments, utilizing `space-xl` (32px) between unrelated narrative modules (e.g., between Baby Feeding and Mother's Hydration).

## Elevation & Depth

To avoid cold, artificial depth, this design system rejects heavy directional drop shadows, hard outlines, and gloss. Depth is constructed through **Ambient Warm Diffusions** and **Tonal Layering**:

- **Ground Level (Canvas):** Warm oat cream (`#FAF8F5`) acts as the resting plane.
- **Elevation 1 (Cards & Trackers):** Pure linen white surfaces (`#FFFFFF`) sitting atop the cream canvas, elevated by a diffused, warm-tinted shadow: `0 4px 20px -2px rgba(45, 49, 46, 0.04)`.
- **Elevation 2 (Floating Action Triggers & Sheets):** Used for nursing timers and persistent bottom bar elements, elevated with: `0 8px 32px -4px rgba(45, 49, 46, 0.08)`.
- **Tactile Boundaries:** When borders are needed for form fields or inactive toggles, soft neutral boundaries are used at 1px solid (`rgba(45, 49, 46, 0.08)`), never pure grays.

## Shapes

The shape system strictly eliminates hard corners and clinical edges, celebrating soft, organic curves:

- **Cards & Modal Sheets:** Utilize `rounded-lg` (16px) up to `rounded-xl` (24px) corner radii to present a pillowed, reassuring physical container.
- **Quick-Action Chips & Badges:** Rendered as full pills (`border-radius: 9999px`) to invite effortless tactile tapping.
- **Progress Trackers & Sliders:** Completed with continuous rounded ends and soft dot indicators.
- **Icon Enclosures:** Enclosed in gentle squircle or circular soft-tint badge backdrops.

## Components

### Buttons
- **Primary Buttons:** High-contrast pill containers filled with Sage Green (`#5B8266`) and white text. Height is 52px with horizontal padding of 24px. Micro-states feature a subtle press compression (`scale: 0.98`).
- **Secondary Buttons:** Soft Blush Sand (`#E8D3C5`) or 12% Sage tint fills with Charcoal (`#2D312E`) text.
- **Ghost/Tertiary Buttons:** Text-only in Charcoal or Sage, enclosed in minimum 48px touch bounding boxes.

### Chips & Quick-Log Switches
- **Pill Shape:** 36px–42px height, pill radius (`9999px`).
- **Unselected State:** Canvas surface with 1px soft border (`rgba(45, 49, 46, 0.08)`) and neutral label.
- **Selected State:** Filled with Sage Green (`#5B8266`) or Warm Blush Sand (`#E8D3C5`) with matching high-contrast label.

### Cards
- **Structure:** Crisp white surface (`#FFFFFF`) with 20px corner radius, padding of 16px to 20px, framed by an ambient warm shadow.
- **Variations:** 
  - *Status Card:* Houses active sleep/feeding timers with a soft sage or blush tint wash.
  - *Insight Card:* Displays gentle developmental milestones, paired with warm terracotta badges.

### Lists & Activity Rows
- **Dividers:** Zero hard lines. List items are grouped inside rounded card containers or separated with 8px whitespace cushions.
- **Structure:** Left-aligned rounded icon badge (40px circular background), two-line hierarchical label (title + timestamp), and a soft chevron or state pill on the right.

### Input Fields & Steppers
- **Form Fields:** 52px height, 16px rounded corners, filled with oat cream canvas background (`#FAF8F5`). Borders are 1px soft charcoal tint, shifting to a 1.5px Sage Green border upon focus with zero harsh glow.
- **Stepper Counter (e.g., Ounces/Milliliters):** Large center-aligned numeric display flanked by 44px circular soft buttons (`+` and `-`) engineered for thumb reach.

### Checkboxes & Radio Controls
- **Radios:** 24px circles with a 4px Sage inset dot when selected.
- **Checkboxes:** 24px soft rounded squares (8px border radius) filling with Sage Green and a clean white checkmark upon completion.

### Specialized Maternal & Pediatric Components
- **Dual-Tracker Timer (Breastfeeding L/R):** Two side-by-side pill segments with 56px height. Active side pulses with a soothing breathing animation in Sage Green; inactive side remains in resting cream.
- **Restorative Check-in Widget:** Non-judgmental mood and physical recovery sliders using warm terracotta and sand gradients with expressive, gentle icon labels.