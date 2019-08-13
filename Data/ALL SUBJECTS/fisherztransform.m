%% Fisher z transform

%% Transforms r values from correlations to Fisher z values

function [zdash] = fisherztransform(r)

    zdash = 0.5*(log(1+r) - log(1-r));

end