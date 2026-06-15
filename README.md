# IMHOTEP-inspired WebXR Medical Viewer

A proof-of-concept VR application for immersive visualization of segmented CT data in a biomedical engineering context.
The project was inspired by the IMHOTEP virtual reality framework for surgical applications and implements a simplified, modern WebXR-based medical visualization workspace using Godot.

The application allows the user to inspect a segmented patient case in VR, combining a 3D anatomical model, 2D CT slice views, patient information, a structure legend, quantitative measurements, and an interactive tool palette.

---

## Project Overview

This project was developed as part of a course assignment focused on analyzing and practically testing modern multimedia solutions in biomedical engineering.

The original IMHOTEP framework proposed the use of virtual reality for surgical planning, education, and patient-specific data visualization. Since the original implementation was based on an older technology stack, this project follows a self-developed implementation scenario instead of reproducing the original code directly.

The goal was not to recreate the full IMHOTEP framework, but to practically verify its core concept:

> combining 3D anatomical data, 2D medical images, patient-related information, and interactive tools in a single immersive VR workspace.

---

## Main Features

* WebXR-based VR application
* Designed for Meta Quest / standalone VR browser usage
* Built in Godot
* Runs through GitHub Pages after web export
* Interactive 3D segmented patient model
* 2D CT slice viewer
* Axial, coronal, and sagittal CT views
* Segmentation overlay ON/OFF switching
* Patient information panel
* Structure legend
* Quantitative summary based on measurements exported from 3D Slicer
* Tool palette controlled with VR pointer interaction
* Teleportation-based movement
* VR head tracking and free looking
* Simplified hand/controller markers
* 3D model rotation in four directions
* Structure visibility toggling
* 3D model opacity control

---

## Biomedical Context

Medical imaging data is often complex and multimodal. A single clinical case may include:

* CT or MRI slices
* segmentation masks
* 3D anatomical models
* patient metadata
* quantitative measurements
* clinical descriptions

Traditional 2D image viewing can make it difficult to understand spatial relationships between anatomical structures. This is especially important when analyzing the position of a lesion or mass relative to organs and blood vessels.

This project demonstrates how VR can support biomedical visualization by presenting the following elements in one environment:

* a central 3D anatomical model,
* 2D CT views,
* a patient information panel,
* structure labels and colors,
* basic quantitative measurements,
* interactive visualization tools.

The application is intended as an educational and demonstrational prototype, not as a clinical tool.

---

## Dataset and Medical Data

The proof of concept uses segmented liver CT data from the HCC-TACE-SEG dataset.

The currently implemented patient case includes the following segmented structures:

* Liver
* Mass segment
* Portal vein
* Abdominal aorta

The structures were prepared as 3D surface meshes and imported into the VR environment. Additional CT slice screenshots were prepared for 2D viewing inside the application.

---

## Data Preparation Pipeline

The medical data was prepared using the following workflow:

```text
DICOM CT / segmentation data
        ↓
3D Slicer
        ↓
segmentation verification
        ↓
3D mesh export
        ↓
Blender mesh optimization
        ↓
GLB export
        ↓
Godot scene integration
        ↓
WebXR export
        ↓
Meta Quest / VR browser
```

In parallel, selected CT views were exported as 2D PNG images:

```text
CT slices
        ↓
axial / coronal / sagittal views
        ↓
plain and segmentation-overlay variants
        ↓
2D slice viewer in VR
```

---

## Application Layout

The VR scene is organized as a simplified medical visualization workstation.

```text
Medical Workspace
├── 3D Patient Model
├── 2D CT Slice Screen
├── Patient Information Panel
├── Structure Legend
├── Quantitative Summary Panel
└── Tool Palette
```

The central element of the scene is the segmented 3D patient model.
The 2D CT screen is placed next to the model and allows switching between anatomical views.
The right-side information area contains patient/case information and measurement summaries.
The tool palette provides interaction buttons for controlling the visualization.

---

## Implemented Interactions

The current prototype supports the following interactions:

### 3D Model Controls

* Toggle liver visibility
* Toggle mass segment visibility
* Toggle portal vein visibility
* Toggle abdominal aorta visibility
* Change liver opacity
* Rotate model left
* Rotate model right
* Rotate model up
* Rotate model down
* Reset model view

