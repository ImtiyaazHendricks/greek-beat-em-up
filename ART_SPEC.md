# ART_SPEC

This document lists the visual assets to be produced for the polish/visuals-hitfeel branch and the exact specs so future artists or automation can replace placeholders reliably.

Priority assets (first integrated pass)
- assets/heroes/hero_perseus_128.png  — spritesheet, 128x128 frames, animations: idle(4), walk(6), atk1(6), atk2(6), special(8), hurt(3), death(6). Grid layout: 8 cols x N rows or single-row strip per animation (documented below).
- assets/heroes/hero_athena_128.png
- assets/heroes/hero_hercules_128.png
- assets/heroes/hero_artemis_128.png

- assets/fx/hit_spark_8.png — 8-frame sprite sheet (64x64 per frame) with additive blending.
- assets/fx/special_burst_10.png — 10-frame sprite sheet (128x128 per frame) with additive blending.

- assets/hud/portrait_frame.png — 72x72 framed portrait image for top HUD.
- assets/hud/hud_bar_9patch.png — 9-patch strip for top HUD bars.
- assets/hud/items_sheet.png — icons 32x32.

- assets/palette/palette_16x1.png — 16x1 palette texture used by shader for color grading.
- assets/font/pixel_font.tres — PackedFont/BitmapFont or BMFont mapping for pixel font.

Notes on file naming and layout
- Spritesheets should be exported with transparent background (PNG), Filter Off, Mipmaps Off, Compression Off.
- Anchor points: character frames should be centered horizontally with a baseline at 3/4 height — export guidance will be added to repo when art is ready.
- SpriteFrames resource names (when creating in Godot) should use animation names: idle, walk, atk1, atk2, special, hurt, death.

Timeline
- Initial placeholder assets committed immediately (done).
- Full original pixel-art hero sheets + FX + HUD: 48–72 hours for first integrated pass.
- Backgrounds & enemy rework: additional 48–72 hours after initial pass if approved.

If you want to supply art or a reference palette, upload a zip with the paths above and I will integrate directly.
