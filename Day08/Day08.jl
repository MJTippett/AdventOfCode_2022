function main()
    lines = ""
    open("Data.txt") do file
        lines = readlines(file)
    end

    numrows = length(lines)
    numcols = length(lines[1])

    # Read lines of grid into a matrix
    grid = Array{Int16}(undef, numrows, numcols)

    for row in 1:numrows
        for col in 1:numcols
            grid[row, col] = parse(Int16, lines[row][col])
        end
    end

    # iterate through each tree in the grid and determine if it is visible (part 1)

    visibletrees = 0
    gridtransposed = transpose(grid)
    for row in 1:numrows
        for col in 1:numcols
            # we use the transpose of the grid matrix to check visibility from sides
            if (isvisiblefrombottom(grid, (row, col)) 
                    || isvisiblefromtop(grid, (row, col)) 
                    || isvisiblefrombottom(gridtransposed, (col, row)) 
                    || isvisiblefromtop(gridtransposed, (col, row)))
                visibletrees += 1
            end
        end
    end

    println("Number of trees visible from outside: $(visibletrees)")

    # Part 2 (find maximum scenic score)
    maxscenicscore = 0
    for row in 1:numrows
        for col in 1:numcols
            # Again we'll transpose the grid to get the scores looking left and right
            scenicscore = gettopscore(grid, (row, col)) * getbottomscore(grid, (row, col)) * gettopscore(gridtransposed, (col, row)) * getbottomscore(gridtransposed, (col, row))
            
            if (scenicscore > maxscenicscore)
                maxscenicscore = scenicscore
            end
        end
    end

    println("Maximum scenic score: $(maxscenicscore)")
end


function isvisiblefromtop(grid, location)
    row = location[1]
    col = location[2]
    
    # If it's in the top row it's visible from the top
    if (row == 1)
        return true
    end

    for index in 1:(row-1)
        if (grid[row, col] <= grid[index, col])
            return false
        end
    end

    return true
end


function isvisiblefrombottom(grid, location)
    row = location[1]
    col = location[2]

    # If it's in the bottom row it's visible from the bottom
    if (row == size(grid)[1])
        return true
    end

    for index in (row+1):size(grid)[1]
        if (grid[row, col] <= grid[index, col])
            return false
        end
    end

    return true
end


function gettopscore(grid, location)
    row = location[1]
    col = location[2]
    
    # If it's in the top row it's score look topwards is 0
    if (row == 1)
        return 0
    end

    score = 0
    for index in (row-1):-1:1
        score += 1
        if (grid[row, col] <= grid[index, col])
            break
        end
    end

    return score
end


function getbottomscore(grid, location)
    row = location[1]
    col = location[2]
    
    # If it's in the bottom row it's score look bottomwards is 0
    if (row == size(grid)[1])
        return 0
    end

    score = 0
    for index in (row+1):size(grid)[1]
        score += 1
        if (grid[row, col] <= grid[index, col])
            break
        end
    end

    return score
end


main()