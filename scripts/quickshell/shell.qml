import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 30
    color: "#000000"   // black bar

    property int currentWorkspace: 1

    Row {
        id: bar
        anchors.fill: parent
        anchors.margins: 6
        spacing: 20

        Row {
            id: workspaceRow
            spacing: 8

            Repeater {
                id: wsRepeater
                model: 6   // workspaces 1–6

                delegate: Rectangle {
                    width: 26
                    height: 20
                    radius: 4
                    border.width: (index + 1) === currentWorkspace ? 2 : 1
                    border.color: (index + 1) === currentWorkspace ? "#00FF55" : "#444444"
                    color: (index + 1) === currentWorkspace ? "#003300" : "#111111"

                    Text {
                        anchors.centerIn: parent
                        text: index + 1
                        color: (index + 1) === currentWorkspace ? "#00FF55" : "#888888"
                        font.family: "monospace"
                    }
                }
            }
        }

        // Spacer comes here to push the right-hand items
        Item {
            id: spacer
            width: 1600 - hyprmode.width - battery.width - clock.width
            height: 1
        }

        Text {
            id: hyprmode
            color: "#FFFB00"
            font.family: "monospace"
            verticalAlignment: Text.AlignVCenter

            Process {
                id: hyprmodeProc
                command: ["sh", "-c", "cat $HOME/.cache/hypr_mode"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: hyprmode.text = "mode: " + text.trim()
                }
            }

            Timer {
                interval: 500
                running: true
                repeat: true
                onTriggered: hyprmodeProc.running = true
            }
        }

        Text {
            id: battery
            color: "#00FF55"
            font.family: "monospace"
            verticalAlignment: Text.AlignVCenter

            Process {
                id: batteryProc
                command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: battery.text = "BAT: " + text.trim() + "%"
                }
            }

            Timer {
                interval: 30000
                running: true
                repeat: true
                onTriggered: batteryProc.running = true
            }
        }

        Text {
            id: clock
            color: "#00FF55"
            font.family: "monospace"
            verticalAlignment: Text.AlignVCenter

            Process {
                id: dateProc
                command: ["date", "+%H:%M:%S"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: clock.text = text.trim()
                }
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: dateProc.running = true
            }
        }
    }

    Process {
        id: workspaceProc
        command: ["sh", "-c", "hyprctl activeworkspace -j | jq '.id'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: currentWorkspace = parseInt(text.trim())
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: workspaceProc.running = true
    }
}
