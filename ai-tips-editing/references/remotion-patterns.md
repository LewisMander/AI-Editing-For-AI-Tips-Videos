# Remotion patterns for AI-tip edits

Use these patterns when the edit is implemented in Remotion. Adapt values to the source rather than copying timings blindly.

## Beat map

Represent each retained section explicitly:

```ts
type Beat = {
  startFrame: number;
  durationInFrames: number;
  focus?: "full" | "typing" | "action" | "progress";
};
```

Calculate output duration from all beat durations minus intentional overlaps. Change the composition duration in the same patch as the beats.

## Direct-cut montage

For reasoning or progress states, avoid whole-screen opacity crossfades. They overlap two changing interfaces and create double text or a brightness pulse.

```tsx
const MontageLayer = ({beat, fadeFrames, index, total}: Props) => {
  const frame = useCurrentFrame();
  const fadeIn =
    index === 0 || fadeFrames === 0
      ? 1
      : interpolate(frame, [0, fadeFrames], [0, 1], clampOptions);
  const fadeOut =
    index === total - 1 || fadeFrames === 0
      ? 1
      : interpolate(
          frame,
          [beat.durationInFrames - fadeFrames, beat.durationInFrames - 1],
          [1, 0],
          clampOptions,
        );

  return <AbsoluteFill style={{opacity: Math.min(fadeIn, fadeOut)}}>{/* clip */}</AbsoluteFill>;
};
```

Pass `fadeFrames={0}` for dynamic reasoning and progress montages. Smooth the perceived pacing by choosing coherent source states and preserving useful cursor actions, not by blending different UI states.

## Opening prompt zoom

Zoom into the prompt quickly, hold while typing, and release as the prompt is submitted:

```ts
const scale = interpolate(
  frame,
  [0, zoomStart, zoomEnd, releaseStart, releaseEnd, duration - 1],
  [1, 1, 1.55, 1.55, 1, 1],
  {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
    easing: Easing.bezier(0.22, 1, 0.36, 1),
  },
);
```

Set `transformOrigin` to the prompt box centre. Inspect frames before, during, and after the release.

## Ending rule

Render previews and completed answers without an added transform unless the user explicitly asks for a close-up:

```tsx
<SkillClip durationInFrames={previewDuration} startFrame={previewStart} />
<SkillClip durationInFrames={resultDuration} startFrame={resultStart} />
```

Do not aim a zoom between the main answer and a sidebar. A split layout is already visually dense and should remain full frame.

## Application-launch sequence

Retain short beats for:

1. clicking Open or Launch;
2. accepting any necessary permission;
3. the application appearing;
4. the document or workbook settling;
5. one or two representative cursor actions.

Cut manual resizing, column dragging, table adjustment, and inactive waiting. Keep enough intermediate states that the application does not appear instantaneously.

## Colour finalisation

Remotion may emit a full-range H.264 intermediate. Use the bundled `finalize-bt709.ps1` to produce a limited-range BT.709 H.264 delivery with a restrained contrast, saturation, and sharpening pass. Do not run it on the raw source.

## Checkpoints

Render or extract frames at:

- opening before zoom;
- fully zoomed prompt;
- zoom release;
- every changed reasoning-cut boundary;
- application launch and settled document;
- follow-up typing and submitted prompt;
- one progress state and a progress boundary;
- evaluation preview;
- final answer;
- encoded output timeline contact sheet.

