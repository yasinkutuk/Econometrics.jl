# sort by column
function sortbyc(x,col)
    x = sortrows(x,by=x->x[col])
end
