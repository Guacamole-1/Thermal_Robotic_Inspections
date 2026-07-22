#import "@local/abbr:0.3.1"
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/subpar:0.2.2"

#abbr.load("acr.csv")
#abbr.config(
    style: it => text(fill: gray.darken(50%),weight: "bold")[#it],
)

#set page(
  paper: "a4",
  flipped: false,
  margin: 2.5cm,
)

#show: abbr.show-rule

#show link: it => {
  if type(it.dest) == label {
      text(weight: "bold", it)
  } else {
      text(fill: blue, underline(it))
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
    place(center + top, hide(heading(level: 1, numbering: "1.")[#title]))
    counter(heading).update((int(num), 0))
    pagebreak()
}

#show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
)

#show raw.where(block: true): block.with(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
)
#let load-file(path) = {
    let code = read(path, encoding: "utf8")
    let lines = code.replace("\r", "").split("\n")
    lines
}

#let wrtc_thermal = load-file("/go2_app/src/connection/thermal_webrtc.ts")

#show: codly-init.with()
#codly(zebra-fill: none,
    languages:(
        ts : (name:[Typescript],color: aqua),
        py : (name:[Python],color:teal),
    )
)

#let code-lines(loaded-file, start, end,filename: "file.ts") = {
    let snippet = loaded-file.slice(start - 1, end).join("\n")
    [
        #codly(header: [*#filename (lines: #start\-#end)*],
        number-format: it => [#(it+start - 1)])
            #raw(snippet, lang: "ts", block: true)

    ]
}
//========================================
// o que foi feito
// update aos acronimos e adicionada lista de acronimos e tabelas
// atualizei as imagens que estao lado a lado
// atualizei diagrama de blocos
// mudei o gimbal e cover plates para arquitetura hardware
//========================================
//#show ref: it => strong(it)
#show heading: set align(center)
#show cite: it => super(text(fill: blue.darken(30%), it))
#set par(justify: true)

#set list(marker: ([•], [--]))
#set text(size: 16pt)
#show bibliography: set heading(numbering: "1.")

#set align(center)
#image("images/logo_isel_novo.png")
\
#heading(level: 1, outlined: false)[Robotic System for Monitoring \ Industrial Installations \ \ ]
#set text(size: 8pt)
#image("images/go2-nobg.png", height: 40%)
#set text(size: 16pt)
\ Final Report of the Bachelors Project \ \
#set text(size: 14pt)
Bachelor's Degree in Electronics, Telecommunications and \ Computer Engineering \
#let day_suff = ("st","nd","rd")
#let today = datetime.today()
#today.display("[month repr:long] [year]")
#place(center + bottom, float: true, [Duarte Santos])

#set align(left)
#pagebreak()
#text(size:28pt)[Abstract]
#text(size:12pt)[

The inspection of industrial electrical infrastructure, such as transformer substations and solar farms, presents significant challenges when carried out by human technicians. Direct access to live high-voltage equipment exposes workers to risks of electrocution, arc flash and electromagnetic radiation, while the logistical cost of deploying trained personnel limits the frequency at which inspections can be performed. Thermal imaging is an established technique for detecting early signs of equipment degradation, but its deployment at scale remains constrained by the same human factors.

This project addresses these constraints by integrating a thermal camera into a low-cost quadruped robotic platform, the _Unitree Go2_, to enable remote thermal inspection of industrial installations. The system combines a _FLIR Lepton 3.5_ radiometric thermal camera mounted on a two-axis gimbal, a _Raspberry Pi 4_ payload computer, and a _WebRTC_-based web interface extended from the open-source _unitree\_ui_ project. The operator can drive the robot, visualise both the standard and thermal camera feeds, and independently orient the gimbal from a single browser interface over a standard _Wi-Fi_ connection.

The system was validated at a transformer substation at _ISEL_, where two active electrical faults were detected. The first, an oxidised cable, reached a peak temperature of 184°C, exceeding the measurement ceiling of the professional handheld thermal camera used as reference, which saturated above 153°C. The second, a loose connection showing cable degradation with no visible external sign, was measured at 151°C. Both faults were correctly identified and localised by the _Lepton 3.5_ despite its limited resolution of 160×120 pixels, demonstrating that the proposed system is capable of detecting thermally significant faults in real industrial environments at a fraction of the cost of existing commercial solutions.
]


#pagebreak()
#text(size:28pt)[Resumo]
#text(size:12pt)[

A inspeção de infraestruturas elétricas industriais, como postos de transformação e parques solares, apresentam desafios significativos quando realizada por humanos. O acesso direto a equipamentos de alta tensão em serviço expõe os trabalhadores a riscos de eletrocussão, arco elétrico e radiação eletromagnética, enquanto o custo logístico de mobilizar pessoal especializado limita a frequência com que as inspeções podem ser realizadas. A termografia é uma técnica estabelecida para detetar sinais precoces de degradação de equipamentos, mas a sua aplicação em larga escala continua condicionada pelos mesmos fatores humanos.

Este projeto aborda estas limitações através da integração de uma câmara térmica numa plataforma robótica quadrúpede de baixo custo, o _Unitree Go2_, com o objetivo de permitir a inspeção térmica remota de instalações industriais. O sistema combina uma câmara térmica radiométrica _FLIR Lepton 3.5_ montada num gimbal de dois eixos, um computador de payload _Raspberry Pi 4_, e uma interface web baseada em _WebRTC_, desenvolvida a partir do projeto de código aberto _unitree\_ui_. O operador pode conduzir o robot, visualizar simultaneamente as imagens da câmara convencional e da câmara térmica, e orientar o gimbal de forma independente, tudo a partir de um único separador do navegador, sobre uma ligação _Wi-Fi_ padrão.

O sistema foi validado num posto de transformação do _ISEL_, onde foram detetadas duas falhas elétricas ativas. A primeira, num cabo oxidado, atingiu uma temperatura máxima de 184°C, ultrapassando o limite de medição da câmara térmica portátil profissional utilizada como referência, que saturava acima dos 153°C. A segunda, numa ligação solta com degradação visível do cabo mas sem sinais externos evidentes, foi medida a 151°C. Ambas as falhas foram corretamente identificadas e localizadas pelo _Lepton 3.5_, apesar da sua resolução limitada de 160×120 píxeis, demonstrando que o sistema proposto é capaz de detetar falhas termicamente significativas em ambientes industriais reais, a uma fração do custo das soluções comerciais existentes.
]
#pagebreak()
#set page(  numbering: "I")
//#counter(page).update(1) // captitulos em impar
#outline()
#pagebreak()
#outline(title: [List of Figures],
  target: figure.where(kind: image))
 #pagebreak()
