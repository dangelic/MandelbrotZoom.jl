# z_0 = 0 + 0i
# z_n+1 = (z_n)^2 + c (c -> starting point)
# Will this diverge? -> if |z| >= 2 (it will grow forever)
#       -> Color coding: 
#       Black inside: No divergence
#       Black outside: Direct proof
#       Colors => Something in range




using Plots
f(x) = exp(-x^2/2)
display(plot(f, -3, 3))