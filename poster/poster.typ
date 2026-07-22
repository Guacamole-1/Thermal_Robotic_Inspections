#import "@preview/peace-of-posters:0.6.0" as pop
#import "@preview/subpar:0.2.2"
#import "@preview/xarrow:0.3.0": xarrow
#show ref: it => strong(it)
#set page("a3", margin: 1.5cm)
#pop.set-poster-layout(pop.layout-a3)
#pop.set-theme(pop.psi-ch)
#set text(font: "Arial", size: pop.layout-a3.at("body-size"))
#set heading(numbering: "1.1")
#let blank-img(width: 100%, height: 5cm) = rect(
    width: width,
    height: height,
    fill: luma(240),
    stroke: luma(180) + 1pt,
)

#let red = rgb("#dc005a")
#let purple = rgb("#eabfda")
#let box-spacing = 0.8em
#set columns(gutter: box-spacing)
#set block(spacing: box-spacing)
#pop.update-poster-layout(spacing: box-spacing, heading-size: 18pt)
#pop.title-box(
    [
        #place(dy:-1.2cm)[#image("/relatorio/images/logo_isel_branco.png",height: 2cm)]
        #place(dy:-1.2cm,dx:18cm)[
                    #set text(fill:white,weight: "regular",size:16pt)
            #grid(
                columns: (auto,auto),
                column-gutter: 5pt,
                row-gutter: 0pt,
            [#v(0.5cm)Partner:],
            [#image("microsegur.png", width: 6.5cm)],
            )
        ]
         #set text(fill: white,size: 29.5pt)
        #v(1.5cm)
        Robotic System for Monitoring Industrial Installations
    ],
    authors: [
        #set text(weight: "bold",fill:white)
        #v(-0.4cm)
        #grid(
            columns: (auto, 0pt, auto),
            rows: (auto, auto),
            column-gutter: (20pt, 20pt),
            row-gutter: 5pt,
            align:bottom,
            grid.vline(
                x: 1,
                start: 0,
                end: 2,
                stroke: 1.5pt + gray,
            ),

            text(size: 10pt, fill: purple)[AUTHOR],
            grid.cell(rowspan: 2)[],
            text(size: 10pt, fill: purple,)[SUPERVISOR],
            [Duarte Santos],
            text(size:12pt,)[Prof. António Serrador],
        )#v(-0.85cm)
        // #text(size:12pt,weight:"regular")[
        //     supervisor: Prof. António Serrador
        // ]
    ],
    institutes: [
        #set text(fill: purple,size:10pt)
        //Instituto Superior de Engenharia de Lisboa
        #v(0.7cm)
    ],
    background: box(rect(
        width: 100%,
        height: 6.6cm,
        fill: gradient.radial(
            center: (20%, 60%),
            radius: 80%,
            rgb("#572792FF"),
            rgb("#dc005a"),
        ),
    ),
        inset: -1.5cm,
        outset: 0pt,
    ),
    authors-size: 16pt,
    institutes-size: 12pt,
)

#columns(2,[
    #pop.column-box(heading: "1. Introduction")[
        #v(0.2cm)
        // This project (@finished) integrates a _FLIR Lepton 3.5_ thermal camera onto a _Unitree Go2_ quadruped robot, enabling remote thermal inspection of industrial electrical installations. The system allows an operator to drive the robot, monitor a live thermal feed, and orient the camera via a two-axis gimbal, all from a single web interface over Wi-Fi.
        The inspection of industrial electrical infrastructure exposes technicians to significant risks, including electrocution and arc flash. Safety constraints limit how close workers can get to live equipment, while logistical costs restrict how frequently inspections can be carried out. Thermal imaging is a well-established method for detecting early signs of equipment failure, but its deployment at scale remains constrained by the same human factors.

                

    ]
    #pop.column-box(heading: "2. Motivation")[
        #v(0.2cm)
        //Current thermal inspection methods are manual and expose operators to hazardous conditions.
        By integrating a thermal camera into a quadruped robot, inspections can become remote, repeatable and safer, while enabling more frequent monitoring of critical infrastructure. \
        The _Unitree Go2_, costing around €1,300–€10,000, offers a much lower-cost alternative to platforms such as _Boston Dynamics' Spot_ (60.000€) or _Anybotics' Anymal_ (130.000€), making robotic thermal inspection more accessible. \ \

        // #grid(
        //     columns: (150pt, auto),
        //     align: left,
        //     column-gutter: 1fr,
        //     [
        //         #set text(size: 12pt)
        //         #figure(box(image("./relatorio/images/anymal.png", width: 85%, fit: "cover"),
        //             clip: true, inset: 1pt),
        //             caption: "Anybotics' Anymal\nwith thermal camera add-on")<anymal>
        //     ],[
        //         #set text(size: 12pt)
        //         #figure(image("./relatorio/images/spot.jpg", width: 60%),
        //             caption: "Boston Dynamics' Spot\nwith thermal camera add-on")<spot>])

        #pop.column-box(heading: "3. System Architecture")[
            #v(0.2cm)
            The system (@diagram) is built around a web-based operator interface (@web) through which the user can control the _Go2_, visualize its _RGB_ camera and _LiDAR_ point cloud with the addition of the thermal feed and control of the gimbal. The robot is controlled over _WebRTC_, while a _Raspberry Pi 4_ mounted on the robot (@finished) handles the thermal camera and gimbal control through WebRTC and Websockets respectively.
            #figure(
                image("./relatorio/images/go2-nobg.png",width:60%),
                caption: "Finished project"
            )<finished>
        ]

    ]


    #pop.column-box(heading: "")[
        #align(center)[
            #move(dy:-30pt)[
                #figure(
                    image("./relatorio/images/updated_diagram.svg",width:80%),
                    caption: "System Logic Block Diagram"
                )<diagram>
            ]
        ]
        #v(-1.1cm)
        #figure(
            image("./relatorio/images/go2_web2.png",width:80%),
            caption: "Web control interface"
        )<web>
    ]
    #pop.column-box(heading: "4. Results & Conclusion")[

        The system was validated at a transformer substation at ISEL, where two active electrical faults were successfully detected. The first, an oxidized cable (@oxi-cable), reached a peak temperature of 184°C, exceeding the 153°C measurement ceiling of the professional handheld camera used as reference.

        Both faults were correctly identified and localized despite the sensor's limited 160×120 pixel resolution, demonstrating that the system is capable of detecting thermally significant faults in real industrial environments at a fraction of the cost of existing commercial solutions.
        #subpar.grid(
            figure(
                image("./relatorio/images/avaria1.jpg", width: 90%),
                caption: "",
            ),<oxi-cable>,
            figure(box(
                image("./relatorio/images/avaria1_termica.jpg", width: 85%),
                clip:true,
                inset: (top:-70%),
            ),
                caption: "",
            ),<avar-hand>,
            figure(box(
                image("./relatorio/images/avaria1_lepton.png", width:270%),
                clip:true,
                inset: (left:-120%,top:-30%,right:60%,bottom:-30%),
            ),
                caption: ""
            ),<avar-lep>,
            columns: (1fr, 1fr, 1fr),
            caption: [Thermal inspection of an oxidized cable],
            label: <avaria1>,
            gap: 20pt,
        )



    ]

])



#pop.bottom-box(
    heading-box-args: (inset: -0.7cm,outset: (bottom:2cm,top:1.1cm,rest:5cm), fill: red),
    //blank-img(height: 1em, width: 6em),
)[
    #move(dy:0cm)[
        #text(fill: white, weight: "regular")[✉️ | A51764\@alunos.isel.pt]
    ]
]

//#v(-1em)
