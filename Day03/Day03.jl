function main()
    rucksacks = []
    open("Day03.txt") do file
        rucksacks = readlines(file)
    end

    # Part 1
    totalpriority = 0
    for rucksack in rucksacks
        len::Int = length(rucksack)
        compartments = (rucksack[begin:Int(len/2)], rucksack[Int((len/2) + 1):end])
        
        totalpriority += getpriority(getmatch(compartments))
    end

    println("Sum of priorities of duplicate items: $(totalpriority)")

    #Part 2
    totalbadgepriority = 0
    numelves = length(rucksacks)
    for i in 1:3:numelves
        totalbadgepriority += getpriority(getbadge((rucksacks[i], rucksacks[i+1], rucksacks[i+2])))
    end

    println("Sum of the priorities of the badges: $(totalbadgepriority)")
end


function getmatch(compartments)
    # Finds the single item (upper or lower case letter, which occurs in both compartments)
    for item in compartments[1]
        if occursin(item, compartments[2])
            return item
        end
    end
end


function getpriority(item)
    if isuppercase(item)
        # ASCII encodes A as 65, whereas we want it to have a priority of 27, hence we subtract 65-27 = 38 from it's integer value
        return Int(item) - 38
    else
        # ASCII encodes a as 97, whereas we want it to have a priority of 1, hence we subtract 97-1 = 96 from it's integer value
        return Int(item) - 96
    end
end


function getbadge(rucksacks)
    # Finds the single item (upper or lower case letter) which occurs in all 3 rucksacks
    for item in rucksacks[1]
        if (occursin(item, rucksacks[2]) && occursin(item, rucksacks[3]))
            return item
        end
    end
end


main()