#outline(title: [List of Tables],
  target: figure.where(kind: table))
#pagebreak()
#set text(size: 12pt)
#abbr.list()
#pagebreak()
#show heading.where(level: 2): set text(size: 20pt)
#show heading.where(level: 3): set text(size: 16pt)
#show heading.where(level: 4): set text(size: 14pt)

#pagebreak()
#set page(  numbering: "1")
#counter(page).update(1)
#chapter(
  "1",
  "Introduction",
  "This chapter introduces the project, the motivation behind the use of a quadruped robot for industrial inspection, and possible use cases for the project"
)

#set heading(numbering: "1.1")
#show heading: it => {
  v(0.5em)
  grid(
    columns: (1fr, 5fr, 1fr),
    align(left)[#context counter(heading).display()],
    align(center)[#text(weight: "bold")[#it.body]],
    [],
  )
  v(0.5em)
}
#let bref(target) = strong(ref(target))


== Overview
This project aims to use a mobile robotic platform, specifically the Unitree Go2 quadruped model, and integrate a thermal camera for monitoring industrial installations. This will allow, in a safe and desirably autonomous way, for the performance of inspections of critical equipment, such as electrical substations. With this system, the aim is to develop the ability to control the robot, receive and monitor images transmitted through a wireless network. In the end, the project aims to demonstrate a use case of industrial inspection with an application close to a real-world scenario.

== Use cases
=== Inspection of electrical substations <REN>
_REN_ (Redes Energéticas Nacionais) is the Portuguese transmission system operator, responsible for managing the high-voltage electricity grid and natural gas network across the country. Its infrastructure includes hundreds of substations, switching stations and transmission corridors that require regular inspection to ensure reliable operation and prevent failures.

Currently, these inspections are carried out by human technicians who must physically access the equipment. This introduces several challenges. Electrical substations operate at high voltages and present a constant risk of electrocution, arc flash and electromagnetic exposure, meaning that workers must follow strict safety protocols and maintain minimum approach distances from live equipment. Inspections are therefore slow, require specialised training, and can only be performed during scheduled maintenance windows or when the relevant sections can be de-energised. The frequency of inspections is consequently limited by cost, availability of trained personnel, and the logistical difficulty of reaching remote or hard-to-access sites.

Thermal inspection in particular is well established as a method for detecting early signs of equipment degradation, such as overheating connections, failing insulators and unbalanced loads, but deploying it at scale is constrained by the same human factors. A single inspection campaign across a large substation requires significant time on site and exposes workers to the associated risks for the duration.

=== Inspection of solar panels <solar-case>

Like any other electrical system, solar panels are susceptible to various faults that can compromise their performance, efficiency, and longevity. These issues can arise due to manufacturing defects, installation errors, environmental exposure, or operational stresses. One of the most common faults is the formation of hot spots@solar-panels (*@hotspots*), which occur due to partial shading, poor soldering, or faulty bypass diodes. These localized overheated regions can significantly reduce efficiency and, in severe cases, cause thermal damage or even fire hazards.

Solar farms present a particularly strong case for robotic thermal inspection. Unlike substations, where the equipment is concentrated in a bounded area, solar installations can span hundreds of hectares with thousands of individual panels. Inspecting them manually with a thermal camera is time-consuming and physically demanding, and the frequency at which it can be done is limited by the same labour and cost constraints discussed previously. A mobile platform can cover large areas systematically, flag anomalies in real time, and repeat the survey at intervals that would be impractical for a human team.

#figure(image("images/solar.png", width: 30%), caption: [Solar panel hotspots@solar-panels])<hotspots>

== Motivation

A mobile robotic platform equipped with a thermal camera solves the constraints mentioned in *#ref(<REN>)* and *@solar-case[]*. It can operate continuously in environments that would otherwise require personnel protection measures, perform inspections at a higher frequency without additional labour cost, and collect thermal data remotely while the operator remains at a safe distance.

There are currently available robots with thermal cameras available on the market like _Boston Dynamics_'s _spot_ and _Anybotics' Anymal_ (#bref(<bots>)), but these robots are very expensive at around 60.000€@boston-spot and 130.000€@anymal-x respectively.
As _Unitree_'s _Go2_ robot is very cheap (from around 1.300€ to 10.000€ depending on the version@unitree-prices) having a cheap alternative to these robots would allow thermal inspection solutions at a significantly lower cost, making them accessible beyond large industrial operators. Having the financial constraints more relaxed, opens the possibility of deploying multiple units for increased coverage, allowing more frequent inspections, and experimenting with other custom sensing and control architectures.

#subpar.grid(
    figure(
        box(image("images/anymal.png", width: 60%, fit: "cover"), clip: true, inset: 1pt),
        caption: "Anybotics' Anymal",
    ),<anymal>,
    figure(
        image("images/spot.jpg", width: 55%),
        caption: "Boston Dynamics' Spot",
    ),<spot>,
    columns: (1fr, 1fr),
    caption: [Two of the available robots on the market with their respective thermal add-ons],
    label: <bots>,
    gap: 20pt,
)

#pagebreak()
#chapter(
    "2",
    "System Architecture",
    "This chapter presents the global system architecture, including the functional block diagram, the rationale for the main component choices, the mechanical assembly onto the robot, and a brief introduction to the programming strategy used to combine robot control, thermal streaming and gimbal control in a single operator system."
)
== Requirements
The system must be able to perform remote thermal inspections of industrial equipment from a mobile platform, which translates into a set of technical requirements that guided every component and software decision in the project: \

The thermal camera should preferably be radiometric, meaning that it can measure absolute temperature, and it should operate in the @LWIR band, which is suitable for the thermal ranges relevant to this project (up to 150ºC) and avoids the complexity of active cooling associated with @MWIR cameras @thermal-cams.

