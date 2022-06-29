function asText = typeToString(viewtype)
switch viewtype
    case 1
        asText = "Drawing Sheet";
    case 2
        asText = "Section";
    case 3
        asText = "Detail";
    case 4
        asText = "Projected";
    case 5
        asText = "Auxiliary";
    case 6
        asText = "Standard";
    case 7
        asText = "Dragged In"; % Named View
    case 8
        asText = "Relative";
    case 9
        asText = "Detached";
    case 10
        asText = "Alternate Position";
    otherwise
        asText = "unknown";
end
end