func isPossible(board: inout[[Int?]], row: Int, column: Int, number: Int) -> Bool {
    // check duplicates in row
    // return false if given row has duplicate input
    for i in 0 ..< 9 {
        if board[row][i] == number {
            return false
        }
    }

    // check duplicates in column
    // return false if given column has duplicate input 
    for i in 0 ..< 9 {
        if board[i][column] == number {
            return false
        }
    }

    let leftMostColumn = (column / 3) * 3

    let topMostRow = (row / 3) * 3

    //check if input is valid in 3x3
    for i in 0 ..< 3 {
        for j in 0 ..< 3 {
            if board[topMostRow + i][leftMostColumn + j] == number {
                return false
            }
        }
    }

    // input is valid; return true
    return true
}

func printBoard(board: [[Int?]]) {
    //horizontal divider when 3 rows are printed
    for row in 0 ..< 9 {
        if row % 3 == 0 && row != 0 {
            print("----------------------- ")
        }

        //every 3 values in column, print vertical divider
        for column in 0 ..< 9 {
            if column % 3 == 0 && column != 0 {
                print(" | ", terminator: "")
            }

            // print values in sudoku 2d array (formatting)
            if column == 8 && board[row][column] != nil {
                print("\(board[row][column])")
            } else if column == 8 && board[row][column] == nil {
                pritn("-")
            } else if column < 8 && board[row][column] == nil {
                print("-" + " ", terminator:"")
            } else {
                print(String(board[row][column]!) + " ", terminator: "")
            }
        }
    }
}

// check if board has no nils
func isCompleted(board: [[Int?]]) -> Bool {
    for row in 0 ..< 9 {
        for column in 0 ..< 9 {
            // if cell is empty, return false
            if board[row][column] == nil {
                return false
            }
        }
    }
    return true
}

// find next empty cell position and put it into an array
func findEmptyCell(board: [[Int?]]) -> [Int?] {
    for row in 0 ..< 9 {
        for column in 0 ..< 9 {
            // if cell empty, return its position
            if board[row][column] == nil {
                let result = [row, column]
                return result
            }
        }
    }
    // if board is full, return array of nil
    return [nil]
}

// this solver ultilzes recursive backtracking
// https://www.geeksforgeeks.org/sudoku-backtracking-7/
func solver(board: inout [[Int?]]) -> Bool {
    let found = findEmptyCell(board:board)
    
    // base case
    if found[0] == nil {
        return true
    } 
    
    // recursive case
    else {
        let position = found

        // starting from lowest input possible and recursively attempt next input
        for i in 1 ..< 10 {
            if isPossible(board: &board, row: position[0]!, column: position[1]!, number: i) {
                board[position[0]!][position[1]!] = i

                // escape case
                if solver(board: &board) == true {
                    return true
                }

                board[position[0]!][position[1]!] = nil
            }
        }
        return false
    }
}

// generates new board
func createBoard(difficulty: String) -> [[Int?]] {
    // initialize empty board

    var newBoard: [[Int?]] = [[nil,nil,nil,nil,nil,nil,nil,nil,nil],
                               [nil,nil,nil,nil,nil,nil,nil,nil,nil],
                               [nil,nil,nil,nil,nil,nil,nil,nil,nil],
                               [nil,nil,nil,nil,nil,nil,nil,nil,nil],
                               [nil,nil,nil,nil,nil,nil,nil,nil,nil],
                               [nil,nil,nil,nil,nil,nil,nil,nil,nil],
                               [nil,nil,nil,nil,nil,nil,nil,nil,nil],
                               [nil,nil,nil,nil,nil,nil,nil,nil,nil],
                               [nil,nil,nil,nil,nil,nil,nil,nil,nil],]

    // select random cell
    let position = [Int.random(in: 0 ..< 9), Int.random(in: 0 ..< 9)]

    // solve board
    solver(board: &newBoard)

    // difficulty levels
    var totalCellCount = 81

    // depending on difficulty level, remove values from solved board
    switch difficulty {
        case "easy":
        difficultyLevel(41, 46, totalCellCount, newBoard)
        case "medium":
        difficultyLevel(31, 36, totalCellCount, newBoard)
        case "hard":
        difficultyLevel(17, 26, totalCellCount, newBoard)
        default:
        fatalError("difficulty levels include easy, medium, or hard")
    }
    return newBoard
}

func difficultyLevel(cellMin: Int, cellMax: Int, totalCellCount: Int, newBoard: [[Int?]]) {
        let endCellCount = Int.random(in: cellMin ... cellMax)
        while totalCellCount > endCellCount {
            // select random cell
            var rowPosition = Int.random(in: 0 ..< 9)
            var columnPosition = Int.random(in: 0 ..< 9)

            // if cell already empty, select new cell
            while newBoard[rowPosition][columnPosition] == nil {
                rowPosition = Int.random(in: 0 ..< 9)
                columnPosition = Int.random(in: 0 ..< 9)
            }

            // clear cell
            newBoard[rowPosition][columnPosition] == nil
            totalCellCount -= 1
        }

}

// test
print("easy")
var newBoard = createBoard(difficulty:"easy")
printBoard(board:newBoard)
solver(board:&newBoard)
print("answer:")
printBoard(board:newBoard)
print("hard")
var sBoard = createBoard(difficulty:"hard")
printBoard(board:sBoard)
solver(board:&sBoard)
print("answer:")
printBoard(board:sBoard)