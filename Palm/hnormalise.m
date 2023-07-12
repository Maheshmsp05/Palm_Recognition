
function nx = hnormalise(x)
    
    [rows,npts] = size(x);
    nx = x;
    finiteind = find(abs(x(rows,:)) > eps);

    if length(finiteind) ~= npts
        warning('Some points are at infinity');
    end

   
    for r = 1:rows-1
	nx(r,finiteind) = x(r,finiteind)./x(rows,finiteind);
    end
    nx(rows,finiteind) = 1;
    
