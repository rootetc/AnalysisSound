<<<<<<< HEAD
function set_bi = Similarfingerprints(key,index)

len = length(index);
lll = len + len*(len-1)/2 + 1;
set_bi = zeros(lll,1);
set_bi(1,1) = key;
    for i = 1 : len % bitÀÇ ÃÑ ±æÀÌ
        set_bi(i+1,1) = bitxor(key,bitshift(1,index(i) - 1));
    end
    if len > 1
        NC2 = nchoosek(1:len,2);
        len_nc2 = size(NC2,1);
        for i = 1 : len_nc2
            tmp = bitxor(key, bitshift(1,index(NC2(i,1))-1));
            key = bitxor(tmp, bitshift(1,index(NC2(i,2))-1));
            set_bi(len+i+1,1) = key;
        end
    end

end
=======
function set_bi = Similarfingerprints(key,index)

len = length(index);
lll = len + len*(len-1)/2 + 1;
set_bi = zeros(lll,1);
set_bi(1,1) = key;
    for i = 1 : len % bitÀÇ ÃÑ ±æÀÌ
        set_bi(i+1,1) = bitxor(key,bitshift(1,index(i) - 1));
    end
    if len > 1
        NC2 = nchoosek(1:len,2);
        len_nc2 = size(NC2,1);
        for i = 1 : len_nc2
            tmp = bitxor(key, bitshift(1,index(NC2(i,1))-1));
            key = bitxor(tmp, bitshift(1,index(NC2(i,2))-1));
            set_bi(len+i+1,1) = key;
        end
    end

end
>>>>>>> d2a4927c51aa93dd8032ac2b4abdb6ef701b7689
