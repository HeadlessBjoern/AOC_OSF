% dlg_overweightevents - pops user dialogue, called by pop_overweightevents.m
%                see >> help pop_overweighevents
%
% Copyright (C) 2018 Olaf Dimigen
% olaf.dimigen@hu-berlin.de 

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, 51 Franklin Street, Boston, MA 02110-1301, USA

function [event2overweight,timelim,ow_proportion,removemean] = dlg_overweightevents(callingFcn,EEG)


geometry = { 1 [2 1.3 0.4] [2 1.3 0.4] 1 [2 1.3 0.4] 1 1 [2 1.3 0.4]};

%% callbacks
cbevent1 = ['if ~isfield(EEG.event, ''type'')' ...
    '   errordlg2(''No type field'');' ...
    'else' ...
    '   if isnumeric(EEG.event(1).type),' ...
    '        [tmps,tmpstr] = pop_chansel(unique([ EEG.event.type ]));' ...
    '   else,' ...
    '        [tmps,tmpstr] = pop_chansel(unique({ EEG.event.type }));' ...
    '   end;' ...
    '   if ~isempty(tmps)' ...
    '       set(findobj(''parent'', gcbf, ''tag'', ''sevent''), ''string'', tmpstr);' ...
    '   end;' ...
    'end;' ...
    'clear tmps tmpv tmpstr tmpfieldnames;' ];

%% main menu
uilist = {...
    {'style', 'text', 'string', 'Overweight samples around this event:', 'fontweight','bold'},...
    ...
    {'style', 'text', 'string', 'Event:'},...
    {'style', 'edit', 'string', 'saccade', 'tag', 'event2overweight' },...
    {'style', 'pushbutton', 'string', '...', 'callback', cbevent1}, ...
    ...
    {'style', 'text', 'string', 'Time limits [start, end] in seconds:'},...
    {'style', 'edit', 'string', '-0.02  0.01' 'tag', 'timelimits'},...
    {'style', 'text', 'string', ''},...
    {},...
    {'style', 'text', 'string', 'Remove mean of appended epochs?'},...
    {'Style', 'checkbox','value', 1,'tag','removeepochbaseline'},...
    {'style', 'text', 'string', ''},...
    {},...
    {'style', 'text', 'string', 'Length of appended data (as proportion of original data length)','fontweight','bold'},...
    {'style', 'text', 'string', 'Proportion:'},...
    {'style', 'edit', 'string', '0.5', 'tag', 'ow_proportion' },...
    {'style', 'text', 'string', ''},...
    };


%% make GUI
[results tmp tmp outstruct] = inputgui( 'geometry',geometry, ...
    'uilist',uilist,'helpcom', ['pophelp(''' callingFcn ''');'],...
    'title', ['Create optimized ICA training data with overweighted events -- ', callingFcn]);


%% process user input (cancel)
if isempty(results)
    return
end

%% collect dialogue entries
event2overweight  = outstruct.event2overweight;
timelim           = str2num(outstruct.timelimits); % this needs to be str2num, NOT str2double (cannot handle multiple strings)
ow_proportion     = str2double(outstruct.ow_proportion);
removemean        = outstruct.removeepochbaseline;

end