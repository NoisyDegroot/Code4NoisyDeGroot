include("logw.jl")
include("graph.jl")
include("matrices.jl")
include("Linvdiag.jl")
include("sparsify.jl")

using Laplacians

function approx(G, EPS, w = open("log.txt", "w")) #G- graph

    logw(w,"")
    logw(w,"running approx algorithm whose eps is ",EPS)
    n = G.n

    ans = zeros(n,1)
    start_time = time()
    Gtil = getGtil(G, [0.0, 1.0], 20)
    logw(w, "get_Gtil")
    A = getAsp(Gtil)
    PI = Array{Float32, 1}(undef, G.n)
	for i in 1:G.n
		PI[i] = convert(Float32, size(G.nbr[i], 1))
	end
    logw(w, "get_A")
    s = sum(PI)
    PI /= s

    logw(w,"start")

    ans = LinvdiagSS(A, PI;ep=EPS)
    ans *= s
    delta = 0.0
	for i in 1:n
		delta += PI[i] * PI[i] * ans[i]
	end

    elapsed_time = time()-start_time
    return delta, elapsed_time
end
