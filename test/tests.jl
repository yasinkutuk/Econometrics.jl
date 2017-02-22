using FactCheck
facts("testing ols.jl") do
    # OLS
    x = [ones(10,1) (1:10)]
    srand(1)
    y = rand(10,1)
    b = ols(y,x,silent=true)[1]
    @fact b[1,1] --> roughly(0.07655377367377458)
    # samin
    include("../examples/samin_example.jl");
    @fact xopt[2] -->roughly(3.25)
    # npreg
    include("../examples/npreg_example.jl");
    @fact yhat[1,1] -->roughly(-0.8108308248103517)
end

