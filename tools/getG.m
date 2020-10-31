function G = getG(e)

% Unstack p  
e = reshape(e,[4,length(e)/4]);

[x nb] = size(e);

G = zeros(3*nb,4*nb);

row = 1;
col = 1;

for i = 1:nb
    e0 = e(1,i);
    e1 = e(2,i);
    e2 = e(3,i);
    e3 = e(4,i);
    
    G(row:row+2,col:col+3) = [
        -e1  e0  e3  -e2;
        -e2 -e3 e0  e1;
        -e3  e2 -e1  e0];
    row = row+3;
    col = col+4;
end
end