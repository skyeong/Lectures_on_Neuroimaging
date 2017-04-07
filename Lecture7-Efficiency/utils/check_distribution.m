[T2, nullex1] = read_parfile('optseq-par/ex1-001.par');
[T3, nullex2] = read_parfile('optseq-par/ex2-001.par');
k=[1:12]';
pk1=hist(nullex1,k);
pk2=hist(nullex2,k);

figure;
bar(k,pk1,'k'); title('ex1')
figure;
bar(k,pk2,'r'); title('ex2')