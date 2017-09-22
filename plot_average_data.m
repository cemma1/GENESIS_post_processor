% Plot Average Data from GENESIS output file

maxpowstring=['P_{max} [GW]=',num2str(meanArray(end,1)/1e9)];
efieldaxis=sqrt(376.73*meanArray(:,indici.power)./(2*pi*meanArray(:,indici.r_size).^2));

    q_e=1.6e-19;c=3e8;kw=2*pi/xlamd;m_e=9.1e-31;
    gammar_sq=xlamd/(2*xlamds)*(1+magfielddata(:,2).^2);
    
   if nslice>1 
       if specifytimewindow
    powvector=squeeze(M(:,1,imin:imax));
       else
           powvector=squeeze(M(:,1,:));
       end
for i=1:size(powvector,1)
stdpower(i)=std(powvector(i,:));              %Compute the std of power
end
   else
       stdpower=zeros(1,length(meanArray(:,indici.power)));
   end
    %% Plots with 3rd harm
if isfield(indici,'power3')
    figure(2)
subplot(1,3,1)
plot(magfielddata(:,1),meanArray(:,indici.power)*1e-9);
hold on
plot(magfielddata(:,1),meanArray(:,indici.power3)*1e-9,'r');
xlim([0,magfielddata(end,1)])
%ylim([meanArray(10,indici.power),max(meanArray(:,indici.power))].*1e-9)
xlabel('z [m]')
ylabel('Radiation Power [GW]')
legend('Fundamental','3rd harmonic','location','NorthWest')
enhance_plot%('Times',16)
subplot(1,3,2)
plot(magfielddata(:,1),meanArray(:,indici.bunching));
if isfield(indici,'bunching3')
hold on
plot(magfielddata(:,1),meanArray(:,indici.bunching3),'r');
end
xlim([0,magfielddata(end,1)])
xlabel('z [m]')
ylabel('Bunching Factor')
enhance_plot%('Times',16)
%efieldaxis=sqrt(376*meanArray(:,1)./(pi*meanArray(:,5).^2));
subplot(1,3,3)
 %plot(omegavar,smooth(specvar),'k')
 [specvar,omegavar]=g3spectrum2(squeeze(sqrt(M(end,indici.p_mid,:))).*exp(1i*squeeze(M(end,indici.phi_mid,:))),xlamds,zsep);
 plot(omegavar,specvar,'b')
 if isfield(indici,'p_mid3')
 [specvar3,omegavar3]=g3spectrum2(squeeze(sqrt(M(end,indici.p_mid3,:))).*exp(1i*squeeze(M(end,indici.phi_mid3,:))),xlamds,zsep);
plot(omegavar3,specvar3*100,'r')
legend('3rd harm. *100','Fund'); legend boxoff
 end
    xlim([-15e-3,15e-3])
    set(gca,'FontSize',16)
    xlabel('\Delta \omega / \omega ','FontSize',16)
    ylabel('P (\omega) [arb. units]','FontSize',16)
    end
    %% Fundamental power plots
    figure(3)
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);    
    subplot(3,2,1)    
    semilogy(magfielddata(:,1),meanArray(:,indici.power))
    %plot(magfielddata(:,1),meanArray(:,indici.power))
    axis([0,magfielddata(end,1),meanArray(2,1),max(meanArray(:,1))*2])      
    enhance_plot
    xlabel('z [m]')
    ylabel('<P(s)> [W]') 
    legend(maxpowstring,'location','NorthWest')
    
    subplot(3,2,2)    
    plot(magfielddata(:,1),meanArray(:,indici.bunching))
    xlim([0,magfielddata(end,1)])
    xlabel('z [m]')
    ylabel('Bunching Factor')
    enhance_plot
     subplot(3,2,4)
     plot(magfielddata(:,1),efieldaxis)
     xlim([0,magfielddata(end,1)])
     xlabel('z [m]')
     ylabel('Electric Field [V/m]')
     enhance_plot
%     subplot(3,2,5)    
%     plot(magfielddata(:,1),meanArray(:,indici.power))
%     hold on
%     plot(magfielddata(:,1),meanArray(:,indici.power)+stdpower.','--r')
%     hold on
%     plot(magfielddata(:,1),meanArray(:,indici.power)-stdpower.','--r')
%     xlim([0,magfielddata(end,1)])
%     enhance_plot
%     xlabel('z [m]')
%     ylabel('<P(s)> [W]')
    
%     subplot(3,2,4)
%     plot(fielddata(:,1),sqrt(xlamd/(2*xlamds).*(1+fielddata(:,2).^2)));
%      xlim([0,fielddata(end,1)])
%      ylim([1.8,2.3])
%      xlabel('z [m]','FontSize',12)
%      ylabel('\gamma_r(z) *10^4','FontSize',12)
if isfield(indici,'sigx')
subplot(3,2,5)    
     plot(magfielddata(:,1),meanArray(:,indici.sigx)*1e6,'r')
     hold on
     plot(magfielddata(:,1),meanArray(:,indici.sigy)*1e6,'g')
     xlim([0,magfielddata(end,1)])
     xlabel('z [m]','FontSize',12)
     ylabel('\sigma_{x} & \sigma_y [\mu m]')
     enhance_plot
else
       subplot(3,2,5)
%    semilogy(magfielddata(:,1),sqrt(efieldaxis*q_e.*magfielddata(:,2).*kw./(m_e.*gammar_sq))./c) 
%    xlim([0,magfielddata(end,1)])
%    xlabel('z [m]','FontSize',12)
%    ylabel('\lambda_{synch} [m] ','FontSize',12)
%    enhance_plot
end
  subplot(3,2,3)
  
const_resp=(0.511e6)*(xlamd/2/xlamds);
% IF PLANAR: const_resp=(0.511e6)/4*(xlamd/2/xlamds);
Kz=magfielddata(:,2);
dz=magfielddata(2,1);
dKdz=zeros(length(magfielddata),1);
dKdz(2:end)=abs(diff(Kz)./dz);
sinpsir=const_resp.*(dKdz./abs(efieldaxis));
psir=zeros(length(magfielddata),1);
psir=asin(sinpsir);
ind=magfielddata(:,2)>0 & sinpsir<1;
%ind=sinpsir<1;

   plot(magfielddata(ind,1),psir(ind,:)*180/pi) 
   %plot(magfielddata(:,1),psir) 
   xlim([0,magfielddata(end,1)])
   xlabel('z [m]');ylabel('Resonant Phase [degree] ');   
   %set(gca,'FontName','Times','FontSize',16)
   enhance_plot('Times',16)
   legend('For helical undulator only','location','NorthWest'); legend boxoff
   
% plot(magfielddata(:,1),meanArray(:,indici.espread)*0.511);
%      xlim([0,magfielddata(end,1)])
%      %ylim([1.8,2.3])
%      xlabel('z [m]')
%      ylabel('\sigma_E [MeV]')
%      enhance_plot
     subplot(3,2,6)
plot(magfielddata(:,1),meanArray(:,indici.r_size));
% hold on
%  plot(magfielddata(:,1),meanArray(:,8),'r');
     xlim([0,magfielddata(end,1)])
     %ylim([1.8,2.3])
 %    legend('\sigma_y','\sigma_x')
     xlabel('z [m]')
    % ylabel('\sigma_x,\sigma_y','FontSize',12)
     ylabel('\sigma_r [m]')
     enhance_plot
