function main()
    datastream = ""
    open("Datastream.txt") do file
        datastream = readline(file)
    end

    # Set packetlength = 4 for part 1, and 14 for part 2
    packetlength = 14

    buffer = []
    for i = 1:packetlength
        append!(buffer, datastream[i])
    end
    
    if (isstartofpacket(buffer))
        return "Start of packet at position $(packetlength)"
    end

    for i in (packetlength + 1):length(datastream)
        popfirst!(buffer)
        append!(buffer, datastream[i])

        if (isstartofpacket(buffer))
            return "Start of packet at position $(i)"
        end
    end

end


function isstartofpacket(buffer)
    # Checks if the start of packet (4 characters with no duplicates for part 1, 14 for part 2) is found

    for i in 1:length(buffer)-1
        for j in i+1:length(buffer)
            if(buffer[i] == buffer[j])
                return false
            end
        end
    end

    return true
end


println(main())