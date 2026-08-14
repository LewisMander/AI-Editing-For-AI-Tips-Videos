# AI Tips Video Editing Skill for Codex

This repository contains a reusable Codex skill for turning raw OBS or desktop recordings into concise AI demonstration videos.

It gives Codex a consistent editing approach for choosing useful moments, removing dead time, keeping important clicks understandable, adding restrained zooms and checking the finished MP4 before delivery.

## What it helps with

- Inspecting the source recording before editing.
- Building a clear sequence from prompt, reasoning, result and application actions.
- Speeding up passive AI reasoning while keeping choices and clicks at normal speed.
- Adding readable prompt-focused or screen-centred zooms.
- Avoiding ghosted crossfades, abrupt application changes and unnecessary final zooms.
- Producing and checking limited-range BT.709 H.264 video.
- Verifying the complete export with FFprobe, a full decode and an optional contact sheet.

## Requirements

- Codex Desktop or Codex CLI with local skill support.
- FFmpeg and FFprobe available on the system path.
- PowerShell for the two bundled helper scripts.
- A Remotion project if you want Codex to implement the edit with Remotion. FFmpeg-only edits do not require Remotion.

The skill supplies editing judgement and reusable technical patterns. It does not bundle FFmpeg, Remotion or a video editor, and it does not upload recordings anywhere by itself.

## Install

Clone or download this repository, open PowerShell in the repository folder and run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

The installer copies `ai-tips-editing` into your Codex skills folder. It stops without overwriting anything if a skill with the same name is already installed.

If the skill does not appear immediately, start a new Codex task or restart Codex.

### Manual installation

Copy the complete `ai-tips-editing` folder to:

```text
%USERPROFILE%\.codex\skills\ai-tips-editing
```

If you use a custom `CODEX_HOME`, place it inside that folder's `skills` directory instead.

## Use it

Attach or provide the local path to a raw screen recording, then ask Codex something like:

```text
Use $ai-tips-editing to turn this recording into a polished, silent AI-tip video under two minutes. Keep the prompt, important choices and final result. Remove dead time, use restrained zooms and verify the finished MP4.
```

For a small revision to an accepted edit:

```text
Use $ai-tips-editing to revise the existing edit. Keep everything else unchanged, but leave the plugin selection at normal speed.
```

Clear instructions about duration, audio, required moments and where the video will be published will produce a better first edit.

## Included files

```text
ai-tips-editing/
  SKILL.md
  agents/openai.yaml
  references/ffmpeg-patterns.md
  references/remotion-patterns.md
  scripts/finalize-bt709.ps1
  scripts/verify-video.ps1
```

The original recording should always remain unchanged. Create versioned outputs so an accepted edit can be recovered if a later revision does not work.

