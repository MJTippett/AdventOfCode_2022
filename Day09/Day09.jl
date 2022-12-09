function main()
    moves = ""
    open("movement.txt") do file
        moves = readlines(file)
    end

    headposition = [0; 0]
    tailposition = [0; 0]
    tailpositionhistory = [[0;0]]

    for move in moves
        tokens = split(move, " ")
        for i in 1:parse(Int, tokens[2])
            movehead!(headposition, tokens[1])
            movetail!(tailposition, headposition)
            updatehistory!(tailpositionhistory, tailposition)
        end
    end

    # Find the unique entries in the tailpositionhistory array (Part 1)
    println("(Part 1) Positions visited by tail: $(length(unique(tailpositionhistory)))")

    # Part 2
    rope = [[0;0] for i in 1:10]
    tailpositionhistory = [[0;0]]

    for move in moves
        tokens = split(move, " ")
        for i in 1:parse(Int, tokens[2])
            movehead!(rope[1], tokens[1])
            for j in 2:length(rope)
                movetail!(rope[j], rope[j-1])
            end

            updatehistory!(tailpositionhistory, rope[10])
        end
    end

    println("(Part 2) Positions visited by tail: $(length(unique(tailpositionhistory)))")
end


function movehead!(head, direction)
    if(direction == "U")
        head[2] += 1
    elseif (direction == "D")
        head[2] -= 1
    elseif (direction == "L")
        head[1] -= 1
    else
        head[1] += 1
    end
end


function movetail!(tail, head)
    # If head and tail are touching do nothing
    if (abs(head[1] - tail[1]) <= 1 && abs(head[2] - tail[2]) <= 1)
        return
    end

    # move tail left or right as needed
    if (head[1] > tail[1])
        tail[1] += 1
    elseif (head[1] < tail[1])
        tail[1] -= 1
    end

    # Move tail up or down as needed
    if (head[2] > tail[2])
        tail[2] += 1
    elseif (head[2] < tail[2])
        tail[2] -= 1
    end
end


function updatehistory!(tailpositionhistory, newtailposition)
    push!(tailpositionhistory, deepcopy(newtailposition))
end


main()