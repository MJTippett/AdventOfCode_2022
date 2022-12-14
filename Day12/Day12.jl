mutable struct Node
    gridlocation::Tuple
    height::Int
    connectsto::Array{Any}
    distancefromstart::Int
    prevnodename::Tuple
    Node() = new()
    Node(a,b,c,d,e) = new(a,b,c,d,e)
end

function main()
    lines = ""
    open("Data.txt") do file
    #open("TestData.txt") do file
        lines = readlines(file)
    end

    nodes = Dict{Tuple, Node}()

    numrows = length(lines)
    numcols = length(lines[1])

    # Create dictionary of nodes
    startlocation = ()
    endlocation = ()
    for row in 1:numrows
        for col in 1:numcols
            
            nodes[(row,col)] = Node((row,col), only(lines[row][col]) - only("a"), [], typemax(Int)-1, ())
            
            if (only(lines[row][col]) == 'S')
                nodes[(row, col)].height = 0
                nodes[(row, col)].distancefromstart = 0
                startlocation = (row, col)
            elseif (only(lines[row][col]) == 'E')  
                nodes[(row, col)].height = only("z") - only("a")
                endlocation = (row, col)
            end
        end
    end

    # For each node, populate which nodes we can travel to/from it based on height and proximity
    for node in keys(nodes)
        
        row = node[1]
        col = node[2]

        # Add nodes above/below/left/right if they are not more than 1 higher
        # Check node above
        if (row > 1 && nodes[(row - 1, col)].height - nodes[node].height <= 1)
            push!(nodes[node].connectsto, (row - 1, col))
        end
        # Check node below
        if (row < numrows && nodes[(row + 1, col)].height - nodes[node].height <= 1)
            push!(nodes[node].connectsto, (row + 1, col))
        end
        # Check node to the left
        if (col > 1 && nodes[(row, col - 1)].height - nodes[node].height <= 1)
            push!(nodes[node].connectsto, (row, col - 1))
        end
        # Check node to the right
        if (col < numcols && nodes[(row, col + 1)].height - nodes[node].height <= 1)
            push!(nodes[node].connectsto, (row, col + 1))
        end
    end

    # Use Dijkstra's algorithm to find the shortest path from the start to end
    mindistance = dijkstra(deepcopy(nodes), endlocation)

    println("(Part 1) Minimum distance from start to end: $(mindistance)")

    # For Part 2 we will run Dijkstra's algorithm from the end with stopping condition that we are at a node with height = 0 (a)
    # As the path goes backwards we need to redefine the connections (as we can now only go DOWN one step at a time)
    for node in keys(nodes)
        
        row = node[1]
        col = node[2]

        # Zero out the connections between nodes
        nodes[node].connectsto = []

        # Add nodes above/below/left/right if they are not more than 1 lower
        # Check node above
        if (row > 1 && nodes[(row - 1, col)].height - nodes[node].height >= -1)
            push!(nodes[node].connectsto, (row - 1, col))
        end
        # Check node below
        if (row < numrows && nodes[(row + 1, col)].height - nodes[node].height >= -1)
            push!(nodes[node].connectsto, (row + 1, col))
        end
        # Check node to the left
        if (col > 1 && nodes[(row, col - 1)].height - nodes[node].height >= -1)
            push!(nodes[node].connectsto, (row, col - 1))
        end
        # Check node to the right
        if (col < numcols && nodes[(row, col + 1)].height - nodes[node].height >= -1)
            push!(nodes[node].connectsto, (row, col + 1))
        end
    end

    nodes[startlocation].distancefromstart = typemax(Int) - 1
    nodes[endlocation].distancefromstart = 0
    mindistance = dijkstra(deepcopy(nodes), endlocation, true)
    println("(Part 2) Minimum distance from start to end: $(mindistance)")
end


function dijkstra(nodes, endlocation, part2 = false)
    nodestocheck = nodes
    mindist = typemax(Int)-1
    iteration = 0

    while !isempty(nodestocheck)
        
        mindist = typemax(Int)-1
        nodetodrop = Node()
        
        # Get the node with the minimum distance
        for node in keys(nodestocheck)
            if (nodestocheck[node].distancefromstart <= mindist)
                mindist = nodestocheck[node].distancefromstart
                nodetodrop = nodestocheck[node]
            end
        end

        if (isempty(nodetodrop.connectsto))
            println("Hit node with no connections, delete it and continue")
            delete!(nodestocheck, nodetodrop.gridlocation)
            continue
        end

        #neighbours = deepcopy(nodetodrop.connectsto)
        neighbours = nodetodrop.connectsto
        for neighbour in neighbours
            # If the neighbour is no longer in the list of nodes to check, continue
            if (!(haskey(nodestocheck, neighbour)))
                continue
            end
            
            # The distance between each node is 1
            altdistance = nodetodrop.distancefromstart + 1
            
            if (altdistance < nodestocheck[neighbour].distancefromstart)
                nodestocheck[neighbour].distancefromstart = altdistance
                nodestocheck[neighbour].prevnodename = nodetodrop.gridlocation
            end
        end

        delete!(nodestocheck, nodetodrop.gridlocation)

        iteration += 1

        # Terminate if we have reached our goal
        if (part2)
            if (nodetodrop.height == 0)
                println("Found target location on iteration $(iteration)...")
                return mindist
            end
        else
            if(nodetodrop.gridlocation == endlocation)
                println("Found target location on iteration $(iteration)...")
                return mindist
            end
        end

        #if(iteration % 100 == 0)
        #    println("Iteration $(iteration), number of nodes to check: $(length(nodestocheck)), minimum distance: $(mindist)")
        #end
    end

    return mindist
end


main()