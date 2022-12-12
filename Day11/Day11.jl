mutable struct Monkey
    items::Vector{Int}
    operation::String
    divisibleby::Int
    iftruethrowto::Int
    iffalsethrowto::Int
    itemsinspected::Int
end


function main()
    monkeys = Dict{Int, Monkey}()

    # Test Data
    #=
    monkeys[0] = Monkey([79, 98], "old * 19", 23, 2, 3, 0)
    monkeys[1] = Monkey([54, 65, 75, 74], "old + 6", 19, 2, 0, 0)
    monkeys[2] = Monkey([79, 60, 97], "old * old", 13, 1, 3, 0)
    monkeys[3] = Monkey([74], "old + 3", 17, 0, 1, 0)
    =#

    # My dataset
    monkeys[0] = Monkey([74, 64, 74, 63, 53], "old * 7", 5, 1, 6, 0)
    monkeys[1] = Monkey([69, 99, 95, 62], "old * old", 17, 2, 5, 0)
    monkeys[2] = Monkey([59, 81], "old + 8", 7, 4, 3, 0)
    monkeys[3] = Monkey([50, 67, 63, 57, 63, 83, 97], "old + 4", 13, 0, 7, 0)
    monkeys[4] = Monkey([61, 94, 85, 52, 81, 90, 94, 70], "old + 3", 19, 7, 3, 0)
    monkeys[5] = Monkey([69], "old + 5", 3, 4, 2, 0)
    monkeys[6] = Monkey([54, 55, 58], "old + 7", 11, 1, 5, 0)
    monkeys[7] = Monkey([79, 51, 83, 88, 93, 76], "old * 3", 2, 0, 6, 0)
    

    # test data lowest common multiple
    #lcm = 96577
    lcm = 9699690

    # Part 1: numrounds = 20, decreasefactor = 3
    # Part 2: numrounds = 10000, decreasefactor = 1
    numrounds = 10_000
    nummonkeys = 7
    decreasefactor = 1
    for round in 1:numrounds
        for monkey in 0:nummonkeys
            
            items = deepcopy(monkeys[monkey].items)
            for item in items
                item = inspectitem(item, monkeys[monkey].operation)
                item = decreaseworrylevel(item, decreasefactor)

                throwto = (test(item, monkeys[monkey].divisibleby)) ? monkeys[monkey].iftruethrowto : monkeys[monkey].iffalsethrowto

                # To keep the worry level in check we calculate the modulus wrt the lowest common multiple
                # of all of the divisibleby factors.  This keeps it small whilst not impacting the divisibleby condition.
                item = item % lcm

                push!(monkeys[throwto].items, item)
                popfirst!(monkeys[monkey].items)

                monkeys[monkey].itemsinspected += 1
            end
        end
    end

    inspections = []
    for monkey in 0:nummonkeys
        println("Monkey $(monkey) inspected items $(monkeys[monkey].itemsinspected) times.")
        append!(inspections, monkeys[monkey].itemsinspected)
    end

    sort!(inspections)
    println("Level of monkey business: $(inspections[end] * inspections[end-1])")
end


function inspectitem(currentworrylevel, operation)
    tokens = split(operation, " ")

    returnvalue::Int = 0
    prevop = ""
    for token in tokens
        if (token == "old")
            if (prevop == "")
                returnvalue = currentworrylevel
            elseif (prevop == "*")
                returnvalue = currentworrylevel * currentworrylevel
            elseif (prevop == "+")
                returnvalue = currentworrylevel + currentworrylevel
            end
        elseif (token == "*" || token == "+")
            prevop = token
        else
            if (prevop == "*")
                returnvalue = returnvalue * parse(Int, token)
            elseif (prevop == "+")
                returnvalue = returnvalue + parse(Int, token)
            end
        end
    end
    return returnvalue
end


function decreaseworrylevel(currentworrylevel, factor)
    return Int(floor(currentworrylevel/factor))
end


function test(item, divisibleby)
    # Return whether the item is divisible by divisibleby
    return item % divisibleby == 0 ? true : false
end


main()