function a = vecangle360(u,v)
a=atan2d(norm(cross(u,v)),dot(u,v));
end

% by James Tursa: 
% https://www.mathworks.com/matlabcentral/answers/101590-how-can-i-determine-the-angle-between-two-vectors-in-matlab
