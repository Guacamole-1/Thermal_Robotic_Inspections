# Thermal Robotic Inspection System

A thermal inspection system built on a [Unitree Go2](https://www.unitree.com/go2/) quadruped robot, integrating a FLIR Lepton 3.5 radiometric thermal camera mounted on a two-axis gimbal. The operator can drive the robot, monitor a live thermal feed, and orient the camera independently — all from a single web interface over Wi-Fi, without exposing personnel to hazardous environments.

Validated at a transformer substation at ISEL, where two active electrical faults were detected, with peak temperatures exceeding the measurement ceiling of a professional handheld thermal camera.

---

## Poster
![Poster](https://raw.githubusercontent.com/Guacamole-1/Thermal_Robotic_Inspections/master/poster/poster.png)

> 📄 [View full poster (PDF)](https://github.com/Guacamole-1/Thermal_Robotic_Inspections/blob/main/poster/poster.pdf)

---

## Report
![Cover](https://raw.githubusercontent.com/Guacamole-1/Thermal_Robotic_Inspections/main/report/cover.png)

> 📄 [View full report (PDF)](https://github.com/Guacamole-1/Thermal_Robotic_Inspections/blob/main/report/final_report.pdf)

---

## Repository structure

- `report/` — Typst source and compiled PDF of the final report
- `poster/` — Typst source and compiled PDF of the poster
- `go2_app/` — Web interface and backend server source code

## Built with

- [Unitree Go2](https://shop.unitree.com/products/unitree-go2) — quadruped mobile platform
- [FLIR Lepton 3.5](https://www.digikey.pt/en/products/detail/groupgets-llc/PURETHERMAL-3/18677153) via [PureThermal 3](https://www.digikey.pt/en/products/detail/groupgets-llc/PURETHERMAL-3/18677153) — radiometric thermal camera
- [Raspberry Pi 4](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) — payload computer
- [FPV Gimbal](https://www.printables.com/model/1042622-cheap-fpv-gimbal-pantilt/comments) by Steve Eckerlein — two-axis camera mount (modified)
- [Karlz Go2 Clip-On Skin](https://makerworld.com/en/models/2311439-karlz-unitree-go2-clip-on-skin) by Gizmo Karl — robot cover and rail system
- [unitree_ui](https://github.com/legion1581/unitree_ui) by legion1581 — web operator interface (extended)
- [unitree_webrtc_connect](https://github.com/legion1581/unitree_webrtc_connect) by legion1581 — WebRTC robot driver
- Python · FastAPI · aiortc · OpenCV
- TypeScript · Three.js · Vite · WebRTC
