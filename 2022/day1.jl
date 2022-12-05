using Downloads: download
using DelimitedFiles
using DataFrames
using CSV


##############################
# Load data
##############################

session_cookie = read(string(@__DIR__, "\\", "session_cookie.txt"), String)

# Credits to https://www.incidentalfindings.org/posts/2022-01-24_learning-julia-with-adventofcode/
# for this download code !
url = "https://adventofcode.com/2022/day/1/input"
filename = "day1.csv"

data_file = joinpath(@__DIR__, filename)
println("Day 1: $data_file")
download(url, data_file, headers = Dict("cookie" => "session=$(session_cookie)"))
df = DataFrame(CSV.File(data_file, header=false, ignoreemptyrows=false))


##############################
# Extract solution 1
##############################

df_mat = Matrix(df)

global mat_cal_tot = []
global mat_cal = []

# Builds a Vector of Vectors for each elf
# Each elf Vector can be identified thanks to a missing to break the loop
for e in df_mat
    println(e)
    if isequal(e, missing)
        println("its a missing")
        global mat_cal_tot = [mat_cal_tot; [mat_cal]]
        global mat_cal = []
    else
        println("its a calorie")
        global mat_cal = [mat_cal; e]
    end
end

# Map
mat_cal_tot_sum =  map(x -> sum(x), mat_cal_tot)

# Reduce
println("Solution: ", maximum(mat_cal_tot_sum))


##############################
# Extract solution 2
##############################

println("Solution: ", sum(partialsort(mat_cal_tot_sum, 1:3, rev=true)))

