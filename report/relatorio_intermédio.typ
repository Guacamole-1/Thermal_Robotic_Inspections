#set page(paper: "a4",
    flipped: false,
    margin: (left: 0.5in,
    right: 0.5in),
    numbering: "1"
    )
#show link: it => {
  if type(it.dest) == label {
    text(weight: "bold",it)
  } else {
    text(fill:blue,underline(it))
  }
}
#let chapter(num, title, description) = {
  align(right + horizon)[
    #text(size: 36pt, weight: "bold")[Chapter #num]
    #v(0.5em)
    #text(size: 28pt)[#title]
  ]
  v(1em)
  align(center + horizon)[
    #text(size: 11pt)[#description]
  ]
    place(center + top, hide(heading(level: 1, numbering: "1.")[#title])) // so the chapter appears on outline
    counter(heading).update((int(num), 0))  // set to (chapter, 0)
    pagebreak()
}
#show ref: it => strong(it)
#show heading: set align(center)
#show cite: it => super(text(fill: blue.darken(30%), it))
#set list(marker: ([•], [--]))
#set text(size: 16pt)//, font: "Times New Roman Cyr")
#show bibliography: set heading(numbering: "1.")


#set align(center)
#image("logo_isel_novo.png")
\
#heading(level: 1, outlined: false)[Robotic System for Monitoring Industrial Installations \ \ ]
#set text(size: 8pt)
#figure(
image("gemini_dog.png",height: 35%),
    caption: "AI generated depiction of the finished project"
)
#set text(size: 16pt)
\ Progress Report of the Final Year Project \ \
#set text(size:14pt)
 Bachelor's Degree in Electronics, Telecommunications and Computer Engineering \
 2025/2026
#place(
  center + bottom,
  float: true,
  [Duarte Santos nº51764])

#set align(left)
#pagebreak()
#outline()
#pagebreak()

#set text(size:12pt)
#chapter(
    1,
    "Introduction",
    "This chapter presents challenges of integrating a thermal imaging system into a quadruped robotic platform for industrial monitoring applications. It defines the problem addressed, establishes the project objectives and scope, and introduces the key technologies involved, including thermal sensing and robotic platforms."
)
#show heading.where(level:2): set text(size: 20pt)
#show heading.where(level:3): set text(size: 18pt)
#show heading.where(level:4): set text(size: 16pt)
#set heading(numbering: "1.1")
#show heading: it => {
  v(0.5em)
  grid(
    columns: (1fr, 5fr, 1fr),
    align(left)[
      #context counter(heading).display()
    ],
    align(center)[
      #text(weight: "bold")[#it.body]
    ],
    []
  )
  v(0.5em)
}
== Overview
This project aims to use a mobile robotic platform (_Unitree Go2_ quadruped model) and integrate a thermal camera, or another type of sensor that may be relevant during the project for use in monitoring industrial installations. This will allow, in a safe and desirably autonomous way, for the performance of inspections of critical equipment, such as electrical substations. With this system, the aim is to develop the ability to control the robot, receive and monitor images transmitted through a wireless network. In the end, the project aims to demonstrate a use case of industrial inspection with an application close to a real-world scenario.
== Motivation
The motivation for this project lies in improving the safety and efficiency of industrial inspections. Thermal imaging is widely used to detect early signs of equipment failure, but current inspection methods are manual and expose operators to hazardous conditions. By integrating a thermal camera into a quadruped robotic platform, it becomes possible to perform remote and repeatable inspections, reduce human risk, and enable more frequent monitoring of critical infrastructure. \
As _Unitree_'s _Go2_ robot is very cheap (from around 1.300€ to 10.000€ depending on the version@unitree-prices) in comparison with other robots in the market, like _Boston Dynamics_' _spot_ at around 60.000€@boston-spot and _Anybotics' Anymal_ at 130.000€@anymal-x with both having a option for a thermal camera integration (@anymal and @spot), having a cheap alternative to these robots would allow thermal inspection solutions at a significantly lower cost, making them accessible beyond large industrial operators. This opens the possibility of deploying multiple units for increased coverage, performing more frequent inspections, and experimenting with custom sensing and control architectures without the financial constraints associated with high-end platforms. \
#grid(
  columns: (250pt, auto),
  align: left,
  [#move(dx:60pt)[
    #figure(box(image("anymal.png",width: 60%,fit: "cover"),
        clip: true, inset: 1pt),
    caption: "Anybotics' Anymal\nwith a thermal camera add-on")<anymal>
   ]
  ],[#figure(image("spot.jpg",width:67%),
        caption: "Boston Dynamics' Spot\nwith a thermal camera add-on")<spot>])
