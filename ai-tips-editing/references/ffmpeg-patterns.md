# FFmpeg patterns for AI-tip edits

Use these patterns when FFmpeg handles timing or animated zooms. Calculate each retained source interval before composing the final filter graph.

## Accelerate passive reasoning

Use acceleration only while the AI is passively reasoning or building. Keep the selection that started the work and the next interactive choice at normal speed.

```text
selection at 1x -> passive reasoning at 4x-16x -> next option or result at 1x
```

Set video timing with:

```text
setpts=(PTS-STARTPTS)/SPEED
```

Calculate the output length as:

```text
outputFrames = round((sourceEnd - sourceStart) * fps / speed)
```

Mute accelerated source audio. Add a restrained speed badge when the change is otherwise ambiguous. Prefer `4x` to `8x` if progress text should remain somewhat legible; reserve `16x` for long builds where the viewer only needs to see continued activity.

Do not accelerate:

- plugin, skill, or option selection;
- the hover and click that confirms a choice;
- permission, Allow, or file-selection dialogs;
- application launch and the first settled view;
- completed answers or artefacts that need to be read.

## Lock an animated zoom to screen centre

For an explicitly screen-centred zoom, use `zoompan` so the crop position is recalculated on every frame:

```text
zoompan=
  z='1+(MAX_ZOOM-1)*ENVELOPE':
  x='iw/2-(iw/zoom/2)':
  y='ih/2-(ih/zoom/2)':
  d=1:
  s=2560x1440:
  fps=60
```

For a zoom that eases in, holds, and eases out, build the envelope from the output frame counter:

```text
min(
  min(1,(on/fps)/zoomInSeconds),
  max(0,(clipSeconds-on/fps)/zoomOutSeconds)
)
```

Replace `2560x1440` and `60` with the actual delivery size and frame rate. Keep the `x` and `y` expressions unchanged to maintain a strict `50% 50%` anchor.

Do not rely on an animated `scale` followed by `crop` unless checkpoint frames prove that crop geometry is updating per frame. Some filter chains retain geometry from the first unzoomed frame and make a nominally centred zoom appear to grow from the top-left.

For a constant zoom used in a checkpoint still, this simpler pattern is suitable:

```text
scale=OUT_W*ZOOM:OUT_H*ZOOM,
crop=OUT_W:OUT_H:(in_w-out_w)/2:(in_h-out_h)/2
```

Extract and inspect the fully zoomed frame from every zoom section before a full render. Check the target's position against the frame centre, not merely the filter expression.