### 2D CT Viewer Controls

* Switch to next CT view
* Switch to previous CT view
* Toggle segmentation overlay ON/OFF

### VR Navigation

* Look around using headset tracking
* Teleport around the environment
* Interact with buttons using a VR pointer/cursor

---

## Quantitative Summary

The application includes a simplified quantitative panel based on measurements exported from 3D Slicer.

Example measurements shown in the VR scene:

| Structure       | Volume [cm³] | Mean HU |
| --------------- | -----------: | ------: |
| Liver           |       1441.6 |    95.8 |
| Mass segment    |       1470.9 |   110.9 |
| Portal vein     |         14.6 |   182.6 |
| Abdominal aorta |          5.2 |   169.9 |

Only a limited set of measurements is displayed in VR to preserve readability.
The full Slicer output contains additional values such as voxel count, surface area, minimum and maximum Hounsfield units, standard deviation, percentiles, and closed-surface volume.

---

## Technology Stack

* Godot Engine
* WebXR
* GitHub Pages
* 3D Slicer
* Blender
* GLB 3D models
* PNG CT slice views
* Meta Quest / standalone VR browser

---

## Repository Structure

A simplified project structure:

```text
project-root/
├── docs/
│   └── WebXR export for GitHub Pages
│
├── data/
│   └── local medical data and prepared assets
│
├── godot_vr_app/
│   └── Godot project files
│
├── python_pipeline/
│   └── optional data preparation scripts
│
└── README.md
```

Depending on repository cleanup, raw medical data may be excluded from the public repository due to size and licensing constraints.

---

## Running the Project

### Local Godot Preview

1. Open the project in Godot.
2. Open the main VR scene.
3. Run the project locally.
4. Use the debug camera or desktop preview for development testing.

### WebXR / Meta Quest Usage

1. Export the Godot project as a Web build.
2. Place the exported files in the `docs/` directory.
3. Enable GitHub Pages for the repository.
4. Open the GitHub Pages URL in a WebXR-compatible browser on the VR headset.
5. Enter VR mode and interact with the scene using the controller pointer.

---

## Current Status

The prototype currently includes:

* one prepared patient case,
* segmented 3D anatomy,
* interactive structure visibility controls,
* opacity control,
* four-direction model rotation,
* 2D CT slice viewer,
* overlay switching,
* patient information panel,
* structure legend,
* quantitative summary panel,
* VR pointer interaction,
* teleportation movement.

The application is stable enough for demonstration as a proof of concept.

---

## Limitations

This project is a proof of concept and has several important limitations:

* It is not a clinical application.
* It is not validated for medical decision-making.
* It is not certified as medical software.
* It currently supports only a limited number of prepared cases.
* Medical data preparation is mostly offline.
* Full DICOM loading is not implemented inside the VR application.
* Full volume rendering is not implemented.
* Segmentation masks are not generated automatically.
* WebXR performance is more limited than a native VR application.
* Advanced tools such as clipping planes, measurements in VR, annotations, and multi-user collaboration are not implemented.

---

## Possible Future Work

Potential extensions include:

* support for multiple patient cases,
* patient switching inside the VR environment,
* automated DICOM/SEG to GLB/PNG conversion pipeline,
* clipping plane through the 3D model,
* interactive distance and volume measurements,
* direct manipulation of the model using controller grabbing,
* two-hand scaling of the anatomical model,
* additional quantitative measurements,
* annotations and labels placed directly in 3D space,
* educational quiz or guided exploration mode,
* native Meta Quest build,
* integration with a larger medical dataset.

---

## Educational Purpose Disclaimer

This application is intended only as an educational and demonstrational prototype.

It must not be used for diagnosis, treatment planning, clinical decision-making, or any real medical procedure.

---

## Reference

Pfeiffer, M., Kenngott, H., Preukschas, A., Huber, M., Bettscheider, L., Müller-Stich, B., & Speidel, S.
**IMHOTEP: Virtual Reality Framework for Surgical Applications**.
International Journal of Computer Assisted Radiology and Surgery, 2018.

---

## Acknowledgements

This project was inspired by the IMHOTEP framework and uses publicly available segmented CT data for educational visualization purposes.

Tools used during development include Godot, 3D Slicer, Blender, and WebXR-compatible VR hardware.
