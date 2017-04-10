mylist  = [1 2 3];
full_list = repmat(mylist,1,4);
idx = randperm(length(full_list));
full_list = full_list(idx);