function clean = sanitizeText(inputText)
%SANITIZETEXT Removes instances of '\b', '\r', '\f', '\t'


inputText = strrep(inputText, char(8), '');     % \b
inputText = strrep(inputText, char(13), '');    % \r
inputText = strrep(inputText, char(12), '');    % \f
clean = strrep(inputText, char(9), '    ');        % \t
end

