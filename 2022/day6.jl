using Downloads: download
using DelimitedFiles
using DataFrames
using CSV


##############################
# Functions
##############################

function f(s, key_len)
    """
    Takes a string and the length of the key to find
    Returns the index of the last character of the found key
    """

    for i in range(1, length(s)-key_len)
    
        sub_s = s[i:i+key_len-1]

        if length(Set(sub_s)) == key_len
            return i + key_len - 1
        end 
    end
end


##############################
# Load data
##############################

session_cookie = read(string(@__DIR__, "\\", "session_cookie.txt"), String)

# Credits to https://www.incidentalfindings.org/posts/2022-01-24_learning-julia-with-adventofcode/
# for this download code !
day = "6"

url = "https://adventofcode.com/2022/day/" * day * "/input"
filename = "day" * day * ".csv"

data_file = joinpath(@__DIR__, filename)
println("Day " * day)
download(url, data_file, headers = Dict("cookie" => "session=$(session_cookie)"))
df = DataFrame(CSV.File(data_file, header=false, ignoreemptyrows=false))


##############################
# Extract solution 1
##############################

stream = df[1, "Column1"]

println("Solution: ", f(stream, 4))


##############################
# Extract solution 2
##############################