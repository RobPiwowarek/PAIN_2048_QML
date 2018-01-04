import QtQuick 2.0

Rectangle {
    color: number <= 1 ? "transparent" :
                         number <= 2 ? "grey" :
                                       number <= 4 ? "brown" :
                                                     number <= 8 ? "blue" :
                                                                   number <= 16 ? "yellow" :
                                                                                  number <= 32 ? "green" :
                                                                                                 number <= 64 ? "darkgreen" :
                                                                                                                number <= 128 ? "white" :
                                                                                                                                number <= 256 ? "pink" :
                                                                                                                                                number <= 512 ? "red" :
                                                                                                                                                                number <= 1024 ? "purple" :
                                                                                                                                                                                 number <= 2048 ? "darkblue" : "#3c3a32"

    property int xindex
    property int yindex
    property int number: 2

    x: tiles.itemAt(xindex + root.rows*yindex).x
    y: tiles.itemAt(xindex + root.columns*yindex).y
    width: tiles.itemAt(xindex + root.rows*yindex).width
    height: tiles.itemAt(xindex + root.columns*yindex).height
    radius: 2

    Text {
        id: numberText
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: parent.number < 1 ? "" : parent.number
        fontSizeMode: Text.Fit
        font.pixelSize: parent.height
    }

    Behavior on x {
        NumberAnimation {
            duration: 50
        }
    }

    Behavior on y {
        NumberAnimation{
            duration: 50
        }
    }

    Behavior on number {
        NumberAnimation {
            duration: 50
        }
    }

    function move(x, y) {
        xindex = x
        yindex = y
    }

    function moveLeft() {
        var shouldSpawn = false

        for (var i = xindex-1; i >= 0; --i){
            var tile = root.getTileAt(i, yindex)

            console.log("I: " + i)

            if (tile){
                if (tile.number == number){
                    // todo: update score

                    number = number + number

                    root.pop(i, yindex)

                    move(i, yindex)

                    shouldSpawn = true
                }
                else
                    return false
            }
            else {
                move(i, yindex)
                shouldSpawn = true
            }
        }

        return shouldSpawn
    }
}