To mount the thermal camera onto the robot, it is preferable to use a gimbal, since this allows the camera to be aimed independently of the robot body and avoids the need to reposition the entire platform for every observation.

It is necessary to have a companion computer due to _Unitree Go2_'s hardware not being open source, making it difficult be modified to accommodate other electronics. This computer must provide enough processing and #abbr.asf("I/O") capability to receive thermal video, handle configuration and radiometric metadata, communicate with the operator interface, and control the gimbal. In practice, this means that interfaces such as @USB, _Wi-Fi_ or _Ethernet_, and sufficient bandwidth for video transmission are required.

To power the companion computer and the other electronics we need a power source, a DC-DC step-down converter will be required to provide a stable 5V output while tolerating the battery's voltage variability (#bref(<go2-specs>)).

== Unitree Go2 <go2-specs>
The _Unitree Go2_ serves as the mobile base of the system. It provides locomotion over uneven terrain and exposes three physical interfaces: _XT30_, _RJ45_, and _S-BUS_ @Go2-internals.
- RJ45 is a port for ethernet networking, which will not be used, as the robot has the ability to be controlled via WIFI using the @WebRTC:s API @Go2-webrtc.\
- The XT30 connector provides 28.8V directly from the Go2 battery, but may vary between 24V to 33.6V depending on the state of charge.@Go2-internals This has to be taken into account when choosing a step-down module to convert to a lower voltage.
- _S-BUS_ is a port intended to receive remote-control data and is limited to the command set available in the handheld controller supplied by _Unitree_ @Go2-sbus. In this project it is not the preferred integration path, since the @WebRTC:s interface provides a more flexible software-based way of controlling the robot.


== Component selection
The component selection process was driven by technical suitability, cost, availability, and ease of integration.
One of the earliest difficulties in the project was the selection of a thermal camera. This proved to be more complex than expected because many suitable devices are expensive, difficult to source, or insufficiently documented. For that reason, the camera selection process had to balance resolution, frame rate, radiometric capability, field of view, software accessibility and cost.

A second challenge was the identification of a suitable computing platform. At an initial conceptual level it was natural to refer to a microcontroller, but once the requirements of the project became clearer, especially the need to capture video, relay thermal data, host local services and communicate with the main operator interface, it became evident that a single-board computer would be a more appropriate choice.

Finally, component selection was not purely electrical or computational. Mechanical integration also had to be considered from the start, including how the thermal board would be mounted on the gimbal, how the gimbal would be fixed to the robot, how the payload would be powered from the robot battery, and how the resulting assembly could be installed without permanent modification to the Go2 chassis.

=== Thermal camera
#move(dx: -1cm)[
  #box(width: 100% + 2cm)[
  #set par(justify:false)
  #set text(size: 9pt)
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
          [FOV],
          grid(
            columns: (1fr, auto, 1fr),
            column-gutter: 6pt,
            [Diag.],
            line(angle: 90deg, length: 4%, stroke: 0.5pt + rgb("#cccccc")),
            [Horiz.],
          )
        )
      ],
      [Resolution (HxV)], [Frame rate (Hz)], [Price],

      [module], link("https://www.digikey.pt/en/products/detail/flir-lepton/500-1387-00/22023225")[Lepton UWFOV], [no],
      [-10°C to 140°C ±5°C], [-10°C to 450°C ±10°C],
      [SPI], [CCI (I2C)], [2.8V - 3.1V],
      [140mW / 5mW], [160°], [160°],
      [160×120], [9], [120€],

      [module], link("https://www.digikey.pt/en/products/detail/flir-lepton/500-0771-01/7606616?s=N4IgTCBcDaIDYFMAOAXA9gOwAQGYB0ArCALoC%2BQA")[Lepton 3.5], [yes],
      [-10°C to 140°C ±5°C], [-10°C to 450°C ±10°C],
      [SPI], [CCI (I2C)], [2.8V - 3.1V],
      [140mW / 5mW], [71°], [57°],
      [160×120], [9], [138€],

      [module], link("https://www.digikey.com/en/products/detail/flir-lepton/500-0758-03/16694505")[Lepton 3.1R], [yes],
      [-10°C to 140°C ±5°C], [-10°C to 450°C ±10°C],
      [SPI], [CCI (I2C)], [2.8V - 3.1V],
      [140mW / 5mW], [119°], [95°],
      [160×120], [9], [142€],

      [camera], link("https://www.digikey.pt/en/products/detail/seek-thermal/S302NP/14267527")[S302NP], [no],
      [-40°C to +330°C], [-],
      [USB], [-], [3.3 - 5.0V],
      [300mW], [-], [105°],
      [320×240], [\<9], [421€],

      [camera], [#link("https://www.alibaba.com/product-detail/IRay-RC-09110X-640-512-50hz_1601406089145.html")[IRay \ RC-09110X]], [yes],
      [-20°C to 150°C ±2°C/2%], [0°C to 550°C ±3°C/3%],
      [DVP, BT656, USB, CVBS], [I2C], [3.3V],
      [\<550mW, fast shot: \<1.23W], [-], [48.7°],
      [640×512], [50], [488€],
    ),
    caption: "Comparison of different cameras considered for this project",
  )<cameras>
]
]


\

Looking at *@cameras*, despite the higher cost, _IRay RC-09110X_ seems the most attractive option, due to its high refresh rate and resolution, with the latter being essential for measuring temperatures of smaller objects like connections.
However, as the camera comes from _Aliexpress_, the documentation is scarce and there is no @SDK, so, the second best option is the _Lepton 3.5_ which was selected due to its lower cost, availability, reduced @FOV and radiometric capability, which enables absolute temperature measurements, which are essential for detecting overheating components in industrial environments. On contrary, the other higher-end modules provide improved spatial resolution, but their cost along with lack of documentation and very high @FOV:pla make them undesirable.

This choice comes at the expense of a limited resolution of 160×120 pixels and a frame rate of 9 Hz, but it still remains adequate for the detection of temperature gradients and localized hotspots. The reduced performance is offset by its low power consumption, compact size, and cost-effectiveness, making it suitable for deployment on a mobile robotic platform where payload and energy constraints are relevant.
\ \
The _Lepton 3.5_ module integrates into the _Purethermal-3_ development board@purethermal3 which provides a @USB interface that abstracts the native @SPI and @I2C communication with the sensor. This significantly simplifies system development, allowing direct interaction with the camera using standard @UVC@whats-UVC compatible tools and software libraries.


