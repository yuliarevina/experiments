%% Fisher z transform

% Transforms Fisher z values back to R values

function [rvalue] = fisherrtransform(z)

    rvalue = (exp(2*z) - 1) / (exp(2*z) + 1);
    
end