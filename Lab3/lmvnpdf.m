
function Y = lmvnpdf(X,MU,SIGMA)
  dcov = det(SIGMA);
  icov = inv(SIGMA);
  [N,dim] = size(X);
  diff = X - repmat(MU, [N 1]);
  Y = exp(-(1/2) * (dim * log(2*pi) + log(dcov) + sum((diff * icov) .* diff,2)));
end
