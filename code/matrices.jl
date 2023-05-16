using LinearAlgebra
using SparseArrays

include("graph.jl")


function getAsp(G :: Graph)
	I, J, V :: Array{Float32, 1} = [], [], []
    for i in eachindex(G.nbr)
        for j in G.nbr[i]
            push!(I, i)
            push!(J, j)
            push!(V, 1)
        end
    end
    return sparse(I, J, V, G.n, G.n)
end


function getAsp(G :: wGraph)
	I, J, V :: Array{Float64, 1} = [], [], []
    for i in eachindex(G.nbr)
        for t in G.nbr[i]
            push!(I, i)
            push!(J, t[1])
            push!(V, t[2])
        end
    end
    A = sparse(I, J, V, G.n, G.n)
    d = Array{Float64, 1}(undef, G.n)
	for i in 1:G.n
		d[i] = 0.0
		for t in G.nbr[i]
			d[i] += t[2]
		end
	end
    return A
end


function getLP2(G :: Graph)
	A = zeros(Float32, G.n, G.n)
	dinv = Array{Float32, 1}(undef, G.n)
	d = Array{Float32, 1}(undef, G.n)
	for i in 1:G.n
		dinv[i] = 1.0 / convert(Float32, size(G.nbr[i], 1))
		d[i] = convert(Float32, size(G.nbr[i], 1))
	end
    Dinv = Diagonal(dinv)
    for i in eachindex(G.nbr)
        A[CartesianIndex.(tuple.(i, G.nbr[i]))] .=  1.0
    end
    D = Diagonal(d)
    P = Dinv * A
    L = D * (I - P * P)
    return L
end


function mppinv(L :: Matrix{Float32})
    n = size(L,2)
    let L = copy(L)
        L .-= 1.0 / n
        L .= inv(L)
        L .+= 1.0 / n
        return L
    end
end

