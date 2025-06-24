# Synesthetic Sound Color
Godot 4.4.1

## Academic Summary
This plugin was developed as part of a final project exploring synesthetic feedback for inclusive game design. It maps selected colors to corresponding 3D sounds—based on research linking musical note frequencies to color wavelengths—to help visually impaired users navigate and interact in a Godot 3D environment. It overrides a MeshInstance3D’s albedo color and plays a linked AudioStreamPlayer3D, with editor preview support and runtime behavior. The plugin auto-detects or accepts a NodePath to the target mesh, caches audio streams for performance, and aims to provide cooperative, emancipatory gamification through synesthetic associations.

## DevLog

### Version 1.0.0
- Plugin release

### Version 0.3.1
- Plugin configuration improvements
- Icons added
- Node functionality, autonomy, and optimization
- Mesh parameter with hierarchical detection on color change
- Detect or instantiate audio node automatically
- Translation from Pt-Br to English

### Version 0.3.0
- Plugin packaging

### Version 0.2.1
- Fix: Disable sound playback in the editor
- Three new example textures
- Support for preserving original material textures
- Transparency effect when approaching the textured surface
- Fix: Player jump behavior

### Version 0.2.0
- Migration from Godot 3.1 to 4.4.1

### Version 0.1.0 – Usability improvements
- Color selection via **Inspector** instead of relying on object name
- Material override applied at edit-time to avoid black materials in the Editor
