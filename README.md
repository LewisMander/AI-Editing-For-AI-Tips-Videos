# AI Tips Video Editing Skill for Claude and Codex

This repository contains a reusable Agent Skill for turning raw OBS or desktop recordings into concise AI demonstration videos.

The core `SKILL.md` format works with both Claude and Codex. It gives the agent a consistent editing approach for choosing useful moments, removing dead time, keeping important clicks understandable, adding restrained zooms and checking the finished MP4 before delivery.

For local video editing, use Codex Desktop, Codex CLI or Claude Code. Claude.ai and Cowork can also accept the skill as a ZIP where custom Skills are available, but local editing still depends on the environment being able to access the recording and run FFmpeg or Remotion.

## What it helps with

- Inspecting the source recording before editing.
- Building a clear sequence from prompt, reasoning, result and application actions.
- Speeding up passive AI reasoning while keeping choices and clicks at normal speed.
- Adding readable prompt-focused or screen-centred zooms.
- Avoiding ghosted crossfades, abrupt application changes and unnecessary final zooms.
- Producing and checking limited-range BT.709 H.264 video.
- Verifying the complete export with FFprobe, a full decode and an optional contact sheet.

## Requirements

- Codex Desktop, Codex CLI or Claude Code with local Agent Skills support.
- FFmpeg and FFprobe available on the system path.
- PowerShell for the two bundled helper scripts.
- A Remotion project if you want the agent to implement the edit with Remotion. FFmpeg-only edits do not require Remotion.

The skill supplies editing judgement and reusable technical patterns. It does not bundle FFmpeg, Remotion or a video editor, and it does not upload recordings anywhere by itself.

## Install for Codex or Claude Code

Clone or download this repository, open PowerShell in the repository folder and choose one command.

Install for Codex:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Platform Codex
```

Install for Claude Code:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Platform Claude
```

Install for both:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Platform Both
```

The installer stops without overwriting anything if a skill with the same name is already installed.

Codex may need a new task or restart before the skill appears. Claude Code normally detects changes inside an existing skills directory, but restart it if the top-level directory did not already exist.

### Manual installation

Copy the complete `ai-tips-editing` folder to the relevant location:

```text
Codex:      %USERPROFILE%\.codex\skills\ai-tips-editing
Claude Code: %USERPROFILE%\.claude\skills\ai-tips-editing
```

For a project-only Claude Code installation, place it at `.claude\skills\ai-tips-editing` inside that project.

## Install in Claude.ai or Cowork

Where custom Skills are available:

1. Create a ZIP containing the complete `ai-tips-editing` folder.
2. Open **Customize > Skills**.
3. Select **Create skill**, then **Upload a skill**.
4. Upload the ZIP and enable the skill.

On Windows, you can create the ZIP from the repository folder with:

```powershell
Compress-Archive -Path .\ai-tips-editing -DestinationPath .\ai-tips-editing.zip
```

## Use it

Provide the local path to a raw screen recording, then ask Codex:

```text
Use $ai-tips-editing to turn this recording into a polished, silent AI-tip video under two minutes. Keep the prompt, important choices and final result. Remove dead time, use restrained zooms and verify the finished MP4.
```

In Claude Code, ask naturally or invoke the skill directly:

```text
/ai-tips-editing Edit this recording into a polished, silent AI-tip video under two minutes. Keep the prompt, important choices and final result.
```

For a small revision to an accepted edit:

```text
Keep everything else unchanged, but leave the plugin selection at normal speed.
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

The `agents/openai.yaml` file supplies Codex interface metadata. Claude ignores it and uses the shared `SKILL.md` instructions and supporting files.

The original recording should always remain unchanged. Create versioned outputs so an accepted edit can be recovered if a later revision does not work.

