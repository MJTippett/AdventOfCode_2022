function main()
    # Populate the initial state from the data
    state = Array[
        ['B','Z','T'],
        ['V','H','T','D','N'],
        ['B','F','M','D'],
        ['T','J','G','W','V','Q','L'],
        ['W','D','G','P','V','F','Q','M'],
        ['V','Z','Q','G','H','F','S'],
        ['Z','S','N','R','L','T','C','W'],
        ['Z','H','W','D','J','N','R','M'],
        ['M','Q','L','F','D','S']
    ]

    # Read instructions
    instructions = []
    open("Procedure.txt") do file
        instructions = readlines(file)
    end

    for instruction in instructions
        # Part 1
        #movecrate!(state, instruction)
        # Part 2
        movecrate2!(state, instruction)
    end

    # Print out the tops of the final stacks
    for stack in state
        print(stack[end])
    end
end


function movecrate!(state, instruction)
    # Recursively moves a single crate at a time (part 1)
    temp = split(instruction, " ")
    
    numbertomove = parse(Int, temp[2])
    fromlocation = parse(Int, temp[4])
    tolocation = parse(Int, temp[6])

    if (numbertomove > 0)
        append!(state[tolocation], pop!(state[fromlocation]))
        numbertomove -= 1
        movecrate!(state, "move $(numbertomove) from $(fromlocation) to $(tolocation)")
    else
        return state
    end
end


function movecrate2!(state, instruction)
    # Moves multiple at a time (part 2)
    temp = split(instruction, " ")
    
    numbertomove = parse(Int, temp[2])
    fromlocation = parse(Int, temp[4])
    tolocation = parse(Int, temp[6])

    startindex = length(state[fromlocation]) - numbertomove + 1
    endindex = length(state[fromlocation])

    append!(state[tolocation], state[fromlocation][startindex:endindex])
    
    bar = (length(state[fromlocation]) - numbertomove + 1)
    deleteat!(state[fromlocation], startindex:endindex)

    return state
end


main()