function main()
    # Load strategy from file
    rounds = []
    open("Day02.txt") do file
        rounds = readlines(file)
    end

    score = 0           # Part 1
    desired = 0         # Part 2
    for round in rounds
        opponent, me = split(round, " ")
        opponent = string(opponent)
        me = string(me)

        # replace the encoding of the strategies with their names for readability
        opponent = replace(opponent, "A"=>"rock", "B"=>"paper", "C"=>"scissors")
        desiredoutcome = me == "X" ? "lose" : me == "Y" ? "draw" : "win" # for part 2
        me = replace(me, "X"=>"rock", "Y"=>"paper", "Z"=>"scissors")
        
        score += getscore(opponent, me)
        desired += desiredscore(opponent, desiredoutcome)
    end

    println("(Part 1) Total score is: $(score)")
    println("(Part 2) Desired total score is: $(desired)")
end

function getscore(opponentstrategy::String, mystrategy::String)
    # Score for choosing a certain shape
    strategyscore = mystrategy == "rock" ? 1 : mystrategy == "paper" ? 2 : 3

    # Score for winning or drawing the round
    if(opponentstrategy == "rock")
        roundscore = mystrategy == "rock" ? 3 : mystrategy == "paper" ? 6 : 0
    elseif(opponentstrategy == "paper")
        roundscore = mystrategy == "rock" ? 0 : mystrategy == "paper" ? 3 : 6
    else
        roundscore = mystrategy == "rock" ? 6 : mystrategy == "paper" ? 0 : 3
    end

    return strategyscore + roundscore
end

function desiredscore(opponentstrategy::String, desiredoutcome::String)
    if(desiredoutcome == "lose")
        roundscore = 0
        strategy = opponentstrategy == "rock" ? "scissors" : opponentstrategy == "paper" ? "rock" : "paper"
    elseif(desiredoutcome == "draw")
        roundscore = 3
        strategy = opponentstrategy
    else
        roundscore = 6
        strategy = opponentstrategy == "rock" ? "paper" : opponentstrategy == "paper" ? "scissors" : "rock"
    end

    strategyscore = strategy == "rock" ? 1 : strategy == "paper" ? 2 : 3

    return strategyscore + roundscore
end

main()