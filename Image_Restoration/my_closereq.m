function my_closereq
global comein;

if comein==2,
    %Function to close the window
    selection = questdlg(['Are you sure you want to close without saving?'],...
                         ['Close ' get(gcf,'Name')],...
                          'Yes','No','No');
    switch selection,
        case 'Yes',
            delete(gcf);
        case 'No'
            return
    end
else
    delete(gcf);
end