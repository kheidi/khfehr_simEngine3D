function data = parseADM(filename)
% PARSEADM - Takes text file written in .adm format and parses through it for
% pertinent information.
%
% Inputs:
%     filename - string that contains filename or filepath. (.adm or .txt)
% 
% Outputs:
%     data - struct that contains all the provided attributes by command
%               name
%
% Author: K. Heidi Fehr
% Email: kfehr@wisc.edu
% October 2020; Last revision: 5-Oct-2020

%------------- BEGIN CODE --------------
% Split file by lines
filecontents = strsplit(fileread(filename),'\n');

% Remove commented lines, combine lines that overflowed onto the next line
count = 1;
while(true)
    if count == length(filecontents)
        break; % exit loop when you get to the end of the file
    end
    if filecontents{1,count}(1,1) == '!'
        filecontents(count) = []; %removes cells that start with '!'
    elseif filecontents{1,count}(1,1) == ','
        str = [filecontents{1,count-1},filecontents{1,count}];
        filecontents{1,count-1} = join(str); %combines line that begins with ',' with the previous cell
        filecontents(count) = [];
    else
        count = count + 1;
    end
end

% Seperate commands from descriptions
for i = 2:numel(filecontents)
    line(i-1,:) = regexp(filecontents{i}, '/', 'split');
end

% Deal with each different command
for i = 1:length(line)
    % UNITS
    if line(i,1) == "UNITS"
        name = char(line(i,1));
        data.(name) = line(i,2);
    %PARTS
    elseif line(i,1) == "PART"
        name = char(line(i,1));
        seperate = regexp(line(i,2), ',', 'split','once');
        partNumber = str2double(seperate{1,1}(1));
        value = seperate{1,1}(2);
        propertyNames = (regexp(value,'[A-Z_]+','match'));
        if strcmp(propertyNames{1,1}(1),'GROUND') == 0 %if the string isn't GROUND
            propertyValues = (regexp(value,'[A-Z_]+','split')); %splits the different attributes
            propertyValues = propertyValues{1,1};
            propertyValues(strcmp(' ',propertyValues)) = []; %removes spaces
            propertyValues = regexprep(propertyValues, '=', ''); %remove = signs
            propertyValues = regexp(propertyValues,',','split','noemptymatch'); %seperate by columns, for variables that have more than one dimension
            propertyValues(strcmp(' ',propertyValues)) = [];
            propertyValues = strtrim(propertyValues); %removes spaces
            %creates variable in struct for each different variable
            %provided
            for j = 1:length(propertyNames{1,1})
                pname = char(propertyNames{1,1}(1,j)); 
                currValue = propertyValues{1,j}(~cellfun(@isempty, propertyValues{1,j}));
                currValue = sprintf('%s ', currValue{:}); 
                currValue = sscanf(currValue, '%f').'; %convert string to number
                data.(name)(partNumber).(pname) = currValue;
            end
        elseif strcmp(propertyNames{1,1}(1),'GROUND') == 1 %if the string isn't GROUND
            data.(name)(partNumber).GROUND = 1;
        end
    %MARKERS
    elseif line(i,1) == "MARKER"
        name = char(line(i,1));
        
        seperate = regexp(line(i,2), ',', 'split','once');
        partNumber = str2double(seperate{1,1}(1));
        value = seperate{1,1}(2);
        value{1,1}(regexp(value{1,1},'[D]'))=[];
        propertyNames = (regexp(value,'[A-Z_]+','match'));
        

        propertyValues = (regexp(value,'[A-Z_]+','split')); %splits the different attributes
        propertyValues = propertyValues{1,1};
        propertyValues(strcmp(' ',propertyValues)) = []; %removes spaces
        propertyValues = regexprep(propertyValues, '=', ''); %remove = signs
        propertyValues = regexp(propertyValues,',','split','noemptymatch'); %seperate by commas, for variables that have more than one dimension
        propertyValues(strcmp(' ',propertyValues)) = [];
        propertyValues = strtrim(propertyValues); %removes spaces
        %creates variable in struct for each different variable
        %provided
        for j = 1:length(propertyNames{1,1})
            pname = char(propertyNames{1,1}(1,j)); 
            currValue = propertyValues{1,j}(~cellfun(@isempty, propertyValues{1,j}));
            currValue = sprintf('%s ', currValue{:}); 
            currValue = sscanf(currValue, '%f').'; %convert string to number
            data.(name)(partNumber).(pname) = currValue;
        end
    %JOINTS    
    elseif line(i,1) == "JOINT"
        name = char(line(i,1));
        seperate = regexp(line(i,2), ',', 'split','once');
        partNumber = str2double(seperate{1,1}(1));
        value = seperate{1,1}(2);
        propertyNames = (regexp(value,'[A-Z_]+','match'));
    
        propertyValues = (regexp(value,'[A-Z_]+','split')); %splits the different attributes
        propertyValues = propertyValues{1,1};
        propertyValues(strcmp(' ',propertyValues)) = []; %removes spaces
        propertyValues = regexprep(propertyValues, '=', ''); %remove = signs
        propertyValues = regexp(propertyValues,',','split','noemptymatch'); %seperate by columns, for variables that have more than one dimension
        propertyValues(strcmp(' ',propertyValues)) = [];
        propertyValues = strtrim(propertyValues); %removes spaces
        %creates variable in struct for each different variable
        %provided
        for j = 1:length(propertyNames{1,1})
            pname = char(propertyNames{1,1}(1,j)); 
            if j == 1
                data.(name)(partNumber).TYPE = pname;
            else
                currValue = propertyValues{1,j}(~cellfun(@isempty, propertyValues{1,j}));
                currValue = sprintf('%s ', currValue{:}); 
                currValue = sscanf(currValue, '%f').'; %convert string to number
                data.(name)(partNumber).(pname) = currValue;
            end
        end
    elseif line(i,1) == "ACCGRAV"
        name = char(line(i,1));
        value = line(i,2);
        propertyNames = (regexp(value,'[A-Z_]+','match'));
    
        propertyValues = (regexp(value,'[A-Z_]+','split')); %splits the different attributes
        propertyValues = propertyValues{1,1}(~cellfun(@isempty, propertyValues{1,1}));
        propertyValues(strcmp(' ',propertyValues)) = []; %removes spaces
        propertyValues = regexprep(propertyValues, '=', ''); %remove = signs
        propertyValues = regexp(propertyValues,',','split','noemptymatch'); %seperate by columns, for variables that have more than one dimension
        propertyValues(strcmp(' ',propertyValues)) = [];
        propertyValues = strtrim(propertyValues); %removes spaces
        %creates variable in struct for each different variable
        %provided
        for j = 1:length(propertyNames{1,1})
            pname = char(propertyNames{1,1}(1,j)); 
            currValue = propertyValues{1,j}(~cellfun(@isempty, propertyValues{1,j}));
            currValue = sprintf('%s ', currValue{:}); 
            currValue = sscanf(currValue, '%f').'; %convert string to number
            data.(name).(pname) = currValue;
        end
    
    end

end
    

%     name = char(line(1));
%     data.(name) = line(2);

%------------- END OF CODE --------------
a = 1
end