using Downloads: download
using DelimitedFiles
using DataFrames
using CSV


##############################
# Functions
##############################

function f(x, y)::Int
    range_dict = Dict()

    x_split = map(e -> parse(Int, e), split(x, "-"))
    x_range = range(x_split[1], x_split[2])

    y_split = map(e -> parse(Int, e), split(y, "-"))
    y_range = range(y_split[1], y_split[2])

    x_is_in_y = issubset(x_range, y_range)
    y_is_in_x = issubset(y_range,x_range)

    x_is_in_y || y_is_in_x

end


function g(x, y)::Int
    range_dict = Dict()

    x_split = map(e -> parse(Int, e), split(x, "-"))
    x_range = range(x_split[1], x_split[2])

    y_split = map(e -> parse(Int, e), split(y, "-"))
    y_range = range(y_split[1], y_split[2])

    size(intersect(x_range, y_range))[1]
end


##############################
# Load data
##############################

session_cookie = read(string(@__DIR__, "\\", "session_cookie.txt"), String)

# Credits to https://www.incidentalfindings.org/posts/2022-01-24_learning-julia-with-adventofcode/
# for this download code !
url = "https://adventofcode.com/2022/day/4/input"
filename = "day4.csv"

data_file = joinpath(@__DIR__, filename)
println("Day 4: $data_file")
download(url, data_file, headers = Dict("cookie" => "session=$(session_cookie)"))
df = DataFrame(CSV.File(data_file, header=false, ignoreemptyrows=false))


##############################
# Extract solution 1
##############################

df = transform(df, ["Column1", "Column2"] => ByRow(f) => "is_overlap")

println("Solution: ", size(filter( x -> isequal(x, 1), df[!, "is_overlap"]))[1])


##############################
# Extract solution 1
##############################

df = transform(df, ["Column1", "Column2"] => ByRow(g) => "nb_intersections")

println("Solution: ", size(filter( x -> !isequal(x, 0), df[!, "nb_intersections"]))[1])