using Downloads: download
using DelimitedFiles
using DataFrames
using CSV


##############################
# Functions
##############################

function f(x)
    x1 = x[1]

    if islowercase(x1)
        parse(Int, x1, base=62) - 35
    elseif isuppercase(x1)
        parse(Int, x1, base=62) - 9 + 26
    end
end


##############################
# Load data
##############################

session_cookie = read(string(@__DIR__, "\\", "session_cookie.txt"), String)

# Credits to https://www.incidentalfindings.org/posts/2022-01-24_learning-julia-with-adventofcode/
# for this download code !
url = "https://adventofcode.com/2022/day/3/input"
filename = "day3.csv"

data_file = joinpath(@__DIR__, filename)
println("Day 3: $data_file")
download(url, data_file, headers = Dict("cookie" => "session=$(session_cookie)"))
df = DataFrame(CSV.File(data_file, header=false, ignoreemptyrows=false))


##############################
# Extract solution 1
##############################

priorities = map(x -> f(x),
                    map(x -> intersect(x[1], x[2]),
                        map(x -> [x[1:Int(floor(length(x)/2))],
                                 x[Int(floor(length(x)/2))+1:length(x)]],
                            df[!, "Column1"]
                        )
                    )
                )

println("Solution: ", sum(priorities))
