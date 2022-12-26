using Downloads: download
using DelimitedFiles
using DataFrames
using CSV
using SplitApplyCombine


##############################
# Functions
##############################

function f(x)
    splited3 = split(x, "to")
    r3 = parse(Int, strip(splited3[2]))
    
    splited2 = split(splited3[1], "from")
    r2 = parse(Int, strip(splited2[2]))
    
    splited1 = split(splited2[1], "move")
    r1 = parse(Int, strip(splited1[2]))
    
    r1, r2, r3
end


function g(crates_local, nb_move, from, to)
    """
    Takes the number of movents to be done, the col number of the crate to be moved,
    the col number of the destination
    Returns the Matrix crates modified
    """

    from_i = 0
    to_i = 0

    for i in range(1, nb_move)
        println("---------- Begin move ", i, " of ", nb_move, from, to)

        # get "from" upper letter's index
        cr = crates_local[from]
        for i in range(1, length(cr))
            if isequal(cr[i], " ")
                break
            else
                from_i = (i, cr[i])
            end
        end

        # get "to" upper letter's top index
        cr = crates_local[to]
        for i in range(1, length(cr))
            if isequal(cr[i], " ")
                to_i = (i, cr[i])
                break
            end
        end

        # place "from" letter in place of "to"
        crates_local[to][to_i[1]] = from_i[2]
        crates_local[from][from_i[1]] = " "

    end

    crates_local
    
end


function h(crates_local, nb_move, from, to)
    """
    Takes the number of movents to be done, the col number of the crate to be moved,
    the col number of the destination
    Returns the Matrix crates modified
    """

    from_i = 0
    to_i = 0

    println("---------- Begin move of ", nb_move, from, to)

    # get "from" upper letter's index
    cr = crates_local[from]
    for i in range(1, length(cr))
        if isequal(cr[i], " ")
            break
        else
            from_i = (i, cr[i])
        end
    end

    # get "to" upper letter's top index
    cr = crates_local[to]
    for i in range(1, length(cr))
        if isequal(cr[i], " ")
            to_i = (i, cr[i])
            break
        end
    end

    # place "from" letter * nb_moves in place of "to"
    for i in range(1, nb_move)
        crates_local[to][to_i[1]+i-1] = crates_local[from][from_i[1]-nb_move+i]
        crates_local[from][from_i[1]-nb_move+i] = " "
    end

    crates_local
end


function get_upper_letters(crates_local)
    up_letter = []

    for cr in crates_local
        local_up_letter = " "
        for i in range(1, length(cr))
            if isequal(cr[i], " ")
                break
            else
                local_up_letter = cr[i]
            end
        end
        push!(up_letter, local_up_letter)
    end

    up_letter
end



##############################
# Load data
##############################

session_cookie = read(string(@__DIR__, "\\", "session_cookie.txt"), String)

# Credits to https://www.incidentalfindings.org/posts/2022-01-24_learning-julia-with-adventofcode/
# for this download code !
day = "5"

url = "https://adventofcode.com/2022/day/" * day * "/input"
filename = "day" * day * ".csv"

data_file = joinpath(@__DIR__, filename)
println("Day " * day)
download(url, data_file, headers = Dict("cookie" => "session=$(session_cookie)"))
df = DataFrame(CSV.File(data_file, header=false, ignoreemptyrows=false))


##############################
# Extract solution 1
##############################

# Transform dataframe to a Matrix
df = vec(Matrix(df))

# Split dataframe into 2 distinct dataframes, split on missing
loc = findall(ismissing, df)

crates, procedure = getindex.(Ref(df),
                                UnitRange.([1; loc .+ 1],
                                [loc .- 1; length(df)]))

# Reformat crates vector
crates = reverse(crates)

crates_col_dict = Dict()

crates = map(e -> e[2:4:length(e)], crates)
crates = map(e -> map(e -> String(e::SubString), split(e, "")),
                    crates)

# reformat procedure
procedure = DataFrame(sentence=procedure)
procedure = transform(procedure, "sentence" => ByRow(f) => ["nb_move", "from", "to"])

# remove first row that is col index 1...9
crates = crates[2:end,:]

# Add empty 50 crates above the existing one for padding
ini_vec = [fill(" ", size(crates[1])[1])]
crates = vcat(crates, repeat(ini_vec, outer = 50))

# Transpose
crates = invert(crates)

crates1 = deepcopy(crates)
crates2 = crates

# move crates according to precedure
for r in eachrow(procedure)
    global crates1 = g(crates1, r[2], r[3], r[4])
end

# get upper letter of each column
println("Solution: ", join(get_upper_letters(crates1), ""))


##############################
# Extract solution 2
##############################

print(crates2)
# move crates according to precedure
for r in eachrow(procedure)
    global crates2 = h(crates2, r[2], r[3], r[4])
end

# get upper letter of each column
println("Solution: ", join(get_upper_letters(crates2), ""))










