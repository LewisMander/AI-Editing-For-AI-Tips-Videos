---
name: ai-tips-editing
description: Edit raw OBS or desktop screen recordings into polished short AI-tip videos with Remotion and FFmpeg. Use when Codex must review or edit an AI-product demonstration, remove loading and dead time, accelerate passive reasoning, preserve understandable selections and clicks, add restrained readable or centre-locked zooms, compress progress states, prepare a clean client-ready MP4, or revise an existing AI-tip edit without reintroducing jumpiness, ghosted crossfades, excessive zoom, personal UI, or colour-range problems.
---

# AI Tips Editing

Turn a raw screen recording into a concise, readable demonstration that a non-technical viewer can follow. Preserve the native workflow and source evidence; polish pacing without making the interface feel artificial.

## Establish the brief

Confirm or infer:

- target duration and platform;
- whether to preserve, mute, or replace recorded audio;
- which prompt, result, application actions, progress states, preview, and human-review step must remain;
- whether the recording contains personal information or visible errors;
- whether the user wants a new edit or the smallest revision to an accepted version.

When revising an accepted edit, change only the requested moments. Keep the previous output recoverable and produce a new versioned file.

## Inspect before editing

1. Leave the raw source unchanged.
2. Use `ffprobe` to inspect resolution, frame rate, duration, codecs, pixel format, colour range, colour space, and audio.
3. Create contact sheets or checkpoint stills to locate the important actions. Inspect exact transition boundaries when feedback concerns a cut or zoom.
4. Note source limitations such as low bitrate, baked-in zooms, private UI, notification clutter, or visible application errors. Do not claim post-production can restore detail absent from the source.
5. Build a beat map with source start frame, output duration, focus target, audio treatment, and narrative purpose for each section.

## Build a clear story

Prefer this order when the source supports it:

1. Show the plain-English prompt being typed.
2. Show submission and enough reasoning/loading to establish that work is happening.
3. Show the completed answer before switching applications.
4. Preserve the clicks that launch or open the generated artefact.
5. Show the artefact in a settled, readable state; remove resizing and table-adjustment fumbling.
6. Return to the AI workspace and show any follow-up prompt being typed.
7. Compress repeated build or progress states.
8. Show the preview if requested.
9. End on the natural completed result at full-screen scale.

Do not force every video into this structure. Preserve the shortest sequence that still explains cause, action, and outcome.

## Apply the accepted pacing rules

### Reasoning and progress

- Keep reasoning/loading in the normal application view unless a close-up materially improves comprehension.
- Accelerate continuous passive reasoning instead of removing it when visible progression helps the story. Use roughly `4x` to `8x` for short sections and up to `16x` for long builds whose text is not meant to be read.
- Mute accelerated source audio and add a subtle `8x` or `16x` badge so the speed change is honest and legible.
- Keep every teaching action at `1x`: plugin or skill selection, option choice, permission/Allow prompt, file selection, application launch, and any click whose result the viewer needs to understand.
- Start acceleration only after the user's selection has visibly completed. Return to `1x` before the next interactive choice or completed output appears.
- Jump between a small number of meaningful states; remove repetitive waiting.
- Use clean direct cuts between changing UI states. Do not overlap opacity crossfades across dynamic interfaces: they create double text, ghosting, brightness pulses, or a breathing effect.
- Make repeated progress states roughly one second each unless the text needs longer to read.
- Hold the final state long enough to register.

### Application changes

- Avoid a sudden cut from chat to a fully opened spreadsheet or document.
- Preserve the initiating click, permission or confirmation when relevant, launch moment, and settled result.
- Never fast-forward the user's plugin, option, permission, file, or application selection. These are instructional milestones rather than loading time.
- Shorten pauses between those milestones rather than deleting the milestones.
- Preserve representative cursor actions when they make the transition feel continuous.

### Zooms

- Zoom only to make typing or one important action readable.
- When the user explicitly requests a screen-centred zoom, lock the anchor to exactly `50% 50%` on every frame instead of retargeting a nearby interface element.
- Centre the transform origin on the actual text box, cells, button, or result, not the midpoint between two panels.
- Prefer a restrained scale around `1.25` to `1.65`, adjusted for the source layout.
- Ease into a zoom quickly enough to feel intentional, usually over `0.4-1.2` seconds.
- Begin zooming back out when the prompt is submitted or before the context changes. Do not hold the opening zoom until the edit cuts away.
- Keep dense evaluation previews, split layouts, final answers, and sidebars at the original full-screen scale.
- Do not add a final-result zoom merely to create motion. Let the result sit naturally.

### Typing, cursor, and review

- Show the prompt being typed when the prompt itself teaches the workflow.
- Preserve plain-English wording and enough time to read it.
- Use one consistent cursor ring or click indicator; do not add competing cursor effects.
- Show the user review boundary, such as Done/Undo, Apply/Cancel, or Preview/Confirm, when it is part of the lesson.

## Protect presentation quality

- Prefer light mode for office-worker and LinkedIn-style demonstrations unless the brief says otherwise.
- Remove or avoid names, initials, email addresses, bookmarks, notifications, account menus, taskbar clutter, and unrelated applications.
- Use fictional or anonymised data when the workflow could expose customer or supplier information.
- Keep the final duration under two minutes when practical, but do not make the edit incomprehensible to hit an arbitrary number.
- Preserve the source frame rate when motion and cursor smoothness benefit from it.
- Use restrained contrast and sharpening only. Never try to cure a low-bitrate source with aggressive sharpening.

## Implement with Remotion

Read [references/remotion-patterns.md](references/remotion-patterns.md) when building or modifying a Remotion composition.

Keep timeline constants explicit. Recalculate the composition duration whenever beat lengths or overlap change. For direct-cut montages, set overlap to zero and ensure opacity stays at one rather than interpolating across a zero-frame range.

## Implement with FFmpeg

Read [references/ffmpeg-patterns.md](references/ffmpeg-patterns.md) when accelerating reasoning or creating animated centre-locked zooms directly in FFmpeg. Prefer `zoompan` for a true per-frame centred zoom; verify the fully zoomed frame before exporting the entire video.

## Finalise colour and verify

If Remotion emits full-range or incorrect colour tags, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "<skill-folder>\scripts\finalize-bt709.ps1" `
  -InputPath "<intermediate.mp4>" `
  -OutputPath "<final.mp4>"
```

Then run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "<skill-folder>\scripts\verify-video.ps1" `
  -InputPath "<final.mp4>" `
  -ContactSheetPath "<temporary-contact-sheet.png>"
```

Also:

1. Run the project lint and TypeScript checks.
2. Inspect checkpoint frames for every revised cut, zoom boundary, application transition, preview, and ending.
3. Inspect the encoded contact sheet, not only Remotion stills.
4. Require a complete decode with no errors.
5. Confirm resolution, frame rate, audio, pixel format, TV/limited range, and BT.709 tags.
6. Remove only explicitly named temporary files. Preserve the raw source and earlier accepted versions.

## Hand off

Lead with the completed output link. State the material changes, duration, and verification result. Mention visible source limitations only when they affect delivery or client expectations.