#subpar.grid(
    figure(
        image("images/pureth.jpg",width: 60%),
        caption:"",
    ),
    figure(
        image("images/thermal.png", width: 65%),
        caption:"",
    ),
    caption: [ Thermal image (b) captured from the _PureThermal-3_  board with the _Lepton 3.5_ module (a)],
    columns: (1fr, 1fr),
    gap: 20pt,

)


=== Step-down converter
Given that the XT30 port on the _Unitree Go2_ supplies a voltage that varies between 24V and 33.6V depending on battery state of charge, a robust and flexible DC-DC step-down converter is required to provide stable power to the payload electronics.

The selected converter@buck-converter is rated for 150W continuous output, accepting an input voltage range of 5V to 40V and providing an adjustable output between 1.2V and 35V. This range comfortably accommodates the full voltage swing of the battery while allowing the output to be set to a stable 5V rail, sufficient to power a single-board computer such as the _Raspberry Pi_ (which draws up to 3A under load), _PureThermal-3_, _Lepton 3.5_, and the gimbal motors simultaneously.

The converter's wide input tolerance provides an additional safety margin against voltage spikes that may occur during dynamic motor operation of the robot. Its high power rating also ensures the system is not thermally stressed under peak current demand, improving long-term reliability in continuous inspection deployments.

=== Payload computer
The @RPI4:a was selected as the payload computer for this project for a combination of practical and technical reasons. The board was already available, which eliminated acquisition cost and lead time and allowed development to begin immediately without waiting on component sourcing.

From a technical standpoint, the @RPI4 runs a full _Linux_ distribution, providing direct access to the tools and libraries needed for the thermal subsystem, such as @V4L2 and _Python_-based @UVC libraries. Its @USB ports allow the _PureThermal-3_ board to be connected directly as a @UVC device without additional drivers, and the integrated _Wi-Fi_ adapter enables it to join the robot's wireless network for @WebRTC and _WebSocket_ communication with the operator interface and the @GPIO header provides two @PWM output channels needed to drive the two _SG90_ gimbal servos, removing the need for a separate servo controller.



== Block diagram

The system architecture is centered around a web-based user interface, which acts as the main operator console. Through this interface, the user can control the Unitree Go2 and visualize its peripherals, such as the @RGB camera and Lidar point cloud, along with the thermal camera feed and command the gimbal orientation. The web page communicates with the robot through @WebRTC, while the thermal subsystem is handled by the @RPI4 mounted on the robot.

The @RPI4:lo acts as a payload computer for the _Go2_. It receives thermal data from the FLIR Lepton 3.5 through the PureThermal-3 development board, which exposes the camera to the @RPI4 through a @USB @UVC interface. The @RPI4 then sends the thermal video stream to the web page using @WebRTC. In parallel, at the control of the user, the web page sends gimbal control commands to the @RPI4 through a WebSocket connection, and the @RPI4 drives the gimbal servos through @PWM outputs.

In terms of power, the Unitree Go2 battery provides a voltage between 24 V and 33.6 V. Since the Raspberry Pi and the auxiliary payload electronics require a lower voltage, a step-down converter is used to generate a regulated 5 V supply. This powers the @RPI4 and supports the operation of the thermal subsystem and gimbal control electronics.

#figure(
  image("images/updated_diagram.svg", scaling: "smooth", width: 71%),
  caption: "System block diagram of the proposed solution.",
)

#pagebreak()
#chapter(
  "3",
  "Software Architecture",
  "This chapter explains the communication and software stack used to control the robot, stream thermal video, process thermal metadata, and integrate gimbal control into the existing operator interface. It covers the use of WebRTC, the role of the existing unitree_ui application, the thermal Python backend, and the modifications made to bring the thermal camera and gimbal into the same control environment."
)

== WebRTC Protocol

@WebRTC:l is an open standard and browser @API that enables direct @P2P exchange of audio, video and arbitrary data between two endpoints without requiring an intermediate media server. The protocol suite combines several underlying standards: @ICE to discover and negotiate a viable network path between peers, @STUN and @TURN to handle address translation and firewalls, @DTLS to encrypt the media and data channels, and @SRTP to carry the actual media streams. Connection setup is coordinated through an @SDP offer/answer exchange, which describes the codec capabilities, media tracks and network candidates each peer is willing to accept. This exchange is carried out over a signalling channel, which is not defined by the @WebRTC standard itself and can be any transport, typically @HTTP or _WebSocket_.@webrtc-prot

Once the peer connection is established, @WebRTC provides two main communication primitives. Media tracks carry encoded audio or video streams with built-in congestion control and adaptive bitrate behaviour. Data channels provide a bidirectional message transport built on @SCTP over @DTLS, supporting both reliable and unreliable delivery modes, which makes them suitable for low-latency control messages or metadata.@webrtc-prot
//#figure(image("images/webrtc.png",width: 66%),caption: "how rtcworks")

== The Unitree_ui project
The _unitree\_go2\_ui_ project@unitree-ui is an open-source browser-based control interface for the _Unitree Go2_, built by _legion1581_ with _TypeScript_, _Three.js_ and _Vite_. _TypeScript_ provides the application logic and type safety across the codebase. _Three.js_ is a _WebGL_-based 3D rendering library used to display a live model of the robot with joint angles, a spinning @LiDAR animation, and a voxel point-cloud map streamed over @WebRTC. _Vite_ serves as the development server and build tool, providing hot module replacement during development and bundling for production.

The application communicates with the robot exclusively over @WebRTC, using the @P2P protocol described in the previous section. It supports three connection modes: direct connection over a local network (_STA-L_), direct connection to the robot's own access point (_AP_), and cloud-relayed connection through a _Unitree_ account (_Remote_). Beyond robot control and video, the interface includes a service manager, robot status monitoring (battery, motor temperatures, etc..), a @SLAM based mapping and navigation workflow, and _Bluetooth_ communication with the robot and with the remote to act as a relay.

