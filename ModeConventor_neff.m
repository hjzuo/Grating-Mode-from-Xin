function [neff_TE,neff_TM]=ModeConventor_neff(nmodes,post)
% This example computes all of the field components of a
% Ridge waveguide
% %         ^        coat (n3)
% %         |
% %         | h3
% %         ^         -------------       ^
% %         |         |           |       |  rh 
% %         h2        |           |       |
% %         |   -------            ---------
% %         |         core film (n2)
% %         -   ----------------------------
% %         ^
% %         |
% %         h1
% %         |          sub (n1)
% %         |
% %         -   ------------------------------
% % 
% clear all;
% close all
% % starttime=datestr(now)
starttime=clock;
timestamp=datestr(now, 30);

%%  struture definition
dx0=25;                 %Grid size nm
dy0=25;                %grid size nm
side = 4000;            % space on side of waveguide (nm) matters
h1 = 2000;              % buffer thickness(nm)
h3 = 3000;              % coating  thickess - cladding (nm)

post_offset=post.offset;
post_h=post.h;
post_w=post.w;
post_n=post.n;

%  fprintf('calculating struture with post.h= %7.5f nm',post.h);
%  
 
lambda=1550;      % Wavelength range
n1=1.444*ones(1,length(lambda));%lower cladding
n3=1.444*ones(1,length(lambda));%upper cladding
n2=1.484*ones(1,length(lambda));%core
w_array=4000;         % waveguide width array
h2_array=4000;         % film thickness 
rh_por_array=1;       % etch depth portion to thickness (move in side film thickness)
% % -------------------------------------

iw_length=length(w_array);
il_length=length(lambda);
ih2_length=length(h2_array);
irh_length=length(rh_por_array);



%% START THE LOOP TO CALCULATE neff FOR DIFFERENT WAVELENGTH, RIDGE AND WIDTH
     
effectiveIndex = zeros(length(post_offset), nmodes);


    w=w_array;
    h2=h2_array;
    rh=floor(h2*rh_por_array);
    
ii=find(lambda==1550);

            dx = dy0;             % grid size (x)
            dy = dx0;             % grid size (y) 
    %         fprintf (1,'generating index mesh...\n');

    [x,y,xc,yc,nx,ny,eps] = ModeConventor_mesh([n1(ii),n2(ii),n3(ii)],[h1,h2,h3],...
        rh,w/2,side,dx,dy,post_offset,post_h,post_w,post_n);
    %             waveguidemeshfull([n1(ii),n2(ii),n3(ii)],[h1,h2,h3],rh,w/2,side,dx,dy);
    
    
    % % % Now we stretch out the mesh at the boundaries: N S E W
    [x,y,xc,yc,dx,dy] = stretch(x,y,[20,20,40,40],[1.5,1.5,1.5,1.5]);
    %         fprintf (1,'solving for eigenmodes...'); t = cputime;
    
    [Hx,Hy,neff] = wgmodes (lambda(ii), n2(ii), nmodes, dx, dy, eps, '0000');
    
    
    
    
    
    
    Hxc_TE     = [];
    
    Hyc_TE     = [];
    
    Hzc_TE     = [];
    
    Ezc_TE     = [];
    
    Exc_TE     = [];
    
    Eyc_TE     = [];
    
    Ic_TE      = [];
    
    Aeff_TE    = [];
    
    P_upper_TE = [];
    
    P_wg_TE    = [];
    
    P_lower_TE = [];
    
    
    Hxc_TM     = [];
    
    Hyc_TM     = [];
    
    Hzc_TM     = [];
    
    Ezc_TM     = [];
    
    Exc_TM     = [];
    
    Eyc_TM     = [];
    
    Ic_TM      = [];
    
    Aeff_TM    = [];
    
    P_upper_TM = [];
    
    P_wg_TM    = [];
    
    P_lower_TM = [];
    
    TM_n = 0;
    
    TE_n = 0;
    
% for k=1:nmodes    
%     
    
%     [Hxc_t,Hyc_t,Hzc_t,Exc_t,Eyc_t,Ezc_t] = postprocess...
%         (lambda, neff(k), Hx(:,:,k), Hy(:,:,k), dx, dy, eps, '0000');