#pagebreak()
== Project Architecture
For the creation of this project it has to be taken into account not only what components to integrate but how they communicate with each other.
#figure(
    image("blocos.png",scaling:"smooth", width: 60%)
    ,caption:"Block Diagram of Project Architecture"
)

=== Components
- Unitree Go2 (quadruped)
- Thermal camera
- Gimbal
- Micro-controller
- DC-DC step-down converter (28.8V to 5V/3.3V)
=== Details <Details>
The Unitree Go2 robot provides 3 ports: RJ45, XT30, S-BUS.@Go2-internals \
- RJ45 is a port for ethernet networking, and may or may not be used, as the robot has the ability to be controlled via WIFI using the webRTC API @Go2-webrtc.\
- The XT30 connector provides 28.8V directly from the Go2 battery, but may vary between 24V to 33.6V depending on the state of charge.@Go2-internals This has to be taken into account when choosing a step-down module to convert to a lower voltage.
- S-BUS is a port that only receives remote control data and can only can handle the commands that are available on the handheld remote control provided by Unitree @Go2-sbus. It may or may not be needed as the webRTC API provides the same functionality.
=== Requirements
The thermal camera should preferably be radiometric (can measure absolute temperature) and LWIR (Long Wave Infrared) as these cameras can detect sufficiently high temperatures for the scope of this project, and have the benefit of not needing active cooling, unlike MWIR (Medium Wave Infrared). @thermal-cams
#parbreak()
To mount the thermal camera onto the robot it would preferable to have a gimbal as it would allow precise aiming without the need of moving the robot.
#parbreak()
The most suitable micro-controller for this project would be one with I2C, USB, WIFI/Ethernet and enough bandwidth to send video with a resolution of 640x512 at 50Hz.
#parbreak()
The DC-DC step-down converter must provide a stable 5V output for the camera and micro-controller while taking into account the variability of the XT30 port as referenced in @Details
== Problems to solve
=== Finding a Thermal Camera <finding-cam>
Maybe the most important part of the project is finding and choosing a thermal camera, which presents a significant challenge, as most cameras need inquiries to find the price, and are very expensive (in the thousands of Euros).\
\ 
#[
    #set text(size:9pt)
    #show figure.caption: set text(size: 12pt)
    #figure(
        table(
            columns: (1.3cm, 1.6cm, 1cm, 2cm, 2cm, 1cm, 1cm, 1.8cm, 1.6cm, 0.8cm, 0.8cm, auto, 1cm, 0.9cm),
            align: (col, row) => if row == 0 { center } else { left },
            fill: (col, row) => if row == 0 { aqua.lighten(50%) } else if calc.odd(row) { rgb("#f5f5f5") } else { white },
            stroke: 0.5pt + rgb("#cccccc"),

            [Type], [Name], [Radio- metric],
            [Temp. range\ (High Gain)], [Temp. range\ (Low Gain)],
            [Video Data], [Control Prot.], [Supply Voltage],
            [Power dissipation\ (operating/ standby)], table.cell(colspan: 2)[
                #grid(
                    rows: (auto, auto),
                    columns: 1,
                    row-gutter: 6pt,

                    // Top full-width content
                    [FOV],

                    // Bottom row split into two columns
                    grid(
                        columns: (1fr, auto, 1fr),
                        column-gutter: 6pt,
                        [Diag.],
                        line(angle: 90deg, length: 4%,stroke: 0.5pt + rgb("#cccccc") ),
                        [Horiz.],
                    )
                )
            ],// [Horizontal FOV],
            [Resolution (HxV)],[Frame rate (Hz)], [Price],

            [module], link("https://www.digikey.pt/en/products/detail/flir-lepton/500-1387-00/22023225")[Lepton UWFOV], [no],
            [-10°C to 140°C ±5°C], [-10°C to 450°C ±10°C],
            [SPI], [CCI (I2C)], [2.8V - 3.1V],
            [140mW / 5mW], [160°], [160°],
            [160×120],[9], [120€],

            [module], link("https://www.digikey.pt/en/products/detail/flir-lepton/500-0771-01/7606616?s=N4IgTCBcDaIDYFMAOAXA9gOwAQGYB0ArCALoC%2BQA")[Lepton 3.5], [yes],
            [-10°C to 140°C ±5°C], [-10°C to 450°C ±10°C],
            [SPI], [CCI (I2C)], [2.8V - 3.1V],
            [140mW / 5mW], [71°], [57°],
            [160×120],[9], [138€],

            [module], link("https://www.digikey.com/en/products/detail/flir-lepton/500-0758-03/16694505")[Lepton 3.1R], [yes],
            [-10°C to 140°C ±5°C], [-10°C to 450°C ±10°C],
            [SPI], [CCI (I2C)], [2.8V - 3.1V],
            [140mW / 5mW], [119°], [95°],
            [160×120],[9], [142€],

            [camera], link("https://www.digikey.pt/en/products/detail/seek-thermal/S302NP/14267527")[S302NP], [no],
            [-40°C to +330°C], [-],
            [USB], [-], [3.3 - 5.0V],
            [300mW], [-], [105°],
            [320×240],[\<9], [421€],

            [camera], [#link("https://www.alibaba.com/product-detail/IRay-InFiRay-Low-Power-Thermal-Imager_1601440424970.html")[IRay RC-09110X] \ #link("https://liberal-technology.com/wp-content/uploads/2024/07/MINI-384288640512-Uncooled-Infrared-Thermal-Module-Product-Manual-.pdf")[Datasheet]], [yes],
            [-20°C to 150°C ±2°C/2%], [0°C to 550°C ±3°C/3%],
            [DVP, BT656, USB, CVBS], [I2C], [3.3V],
            [\<550mW, fast shot: \<1.23W], [-], [48.7°],
            [640×512],[50], [488€],
        ),
        caption:[Comparison of different cameras]
    )<cameras>
]
#pagebreak()
=== Finding a Micro-Controller and Powering it
After picking a thermal camera, it is necessary to pick a micro-controller that has the required peripherals and processing power. At this stage it is early to decide what micro-controller to use, as it is essential to prototype first with a computer. \
Most micro-controllers need a 5V power source, so it is crucial to have a step-down converter with a output of 5V/3.3V to power the micro-controller and thermal camera.
=== Programming the Micro-Controller
The objective is to have a application where one could define a preset path for the robot to follow and set locations to observe with the thermal camera, but the application should at its most basic level be able to control the robot and gimbal with the thermal camera and see its video stream.
=== Assembly of all Components
From a mechanical standpoint, lightweight and rigid mounting structures must be designed to support the thermal camera, gimbal, micro-controller, and power electronics without compromising the robot's balance or mobility and minimize vibrations
\
Electrically, proper grounding, voltage regulation, and cable management are essential to prevent instability, or disconnections during movement.
#pagebreak()
== Timeline
The following Gantt chart (@gantt) outlines the main phases of the project, from initial research and component selection to system integration, testing, and final validation. Each task is structured to ensure a logical progression, with dependencies defined to maintain technical coherence and efficient resource allocation throughout the academic year.
#{
    show figure.caption: set align(left)
    let col-report = eastern
    let col-components = rgb("#F58518")
    let col-testing = rgb("#54A24B")
    let col-programming = rgb("#B279A2")
    let col-assembly = rgb("#E45756")
    // Import the base library
    import "@preview/gantty:0.5.1" as gantty
    // Here we import many drawers
    import gantty.dependencies: default-dependencies-drawer
    import gantty: (
    dependencies.orthogonal-dependencies-drawer,
    dividers.default-dividers-drawer,
    drawers.default-drawer,
    field.default-field-drawer,
    gantt,
    milestones.default-milestones-drawer,
    sidebar.default-sidebar-drawer,
    task.default-tasks-drawer,
    )
    // And some specific drawers for headings
    import gantty.header: (
    default-headers-drawer, default-month-header, default-week-header,
    )
    set text(font: "New Computer Modern", size:11pt)
    // (This is a library I've found to help render patterns better)
    import "@preview/modpattern:0.1.0": modpattern
    // Here is the pattern we create with it.
    let hatched = modpattern((4pt, 4pt))[
        #place(line(start: (100%, 0%), end: (0%, 100%)))
    ]
    // Now, let us configure how our Gantt chart will be drawn
    let drawer = (
        field: default-field-drawer,         // required
        sidebar: default-sidebar-drawer.with(
            formatters: (
                x => align(center, strong(x.name)),
                x => align(center, x.name),
                x => align(center, emph(x.name)),
            )

        ),
        dividers: default-dividers-drawer.with(styles: (none,)),
        headers: default-headers-drawer.with(
            headers: (
                default-month-header(gridlines-style: none),
                default-week-header(gridlines-style: (
                    stroke: (paint: black, dash: "loosely-dashed", thickness: 0.5pt),
                )),
            ),
        ),
        tasks: default-tasks-drawer.with(
            styles: (

                // LEVEL 0 — containers (no bar)
                (
                    uncompleted: (style: none, width: 0pt),
                    completed-early: (
                        timeframe: (style: none, width: 0pt),
                        body: (style: none, width: 0pt),
                    ),
                    completed-late: (
                        timeframe: (style: none, width: 0pt),
                        body: (style: none, width: 0pt),
                    ),
                ),

                // LEVEL 1 — tasks (colored by group order)
                (
                    uncompleted: (
                        style: (fill: col-report, stroke: black),
                        body: (style: (fill: col-report), width: 7pt),
                        width: 8pt,
                    ),
                    completed-early: (
                        timeframe: (style: (stroke: black), width: 7pt),
                        body: (style: (fill: green.lighten(30%)), width: 7pt),
                    ),
                    completed-late: (
                        timeframe: (style: (fill: red), width: 7pt),
                        body: (style: (fill: col-report,stroke:black), width: 7pt),
                    ),
                ),

                // LEVEL 2 — (if ever used deeper)
                (
                    uncompleted: (
                        style: (fill: col-components, stroke: black),
                        width: 8pt,
                    ),
                ),
            ),
        ),
        dependencies: orthogonal-dependencies-drawer.with(style: (
            stroke: black + 0.75pt,
            radius: 5pt,
            mark: (end: "straight"),
        )),
        milestones: default-milestones-drawer,
    )
    // Now, we rebind the `gantt` variable with our custom drawer: so if
    // we want to create multiple gantt charts they will all have the same style.
    let gantt = gantt.with(drawer: drawer)
    // Draw the gantt chart
    [
    #figure(
    gantt(yaml("gantt.yaml")),
    caption:"Gantt Chart",
    )<gantt>
    ]
}
#pagebreak()
#chapter("2",
    "System Architecture",
    "This chapter details the selection and integration of the hardware components that constitute the robotic inspection system. It covers the rationale behind the choice of thermal camera, power electronics, and mechanical structures, as well as the assembly strategy for mounting all components onto the Unitree Go2 quadruped platform. Each subsystem is evaluated in terms of its technical specifications, compatibility with the overall architecture, and suitability for deployment in an industrial inspection context."
)

