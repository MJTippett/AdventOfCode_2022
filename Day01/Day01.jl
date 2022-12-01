# Part 1
open("Day01.txt") do file
    lines = readlines(file)

    prevMax = 0
    current = 0
    for line in lines
        if(line != "")
            current += parse(Int, line)
        elseif(current > prevMax)
            prevMax = current
            current = 0
        else
            current = 0
        end
    end
    if(current > prevMax)
        prevMax = current
    end

    println("Maximum calories held by an Elf: $(prevMax)")
end

# Part 2
open("Day01.txt") do file
    lines = readlines(file)

    calories = Vector{Int64}()
    current = 0
    for line in lines
        if(line != "")
            current += parse(Int, line)
        else
            append!(calories, current)
            current = 0
        end
    end
    # Add last sum to the vector
    append!(calories, current)

    # Sort the vector of calories in reverse order, pick the first 3 elements, and sum them
    println("Calories held by top 3 Elves: $(sum(first(sort!(calories, rev = true), 3)))")
end