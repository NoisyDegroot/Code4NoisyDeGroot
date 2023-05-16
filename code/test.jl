include("logw.jl")
include("matrices.jl")
include("Approx.jl")
include("Exact.jl")

function run_exact()
    return length(ARGS) <= 1 || ARGS[2] == "both" || ARGS[2] == "exact"
end

function run_approx()
    return length(ARGS) <= 1 || ARGS[2] == "both" || ARGS[2] == "approx"
end

datadir = string(ARGS[1],"/")
outFName=string(ARGS[1],".txt")
w = open(outFName, "w")
# srand(Int(round(time())))
for rFile in readdir(string(datadir))
    logw(w, "reading graph from edges list file ", rFile)
    G=read_file(string(datadir,rFile))
    logw(w, "finished reading graph")
    logw(w, "LCC.n: ", G.n, "\t LCC.m: ", G.m)
	
    if run_exact() exact_rst,exact_time = exact(G, w) end
	
	logw(w, "")
	if run_exact()
      logw(w, "exact_elapsed_time: ",  exact_time,  " (s)\t cent[1]: ", exact_rst[1])
    end
    
	for eps in 0.3:-0.1:0.3  	
    	if run_approx() 
    	  approx_rst,approx_time = approx(G, eps, w)
          logw(w, "approx_elapsed_time: ", approx_time, " (s)\t eps: ", eps, "\t K: ",approx_rst[1])
        end
        
        if run_exact() && run_approx()
          mRelStdEr=mean(abs.(exact_rst-approx_rst)./exact_rst)
          logw(w, "approx_mRelStdEr:",mRelStdEr)
          maxRelStdEr=maximum(abs.(exact_rst-approx_rst)./exact_rst)
          logw(w, "approx_maxRelStdEr:",maxRelStdEr)
        end
    end
    
    logw(w,"")
    logw(w,String(fill('*',80)))
    logw(w,"")
	flush(stdout)
end
close(w)
