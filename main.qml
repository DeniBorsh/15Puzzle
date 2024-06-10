import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: root
    width: 640
    height: _board.height + _footer.height
    visible: true
    title: qsTr("15Puzzle")

    GameBoard {
        id: _board
        width: 640
        height: 480
    }

    Footer {
        id: _footer
        anchors.top: _board.bottom
        height: 80
        width: parent.width
    }

    Image {
        z: -1
        anchors.fill: parent
        source: "qrc:/img/gray-stone.jpg"
    }

    EndScreen {
        id: _endScreen
        anchors.fill: parent
        visible: false
    }

    Connections {
        target: _footer._reset
        function onClicked() {
            _footer.reset();
            _board.reset();
        }
    }

    Connections {
        target: _board.model
        function onMovementsChanged(n) {
            _footer.setMovements(n);
        }
        function onFinished(n) {
            sleep();
            _endScreen.visible = true
            _endScreen.shifts = n
            _endScreen.time = _footer.time
        }
    }
    Connections {
        target: _endScreen._restart
        function onClicked() {
            _endScreen.visible = false
            _footer.reset();
            _board.reset();
        }
    }

    function sleep(milliseconds) {
      var start = new Date().getTime();
      for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds){
          break;
        }
      }
    }

}
