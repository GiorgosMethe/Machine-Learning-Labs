function check = presentredir(DIR , RE)
    
    FILES = dir(DIR);
    N=size(RE,2);
    M=size(FILES,1);
    check = zeros(1,N);
    
    for i=3:M
      check = [check ; presentre([DIR '/' FILES(i).name], RE)];
    end
    check(1,:)=[];
end
    