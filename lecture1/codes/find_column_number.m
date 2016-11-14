function colnum=find_column_number(list_of_headers,name_of_field)
%FIND_COLUMN_NUMBER is to find the column number from headers
%  
%   FIND_COLUMN_NUMBER(list_of_headers, name_of_field) locates the column number
%   of name_of_field.
%
%   list_of_headers - {'name','age','sex','position'};
%   name_of_field   - 'name' or 'position'
%
%   Example:
%     list_of_headers = {'name','age','sex','position'};
%     find_column_number(list_of_headers, 'age');
%     return value would 2 because 'age' is located at the second.

for i=1:length(list_of_headers)
    if strcmpi(list_of_headers{i},name_of_field),
        colnum = i;
        return
    end
end