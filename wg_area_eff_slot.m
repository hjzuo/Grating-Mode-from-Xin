function    [Aeff_wall, Aeff_slot, Ic,Power_upper_clad,Power_waveguide_wall, Power_waveguide_slot,Power_lower_clad] = wg_area_eff_slot(Hxc,Hyc,Hzc,Exc,Eyc,Ezc,n,dx,dy,eps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Intensity : I = 1/4(E x H* + E* x H) = 1/4 (ExHy*-EyHx* +Ex*Hy-Ey*Hx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=1;

Ic = 1/4*(Exc .* conj(Hyc) - Eyc.*conj(Hxc) + conj(Exc) .* Hyc - conj(Eyc).*Hxc);

% I_real = real(Exc.*conj(Hyc)-Eyc.*conj(Hxc));



% E_abs = sqrt(abs(Exc).^2 + abs(Eyc).^2+abs(Ezc).^2);

% E_abs = sqrt(abs(Exc).^2 + abs(Eyc).^2);

Ih = max(abs(Ic(:)));

nlayer   = length(n);

[nx,ny]  = size(Ic);

if isscalar(dx)
  
    dx = dx*ones(nx,1);             % uniform grid

else

   dx = dx;                       % convert to column vector

end

if isscalar(dy)
  
    dy = dy*ones(1,ny);             % uniform grid

else

   dy = dy;                       % convert to column vector

end

Idx      = dx * ones(1,ny);

Idy      = ones(nx,1)* dy;

Ids      = Idx.*Idy;

In1      = find(eps(:) == n(1)^2);         % substrate;

In2      = find(eps(:) == n(2)^2);         % Wall Material

In3      = find(eps(:) == n(4)^2 );        % Slot Material

In5      = find(eps(:) == n(nlayer)^2 );   % Upper cladding

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Mode field area Aeff=(int(abs(A)^2)dxdy)^2/(int abs(A)^4 dxdy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Aeff_wall          = (sum(Ic(:).*Ids(:)))^2 / sum(Ic(In2).^2.*Ids(In2));

Aeff_slot          = (sum(Ic(:).*Ids(:)))^2 / sum(Ic(In3).^2.*Ids(In3));


% Aeff_test         = abs(sum(I_real(:).*Ids(:)))^2 / sum(E_abs(In2).^4.*Ids(In2))/n(nlayer-1)^2;

Power_all          = sum(Ic(:).*Ids(:));

Power_upper_clad   = sum(Ic(In5).*Ids(In5))/Power_all;

Power_waveguide_wall    = sum(Ic(In2).*Ids(In2))/Power_all;

Power_waveguide_slot    = sum(Ic(In3).*Ids(In3))/Power_all;

Power_lower_clad   = sum(Ic(In1).*Ids(In1))/Power_all;

% a =0.1;









