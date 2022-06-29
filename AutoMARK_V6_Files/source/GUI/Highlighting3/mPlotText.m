function mPlotText(iHandler, colour, startPosition, givenText, fontSize, anchorpoint,fontName)
%HPLOTARROW Plots a text on the image, The text can have latex format
    % this prevents having to read the settings each time we plot text
    % this code can be replaced by adjusting the function inputs each time this
    % function is called in the code
   
    [imageX, imageY] = iHandler.sheetToImage(startPosition(1), startPosition(2));
    cleanText = sanitizeText(givenText);
    if ~contains(givenText, char(hex2dec('2713')))
        iHandler.pixelData = insertText(iHandler.pixelData, [imageX, imageY], cleanText,...
            'FontSize', fontSize, 'TextColor', colour, 'BoxOpacity', 0, 'AnchorPoint', anchorpoint,...
            'Font', fontName);
    else
        iHandler.pixelData = insertText(iHandler.pixelData, [imageX, imageY], cleanText,...
            'FontSize', fontSize, 'TextColor', colour, 'BoxOpacity', 0, 'AnchorPoint', anchorpoint);
    end
end