Using this existing application as a baseline is advantageous because it already solves the non-trivial problems of connecting to the _Go2_, negotiating the @WebRTC session, and exposing a functional operator surface. In this project its role is extended: beyond the original robot control, it becomes the integration point for the thermal camera feed and gimbal controls, so that the operator works with a single coherent interface.

== Thermal video and processing
The _PureThermal-3_ development board exposes the _Lepton 3.5_ to the host as a standard @UVC device, which means that the operating system recognises it without the need for proprietary drivers. This makes it possible to capture the thermal video stream using normal _Linux_ tools and libraries, such as @V4L2 or @OpenCV.

Beyond simple video capture, access to radiometric information and sensor configuration requires interacting with the extension units exposed by the _PureThermal-3_. On _Linux_, this can be done through standard @V4L2 tools such as _uvcdynctrl_ or through libraries such as _libuvc_ @uvc-capture @libuvc. This is relevant because the project is not limited to displaying a false-colour thermal image; it also benefits from access to temperature-related metadata.

The thermal backend (`thermal_server.py`) is built on _aiohttp_ and _aiortc_, and runs as a standalone server on port 8080. It opens the camera via `cv2.VideoCapture` in _V4L2_ mode, requesting the raw 16-bit `Y16` pixel format at 160×122 pixels. Each frame is processed by stripping the two telemetry rows at the bottom, converting the remaining 160×120 raw values to degrees Celsius using the _Lepton_'s linear encoding ($T_C = "raw" * 0.01 - 273.15$), and computing per-frame statistics: centre temperature, minimum and maximum values, and their pixel positions. The 16-bit image is then normalised to 8 bits and passed through a configurable colour palette from a library of thirteen maps before being resized to 640×480 and encoded as an _RGB_ video frame. Center and maximum temperature markers are drawn on the image before it is sent.

The server exposes a `/thermal/offer` endpoint that performs @WebRTC offer/answer negotiation. Once a peer connection is established, the video track streams frames to the browser and a data channel named `temps` pushes temperature statistics as _JSON_ at approximately 5 Hz. The data channel also accepts incoming messages, allowing the browser to change the active colour palette at runtime without reconnecting. A debug mode (`DebugThermalTrack`) is available, which synthesises an animated thermal scene entirely in software, useful for development without physical hardware.

== _Unitree_ui_ modifications
The main software-integration effort consisted of extending the original _unitree\_ui_ application so that it could connect not only to the _Go2_ but also to the thermal subsystem and gimbal. The objective was not to replace the original application architecture but to augment it in a way that preserved the existing robot-control workflow while adding the new capabilities.

=== Connection flow
A new boolean field (`thermal`) was added to the `ConnectionConfig` type, and a dedicated checkbox was introduced in the connection panel. The checkbox is only enabled when the _STA-L_ (local network) mode is selected, since the thermal backend is expected to be locally reachable on the same network. This keeps the thermal connection opt-in and tied to the relevant operating mode without affecting remote or access-point modes.

=== Thermal WebRTC connection
A dedicated `ThermalWebRTCConnection` class was added in `thermal_webrtc.ts` to manage the connection to the thermal backend independently from the robot's own @WebRTC path. Its lifecycle follows the three phases described below:

- *Signalling.* The class first creates an `RTCPeerConnection` configured with a _Google's_ @STUN server, adds a `recvonly` video transceiver, and opens a data channel named `temps`. It then calls `createOffer`, sets the result as the local description, and _POST_-s the @SDP offer to `/thermal/offer`. Because the browser and the _Raspberry Pi_ are on the same network, this request goes through the _Vite_ proxy, which forwards it to the thermal server on port 8080. The server returns an @SDP answer, which is set as the remote description to complete the exchange.

- *ICE.* As the @SDP negotiation proceeds, the browser's @ICE agent contacts the _Google's_ @STUN server to discover its reflexive address — the public-facing @IP and port assigned by the @NAT router. Each candidate produced locally is forwarded to the _Raspberry Pi_ individually via _POST_ to `/thermal/ice` as soon as it becomes available, a technique known as trickle @ICE. @P2P connectivity checks then run between the two peers to confirm a working network path.

- *Connected.* Once a path is established, a @DTLS handshake encrypts the channel. The connection is considered validated only when the `temps` data channel transitions to the open state, which avoids a timing issue in some browsers where the peer connection reports connected before the channel is ready. From that point the _Raspberry Pi_ sends the thermal video track over @SRTP and pushes temperature statistics as _JSON_ at approximately 5 Hz over the data channel. The browser can also send palette change commands back through the same channel without requiring a reconnection.


#figure(image("images/webrtc_thermal_sequence.png",width:77%),caption:"Diagram showing the progress of connecting to the thermal server via WebRTC")
//#code-lines(wrtc_thermal,38,60)

=== Thermal PIP component
`PipCamera` is a class already present in _unitree\_ui_ that creates a draggable picture-in-picture overlay. It manages a video element for live stream display, a white-noise animation canvas shown while no stream is active, and pointer-event-based drag-to-reposition logic. It is used in the original application for the robot camera feed and the @SLAM mapping page.

To introduce the thermal feed into the same interface without duplicating this infrastructure, a `PipThermal` class was created in `pip-thermal.ts` as a subclass of `PipCamera`. The extension adds a monospaced statistics overlay below the video that is updated in real time with the centre, minimum and maximum temperature values received from the data channel. To make inheritance possible, all private members of `PipCamera` were changed to protected, and the constructor was extended to accept an initial position so that the thermal _PIP_ and the robot camera _PIP_ can be placed independently on screen.


=== Gimbal integration
A `GimbalClient` class was created in `gimbal.ts`. It opens a _WebSocket_ to `/gimbal/ws` and provides a `move` method that sends a `{pan, tilt}` _JSON_ command to the server. If the connection drops, the client automatically reconnects after two seconds. On the server side, `servos.py` implements a _FastAPI_ application that accepts the same _WebSocket_ path. It instantiates a `Gimbal` object composed of two `Servo` instances, each controlling one _SG90_ motor through a @GPIO pin using _RPi.GPIO_ and hardware _PWM_ at 50 Hz. Each `Servo` converts an angle in the range 0–180° to a duty cycle between 5% and 12% and uses an `asyncio.sleep` proportional to the angle to allow the motor time to reach its position. The `Gimbal.Move` method runs both axes concurrently using `asyncio.gather`.