== Component Selection
=== Thermal camera

Looking at *@cameras*, despite the higher cost, _IRay RC-09110X_ seems the most attractive option, due to its high refresh rate and resolution, with the latter being essential for measuring temperatures of smaller objects like connections.
However, as the camera comes from _Aliexpress_, the documentation is scarce and there is no SDK, so, the second best option is the _Lepton 3.5_ which was selected due to its lower cost, availability, reduced FOV and radiometric capability, which enables absolute temperature measurements, which are essential for detecting overheating components in industrial environments. On contrary, the other higher-end modules provide improved spatial resolution, but their cost along with lack of documentation and very high FOV's make them undesirable. 

This choice comes at the expense of a limited resolution of 160×120 pixels and a frame rate of 9 Hz, but it still remains adequate for the detection of temperature gradients and localized hotspots. The reduced performance is offset by its low power consumption, compact size, and cost-effectiveness, making it suitable for deployment on a mobile robotic platform where payload and energy constraints are relevant.
\ \
The _Lepton 3.5_ module integrates into the #link("https://www.digikey.pt/en/products/detail/groupgets-llc/PURETHERMAL-3/18677153")[Purethermal-3 development board] which provides a _USB_ interface that abstracts the native _SPI_ and _I2C_ (_CCI_ ) communication with the sensor. This significantly simplifies system development, allowing direct interaction with the camera using standard UVC (USB Video Class@whats-UVC) compatible tools and software libraries.

