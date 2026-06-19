# Local Voice Assistant

This chart deploys a fully local Home Assistant voice pipeline. All speech and
language processing runs inside the cluster — no cloud services are involved.

```text
voice satellite / phone input
        -> Home Assistant
        -> Wyoming Whisper (speech-to-text)
        -> Home Assistant Assist / Ollama (intent + LLM)
        -> Home Assistant action
        -> Wyoming Piper (text-to-speech)
        -> speaker / satellite output
```

## Deployed components

All components run in the `home-assistant` namespace and are reachable from Home
Assistant via in-cluster DNS. They are configured under the `voice` key in
[`values.yaml`](./values.yaml).

| Component | Workload | Service (in-cluster) | Protocol |
| --- | --- | --- | --- |
| Speech-to-text | `wyoming-whisper` (faster-whisper) | `wyoming-whisper:10300` | Wyoming |
| Text-to-speech | `wyoming-piper` (piper) | `wyoming-piper:10200` | Wyoming |
| Local LLM | `ollama` (IPEX-LLM / Intel iGPU) | `ollama:11434` | Ollama HTTP API |

The Whisper and Piper services speak the [Wyoming protocol](https://www.home-assistant.io/integrations/wyoming/),
so the same services can later be shared by ESPHome / Wyoming voice satellites.

Ollama runs on the 13th gen Intel iGPU through the IPEX-LLM runtime (it requests an
`i915` device via the cluster's Intel GPU resource driver). On first start it
automatically pulls the model configured in `voice.ollama.model` (Qwen3 8B by
default); the model is stored on a persistent volume so it survives restarts.

## Home Assistant configuration (manual)

The Home Assistant **Wyoming** and **Ollama** integrations are *config-flow only* —
they cannot be set up through the YAML config loader used by this chart. Add them
once from the Home Assistant UI after the workloads are running. Everything below
is stored in Home Assistant's own database and persists across restarts.

### 1. Add the Wyoming speech-to-text service (Whisper)

1. Go to **Settings → Devices & services → Add integration → Wyoming Protocol**.
2. Host: `wyoming-whisper`
3. Port: `10300`

### 2. Add the Wyoming text-to-speech service (Piper)

1. **Settings → Devices & services → Add integration → Wyoming Protocol**.
2. Host: `wyoming-piper`
3. Port: `10200`

Piper downloads voices on demand into its config volume, so any of the voices below
can be selected per pipeline. At least a male and a female English voice are
available, plus optional Dutch and Swedish voices:

| Language | Female voice | Male voice |
| --- | --- | --- |
| English | `en_US-lessac-medium` (default), `en_US-amy-medium` | `en_GB-alan-medium`, `en_US-ryan-medium` |
| Dutch | `nl_NL-mls-medium` | `nl_BE-nathalie-medium` |
| Swedish | `sv_SE-nst-medium` | `sv_SE-nst-medium` |

Change the default voice with `voice.piper.voice` in `values.yaml`.

### 3. Add the local LLM (Ollama)

1. **Settings → Devices & services → Add integration → Ollama**.
2. URL: `http://ollama:11434`
3. Select the model (e.g. `qwen3:8b`). It is pulled automatically by the workload,
   so it should already be available in the model list.

### 4. Create the Assist pipeline

1. Go to **Settings → Voice assistants → Add assistant** (or edit the default one).
2. **Conversation agent:** *Ollama* (for LLM answers) or *Home Assistant* (for
   built-in intent control). You can keep one pipeline per use case.
3. **Speech-to-text:** *faster-whisper* (the `wyoming-whisper` service). Pick the
   language (English, and optionally Dutch / Swedish).
4. **Text-to-speech:** *piper* (the `wyoming-piper` service) and choose a voice.
5. Save the pipeline and set it as **preferred** if desired.

### 5. Connect voice satellites / phone input

- The Home Assistant companion app's *Assist* button uses the preferred pipeline
  automatically.
- ESPHome / Wyoming voice satellites can either talk to Home Assistant Assist
  directly or be pointed at the `wyoming-whisper` / `wyoming-piper` services.
- TTS output plays through any Home Assistant media player or voice satellite
  target via the standard `tts.speak` / Assist response path.

## Notes & tuning

- **Whisper accuracy vs. speed:** increase `voice.whisper.model` (e.g. `medium`)
  for better accuracy, or keep `small` for faster CPU transcription.
- **LLM speed:** if Qwen3 8B is too slow on the iGPU, set `voice.ollama.model` to a
  smaller model such as `qwen3:4b`.
- **OpenVINO / iGPU for Whisper:** the standard Wyoming faster-whisper image runs on
  CPU. Intel iGPU/OpenVINO acceleration for STT can be added later by swapping the
  `voice.whisper.image` for an OpenVINO-enabled build and adding an `i915` resource
  claim (see `templates/voice/ollama.yaml` for the claim pattern).