=== Vite proxy configuration
New proxy entries were added to `vite.config.ts` to route browser requests to the backend services. This is necessary because browsers enforce the same-origin policy: a page loaded from `http://localhost:5173` (the _Vite_ dev server) is not permitted to make direct requests to `http://localhost:8080` (the thermal server) or `ws://localhost:5052` (the gimbal server), since these are different origins. Rather than configuring _CORS_ headers on every backend service or hard-coding backend addresses in the frontend, the _Vite_ development server acts as a reverse proxy, forwarding requests transparently so that the browser always communicates with a single origin.

HTTP requests to `/thermal` are forwarded to `http://127.0.0.1:8080`, where the thermal server listens. WebSocket connections to `/gimbal/ws` are forwarded to `ws://127.0.0.1:5052`, where the gimbal server listens. From the browser's perspective, all three services appear to be part of the same application, which simplifies the frontend code and keeps the backend topology an implementation detail of the server configuration rather than something the client needs to be aware of.

#pagebreak()

#chapter(
  "4",
  "Mechanical Architecture",
  "This chapter describes the mechanical integration of the payload subsystem onto the Unitree Go2. It covers the design rationale for using 3D printing, the custom mounting plate developed to carry the Raspberry Pi and step-down converter on the robot's rails, and the adapted camera mount designed to fix the PureThermal 3 board onto the gimbal."
)

== 3D printing
The mechanical integration of the payload subsystem onto the _Unitree Go2_ requires custom parts that are specific to this combination of components. Off-the-shelf mounting solutions do not exist for this assembly, and traditional fabrication methods such as machining or sheet metal work are costly, slow to iterate, and require access to specialised equipment. 3D printing addresses all of these constraints: parts can be designed, printed and tested within hours, redesigned if the fit is incorrect, and reproduced at negligible cost.

Reversibility is also an important consideration. All mechanical interfaces in this project are designed to attach and detach without permanent modification to the robot. This is relevant both for maintenance and for the possibility of reconfiguring or upgrading the payload in future iterations. 3D printing makes this straightforward since the parts are defined by digital models that can be adjusted whenever the design requirements change.

All components except the cover plate and rails were printed in 9600 Resin@resin due to its cheapness, high toughness and durability, good temperature resistance up to 59℃. Unfortunately it is not suitable for outdoors, high temperatures, sunlight and UV light environments. Besides its drawbacks, it is a good choice for this stage of development.


== Gimbal
As the design and manufacturing of a gimbal from scratch falls outside the scope of this project, an existing open-source model was sourced from Steve Eckerlein at _Printables_@gimbal, a community platform for sharing 3D-printable designs. The selected model provided a suitable mechanical baseline, a two-axis gimbal for a FPV camera that uses two 180 degree SG90 servo motors, reducing development time and allowing focus on system integration rather than mechanical design.

The original design was not dimensioned for the _PureThermal-3_ board and the attached _FLIR Lepton 3.5_ module, so, a replacement camera mount was designed from scratch to fix the board securely to the gimbal's tilt axis. The design takes into account the board's outline and mounting holes with the part attaching to the gimbal using the same screw positions as the original part.

#subpar.grid(
    figure(
  image("images/lepton_mount.png", width: 60%),
  caption: "",
),<gimbal-3d>,

    figure(image("images/gimbal_lept.png", width: 40%),caption:""),<plate-3d-pic>,
    columns: (1fr, 1fr),
    caption: [Designed gimbal (a) and 3D printed finished assembly with servos and dev board (b)],
    gap: 20pt,
)



== Payload mounting plate
To carry the _Raspberry Pi 4_ and the step-down converter on the robot, a custom plate was designed to attach to the clip-on rail. The plate is equipped with feet to be screwed into the rails so that the plate is properly secured. The plate provides dedicated mounting positions for both the _Raspberry Pi 4_ and the step-down converter, with the board holes matching the standard fixing pattern of each component.
#figure(
image("images/payload mount.png", width:40%),
    caption: "mounting plate with Raspberry pi 4 and step-down converter attached"
)

== Assembly onto the robot
To assemble the gimbal, step-down converter, payload computer and associated wiring onto the quadruped, it is essential to have a structural enclosure that can be mounted onto the _Unitree Go2_ without permanent modifications to the robot's chassis.
So, a 3D print cover plate design has been sourced from Gizmo Karl at _MakerWorld_@go2-cover (#bref(<plate-3d>)) specifically designed to fit the top surface of the _Unitree Go2_ body. The part attaches via clip on and locks into the rail on the rear, requiring no permanent modifications to the robot's outer hull and allowing easy removal for maintenance or reconfiguration. \

The plate and the cover rails are printed in _PA11-HP Nylon_@nylon. This material was chosen for its excellent heat resistance, high toughness, and superior chemical and impact resistance.


#subpar.grid(
    figure(image("images/3d_cover.webp", width: 60%),caption:""),<plate-3d>,
    figure(image("images/3d_cover_pic.webp", width: 60%),caption:""),<plate-3d-pic>,
    columns: (1fr, 1fr),
    caption: [3D printed cover plate design (a) and assembly (b)],
    gap: 20pt,
)



== Full assembly

The complete payload assembly consists of the following steps: the clip-on cover attaches to the top of the _Go2_ body, the payload plate with the @RPI4 and step-down converter screws into the rails and then the rails are screwed into the quadruped using its top plate screw holes, the gimbal is screwed into the mount cap and glued to the top of the cover, and the _PureThermal 3_ with the _Lepton 3.5_ module is screwed to the custom mount on the gimbal's tilt axis.

#subpar.grid(
    figure(image("images/go2_finished_front_nobg.png", width: 60%),caption:""),
    figure(image("images/go2_finished_top_nobg.png", width: 60%),caption:""),
    columns: (1fr, 1fr),
    caption: [Finished project assembly],
    gap: 20pt,
)


#pagebreak()
#chapter(
  "5",
  "Validation and Results",
  "This chapter presents the tests carried out to validate the system, from isolated verification of the thermal subsystem to full integration of the robot, mounting structure and operator interface. It concludes with a real-world inspection case performed at a transformer substation at ISEL, where the system successfully identified an overheating fault."
)

