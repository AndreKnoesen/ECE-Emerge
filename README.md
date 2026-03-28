# ECE Emerge Lab Manuals

ADA-compliant lab manuals for **EEC1: Introduction to Electrical Engineering**, Spring 2026, Department of Electrical and Computer Engineering, UC Davis.

This repository contains lab manuals for the ECE Emerge course, covering hands-on experiments with the ADALM2000 (M2K) measurement platform, signal conditioning, and the ECE Emerge Digital Scale Project.

---

## Contents

| Directory | Description |
|---|---|
| `Lab1/` | Lab 1: Introduction to the M2K, signal acquisition, differential wiring |
| `Lab2/` | Lab 2: DC voltage measurements, resistor networks, signal analysis |
| `Lab3/` | Lab 3: Diode characteristics, frequency domain analysis, Fourier synthesis |
| `Lab4/` | Lab 4: RC and RL transient response |
| `Lab5/` | Lab 5: RC/RL filters, frequency response, Bode plots |
| `Lab6/` | Lab 6: Operational amplifiers — unity-gain buffer, slew rate |
| `Lab7/` | Lab 7: Operational amplifiers — inverting, non-inverting, summing amplifiers |
| `Lab8/` | Lab 8: Instrumentation amplifier (INA125), differential signal acquisition |
| `Project/` | ECE Emerge Digital Scale Project brief and appendices |
| `md2ada.py` | Markdown to ADA-compliant HTML converter (see below) |
| `Learning objectives for labs/` | Essential learning objectives for Lectures 1–16 |

Each lab directory contains:

```
LabN/
  LabNInstructions.md       ← source document
  media/                    ← images referenced by the lab manual
  htmlconversion/           ← generated ADA-compliant HTML (self-contained)
```

---

## Learning Objectives for Labs

Essential skills and learning objectives aligned to each lecture, used to guide lab assessment.

