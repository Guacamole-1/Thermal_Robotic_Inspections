# Thermal Robotic Inspection System

A thermal inspection system built on a [Unitree Go2](https://www.unitree.com/go2/) quadruped robot, integrating a FLIR Lepton 3.5 radiometric thermal camera mounted on a two-axis gimbal. The operator can drive the robot, monitor a live thermal feed, and orient the camera independently — all from a single web interface over Wi-Fi, without exposing personnel to hazardous environments.

Validated at a transformer substation at ISEL, where two active electrical faults were detected, with peak temperatures exceeding the measurement ceiling of a professional handheld thermal camera.

---

## Poster
![Poster](https://raw.githubusercontent.com/Guacamole-1/Thermal_Robotic_Inspections/main/poster/poster.png)

> 📄 [View full poster (PDF)](https://github.com/Guacamole-1/Thermal_Robotic_Inspections/blob/main/poster/poster.pdf)

---

## Report

> 📄 [View full report (PDF)](https://github.com/Guacamole-1/Thermal_Robotic_Inspections/blob/main/report/final_report.pdf)

---

## Repository structure

- `report/` — Typst source and compiled PDF of the final report
- `poster/` — Typst source and compiled PDF of the poster
- `go2_app/` — Web interface and backend server source code

## Built with

- [Unitree Go2](https://www.unitree.com/go2/) — quadruped mobile platform
- [FLIR Lepton 3.5](https://www.flir.com/products/lepton/) — radiometric thermal camera
- [PureThermal 3](https://groupgets.com/products/purethermal-3) — UVC development board
- [Raspberry Pi 4](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) — payload computer
- [unitree_ui](https://github.com/legion1581/unitree_webrtc_connect) — open-source web interface (extended)
- Python · FastAPI · aiortc · OpenCV
- TypeScript · Three.js · Vite · WebRTC
