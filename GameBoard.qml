import QtQuick 2.15
import Game 1.0

GridView {
    id: _board
    interactive: false
    model: GameBoardModel {}
    cellHeight: height / _board.model.dimension
    cellWidth: width / _board.model.dimension

    function reset() {
        model.shuffle();
    }

    delegate: Item {
        id: _tileWrapper
        width: _board.cellWidth
        height: _board.cellHeight
        visible: display !== _board.model.hiddenElement
        Tile {
            anchors.fill: parent
            anchors.margins: 5
            text: display.toString()

            MouseArea {
                anchors.fill: parent
                onClicked: _board.model.move(index);
            }
        }
    }

    move: Transition {
        PropertyAnimation {
            easing.type: Easing.OutQuad
            properties: "x,y"
            duration: 120
        }
    }
}
