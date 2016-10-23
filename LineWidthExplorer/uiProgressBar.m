function uiProgressBar(varargin)
%uiProgressBar: A waitbar that can be embedded in a GUI figure.

    if ishandle(varargin{1}) && size(varargin, 2) > 1
        ax = varargin{1};
        value = varargin{2};
        p = get(ax,'Child');
        x = get(p,'XData');
        x(3:4) = value;
        set(p,'XData',x)
        return
    end

    bg_color =[0.5 0.5 0.5];
    fg_color = 'r';
    ax = varargin{1};
    cla(ax,'reset');
%    ax.Units = 'pixels';
    set(ax,'XLim',[0 1]);
    set(ax,'YLim',[0 1]);
    set(ax,'Units','pixels');
    set(ax,'XTick',[]);
    set(ax,'YTick',[]);
    set(ax,'Color',bg_color);
    set(ax,'XColor',bg_color);
    set(ax,'YColor',bg_color);

    
    patch([0 0 0 0],[0 1 1 0],fg_color,...
        'Parent',varargin{1},...
        'EdgeColor','none',...
        'EraseMode','none');
end