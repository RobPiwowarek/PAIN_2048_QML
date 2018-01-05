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

function moveLeft() {
    var shouldSpawn = false

    for (var i = 0; i < rows; ++i)
        for (var j = 0; j < columns; ++j) {
            var tile = getTileAt(j, i)

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
            var tile = getTileAt(j, i)

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
            var tile = getTileAt(j, i)

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
            var tile = getTileAt(j, i)

            if (!tile)
                continue

            if (tile.moveDown())
                shouldSpawn = true
        }

    if (shouldSpawn){
        spawn()
    }
}

function victory() {

}