#figure(image("thermal.png", width: 40%),
caption: [Image captured from the _Purethermal-3_ \ board with the _Lepton 3.5_ module])
=== Step-down Converter
Given that the XT30 port on the _Unitree Go2_ supplies a voltage that varies between 24V and 33.6V depending on battery state of charge, a robust and flexible DC-DC step-down converter is required to provide stable power to the payload electronics.

The selected converter@buck-converter is rated for 150W continuous output, accepting an input voltage range of 5V to 40V and providing an adjustable output between 1.2V and 35V. This range comfortably accommodates the full voltage swing of the battery while allowing the output to be set to a stable 5V rail, sufficient to power a single-board computer such as the _Raspberry Pi_ (which draws up to 3A under load), _PureThermal-3_, _Lepton 3.5_, and the gimbal motors simultaneously.

The converter's wide input tolerance provides an additional safety margin against voltage spikes that may occur during dynamic motor operation of the robot. Its high power rating also ensures the system is not thermally stressed under peak current demand, improving long-term reliability in continuous inspection deployments.
=== Gimbal
As the design and manufacturing of a gimbal from scratch falls outside the scope of this project, an existing open-source model was sourced from Steve Eckerlein at _Printables_@gimbal, a community platform for sharing 3D-printable designs. The selected model (@gimbal-3d) provided a suitable mechanical baseline, a two-axis gimbal for a FPV camera that uses two SG90 servo motors, reducing development time and allowing focus on system integration rather than mechanical design.

