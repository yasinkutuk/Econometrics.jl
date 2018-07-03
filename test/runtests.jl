using Test, Random
function main()
    # OLS
    x = [ones(10,1) (1:10)]
    srand(1)
    y = rand(10,1)
    b = ols(y,x,silent=true)[1]
    @testset "ols" begin
        @test b[1,1] ≈ 0.07655377367377458
    end    
    # samin
    junk=2. # shows use of obj. fun. as a closure
    function sse(x)
        objvalue = junk + sum(x.*x)
    end
    k = 5
    x = rand(k,1)
    lb = -ones(k,1)
    ub = -lb
    xopt, fopt, junk, junk = samin(sse, x, lb, ub, verbosity=0)
    @testset "samin" begin
    @test xopt[1] ≈ 0.0 atol=1e-5
    @test fopt ≈ 2.0 atol=1e-5
    end
    # npreg
    #include("../examples/npreg_example.jl");
    #yhat[1,1] ≈ -0.8108308248103517
end
main()
