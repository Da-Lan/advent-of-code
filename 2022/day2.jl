using Downloads: download
using DelimitedFiles
using DataFrames
using CSV


##############################
# Functions
##############################

function f(x)
    if isequal(x, "X")
        1
    elseif isequal(x, "Y")
        2
    elseif isequal(x, "Z")
        3
    else
        println("Carefull !!! it's an unknown symbol")
        0
    end
end


function g(x, y)
    # I win if
    if ((isequal(x, "A") && isequal(y, "Y"))
        || (isequal(x, "B") && isequal(y, "Z"))
        || (isequal(x, "C") && isequal(y, "X")))
        6
    # Draw if
    elseif ((isequal(x, "A") && isequal(y, "X"))
        || (isequal(x, "B") && isequal(y, "Y"))
        || (isequal(x, "C") && isequal(y, "Z")))
        3
    # I lose if
    else
        0
    end
end


function h(x)
    if isequal(x, "X")
        0
    elseif isequal(x, "Y")
        3
    elseif isequal(x, "Z")
        6
    else
        println("Carefull !!! it's an unknown symbol")
        0
    end
end


function k(x, y)
    # if I need to win
    if isequal(y, 6)
        if isequal(x, "A")
            2 # I do paper
        elseif isequal(x, "B")
            3 # I do scisors
        elseif isequal(x, "C")
            1 # I do rock
        else
            println("Carefull !!! it's an unknown symbol")
            0
        end
    # if I need a Draw
    elseif isequal(y, 3)
        if isequal(x, "A")
            1 # I do rock
        elseif isequal(x, "B")
            2 # I do paper
        elseif isequal(x, "C")
            3 # I do scisors
        else
            println("Carefull !!! it's an unknown symbol")
            0
        end
    # if I need to lose
    elseif isequal(y, 0)
        if isequal(x, "A")
            3 # I do scisors
        elseif isequal(x, "B")
            1 # I do rock
        elseif isequal(x, "C")
            2 # I do paper
        else
            println("Carefull !!! it's an unknown symbol")
            0
        end
    end
end


##############################
# Load data
##############################

session_cookie = read(string(@__DIR__, "\\", "session_cookie.txt"), String)

# Credits to https://www.incidentalfindings.org/posts/2022-01-24_learning-julia-with-adventofcode/
# for this download code !
url = "https://adventofcode.com/2022/day/2/input"
filename = "day2.csv"

data_file = joinpath(@__DIR__, filename)
println("Day 2: $data_file")
download(url, data_file, headers = Dict("cookie" => "session=$(session_cookie)"))
df = DataFrame(CSV.File(data_file, header=false, ignoreemptyrows=false))


##############################
# Extract solution 1
##############################

df = transform(df, "Column2" => ByRow(f) => "my_points")
df = transform(df, ["Column1", "Column2"] => ByRow(g) => "match_points")
df = transform(df, ["my_points", "match_points"] => (+) => "tot_points")

println("Solution: ", sum(df[!, "tot_points"]))


##############################
# Extract solution 2
##############################

df = transform(df, "Column2" => ByRow(h) => "match_points2")
df = transform(df, ["Column1", "match_points2"] => ByRow(k) => "my_points2")
df = transform(df, ["my_points2", "match_points2"] => (+) => "tot_points2")

println("Solution: ", sum(df[!, "tot_points2"]))

