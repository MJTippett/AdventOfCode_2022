function main()
    instructions = ""
    open("Data.txt") do file
        instructions = readlines(file)
    end

    x::Int = 1
    cycle::Int = 1
    display = Array{String}(undef, 6, 40)

    for instruction in instructions
        # Output value of x during cycles of interest
        updatesignalstrengths(cycle, x)
        updatedisplay!(display, cycle, x)

        # Execute the command
        if (instruction == "noop")
        cycle += 1
        else
            tokens = split(instruction, " ")
            value = parse(Int,tokens[2])
            
            cycle += 1
            updatesignalstrengths(cycle, x)
            updatedisplay!(display, cycle, x)
            cycle += 1
            x += value
        end
    end

    # Part 1
    println("Signal strengths: $(signalstrengths)")
    totalsignalstrengths = 0
    for signal in keys(signalstrengths)
        totalsignalstrengths += signalstrengths[signal]
    end

    println("Total signal strength: $(totalsignalstrengths)")
    
    # Part 2
    for i in 1:6
        println(display[i,:])
    end
end


function endcycle!(x::Int, instruction::String)
    tokens = split(instruction, " ")
    if (tokens[1] == "noop")
        return
    else
        value = parse(Int, tokens[2])
        x += value/abs(value)
    end
end


function updatesignalstrengths(cycle::Int, x::Int)
    if(cycle == 20 || cycle == 60 || cycle == 100 || cycle == 140 || cycle == 180 || cycle == 220)
        signalstrengths[cycle] = x*cycle
    end
end


function updatedisplay!(display, cycle, x)
    #=
        Each block in the if statement represents a different row of the display.
        We use x-1 in the absolute value to correct for the fact that our array is indexed from 1
        while the display is indexed from 0
    =#

    if (cycle <= 40)
        display[1, cycle] = abs(cycle-x-1) <= 1 ? "#" : "."
    elseif (cycle <= 80)
        display[2, cycle - 40] = abs((cycle-40)-x-1) <= 1 ? "#" : "."
    elseif (cycle <= 120)
        display[3, cycle - 80] = abs((cycle-80)-x-1) <= 1 ? "#" : "."
    elseif (cycle <= 160)
        display[4, cycle - 120] = abs((cycle-120)-x-1) <= 1 ? "#" : "."
    elseif (cycle <= 200)
        display[5, cycle - 160] = abs((cycle-160)-x-1) <= 1 ? "#" : "."
    elseif (cycle <= 240)
        display[6, cycle - 200] = abs((cycle-200)-x-1) <= 1 ? "#" : "."
    end
end


signalstrengths = Dict{Int,Int}()
main()