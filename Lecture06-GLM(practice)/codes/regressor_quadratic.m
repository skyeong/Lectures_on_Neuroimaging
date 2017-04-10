function y = regressor_quadratic(nscan)

x = 1:nscan;
y = -x.*(x-nscan);
y = y(:)/max(y);