== System integration
With the hardware assembled and all backend services running on the _Raspberry Pi_, the full system was tested with the operator interface active on a laptop connected to the same local network as the robot. The objective was to confirm that all subsystems operated simultaneously without conflict and that the operator experience was coherent from a single browser tab.

@web-interface shows the interface during a live session. The _Go2_'s voxel point cloud occupies the main view with the thermal camera and @RGB _PIP_ windows visible in the upper left corner of the display.

Robot movement commands sent through the interface via the keyboard were responded with a slight delay by the _Go2_ with the thermal camera also having a slight delay. The gimbal responded to mouse input in pointer-lock mode, with pan and tilt commands reaching the _Raspberry Pi_ over the _WebSocket_ connection and the servos moving to the commanded position.

The integration test therefore confirms that the system meets its core operational requirement: a single operator, from a single interface, can drive the robot, observe its surroundings through both the visual and thermal feeds, and independently orient the thermal camera using the gimbal, all over a standard _Wi-Fi_ connection.

#figure(image("images/go2_web2.png",width:100%),
    caption:[Web interface to control tbe robot,with _Go2's_ @RGB camera and @LiDAR voxel view \ along with the added thermal camera with its radiometric measurements below])<web-interface>

#pagebreak()
== Project's @FOV
The _Lepton 3.5_ has a horizontal field of view of 57° and a vertical field of view of 43° (*@cameras*), which is considerably narrower than the _Go2_'s front-facing @RGB camera, which covers 120º horizontally and approximately 90° vertically. On a fixed mount, this would require repositioning the entire robot to survey a wider area. With a angular range of 95° in pan and 102º in tilt, the gimbal allows the thermal camera to sweep a total coverage of 152° horizontally and 145° vertically without moving the robot, solving the problem of a limited @FOV:lo.

*@Fovs* shows a representation of the horizontal and vertical @FOV:pls (*@fov* and *@vfov[]* respectively) with the _Go2's_ @RGB camera in blue, the _Lepton_ camera's @FOV in yellow and the thermal scan range (_Lepton's_ @FOV along with the sweep coverage of the gimbal) in red
#subpar.grid(
    figure(
        image("images/FOVs.png", width: 110%),
        caption: "Top view (Horizontal FOVs)",
    ),<fov>,
    figure(
        box(image("images/vFOV.png",width: 90%), inset: (right: -19%), clip:true),
        caption: "side view (Vertical FOVs)",
    ),<vfov>,
    columns: (1fr, 1fr),
    caption: [Representation of project's FOV],
    label: <Fovs>,
    gap: 20pt,)
== Thermal camera validation
To validate the thermal camera under real conditions, an inspection was carried out at a transformer substation located at _ISEL_. As the robot payload was not assembled at the time, the thermal camera was tested with a laptop.

Upon arriving at the substation, the thermal camera was first directed at a transformer unit. The imaging revealed a homogeneous heating pattern across the body of the equipment, consistent with normal thermal dissipation during operation under load. The readings from the _Lepton 3.5_ were cross-validated using a laser thermometer and the professional handheld thermal camera, with all three instruments producing consistent values.

#figure(image("images/transformador.jpg",width:50%),caption:"Inspection of a transformer unit")

During the inspection, a oxidated cable was observed (*@oxi-cable*) and the thermal feed revealed two clear hot spots, one on the oxidated cable and one on the cable next to it. *@avar-hand* shows the same area captured with a professional handheld thermal camera, and *@avar-lep* shows the corresponding image produced by the _Lepton 3.5_. The handheld camera can only measure temperatures below 153ºC, while the _Lepton_ measured 184ºC.

#subpar.grid(
    figure(
        image("images/avaria1.jpg", width: 70%),
        caption: "",
    ),<oxi-cable>,
    figure(box(
        image("images/avaria1_termica.jpg", width: 85%),
        clip:true,
        inset: (top:-130pt),
        ),
        caption: "",
    ),<avar-hand>,
    figure(box(
        image("images/avaria1_lepton.png", width:150%),
        clip:true,
        inset: (left:-100pt,rest:0pt),
    ),
        caption: ""
        ),<avar-lep>,
    columns: (1fr, 1fr, 1fr),
    caption: [Detected electrical fault (overheating wires from oxidation) measured with handheld thermal camera and _Lepton 3.5_ with max detected temperature of \>153ºC and 184ºC respectively],
    label: <avaria1>,
    gap: 20pt,
)

Briefly after the detection of the overheating wires, a second fault was detected on the same electrical panel (*@avaria2*), this time it was not as visually apparent, most likely a loose connection, with the only sign of a fault being a degradation of the cable as a result of the heat emitted.

#subpar.grid(
    figure(
        image("images/avaria2.jpg", width: 70%),
        caption: "",
    ),
    box(figure(
        image("images/avaria2_termica.jpg", width: 130%),
        caption: "",
        ),
        clip:true,
        inset: (top:0pt),

    ),
    box(figure(
        image("images/avaria2_lepton.png", width:100%),
        caption: ""
        ),
        clip:true,
        inset: (left:-100pt,right:-30pt,rest:0pt),
    ),
    columns: (1fr, 1fr, 1fr),
    caption: [Second detected electrical fault (overheating wires from a loose connection) measured with handheld thermal camera and _Lepton 3.5_ with max detected temperature of \>153ºC and 151ºC respectively],
    label: <avaria2>,
    gap: 20pt,
)
\ \
Left undetected, this type of fault can escalate into insulation damage or a fire. The fact that the _Lepton 3.5_ was able to identify the anomaly with higher radiometric precision than the handheld camera and localize it within the frame demonstrates that the system is capable of detecting thermally significant faults with high accuracy in a real installation, despite the sensor's limited resolution of 160×120 pixels.
#pagebreak()



#chapter(
  "6",
  "Conclusions",
  "This chapter summarises the current state of the project, the main technical lessons obtained so far, the aspects that worked well and those that proved more difficult than expected, the project timeline, and the main improvements that should be addressed in future iterations."
)

== Development insights


