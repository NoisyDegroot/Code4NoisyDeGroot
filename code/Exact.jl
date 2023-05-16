include("graph.jl")
include("matrices.jl")
include("logw.jl")

function exact(G, w :: IOStream) #G- graph

    logw(w,"")
    logw(w,"running exact algorithm...")

    n = G.n
    PI = Array{Float32, 1}(undef, G.n)
	for i in 1:G.n
		PI[i] = convert(Float32, size(G.nbr[i], 1))
	end
    s = sum(PI)
    PI /= s
    ans = zeros(n,1)

    L = getLP2(G)

    logw(w, "start")
    start_time = time()

    Linv = mppinv(L)
    logw(w, "get pinv(L)")

	er = sum(PI'*Linv*PI)
	ans = zeros(n,1)

	for j in 1:n
	  for i in 1:n
	    ans[j] -= Linv[j,i]*PI[i]
	  end
	  ans[j] *= 2
	  ans[j] += Linv[j,j] + er
	end
	
	ans *= s
	delta = 0.0
	for i in 1:n
		delta += PI[i] * PI[i] * ans[i]
	end

    elapsed_time=time()-start_time
    return delta, elapsed_time
end
