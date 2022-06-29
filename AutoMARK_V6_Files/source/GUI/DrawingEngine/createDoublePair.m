function [handler1 , handler2, ax] = createDoublePair(sheet1, sheet2)
%CREATEDDOUBLEPAIR Plots a Side by Side of two sheets and returns the two
%imageHandlers

% OLD , DEPRECATED!

% The left side is red, and the right side is blue.
% Its plotted on a square 1 by 1 for each image.

ax = axes();

%% Ticks

% Manual Ticks
ax.XTickMode = 'manual';
ax.YTickMode = 'manual';

% No Ticks
ax.XTick = [];
ax.YTick = [];

% No Numbers
ax.XTickLabel = [];
ax.YTickLabel = [];

%% Rulers

ax.XLimMode = 'manual';
ax.YLimMode = 'manual';

ax.XLim = [0 2];
ax.YLim = [0 1];

%% Labels

% ax.Title.String = "Side by Side Sheet Pair";
% ax.Title.FontWeight = 'normal';

%% Boxing
ax.Box = 'on';

%% Aspect Ratio of boxes

ax.PlotBoxAspectRatioMode = 'manual';
ax.PlotBoxAspectRatio = [2 1 1];

%ax.Position = [0.025 0.05 0.95 0.9];

%% Make the two side by sides

handler1 = imageHandler(sheet1, [0 0], [1 1], [1 0 0], ax);
handler2 = imageHandler(sheet2, [1 0], [2 1], [0 0 1], ax);

%% While we are at it lets just show them as well

handler1.displayFully();
handler2.displayFully();

end

