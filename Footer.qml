import QtQuick 2.15

Item {
    id: _footer
    property alias _reset: _reset
    property string time: _time.text

    function reset() {
        _timer.restart();
        _time.seconds = 0;
    }

    function setMovements(n) {
        _movements.text = n + " shift" + (n % 10 === 1 && n % 100 !== 11 ? "" : "s");
    }

    Rectangle {
        anchors.centerIn: parent
        width: parent.width - 10
        height: parent.height - 10
        color: "#000"
        radius: 10
        opacity: .5
    }

    Text {
        id: _time
        property int seconds: 0
        anchors.centerIn: parent
        font.pointSize: 24
        text: toClock(seconds)
        color: "white"

        Timer {
            id: _timer
            interval: 1000
            running: true
            repeat: true
            onTriggered: ++_time.seconds;
        }

        function toClock(seconds) {
            return Math.round(seconds / 60) + ":" + (seconds % 60 < 10 ? "0" : "") + Math.round(seconds % 60)
        }
    }

    Text {
        id: _movements
        anchors {
            left: parent.left
            leftMargin: 50
            verticalCenter: parent.verticalCenter
        }
        text: 0 +" shifts"
        font.pointSize: 22
        color: "white"
    }

    Rectangle {
        anchors {
            right: parent.right
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }

        width: 150
        height: 50
        color: _reset.containsMouse ? "#ad865a" : "#c69663"
        radius: 5
        Text {
            text: "Reset"
            anchors.centerIn: parent
            color: "#111"
            font.pointSize: 18
        }

        MouseArea {
            id: _reset
            anchors.fill: parent
            hoverEnabled: true
            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
