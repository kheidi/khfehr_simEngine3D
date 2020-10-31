classdef buildCons
    methods(Static)
        function phi_q = buildPhi_q(varargin)
            phiPair = varargin;
             count = 1;
            for i = 1:length(phiPair)
                impPhi_q = phiPair{1,i}.phi_q;
                [row col] = size(impPhi_q);
                if row == 6 % is ground
                    chunk{count} = impPhi_q;
                    count = count + 1;
                elseif row == 12 % does not have ground
                    chunk{count} = impPhi_q(1:2:end,:);
                    count = count + 1;
                    chunk{count} = impPhi_q(2:2:end,:);
                    count = count + 1;
                else
                    error('Something is funky with your phi_q')
                end
            end
            
            phi_q = cell2mat(chunk.');
               
        end
    end
end
