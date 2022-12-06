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

