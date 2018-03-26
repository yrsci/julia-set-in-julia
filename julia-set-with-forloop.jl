#!/Applications/Julia-0.6.app/Contents/Resources/julia/bin/julia

#using BenchmarkTools

function pbm(lattice,filename)
    #=
    Generate a .pbm file from a given 2D lattice &
    save it under the given filename.
    =#
    flip_lattice = transpose(lattice) # rotate lattice to give correct orientation in .pbm format

    # generate the body of the .pbm file in required format
    body = string("P1\n", size(flip_lattice)[1],  " ", size(flip_lattice)[2], "\n")
    for i in 1:length(flip_lattice)
        body = string(body,flip_lattice[i]," ")
        if i^2 == size(flip_lattice)
            body = string(body,"\n")
        end
    end

    # write the file
    open(filename, "w") do new_img
        write(new_img,body)
    end
end

function julia(n,m,c)
    #=
    Generate a Julia set for given dimensions n, m
    and constant c.
    =#
    lattice = rand(0:0,n,m) # lattice of integer zeros (.pbm format req's integers

    for p in 1:n, q in 1:m
        a =  3.0 * (p / n) - 1.5 # rescale & translate axes for centered image
        b =  3.0 * (q / m) - 1.5

        # perform calculation to generate Julia set
        z = a + b*im
        for num in 1:100
            if abs(z) < 100.0
                z = z^2 + c
                lattice[p,q] = 0
            else
                lattice[p,q] = 1
            end
        end
    end

    # generate the image file
    pbm(lattice,"julia_set.pbm")

    return "Image saved.\n"
end

julia_constants = Dict{String,Complex{Float64}}("setA" => 0.295+0.55im, "setB" => -0.74434-0.10772im, "setC" => -0.233+0.5378im)

#display(@benchmark julia(200,200,julia_constants["setA"]))

println(julia(200,200,julia_constants["setA"]))
