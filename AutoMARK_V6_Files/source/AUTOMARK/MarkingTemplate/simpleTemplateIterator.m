classdef simpleTemplateIterator
    %SIMPLETEMPLATEITERATOR Iterates through a template. Needed for GUI
    % This is a complex stack mahcine. If you aren't good with drawing tree
    % diagrams and proofs by induction, do not attempt to modify!
    
    properties
        %debugDisplay2 = '';
        %debugDisplay = '';
        onFeature = [];
        onTemplateCell = [];
        parent = [];
        state = 0;
        % 0 is staring at ourself
        % > 0 is one of our children
        % > numel(obj.onTemplateCell) is exhausted return to parents next
        % < 0 is exhausted, return to parents previous
    end
    
    methods
        function obj = simpleTemplateIterator(onTemplateCell)
            %SIMPLETEMPLATEITERATOR Construct an instance of this class
            assert(isa(onTemplateCell, 'templateCell'));
            obj.onTemplateCell = onTemplateCell;
            obj.onFeature = onTemplateCell.onFeature;
            % obj.debugDisplay = onTemplateCell.onFeature.name;
            % obj.debugDisplay2 = onTemplateCell.onFeature.commonTypeName;
        end
        
        function nextCell = next(obj)
            % Try to go down tree
            obj.state = obj.state + 1;
            if numel(obj.onTemplateCell.children) >= obj.state
                if obj.state > 0
                    % Go into this new child
                    nextCell = simpleTemplateIterator(obj.onTemplateCell.children(obj.state));
                    nextCell.parent = obj;
                else
                    % We are the next cell
                    % Should never happen
                    obj.state = 0;
                    nextCell = obj;
                end
            else % We are exhausted
                if ~isempty(obj.parent)
                    nextCell = obj.parent.next();
                else
                   % No where to go :(
                   % Reset on me
                   obj.state = 0;
                   nextCell = obj;
                end
            end
        end
        
        function nextCell = prev(obj)
            % Try to go back
            % Decrement our state
            obj.state = obj.state - 1;

            if obj.state > 0
                % We can actually go back, so spawn a child who is
                % exhausted
                childcell = simpleTemplateIterator(obj.onTemplateCell.children(obj.state));
                childcell.state = numel(childcell.onTemplateCell.children) + 1;
                childcell.parent = obj;
                
                % The next cell is that childs previous
                nextCell = childcell.prev();
            elseif obj.state == 0
                % We can't go back, so its us that is the next cell!
                nextCell = obj;
            else
                % We already went, and are one-overed, so now its our
                % parent's previous
                if ~isempty(obj.parent)
                   nextCell = obj.parent.prev();
                else
                   % Nowhere to go, so we must be the top level, so we
                   % force going down! (Inverse of next())
                   obj.state = numel(obj.onTemplateCell.children) + 1;
                   nextCell = obj.prev();
                end
            end
        end
        
        function nextCell = nextOver(obj)
            % Jump out, if possible
            if ~isempty(obj.parent)
                % Call next
                % But If our parent is nearly exhausted, reset them
                if obj.parent.state >= numel(obj.parent.onTemplateCell.children)
                   obj.parent.state = 0; 
                end
                nextCell = obj.parent.next();
            else
                % can't jump out, just reset at me
               obj.state = 0;
               nextCell = obj;
            end
        end
        
        function nextCell = prevOver(obj)
            % Jump out, if possible
            if ~isempty(obj.parent)
                % Our parent should be looking at us, so
                % we jump them back 1 and call next
                obj.parent.state = obj.parent.state - 2;
                
                % If we made them negative, Then we make them one before
                % exhausted
                if obj.parent.state < 0
                    obj.parent.state = numel(obj.parent.onTemplateCell.children) - 1;
                end
                nextCell = obj.parent.next();
            else
                % can't jump out, just reset at me
               obj.state = 0;
               nextCell = obj;
            end
        end
        
        function nextCell = jumpOut(obj)
           % Jump up to the parent! (If possible)
           if ~isempty(obj.parent)
               obj.parent.state = 0; % Our parent is looking at themselves
               nextCell = obj.parent;
           else
               nextCell = obj;
           end
        end
        
        function stackState = getStackState(obj)
           % Full stack state.
           if ~isempty(obj.parent)
               stackState = sprintf('%s - %d', obj.parent.getStackState(), obj.state);
           else
              stackState = sprintf('%d', obj.state); 
           end
        end
    end
    
    % New, but same
    %         function nextCell = next(obj)
%             % We can move forwards
%             if numel(obj.onTemplateCell.children) > obj.state
%                 obj.state = obj.state + 1;
%                 nextCell = simpleTemplateIterator(obj.onTemplateCell.children(obj.state));
%                 nextCell.parent = obj; % We are their parent
%             else % We are exhausted
%                 if ~isempty(obj.parent)
%                     nextCell = obj.parent.next(); % Pass the baton to our parent
%                 else
%                     % No where left to go. =(
%                     % Reset on me
%                     obj.state = 0;
%                     nextCell = obj;
%                 end
%             end
%         end
%         
%         function nextCell = prev(obj)
%            
%             % If we can move backwards
%             if obj.state > 0
%                 obj.state = obj.state - 1;
%                 
%                 % If we aren't bottomed out
%                 if obj.state > 0
%                     % Make a new child, who is exhausted, and unexhaust them.
%                     childcell = simpleTemplateIterator(obj.onTemplateCell.children(obj.state));
%                     childcell.state = numel(childcell.onTemplateCell.children) + 1;
%                     
%                     nextCell = obj.
%                     
%                 
%         end
end

