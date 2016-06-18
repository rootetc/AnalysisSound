<<<<<<< HEAD
classdef queue < handle
    properties (SetAccess = public)
        elements=[];
        head=[];
        result=[];
        length=0;
    end
    methods
        function obj = queue(l)
            obj.head = 0;
            obj.elements = zeros(l,3);
            obj.result = zeros(3,1);
            obj.length = size(obj.elements,1);
        end
        function push(obj, key, id, index)
            if obj.head <= obj.length
                obj.head = obj.head + 1;
                obj.elements(obj.head,:) = [key id index];
                i = obj.head;
                while i > 1
                    if obj.elements(i,2) < obj.elements(floor(i/2),2)
                        tmp = obj.elements(floor(i/2),:);
                        obj.elements(floor(i/2),:) = obj.elements(i,:);
                        obj.elements(i,:) = tmp;
                        i=floor(i/2);
                    else
                        break;
                    end
                end
            end
        end     
        function pv = pop(obj)
            if obj.head >= 1
                pv = obj.elements(1,:);
                obj.elements(1, :) = obj.elements(obj.head, :);
                obj.elements(obj.head,:) = [inf inf inf];
                obj.head = obj.head - 1;
                i = 1;
                while( 2 * i <= obj.head )
                    if obj.elements(i,2) < obj.elements(2*i,2) && obj.elements(i,2) < obj.elements(2 * i + 1 ,2)
                        break;
                    elseif obj.elements(2 * i ,2) < obj.elements(2 * i + 1 ,2)
                        tmp = obj.elements( 2 * i,:);
                        obj.elements(2*i,:) = obj.elements(i,:);
                        obj.elements(i,:) = tmp;
                        i = 2 * i;
                    else
                        tmp = obj.elements(2*i+1,:);
                        obj.elements(2 * i + 1,:) = obj.elements(i,:);
                        obj.elements(i,:) = tmp;
                        i = 2 * i + 1;
                    end
                end
            end
        end
    end
=======
classdef queue < handle
    properties (SetAccess = public)
        elements=[];
        head=[];
        result=[];
        length=0;
    end
    methods
        function obj = queue(l)
            obj.head = 0;
            obj.elements = zeros(l,3);
            obj.result = zeros(3,1);
            obj.length = size(obj.elements,1);
        end
        function push(obj, key, id, index)
            if obj.head <= obj.length
                obj.head = obj.head + 1;
                obj.elements(obj.head,:) = [key id index];
                i = obj.head;
                while i > 1
                    if obj.elements(i,2) < obj.elements(floor(i/2),2)
                        tmp = obj.elements(floor(i/2),:);
                        obj.elements(floor(i/2),:) = obj.elements(i,:);
                        obj.elements(i,:) = tmp;
                        i=floor(i/2);
                    else
                        break;
                    end
                end
            end
        end     
        function pv = pop(obj)
            if obj.head >= 1
                pv = obj.elements(1,:);
                obj.elements(1, :) = obj.elements(obj.head, :);
                obj.elements(obj.head,:) = [inf inf inf];
                obj.head = obj.head - 1;
                i = 1;
                while( 2 * i <= obj.head )
                    if obj.elements(i,2) < obj.elements(2*i,2) && obj.elements(i,2) < obj.elements(2 * i + 1 ,2)
                        break;
                    elseif obj.elements(2 * i ,2) < obj.elements(2 * i + 1 ,2)
                        tmp = obj.elements( 2 * i,:);
                        obj.elements(2*i,:) = obj.elements(i,:);
                        obj.elements(i,:) = tmp;
                        i = 2 * i;
                    else
                        tmp = obj.elements(2*i+1,:);
                        obj.elements(2 * i + 1,:) = obj.elements(i,:);
                        obj.elements(i,:) = tmp;
                        i = 2 * i + 1;
                    end
                end
            end
        end
    end
>>>>>>> d2a4927c51aa93dd8032ac2b4abdb6ef701b7689
end