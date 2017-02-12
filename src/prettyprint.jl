# formatted print of array, with column names
function prettyprint(a, cnames, rnames="",digits=8, decimals=4)
    # TBD: try to use this to allow using specified digits and decimals
    #fmt = @sprintf("%d",digits)"."@sprintf("%d",decimals)"%f"
    #@eval dofmt(x) = @sprintf($fmt, x)
    
    # print column names
    for i = 1:size(a,2)
        pad = digits
        if rnames != "" && i==1
            pad = 2*digits
        end    
        @printf("%s", lpad(cnames[i],pad," "))
    end
    @printf("\n")
    # print the rows
    for i = 1:size(a,1)
        if rnames != ""
            @printf("%s", lpad(rnames[i],digits," "))
        end
        for j = 1:size(a,2)
            # TBD: use fmt defined above to print array contents
            @printf("%8.3f",(a[i,j]))
        end
        @printf("\n")
    end    
end  