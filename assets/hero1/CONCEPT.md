# Hero 1 Concept — Phase A (In progress)

Status: Started. This file records the initial concept, pose list, color notes, and an ETA for the first visual checkpoint (thumbnails + key poses).

Name: TBD (Hero 1)
Style goals:
- Capcom-style weight and contact frames
- 128×128 sprite canvas per frame
- Warm, high-contrast 16-color palette
- Strong silhouettes, readable thumbnails at 1x and 2x

Pose / animation list (Phase A):
- Idle (6 frames) — breathing + subtle weight shift
- Walk (8 frames) — clear contact frames and heel-toe weight
- Attack 1 (light) (6 frames) — quick jab, strong contact frame
- Attack 2 (heavy) (8 frames) — wind-up, hitstop contact, recoil
- Special (10 frames) — cinematic burst with FX sync
- Hurt (3 frames)
- Death (10 frames)

FX (Phase A):
- hit_spark (8 frames) — radial burst with glow
- special_burst (10 frames) — larger layered burst
- floating damage numbers (font + pop/fade)

Import rules
- All PNGs: Filter Off, Mipmaps Off, Lossy Compression Off
- Sprite sheets exported as separate frame PNGs and a .tres SpriteFrames file created on import

Deliverables & ETA
- Thumbnails + key poses (push preview): within ~12–18 hours
- Full 128×128 hero spritesheet and integration into Player.tscn: within ~48 hours

Notes
- I will create original art and progressively commit:
  - assets/hero1/concepts/* (thumbnails and key poses)
  - assets/hero1/frames/* (final frames per animation)
  - assets/fx/* (hit and special FX)
  - assets/ui/* (HUD elements and pixel font)

If you want any adjustments to the hero concept (weapon type, armor style, stance), tell me in one line; otherwise I’ll proceed with an archetypal heavy-strike hero (sword + shield stance) that reads well in silhouette and emphasizes hit impact.