As the original model was not dimensioned to accommodate the _PureThermal-3_ development board and its attached _FLIR Lepton 3.5_ module, modifications need to be made to the camera mount in order to match the mounting hole pattern of the _PureThermal-3_ board.

#figure(image("gimbal_3d.png", width: 35%),
caption: "3D assembly of the gimbal")<gimbal-3d>

#pagebreak()

== Assembly onto the robot
To assemble the gimbal, step-down converter, micro-controller, and associated wiring onto the quadruped, it is essential to have a structural enclosure that can be mounted onto the _Unitree Go2_ without permanent modifications to the robot's chassis.
So, a 3D print cover plate design has been sourced from Gizmo Karl at _MakerWorld_@go2-cover (@plate-3d and @plate-3d-pic), specifically designed to fit the top surface of the _Unitree Go2_ body. The part attaches via clip on and locks into the rail on the rear, requiring no permanent modifications to the robot's outer hull and allowing easy removal for maintenance or reconfiguration. \
The use of 3D printing for the enclosure offers several practical advantages in the context of this project. Since the cover is fabricated from a digital model, it can be modified to accommodate the also 3D printed gimbal, the step-down converter, microcontroller and other eletronics.
#grid(
    columns: (auto, auto),
    [
    #figure(image("3d_cover.webp", width: 67%),
        caption: "3D render of the cover plate and rails")<plate-3d>
    ],[
    #figure(image("3d_cover_pic.webp", width: 67%),
        caption: "assembly of the cover plate and rails\n(3D print)")<plate-3d-pic>
    ])

== Programming
The primary programming objective of this project is to develop a interface that consolidates all monitoring and control functions into a single application. The final form of the application, whether a web-based or native desktop implementation, will provide the operator with three simultaneous video feeds: the thermal imaging feed from the _Lepton 3.5_ along with the standard camera feed and the LiDAR point cloud visualization from the _Go2_'s onboard sensors. \
In terms of control, the application will support robot movement via keyboard and mouse as the primary input method, with gamepad support as a desirable extension. Gimbal control will also be integrated, allowing the operator to aim the thermal camera independently of the robot's heading without needing to reposition the platform.


=== Robot Control
Because of the mobile App, the _Unitree Go2_ exposes a _WebRTC_-based communication interface that allows external applications to interact with the robot over a wireless network. The specific library used in this project is _unitree\_webrtc\_connect_ @unitree-webrtc, an open-source Python package that reverse-engineered the underlying _WebRTC_ protocol, allowing more freedom over the official _Unitree SDK_ because interfaces like sport mode (what allows the robot to move and perform actions like sitting, standing, etc...) are locked to the EDU model.

=== Thermal Camera Interface
The _PureThermal-3_ development board exposes the _Lepton 3.5_ to the host system as a standard _UVC_ (USB Video Class @whats-UVC) device, meaning it is recognised by the operating system without the need for proprietary drivers. This allows the video stream to be captured using standard tools such as _Video for Linux_ (_V4L2_) or _OpenCV_, simplifying integration into a Python-based application.

//For access to radiometric data, that is, the raw temperature values per pixel rather than a false-colour video stream, the _FLIR Lepton SDK_ provides the necessary interface to retrieve calibrated thermal measurements via the _CCI_ (_I2C_) protocol abstracted by the _PureThermal-3_ board. This is essential for the industrial inspection use case, where absolute temperature readings are required to identify overheating components rather than simply visualising relative heat distribution. \
Beyond basic video capture, full access to the _Lepton 3.5_'s radiometric and configuration capabilities requires interaction with the _CCI_ interface, which the _PureThermal-3_ exposes through _UVC_  extension units, allowing the host to read and write sensor registers without direct _CCI_ access.On _Linux_, this can be achieved through the standard _V4L2_ API using _uvcdynctrl_ @uvc-capture, or more portably through _libuvc_ @libuvc, a cross-platform C library for _USB_ video devices.
#pagebreak()

#bibliography("bibliography.yaml")
// need to edit draw.io sketch
// falar com o professor:
//      https://github.com/legion1581/unitree_go2_ui, go2 nipple chargers

