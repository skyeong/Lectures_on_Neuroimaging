function value = get_data_from(key,data)

hdr = cellstr(data.hdr);

for i=1:length(hdr),
    if strcmpi(hdr{i},key),
        try
            value = cell2mat(data.dat(:,i));
        catch
            value = data.dat(:,i);
        end
    end
end
