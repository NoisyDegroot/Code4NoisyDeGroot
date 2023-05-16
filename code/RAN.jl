using StatsBase

#n = parse(Int, ARGS[1])
#m = parse(Int, ARGS[2])

for t in 1:5
for m in 2:4
	clique = []
	flag = []
	c = [1]
	edge = []
	for i in 2:m+1
		for j in 1:i-1
			push!(edge, [i,j])
		end
		push!(c,i)
	end
	push!(clique, c)
	push!(flag, false)
	curn=m+1
	for n in 2000:2000:50000
		f = open(string(t,"_RAN_",m,"_",n,".txt"), "w")
		for i in curn:n
			k = rand(1:size(clique, 1))
			while flag[k]
				k = rand(1:size(clique, 1))
			end
			flag[k] = true
			#println(clique[k])
			for j in clique[k]
				push!(edge, [i,j])
				#println(f, i, " ", j)
				c = [i]
				for p in clique[k]
					(p != j) && (push!(c, p))
				end
				push!(clique, c)
				push!(flag, false)
			end
		end
		#println(clique)
		#println(flag)
		println(n)
		curn=n
		for e in edge
			println(f, e[1], " ", e[2])
		end
	end
end
end
