function [ word_selection ] = word_selection( list_srt, now )
%WORK_SELECTION Summary of this function goes here
%   Detailed explanation goes here
j=1;
ham_words=0;
spam_words=0;
for i=1:size(list_srt,1)
    if (list_srt{i,2}) > list_srt{i,3}
        word_selection(j)= list_srt(i,1);
        j=j+1;
        ham_words=ham_words+1;
    end
    if(ham_words == now/2)
        break;
    end
end

for i=1:size(list_srt,1)   
    if (list_srt{i,3}) > list_srt{i,2}
        word_selection(j)= list_srt(i,1);
        spam_words=spam_words+1;
        j=j+1;
    end
    if(spam_words == now/2)
        break;
    end
end

end

