import QtQuick 2.6
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

Rectangle {
    id: root
    width: 600; height: 600
    color: "#888888"

    property int columns: 4
    property int rows: 4
    property variant numbers: []

    Rectangle {
        id: scoreBoard
        width: parent.width; height: parent.height * 0.1

        anchors.top: parent.top
        opacity: 0.66
        color: "white"
        radius: 4

        property int score: 0
        Grid {
            width: parent.width
            height: parent.height
            columns: 3
            rows: 1

            anchors.top: parent.top

            Button {
                text: "new"

                height: parent.height

                onClicked: root.newGame()
            }

            Button {
                text: "settings"
                height: parent.height
            }

            Text {
                id: scoreBoardText
                width: parent.width
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                font.pixelSize: parent.height
                text: "Score: " + scoreBoard.score
            }
        }
    }

    Grid {
        id: grid
        width: parent.width
        height: parent.height - scoreBoard.height

        columns: root.columns
        rows: root.rows

        spacing: 4

        property real tileWidth: (width - (columns - 1) * spacing) / columns
        property real tileHeight: (height - (rows - 1) * spacing) / rows

        anchors.bottom: parent.bottom

        Repeater {
            id: tiles
            model: root.columns * root.rows

            Rectangle {
                width: parent.tileWidth
                height: parent.tileHeight
                color: "#AAAAAA"
                radius: 2

                property int xindex: index % root.columns
                property int yindex: index / root.columns
            }

            function getEmptyTile(){
                var emptyTiles = []

                for (var i = 0; i < root.columns; ++i) {
                    for (var j = 0; j < root.rows; ++j) {
                        if (!root.getTileAt(j, i)) {
                            emptyTiles.push(itemAt(j + root.rows*i))
                        }
                    }
                }

                var index = Math.floor(Math.random() * emptyTiles.length)

                return emptyTiles[index];
            }
        }
    }

    function moveLeft() {
        var shouldSpawn = false

        for (var i = 0; i < rows; ++i)
            for (var j = 0; j < columns; ++j) {
                var tile = root.getTileAt(j, i)

                if (!tile)
                    continue

                if (tile.moveLeft())
                    shouldSpawn = true
            }

        if (shouldSpawn){
            spawn()
        }
    }

    function moveRight() {
        var shouldSpawn = false

        for (var i = 0; i < rows; ++i)
            for (var j = rows-1; j >= 0; --j) {
                var tile = root.getTileAt(j, i)

                if (!tile)
                    continue

                if (tile.moveRight())
                    shouldSpawn = true
            }

        if (shouldSpawn){
            spawn()
        }
    }

    function moveUp() {
        var shouldSpawn = false

        for (var i = 0; i < rows; ++i)
            for (var j = 0; j < columns; ++j) {
                var tile = root.getTileAt(j, i)

                if (!tile)
                    continue

                if (tile.moveUp())
                    shouldSpawn = true
            }

        if (shouldSpawn){
            spawn()
        }
    }

    function moveDown() {
        var shouldSpawn = false

        for (var i = rows-1; i >= 0; --i)
            for (var j = 0; j < columns; ++j) {
                var tile = root.getTileAt(j, i)

                if (!tile)
                    continue

                if (tile.moveDown())
                    shouldSpawn = true
            }

        if (shouldSpawn){
            spawn()
        }
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onLeftPressed: {
            root.moveLeft()
        }

        Keys.onUpPressed: {
            root.moveUp()
        }

        Keys.onDownPressed: {
            root.moveDown();
        }

        Keys.onRightPressed: {
            root.moveRight();
        }
    }

    function getTileAt(x, y) {
        for (var i = 0; i < numbers.length; ++i) {
            if (numbers[i].xindex == x && numbers[i].yindex == y)
                return numbers[i]
        }
    }

    function pop(x, y){
        for (var i = 0; i < numbers.length; ++i){
            if (numbers[i].xindex == x && numbers[i].yindex == y){
                numbers[i].destroy()
                numbers.splice(i, 1)
            }
        }
    }

    function spawn() {
        var component = Qt.createComponent("number.qml")

        if (component.status == Component.Ready) {
            var tile = tiles.getEmptyTile()

            if (Math.random() * 2 > 1)
                root.numbers.push(component.createObject(tiles, {"xindex": tile.xindex, "yindex": tile.yindex, "number": 4}))
            else
                root.numbers.push(component.createObject(tiles, {"xindex": tile.xindex, "yindex": tile.yindex, "number": 2}))
        }
    }

    function generate() {
        var component = Qt.createComponent("number.qml")

        if (component.status == Component.Ready) {
            root.numbers.push(component.createObject(tiles, {"xindex": 2, "yindex": 0, "number": 2}));
            root.numbers.push(component.createObject(tiles, {"xindex": 1, "yindex": 1, "number": 4}));
        }
    }

    function newGame(){
        for (var i = 0; i < numbers.length; ++i){
            numbers[i].destroy()
        }

        scoreBoard.score = 0

        numbers = new Array()

        generate()
    }

    Component.onCompleted: generate()
}
