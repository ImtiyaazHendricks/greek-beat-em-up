# VISUALS_PLAN

Goal: Deliver a polished, arcade/hand-painted pixel aesthetic with high-quality assets, animations, HUD and feel that match the composition and impact of the reference (original art, not copied). Work will be committed to branch: `polish/visuals-hitfeel` and merged by PR when Phase A is complete.

Quality target
- Frame-by-frame pixel animation with clear contact frames and weight (Capcom-style impact feel).
- 128×128 sprite sheets for main heroes with smooth animations (idle/walk/atk1/atk2/special/hurt/death).
- Additive, well-timed FX (hit sparks, bursts) and crisp pixel HUD with framed portraits.
- Global palette grading via shader (palette remap + scanlines + vignette) for consistent look.
- Correct import settings (Filter Off, Mipmaps Off, Compression Off) to preserve pixel clarity.

Delivery milestones

Phase A — First playable visual pass (ETA: ~48 hours from start)
- Deliverables:
  - One fully animated original hero spritesheet integrated into Player.tscn
  - HUD assets (portrait frame, HUD bar 9-patch, item icons)
  - FX assets: hit_spark (8 frames), special_burst (10 frames)
  - Pixel UI font (PackedFont/BitmapFont)
  - Palette texture (16 colors) + tuned shaders (palette_scanline.shader)
  - visuals_demo.tscn updated to show hero vs enemy + HUD
  - Correct import settings and tuned hitstop/camera shake/FX timing
- Output: PR with screenshots/GIFs and export build (Windows + Linux by default)

Phase B — Remaining heroes + enemies (ETA: +24–48 hours)
- Deliverables:
  - 3 additional hero spritesheets (Perseus, Athena, Hercules, Artemis total 4)
  - Initial enemy set sprites (Skeleton, Satyr, Harpy, Minotaur) base frames
  - Boss placeholder (Hydra) frames
  - Tuning and iteration based on review

Phase C — Backgrounds & polish (ETA: +1–2 days)
- Deliverables:
  - Layered parallax background (foreground/mid/background) with statue and foliage
  - Final enemy polish and additional FX
  - Gameplay polish pass (timing/particle tweaks, HUD microinteractions)

Process and commits
- I will push incremental, small commits by asset group (HUD, FX, hero1, hero2, etc.).
- Each commit will be accompanied by a short message describing what's added and the files changed.
- When Phase A is complete I will open a PR: title "polish: visuals — first playable art pass" and attach screenshots, short how-to-test, and an export build.

Testing and review
- I will include visuals_demo.tscn aimed for quick review; instructions in the PR will show how to run it locally in Godot 4.2+.
- I will attach short GIFs and screenshots in the PR and mark TODOs for any follow-ups.

Decisions required from you (please reply)
- Palette mood: "warm" (recommended) or "muted/grimy"?
- Export builds to attach to the PR: "Windows", "Linux", or "both"?

Notes on originality and licensing
- All art created will be original and owned by you. If you later want to supply assets, I will replace mine using the ART_SPEC naming convention.

Immediate next steps (I will do now)
1. Start hero 1 concept + key poses and commit placeholder preview frames so you can see progress.
2. Produce full hero 1 spritesheet and integrate into Player.tscn.
3. Create HUD + FX and integrate; tune shader and timing.

If you confirm the tiny choices above (palette + exports) I will lock them in and proceed. Otherwise I will default to: palette = warm, exports = both.
