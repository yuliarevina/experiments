function [lowerBound upperBound BF] = BayesFactor_Dienes(distribution, standarderror, raweffect, minvalue, maxvalue, meandata1)

% Calculates BayesFactor based on uniform distribution. Needs minvalue and
% maxvalue (not the same as lower and upper bound) of the data. E.g. lowest
% possible observed mean is 0, highest possible is 2 based on some previous
% literature. Current observed mean is 1.5, so lower and upper bounds are
% 1.5 - 0 = 1.5 and 1.5 - 2 = -0.5 for this specific condition. The
% function calculates this based on the means you supply.

% distribution = 1 % uniform (only programmed for this so far)
% standarderror = standard error as per Dienes instructions
% raweffect = raw effect as per Dienes instructions -> mean1 - mean2
% min/max value = theoretical min and max you can observe in your data
% (e.g. slope of psychometric function has to be 0 if absolutely the
% smallest it could be, so min is zero for such data. Etc)
% meandata1 = the mean of data1, used to calculate lower and upper bounds
% for this specific pairwise comparison.

% Edited from code provided on Z Dienes website

% Yulia Revina 2020

normaly = @(mn, variance, x) 2.718283^(- (x - mn)*(x - mn)/(2*variance))/realsqrt(2*pi*variance);
 
%       sd = input('What is the sample standard error? ');
      sd = standarderror;
      sd2 = sd*sd;
%       obtained = input('What is the sample mean? ');
      obtained = raweffect;
   
%       uniform = input('is the distribution of p(population value|theory) uniform? 1= yes 0=no ');
      uniform = distribution;

     if uniform == 0
          meanoftheory = input('What is the mean of p(population value|theory)? ');
          sdtheory = input('What is the standard deviation of p(population value|theory)? ');
          omega = sdtheory*sdtheory;   
          tail = input('is the distribution one-tailed or two-tailed? (1/2) ');
     end
    
    
     if uniform == 1
%           lower = input('What is the lower bound? ');
%           upper = input('What is the upper bound? ');
          tmp1 = meandata1 - minvalue;
          tmp2 = meandata1 - maxvalue;
          lower = min([tmp1 tmp2]);
          upper = max([tmp1 tmp2]);
     end
    
    
    
     area = 0;
     if uniform == 1
         theta = lower;
     else theta = meanoftheory - 5*(omega)^0.5;
     end
     if uniform == 1
          incr = (upper- lower)/2000;
     else incr =  (omega)^0.5/200;
     end
        
     for A = -1000:1000
          theta = theta + incr;
          if uniform == 1
              dist_theta = 0;
              if and(theta >= lower, theta <= upper)
                  dist_theta = 1/(upper-lower);
              end              
          else %distribution is normal
              if tail == 2
                  dist_theta = normaly(meanoftheory, omega, theta);
              else
                  dist_theta = 0;
                  if theta > 0
                      dist_theta = 2*normaly(meanoftheory, omega, theta);
                  end
              end
          end
         
          height = dist_theta * normaly(theta, sd2, obtained); %p(population value=theta|theory)*p(data|theta)
          area = area + height*incr; %integrating the above over theta
     end
    
    
     Likelihoodtheory = area
     Likelihoodnull = normaly(0, sd2, obtained)
     Bayesfactor = Likelihoodtheory/Likelihoodnull;
     lowerBound = lower;
     upperBound = upper;
     BF = Bayesfactor;
end