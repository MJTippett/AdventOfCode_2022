function main()
    lines = ""
    open("Data.txt") do file
    #open("C:\\Users\\michael.tippett\\OneDrive - AVEVA Solutions Limited\\Scripts\\Julia\\AdventOfCode_2022\\Day13\\TestData.txt") do file
        lines = readlines(file)
    end

    # Read data into an array
    pairs = []
    for i in 1:length(lines)
        if (length(lines[i]) == 0)
            temp = Any[]
            push!(temp, lines[i-2])
            push!(temp, lines[i-1])
            push!(pairs, temp)
        end
    end
    temp = Any[]
    push!(temp, lines[end-1])
    push!(temp, lines[end])
    push!(pairs, temp)


    # Parse the pairs of packets into a form we can compare
    for pair in pairs
        pair[1] = parsepacket(pair[1])
        pair[2] = parsepacket(pair[2])
    end

    ### PART 1 ###
    pair_num = 1
    sum_ordered_pairs = 0
    for pair in pairs
        #if (isincorrectorder(pair))
        if (isincorrectorder(pair[1], pair[2]))
            sum_ordered_pairs += pair_num
        else
        end

        pair_num += 1
    end

    println("Sum of correctly ordered pairs: $(sum_ordered_pairs)")

    ### PART 2 ###
    # Build list of packets to sort (including divider packets)
    packetlist = []
    push!(packetlist, [[2]])
    push!(packetlist, [[6]])

    for pair in pairs
        push!(packetlist, pair[1])
        push!(packetlist, pair[2])
    end

    sortpackets!(packetlist)

    # multiply the indices of the divider packets
    ans = 1
    for i in 1:length(packetlist)
        if(packetlist[i] == [[2]] || packetlist[i] == [[6]])
            ans *= i
        end
    end

    println("Decoder key: $(ans)")
end


# Sort the list of packets into the correct order using an insertion sort
function sortpackets!(list)
    for i in 2:length(list)
        
        key = list[i]
        j = i-1
        while (j >= 1 && !isincorrectorder(list[j], key))
            list[j+1] = list[j]
            j -= 1
        end

        list[j+1] = key
    end

    return list
end


function isincorrectorder(left, right)


    for i in 1:length(left)
        
        # If the right side has run out of inputs before the left side, return false
        if (i > length(right))
            return false
        end

        # If both elements are integers, compare them as such
        if (length(size(left[i])) == 0 && length(size(right[i])) == 0)
            if (left[i] < right[i])
                return true
            elseif (left[i] > right[i])
                return false
            end
            # If we are here it means that the elements are the same integer, in which case we move on to the next element to compare
        end

        # If both elements are lists recursively call the function to compare them
        if (length(size(left[i])) != 0 && length(size(right[i])) != 0)
            result = isincorrectorder(left[i], right[i])
            if (result != "indeterminate")
                return result
            end
        end

        # If one element is a list, convert the other (integer) element to a list and recursively compare
        if (length(size(left[i])) == 0 && length(size(right[i])) != 0)
            result = isincorrectorder([left[i]], right[i])
            if (result != "indeterminate")
                return result
            end
        elseif (length(size(left[i])) != 0 && length(size(right[i])) == 0)
            result = isincorrectorder(left[i], [right[i]])
            if (result != "indeterminate")
                return result
            end
        end

    end

    # If we are here the lists are so far indeterminate, in which case, if the left list is shorter than the right, they are in the correct order
    if(length(left) < length(right))
        return true
    end

    # We should only be here if we are in a sublist and the result is indeterminate, in which case we return something to that effect and back out
    return "indeterminate"
end


function parsepacket(packet)
    #println("Raw packet: $(packet)")
    
    #if (length(packet) ==  1 && !isnothing(tryparse(Int, packet)))
    if (!isnothing(tryparse(Int, packet)))
        #println("Int packet: $(packet)")
        return parse(Int, packet)
    elseif (length(packet) ==  0)
        return nothing
    end

    # We have a list (potentially of lists), remove [ and ] from list to get what's in it
    elements = chop(packet, head = 1, tail = 1)
    packetlist = []
    listdepth = 0
    tempstr = ""
    partialint = ""
    for element in elements
        #println("Element: $(element)")
        
        # If it's an integer, add it to partialint and continue
        if (!isnothing(tryparse(Int, string(element))) && listdepth == 0)
            #push!(packetlist, string(element))
            partialint *= string(element)
            continue
        # This handles the end of a (possibly multi-digit) integer, in which case we push partialint to the list and reset it
        elseif (string(element) == "," && listdepth == 0 && partialint != "")
            push!(packetlist, string(partialint))
            partialint = ""
            continue
        # If we hit a [ increase the depth of the list
        elseif (string(element) == "[")
            listdepth += 1
        # If we hit a ], push anything in partialint (if listdepth == 0) and decrease the depth of the list if not
        elseif (string(element) == "]")
            if (partialint != "" && listdepth == 0)
                push!(packetlist, string(partialint))
                partialint = ""
                continue
            end    
            listdepth -= 1
        end

        # If listdept != 0 (we're in an inner list) or tempstr = "" (implies element == [)
        if (listdepth > 0 || length(tempstr) > 0)
            tempstr *= element
        end
        
        # We should only hit this if we're back at the top of the list and element == ]
        if (listdepth == 0 && length(tempstr) > 0)
            push!(packetlist, tempstr)
            tempstr = ""
        end
    end

    # Ensures the last integer in the packet is pushed to the list
    if (partialint != "")
        push!(packetlist, string(partialint))
    end

    return parsepacket.(packetlist)
end


main()