%     
%     [Aeff_t, Ic_t,P_upper_t,P_wg_t,P_lower_t] = ModeConventor_area_eff...
%         (Hxc_t,Hyc_t,Hzc_t,Exc_t,Eyc_t,Ezc_t,[n1,n2,n3,post_n],dx,dy,eps);

        [neff_TE,neff_TM]=image_all_fields(nmodes, lambda, neff, Hx, Hy, dx, dy, eps,[n1,n2,n3],xc,yc,x,y);

%     
%     k
%     hn1 = max(abs(Hyc_t(:)))
%     
%     hn2 = max(abs(Hxc_t(:)))
%     
%     
%     if hn1>hn2
%         
%         hn = hn1;
%         
%         mode = 'TE';
%         
%         TE_n = TE_n +1;
%         
%         tt = TE_n;
%         
%         Hxc_TE     = [Hxc_TE, Hxc_t];
%         
%         Hyc_TE     = [Hyc_TE, Hyc_t];
%         
%         Hzc_TE     = [Hzc_TE, Hzc_t];
%         
%         Ezc_TE     = [Ezc_TE, Ezc_t];
%         
%         Exc_TE     = [Exc_TE, Exc_t];
%         
%         Eyc_TE     = [Eyc_TE, Eyc_t];
%         
%         Ic_TE      = [Ic_TE, Ic_t];
%         
%         Aeff_TE    = [Aeff_TE, Aeff_t];
%         
%         P_upper_TE = [P_upper_TE, P_upper_t];
%         
%         P_wg_TE    = [P_wg_TE, P_wg_t];
%         
%         P_lower_TE = [P_lower_TE,P_lower_t];
%         
%     else
%         
%         hn = hn2;
%         
%         mode = 'TM';
%         
%         TM_n = TM_n +1;
%         
%         tt = TM_n;
%         Hxc_TM     = [Hxc_TM, Hxc_t];
%         
%         Hyc_TM     = [Hyc_TM, Hyc_t];
%         
%         Hzc_TM     = [Hzc_TM, Hzc_t];
%         
%         Ezc_TM     = [Ezc_TM, Ezc_t];
%         
%         Exc_TM     = [Exc_TM, Exc_t];
%         
%         Eyc_TM     = [Eyc_TM, Eyc_t];
%         
%         Ic_TM      = [Ic_TM, Ic_t];
%         
%         Aeff_TM    = [Aeff_TM, Aeff_t];
%         
%         P_upper_TM = [P_upper_TM, P_upper_t];
%         
%         P_wg_TM    = [P_wg_TM, P_wg_t];
%         
%         P_lower_TM = [P_lower_TM,P_lower_t];
%     end
% 
%     en = hn/n2;
%     
%     fprintf(1,'mode number: %d,neff (%c%c%d mode)= %7.5f\n',k,mode,tt,neff(k));
%     colormap(jet(256));
% 
%     Ih = max(abs(Ic_t(:)));
%     figure(k)
%     subplot(3,1,1)
%     colormap(jet(256));
%     image_mode(xc,yc,Exc_t/en,sprintf('mode number: %d,Ex (%c%c%d mode)',k,mode,tt));
%     hold on;
%     con_mode(xc,yc,Hxc_t/en,1,3,55,sprintf('mode number: %d,Ex (%c%c%d mode)',k,mode,tt));
%     hold off;
%     
%     
%     subplot(3,1,2)
%     colormap(jet(256));
%     image_mode(xc,yc,Eyc_t/en,sprintf('mode number: %d,Ey (%c%c%d mode)',k,mode,tt));
%     hold on;
%     con_mode(xc,yc,Hyc_t/en,1,3,55,sprintf('mode number: %d,Ey (%c%c%d mode)',k,mode,tt));
%     hold off;
%     
%     subplot(3,1,3)
%     colormap(jet(256));
%     Ih = max(abs(Ic_t(:)));
%     image_mode(xc,yc,Ic_t/Ih,sprintf('mode number: %d,Intensity (%c%c%d mode)',k,mode,tt));
%     hold on;
%     con_mode(xc,yc,Ic_t/Ih,1,3,55,sprintf('mode number: %d,Intensity (%c%c%d mode)',k,mode,tt));
%     hold off;
% 
% 
% end
%%  analysis the result
% ModeConventor_eps_plot