| File | Link |
|---|---|
| Lecture 1 Essentials | [Lecture1Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture1Essentials.md) |
| Lecture 2 Essentials | [Lecture2Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture2Essentials.md) |
| Lecture 3 Essentials | [Lecture3Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture3Essentials.md) |
| Lecture 4 Essentials | [Lecture4Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture4Essentials.md) |
| Lecture 5 Essentials | [Lecture5Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture5Essentials.md) |
| Lecture 6 Essentials | [Lecture6Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture6Essentials.md) |
| Lecture 7 Essentials | [Lecture7Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture7Essentials.md) |
| Lecture 8 Essentials | [Lecture8Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture8Essentials.md) |
| Lecture 9 Essentials | [Lecture9Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture9Essentials.md) |
| Lecture 10 Essentials | [Lecture10Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture10Essentials.md) |
| Lecture 11 Essentials | [Lecture11Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture11Essentials.md) |
| Lecture 12 Essentials | [Lecture12Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture12Essentials.md) |
| Lecture 13 Essentials | [Lecture13Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture13Essentials.md) |
| Lecture 14 Essentials | [Lecture14Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture14Essentials.md) |
| Lecture 15 Essentials | [Lecture15Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture15Essentials.md) |
| Lecture 16 Essentials | [Lecture16Essentials.md](https://github.com/AndreKnoesen/ECE-Emerge/blob/main/Learning%20objectives%20for%20labs/Lecture16Essentials.md) |

---

## HTML Lab Manuals

The `htmlconversion/` folder in each lab directory contains a single self-contained HTML file suitable for upload to a learning management system (Canvas, etc.). All images are embedded as base64 data URIs — no external files are needed.

Math equations are rendered in the browser using [KaTeX](https://katex.org/) loaded from CDN. An internet connection is required for math rendering.

---

## Converter: md2ada.py

`md2ada.py` converts a Markdown source file to an ADA-compliant HTML file.

### Requirements

```bash
pip install markdown beautifulsoup4
```

### Usage

```bash
python md2ada.py path/to/LabNInstructions.md
```

Output is written to `LabN/htmlconversion/LabNInstructions.html`.

### Features

- WCAG 2.1 / ADA compliant output: skip navigation, landmark regions, table captions, `scope="col"` on headers, high-contrast color scheme
- KaTeX math rendering: `$...$` inline and `$$...$$` display math protected from the markdown parser and rendered client-side
- Self-contained output: all images embedded as base64 data URIs
- Responsive table layout with scrollable wrappers

### Image sizing

All images use inline HTML with an explicit width percentage, making per-image size adjustment straightforward:

```html
<img src="media/file.png" alt="descriptive alt text" style="width: 60%; display: block; margin: 0 auto;" />
```

Change the percentage in the `.md` source and re-run `md2ada.py` to update the HTML.

---

## Markdown Authoring Notes

- Always put a blank line between an `<img ... />` tag and the figure caption that follows it, otherwise the caption is absorbed into the HTML block and math inside it will not render.
- Keep all math expressions on a single line — KaTeX does not render inline math that spans a line break.
- Use inline `<img>` HTML for all images rather than `![alt](src)` markdown syntax, to retain per-image size control.

---

## Live Web Access

Lab manuals are served via GitHub Pages:

| Manual | Link |
|---|---|
| Lab 1 Instructions | [Lab1Instructions.html](https://andreknoesen.github.io/ECE-Emerge/Lab1/htmlconversion/Lab1Instructions.html) |
| Lab 2 Instructions | [Lab2Instructions.html](https://andreknoesen.github.io/ECE-Emerge/Lab2/htmlconversion/Lab2Instructions.html) |
| Lab 3 Instructions | [Lab3Instructions.html](https://andreknoesen.github.io/ECE-Emerge/Lab3/htmlconversion/Lab3Instructions.html) |
| Lab 4 Instructions | [Lab4Instructions.html](https://andreknoesen.github.io/ECE-Emerge/Lab4/htmlconversion/Lab4Instructions.html) |
| Lab 5 Instructions | [Lab5Instructions.html](https://andreknoesen.github.io/ECE-Emerge/Lab5/htmlconversion/Lab5Instructions.html) |
| Lab 6 Instructions | [Lab6Instructions.html](https://andreknoesen.github.io/ECE-Emerge/Lab6/htmlconversion/Lab6Instructions.html) |
| Lab 7 Instructions | [Lab7Instructions.html](https://andreknoesen.github.io/ECE-Emerge/Lab7/htmlconversion/Lab7Instructions.html) |
| Lab 8 Instructions | [Lab8Instructions.html](https://andreknoesen.github.io/ECE-Emerge/Lab8/htmlconversion/Lab8Instructions.html) |
| ECE Emerge Project | [ECE_Emerge_Project.html](https://andreknoesen.github.io/ECE-Emerge/Project/htmlconversion/ECE_Emerge_Project.html) |
| Equipment: Resistance Measurement | [ResistanceMeasurements.html](https://andreknoesen.github.io/ECE-Emerge/EquipmentInstructions/htmlconversion/ResistanceMeasurements.html) |
| Equipment: DC Voltage Measurement | [DCVoltageMeasurement.html](https://andreknoesen.github.io/ECE-Emerge/EquipmentInstructions/htmlconversion/DCVoltageMeasurement.html) |
| Equipment: Capacitance Measurement | [CapacitanceMeasurement.html](https://andreknoesen.github.io/ECE-Emerge/EquipmentInstructions/htmlconversion/CapacitanceMeasurement.html) |

---

## Contributing

Issues and pull request discussions are not monitored on this repository. For questions, corrections, or collaboration inquiries, contact the author directly:

**Andre Knoesen** — [aknoesen@ucdavis.edu](mailto:aknoesen@ucdavis.edu)
Department of Electrical and Computer Engineering, UC Davis

---

## License

MIT License. See [LICENSE](LICENSE).
