function myseq = longtail_exp(mu,psdwin,N)

myseq = zeros(N,1);
cnt   = 1;

while 1,
    val = exprnd(mu);
    
    % Min-Max boundary
    if val<psdwin(1) || val>psdwin(2), continue; end
    
    myseq(cnt) = round(val*10)/10;
    cnt = cnt+1;
    
    if cnt>N*2, 
        break; 
    end
end

myseq = myseq(myseq>0);
myseq = myseq(1:N);