import Foundation

struct Position {
    var x = 0
    var y = 0
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    static func ==(lhs: Position, rhs: Any) -> Bool {
        if rhs is (Int, Int) {
            let rhs = rhs as! (Int, Int)
            
            if lhs.x == rhs.0, lhs.y == rhs.1 {
                return true
            }
            else {
                return false
            }
        }
        else if rhs is Position {
            let rhs = rhs as! Position
            
            if lhs.x == rhs.x, lhs.y == rhs.y {
                return true
            }
            else {
                return false
            }
        }
        return false
    }
    
    static func !=(lhs: Position, rhs: Any) -> Bool {
        if rhs is (Int, Int) {
            let rhs = rhs as! (Int, Int)
            
            if lhs.x != rhs.0 || lhs.y != rhs.1 {
                return true
            }
            else {
                return false
            }
        }
        else if rhs is Position {
            let rhs = rhs as! Position
            
            if lhs.x != rhs.x || lhs.y != rhs.y {
                return true
            }
            else {
                return false
            }
        }
        return false
    }
}

var grid = [Position(x: 4, y: 9), Position(x: 5, y: 9), Position(x: 6, y: 9), Position(x: 6, y: 8), Position(x: 6, y: 7), Position(x: 5, y: 7), Position(x: 4, y: 7), Position(x: 4, y: 8)]

func getBounds() -> ((Position), (Position)) {
    var maxX = 0
    var maxY = 0
    var minX = grid[0].x // So it will return the max value,
    var minY = grid[0].y // in case that made any sense
    
    for cell in grid {
        if cell.x > maxX {
            maxX = cell.x
        }
        else if cell.x < minX {
            minX = cell.x
        }
        
        if cell.y > maxY {
            maxY = cell.y
        }
        else if cell.y < minY {
            minY = cell.y
        }
    }
    
    return (Position(x: minX - 1, y: maxY + 1), Position(x: maxX + 1, y: minY - 1))
}

func forCellInBounds(bounds: (Position, Position), cellBlock: (_ pos: Position) -> ()) {
    var x = bounds.0.x
    
    while x <= bounds.1.x {
        var y = bounds.1.y
        
        while y <= bounds.0.y {
            cellBlock(Position(x: x, y: y))
            
            y += 1
        }
        x += 1
    }
}

func isAlive(pos: Position) -> Bool {
    for cell in grid {
        if Position(x: cell.x, y: cell.y) == pos {
            return true
        }
    }
    return false
}

func getNeighbors(cell: Position) -> Int {
    var neighbors = 0
    
    let bounds = (Position(x: cell.x - 1, y: cell.y + 1), Position(x: cell.x + 1, y: cell.y - 1))
    
    forCellInBounds(bounds: bounds) { (pos: Position) in
        if isAlive(pos: pos), pos != cell {
            neighbors += 1
        }
    }
    
    return neighbors
}

while true {
    let bounds = getBounds()
    
    var deadCells: [Position] = []
    var liveCells: [Position] = []
    
    forCellInBounds(bounds: bounds) { (pos: Position) in
        let neighbors = getNeighbors(cell: pos)
        
        if isAlive(pos: pos) {
            if neighbors < 2 { // Die
                deadCells.append(pos)
            }
            else if neighbors == 2 || neighbors == 3 { // Survive
                // Do nothing
            }
            else if neighbors > 3 { // Die
                deadCells.append(pos)
            }
        }
        else {
            if neighbors == 3 { // Live
                liveCells.append(pos)
            }
        }
    }
    
    // Kill cells
    
    for cell in deadCells {
        let index = grid.index{$0 == cell}
        grid.remove(at: index!)
    }
    
    // Add cells
    grid.append(contentsOf: liveCells)
    
    var row = 0
    
    forCellInBounds(bounds: bounds) { (pos: Position) in
        if row != pos.x {
            row = pos.x
            print("")
        }
        //X
        //
        if isAlive(pos: pos) {
            print("X", terminator: "")
        }
        else {
            print(" ", terminator: "")
        }
    }
    print("")
    
    sleep(1)
}
