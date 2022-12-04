function main()
    assignments = []
    open("Day04.txt") do file
        assignments = readlines(file)
    end

    assignments = split.(assignments, ",")
    
    countfullycontained = 0
    countpartiallycontained = 0
    for pair in assignments
        if (isfullycontained(pair))
            countfullycontained += 1
        end
        if (ispartiallycontained(pair))
            countpartiallycontained += 1
        end
    end

    println("Number of fully contained assignments: $(countfullycontained)")
    println("Number of partially contained assignments: $(countpartiallycontained)")
end


function isfullycontained(assignments)
    # Determine if one of the assignments is fully contained within the other
    first = split(assignments[1], "-")
    second = split(assignments[2], "-")

    first = (parse(Int, first[1]), parse(Int, first[2]))
    second = (parse(Int, second[1]), parse(Int, second[2]))

    if ((first[1] <= second[1] && first[2] >= second[2]) || (first[1] >= second[1] && first[2] <= second[2]))
        return true
    end

    return false
end


function ispartiallycontained(assignments)
    # Determine if there is partial or full overlap between the assignments
    first = split(assignments[1], "-")
    second = split(assignments[2], "-")

    first = (parse(Int, first[1]), parse(Int, first[2]))
    second = (parse(Int, second[1]), parse(Int, second[2]))

    if ((first[2] >= second[1] && first[2] <= second[2]) || (first[1] <= second[2] && first[1] >= second[1]))
        return true
    elseif((second[2] >= first[1] && second[2] <= first[2]) || (second[1] <= first[2] && second[1] >= first[1]))
        return true
    end

    return false
end


main()