%% Generate random transformation matrix
%  Generate random rigid transformation matrix
%
%  Inputs:
%  - theta_max: maximum rotation angle
%  - t_max: maximum translation value
%
%  Outputs:
%   - randtransmat: random transformation matrix
%
% (c) Jose Bernal and Michael J. Thrippleton 2020

function randtransmat = generateRandomTransformation(theta_max, t_max)
    thetax = deg2rad(unifrnd(-theta_max, theta_max));
    thetay = deg2rad(unifrnd(-theta_max, theta_max));
    thetaz = deg2rad(unifrnd(-theta_max, theta_max));
    tx = unifrnd(-t_max, t_max);
    ty = unifrnd(-t_max, t_max);
    tz = unifrnd(-t_max, t_max);
    
    randtransmat = eye(4, 4);
    randtransmat(1:3,1:3) = eul2rotm([thetaz, thetay, thetax]);
    randtransmat(4, 1:3) = [tx, ty, tz];
    
    randtransmat = affine3d(randtransmat);
end