using Laplacians

function LinvdiagSS(a::SparseMatrixCSC{Float64}, pii; ep=0.3, matrixConcConst=4.0)

  f = approxchol_lap(a, tol=1e-5);

  n = size(a,1)
  k = round(Int, (log2(2*n)/ep)/ep) # number of dims for JL
  U = wtedEdgeVertexMat(a)
  m = size(U,1)
  er = zeros(n,1)
  r = zeros(m,1)
  v = zeros(k,n)
  println(n)
  s = [1/sqrt(k),-1/sqrt(k)]

  for i = 1:k
    for j = 1:m
      r[j,1] = rand(s)
    end
    ur = U'*r
    v[i,:] = f(ur[:])'
  end

  er = v*pii
  ans = zeros(n,1)
  
  for i in 1:n
    ans[i,1] = sum((v[:,i]-er).^2)
  end
  
  return ans
  
end
