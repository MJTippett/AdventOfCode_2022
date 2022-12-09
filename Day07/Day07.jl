mutable struct Folder
    name::String
    parent::String
    children::Vector{String}
    size::Int
end


function main()
    history = []
    open("Commandhistory.txt") do file
        history = readlines(file)
    end

    #directory() = DirectoryTree{"/" => Folder("/", "", [], 0)}
    directory = Dict("/" => Folder("/", "", String[], 0))

    # Build the directory structure, and calculate the size of files in each folder
    # Start in the root directory
    currentfolder = "/"
    for item in history
        # If the item starts with \$ it is a command, otherwise it is the output of the last command
        # A single command can result in multiple lines of output (for example, ls)

        if (occursin("\$", item))
            tokens = split(item, " ")
            if (tokens[2] == "cd")
                # Return to root
                if (tokens[3] == "/")
                    currentfolder = "/"
                # Go up one level to parent folder (if we aren't at the root already)
                elseif (tokens[3] == ".." && currentfolder != "/")
                    path = split(directory[currentfolder].parent, "/")
                    temp = ""
                    for i in path
                        temp = temp * "/" * i
                    end

                    # The above logic adds an extra "/" to the beginning of the folder, so we trim it off
                    currentfolder = temp[2:end]
                    
                # Go down one level to the child folder (which may not have been found yet)
                else
                    addfolder!(directory, currentfolder, string(tokens[3]))                    
                    currentfolder = currentfolder * "/" * tokens[3]
                end
            # If tokens[2] != "cd" it's a ls command, which we can ignore
            end
        # If it's not a command, it's the output of a (ls) command
        else
            lsoutput = split(item, " ")
            # If it's not a directory, it's a file, in which case we add it to the current folder's size
            if (lsoutput[1] != "dir")
                directory[currentfolder].size += parse(Int, lsoutput[1])
            end
        end
    end

    # Calculate the overall size of each folder including subfolders
    getchildrensize!(directory, "/")

    # Find the cummulative size of all subfolders of size <= 100000
    size = 0
    for foldername in keys(directory)
        if directory[foldername].size <= 100000
            size += directory[foldername].size
        end
    end

    # Part 1
    println("Size of folders <= 100000: $(size)")

    # Part 2
    totaldiskspace = 70_000_000
    currentfreespace = totaldiskspace - directory["/"].size
    sizetodelete = 30_000_000 - currentfreespace

    minsize = totaldiskspace
    for folder in keys(directory)
        if (directory[folder].size >= sizetodelete && directory[folder].size < minsize)
            minsize = directory[folder].size
        end
    end

    println("Size of folder to delete: $(minsize)")
end


function getchildrensize!(directory, folder)
    #=
    Iterate through all the children of the current folder, and then recursively get the total size of them
    =#

    for child in directory[folder].children
        if (length(directory[child].children) == 0)
            directory[folder].size += directory[child].size
        else
            getchildrensize!(directory, directory[child].name)
            directory[folder].size += directory[child].size
        end
    end
end


function addfolder!(directory, currentfolder, newfolder)
    # If the folder is already in the hierarchy, return it unchanged
    if (newfolder in keys(directory))
        return directory
    end

    newfoldername = directory[currentfolder].name * "/" * newfolder

    directory[newfoldername] = Folder(newfoldername, currentfolder, String[], 0)
    push!(directory[currentfolder].children, newfoldername)

    return directory
end



main()