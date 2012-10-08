function [NUM] = count_files(DIR)

  FILES = dir(DIR);
  NUM=size(FILES,1)-2; % Discard '.' and '..'
            
end