This project required working simultaneously across several disciplines that are not usually combined in a single assignment: network protocols, embedded Linux, real-time video processing, browser-based development, power electronics and mechanical design. The most important lesson is that the interfaces between these domains are where the real complexity lies. Choosing a component that works well in isolation is easy, the arduous part is integrating it with everything else.

This was particularly clear in the software stack. _WebRTC_ appeared straightforward in theory but required understanding signalling, _ICE_ negotiation, _DTLS_ encryption and data channel lifecycle before a working connection could be established. Similarly, integrating the thermal backend into an existing _TypeScript_ application meant understanding its internal architecture deeply enough to extend it without breaking existing functionality. The same-origin policy, _Vite_'s proxy mechanism and the browser's secure context requirements for _WebCrypto_ were all constraints that were not anticipated at the start and had to be understood and solved individually.

The lesson is that software and hardware architecture cannot be developed independently. The choice of thermal camera affects the software stack, the computing platform, the required power conversion and the mechanical integration. Likewise, the decision to reuse an existing operator interface considerably influences how the local thermal backend and the gimbal services are programmed and used for display and control to the user.

== Final thoughts
Several aspects of the project evolved positively. The use of existing open-source resources, such as the _unitree_ui_ codebase, the gimbal model and the clip-on cover plate, made it possible to accelerate development and focus effort on integration rather than on building every subsystem from zero.

The most significant result of the project is the successful unexpected detection of electrical faults in a real world scenario, proving the capability and viability of the selected thermal camera.

Overall, despite several delays, the project is considered to be successful, with a completed assembly of the robot's subsystem's components, along with its integration with a web interface including full control of the quadruped, with visualization of its peripherals, in addition to a thermal video feed and gimbal actuation operated simultaneously, without any conflicts.


== Timeline
The following Gantt chart outlines the main phases of the project, from initial research and component selection to system integration, testing and final validation. Each task has a planned timeframe shown by the bar extent, and the colour of the bar indicates whether the task was completed ahead of or behind that plan. The start of green bars indicate the time that the task was finished earlier than scheduled, while the end of the red bars indicate tasks that finished after their planned duration. Tasks shown without any colour were completed exactly on schedule.

As observed in the *@gantt* there are a lot of tasks that were completed after its projected time, this was due to a load of factors, including a months delay of shipping from the thermal camera's distributor due to internal delays or negligence, which caused a cascading effect which delayed all the other tasks such as gimbal design, testing and programming.

#{
  show figure.caption: set align(left)
  let col-report = eastern
  let col-components = rgb("#F58518")
  let col-testing = rgb("#54A24B")
  let col-programming = rgb("#B279A2")
  let col-assembly = rgb("#E45756")

  import "@preview/gantty:0.5.1" as gantty
  import gantty.dependencies: default-dependencies-drawer
  import gantty: (
    dependencies.orthogonal-dependencies-drawer,
    dividers.default-dividers-drawer,
    field.default-field-drawer,
    gantt,
    milestones.default-milestones-drawer,
    sidebar.default-sidebar-drawer,
    task.default-tasks-drawer,
  )
  import gantty.header: (
    default-headers-drawer, default-month-header, default-week-header,
  )

  set text(font: "New Computer Modern", size: 11pt)
  import "@preview/modpattern:0.1.0": modpattern
  let hatched = modpattern((4pt, 4pt))[
    #place(line(start: (100%, 0%), end: (0%, 100%)))
  ]

  let drawer = (
    field: default-field-drawer,
    sidebar: default-sidebar-drawer.with(
      formatters: (
        x => align(center, strong(x.name)),
        x => align(center, x.name),
        x => align(center, emph(x.name)),
      ),
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
            body: (style: (fill: col-report, stroke: black), width: 7pt),
          ),
        ),
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
      milestones: default-milestones-drawer.with(
          today-content: none,
      ),
  )

    let gantt = gantt.with(drawer: drawer)

    [#figure(
        gantt(yaml("gantt.yaml")),
        caption: "Gantt Chart",
    )<gantt>]
}

== Future work
Several directions remain open for future development, ranging from incremental improvements to the existing subsystems to more substantial extensions of the system's capabilities.

The thermal video transmission currently goes through a _WebRTC_ video track encoded with a lossy codec. Replacing this with a binary data channel stream carrying raw or 8-bit normalised pixel data would eliminate compression artefacts entirely and preserve the full radiometric fidelity of each frame at the cost of a modest increase in bandwidth. The data channel infrastructure is already in place, making this a contained change with a clear quality benefit.

A noticeable latency exists between operator input and robot movement, which becomes apparent during precise robot navigation. Two mitigation paths are worth exploring. The first is the _S-BUS_ port on the _Go2_, which accepts remote-control signals and bypasses the _WebRTC_ control path entirely. The second is the _Bluetooth_ relay already present in _unitree\_ui_, which is currently non-functional due to a known bug; fixing it would provide a lower-latency alternative control path without additional hardware.

In the operator interface, the _Three.js_ voxel map view does not currently track the robot's position. Adding a camera follow mode, where the 3D view automatically centres on the robot as it moves, would significantly improve spatial awareness during navigation, particularly in larger environments.

The system currently does not handle disconnections gracefully. If the thermal _WebRTC_ connection or the gimbal _WebSocket_ drops during operation, the interface provides no feedback and no automatic recovery beyond the existing two-second gimbal reconnect. A more complete approach would detect disconnection events, display clear status indicators to the operator, and attempt reconnection automatically for both subsystems.

On the capability side, several features would bring the system closer to a practical inspection tool. Automatic hotspot detection (flagging regions that exceed a configurable temperature threshold) would reduce operator workload and make the system usable for unsupervised monitoring. Full navigational autonomy, combined with a predefined inspection path, would allow the robot to survey a substation without continuous operator input. More speculatively, integrating a large language model could allow the operator to issue high-level instructions in natural language and have the system translate them into movement and observation commands.

Finally, and most critically, the _Unitree Go2_ has a number of well-documented security vulnerabilities in its network interface and control protocol. Any deployment in a real industrial environment should address these before the system is considered production-ready, as an unsecured robot operating in a live substation represents a meaningful attack surface.
#pagebreak()
#bibliography("bibliography.yaml")
