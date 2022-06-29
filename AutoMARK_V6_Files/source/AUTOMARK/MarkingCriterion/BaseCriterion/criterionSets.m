classdef criterionSets
    %CRITERIONSETS Cell arrays which hold the various criterion, This is
    % for the GUI to work properly. It needs to make copy()'s of these!
    
    properties
        drawingCriterion = {criterionDrawingSheetOrder(2), criterionDrawingExtraSheets(15), criterionAlwaysWrong(0)};
        sheetCriterion = {criterionSheetName(0), criterionSheetPaperSize(1), criterionSheetScale(1), criterionSheetTemplateIN(1), criterionSheetExtraBOMs(15), criterionSheetExtraViews(15),criterionSheetViewTypes(10), criterionSheetIntersectingBalloons(5), criterionSheetMass(1), criterionAlwaysWrong(0)};
        viewCriterion = {criterionViewPosition(6), criterionViewScale(2), criterionViewDisplayStyle(1), criterionViewTangentLines(3), criterionViewExtraDimensions(1), criterionViewExtraCentermarks(1), criterionViewExtraCenterlines(1), criterionViewExtraDatums(1), criterionViewWrongProjection(3), criterionViewMaterial(3), criterionAlwaysWrong(0)};
        bomCriterion = {criterionBOMTableType(40), criterionBOMColumnOrder(8), criterionBOMContent(3),criterionBOMNumberColumns(6), criterionBOMNumberRows(6), criterionBOMPosition(10), criterionBOMTableHeight(2), criterionBOMTableWidth(2),criterionBOMFontType(1), criterionBOMFontSize(1), criterionAlwaysWrong(0)};
        dimensionCriterion = {criterionFeatureDangling(2), criterionDimensionWrongView(2), criterionDimensionPostion(1), criterionDimensionArrowSide(1), criterionDimensionValue(2), criterionDimensionBadText(2), criterionAlwaysWrong(0)};
        centerlineCriterion = {criterionFeatureDangling(2), criterionCenterlinePostion(1), criterionAlwaysWrong(0)};
        centermarkCriterion = {criterionFeatureDangling(2), criterionCentermarkPosition(3), criterionCentermarkStyle(2), criterionCentermarkShowlines(1), criterionCentermarkAngle(1), criterionCentermarkConnectionLines(1), criterionCentermarkExtensions(1), criterionCentermarkGap(1), criterionCentermarkMarkSize(1), criterionCentermarkGroupedCorrectly(1), criterionAlwaysWrong(0)};
        datumCriterion = {criterionFeatureDangling(2), criterionDatumWrongView(2), criterionDatumPostion(1), criterionDatumBasePosition(1), criterionDatumLabel(2), criterionDatumDisplayStyle(1), criterionDatumFilledTriangle(1), criterionAlwaysWrong(0)};
        balloonCriterion = {criterionFeatureDangling(2), criterionBalloonPostion(0), criterionAlwaysWrong(0)};
    end
    
    properties
        defaultDimensionWeight = 5;
        defaultCenterlineWeight = 3;
        defaultCentermarkWeight = 5;
        defaultDatumWeight = 5;
        defaultBalloonWeight = 2;
        defaultBOMWeight = 50;
        
        % For views, sheets, and drawings, the default is the sum of the criterion and child
        % weights
    end
    methods 
        function obj = criterionSets()
            weights = getDefaultWeights();
            obj.defaultDimensionWeight = str2double(weights{1});
            obj.defaultCenterlineWeight = str2double(weights{2});
            obj.defaultCentermarkWeight = str2double(weights{3});
            obj.defaultDatumWeight = str2double(weights{4});
            obj.defaultBalloonWeight = str2double(weights{5});
            obj.defaultBOMWeight = str2double(weights{6});
        end
    end
end

