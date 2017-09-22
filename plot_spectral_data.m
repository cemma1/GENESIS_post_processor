% Plot spectral data
clear zlocations pulseenergy
c=3e8;q_e=1.6e-19;eps0=4*pi*1e-07;
kw=2*pi/xlamd;
m_e=9.1e-31;
hbar=6.582e-16;
fundpower=[];sidebandpower=[];
zlocations=linspace(magfielddata(2,1),magfielddata(end,1),40);
%zlocations = [magfielddata(2,1),magfielddata(end,1)]

zindices=round(zlocations/magfielddata(2,1));
gammar_sq=xlamd/(2*xlamds)*(1+magfielddata(20,2).^2);

if specifytimewindow
    poweramp=squeeze(M(:,indici.p_mid,imin:imax));
    ephase=squeeze(M(:,indici.phi_mid,imin:imax));
    powerfield=sqrt(poweramp).*exp(1i*ephase);
    [specvar,omegavar]=g3spectrum2(powerfield,xlamds,zsep);
end
   
  for n=1:length(zlocations)
      legendstring=['z = ',num2str(zlocations(n)),'m'];
      if ~specifytimewindow
      poweramp=squeeze(M(zindices(n),indici.p_mid,:));
      ephase=squeeze(M(zindices(n),indici.phi_mid,:));
      powerfield=sqrt(poweramp).*exp(1i*ephase);
      [specvar,omegavar]=g3spectrum2(powerfield,xlamds,zsep);
      end

   % Compute the synch freq. relative to the central freq
   %   synchflocation=xlamds/(2*pi*c)*sqrt(efieldaxis*q_e.*fielddata(:,2)*kw./(m_e*gammar_sq));
   % Compute the power in the sidebands and fundamental
 omegalimit=bandwidth;limitindex=omegavar>omegalimit & omegavar<-1*omegalimit;
 specvar(limitindex)=0;           
     
 specfiltered=specvar;specfiltered2=specvar;
 omegamax=1e-3; omegamin=-1e-3;

 sidebandindex=omegavar>omegamax & omegavar < omegamin;
 specfiltered(sidebandindex)=0;
 %sidebandindex=omegavar<omegamin; specfiltered(sidebandindex)=0;
 %  maxindex=omegavar>omegalimit; minindex=omegavar<-omegalimit;
 %  specfiltered2(maxindex)=0; specfiltered2(minindex);
 % Compute the fundamental & integrated sideband power 
 fundpower(n)=trapz(specfiltered)/trapz(specvar);
 sidebandpower(n)=(trapz(specvar)-trapz(specfiltered))/trapz(specvar);

tvector=[xlamds*zsep:xlamds*zsep:xlamds*zsep*size(M(:,:,imin:imax),3)];
 % Compute the pulse energy at each location

if isfield(indici,'power3')
pulseenergy(n)=trapz(tvector./c,squeeze(M(zindices(n),indici.power3,imin:imax)));
else
    pulseenergy(n)=trapz(tvector./c,squeeze(M(zindices(n),indici.power,imin:imax)));
end

figure(5)
subplot(2,2,1)
plot(tvector./c*1e15,squeeze(M(zindices(n),indici.power,imin:imax)))
if isfield(indici,'power3')
hold on
plot(tvector./c*1e15,squeeze(M(zindices(n),indici.power3,imin:imax))*100,'g')
hold off
legend('Fund','3rd harm *100')
end
xlabel('t [fs]','FontSize',14)
ylabel('Radiation Power [W]','FontSize',14)
xlim([0,tvector(end)./c*1e15])
drawnow
legend(legendstring); legend boxoff
subplot(2,2,2)
if specifytimewindow
plot((omegavar+1)*hbar*2*pi*c/xlamds./1e3,specvar(:,zindices(n)),'b');    
else
%plot((omegavar+1)*hbar*2*pi*c/xlamds./1e3,specvar,'b');    
semilogy((omegavar+1)*hbar*2*pi*c/xlamds./1e3,specvar,'b');    
end
    xlim(hbar*2*pi.*c./xlamds.*[-omegalimit+1,omegalimit+1]./1e3)
         xlabel('Photon Energy [keV]')
     ylabel('P (\omega) [arb. units]','FontSize',16)     
legend(sprintf(['FWHM [eV] = ',num2str(fwhm((omegavar+1)*hbar*2*pi*c/xlamds,specvar))]))
legend boxoff
fullwidth(n)=fwhm((omegavar+1)*hbar*2*pi*c/xlamds,specvar);

subplot(2,2,3)
plot(tvector./c*1e15,squeeze(M(zindices(n),indici.espread,imin:imax))*0.511,'r')
xlabel('t [fs]','FontSize',14)
ylabel('\sigma_\gamma [MeV]','FontSize',14)
xlim([0,tvector(end)./c*1e15])

subplot(2,2,4)
if isfield(indici,'p_mid3')
[specvar3,omegavar3]=g3spectrum2(sqrt(squeeze(M(zindices(n),indici.p_mid3,imin:imax))).*exp(1j*squeeze(M(zindices(n),indici.phi_mid3,imin:imax))),xlamds,zsep);
plot((omegavar3+1)*hbar*2*pi*c/xlamds*3./1e3,specvar3,'g');    
xlim(hbar*2*pi.*c./xlamds.*3.*[-(omegalimit)+1,(omegalimit+1)]./1e3)    
else
    [specvar3,omegavar3]=g3spectrum2(sqrt(squeeze(M(zindices(n),indici.p_mid,imin:imax))).*exp(1j*squeeze(M(zindices(n),indici.phi_mid,imin:imax))),xlamds,zsep);
plot((omegavar3+1)*hbar*2*pi*c/xlamds./1e3,specvar3,'g');
%semilogy((omegavar3+1)*hbar*2*pi*c/xlamds./1e3,specvar3,'g');
    xlim(hbar*2*pi.*c./xlamds.*3.*[-(omegalimit)+1,(omegalimit+1)]./1e3)    
% plot((omegavar+1)*hbar*2*pi*c/xlamds,specvar,'g');    
%     xlim(hbar*2*pi*c/xlamds*[-(omegalimit)+1,(omegalimit+1)])
     xlabel('Photon Energy [keV]')
     ylabel('P (\omega) [arb. units]','FontSize',16)
end
  end
%% Spectrum and pulse energy 
%save('poweramp','poweramp');save('ephase','ephase');
subplot(2,2,4)
%legend(sprintf(['<P>= ',num2str(mean(squeeze(M(end,indici.power,imin:imax)))./1e9),' GW']),'FontSize',12)
semilogy(zlocations,pulseenergy*1e6,'g')
xlim([0,zlocations(end)])
xlabel('z [m]','FontSize',14)
ylabel('Pulse Energy [uJ]','FontSize',14)
legend(sprintf(['E_{max}=',num2str(max(pulseenergy)*1e6),' uJ']))%,'location','SouthEast','FontSize',12)
legend boxoff
subplot(2,2,3)
hold on
plot(tvector./c*1e15,squeeze(M(zindices(1),indici.espread,imin:imax))*0.511,'k')
legend('Final Energy Spread','Initial Energy Spread','location','NorthEast')%,'FontSize',12);
legend boxoff
espread=squeeze(M(zindices(end),indici.espread,imin:imax))./squeeze(M(zindices(1),indici.espread,imin:imax));
espreadinitial=squeeze(M(zindices(1),indici.espread,imin:imax))*0.511;
psase=squeeze(M(zindices(end),indici.power,imin:imax))*1e-9;
%save('espread_relativerss','espread')
%save('psaserss','psase')
%save('tvectorrss','tvector')
% subplot(2,2,4)
% plot(magfielddata(:,1),magfielddata(:,2))
% xlabel('z [m]','FontSize',14)
% ylabel('a_w','FontSize',14)
% xlim([0,magfielddata(end,1)])
% ylim([min(magfielddata(:,2))*0.98,max(magfielddata(:,2))*1.02])
%figure(6)
%set(gca,'FontSize',14)
%plot(tvector./c*1e15,squeeze(M(1,1,:)));
%hold on
%xlabel('t [fs]')
%ylabel('Seed Power [W]')
%xlim([0,tvector(end)./c*1e15])
photonenergy=(omegavar+1)*hbar*2*pi*c/xlamds;
figure
plot(photonenergy,specvar,'b');
    %plot(omegavar,specvar)
    xlim(hbar*2*pi*c/xlamds*[-(omegalimit)+1,(omegalimit+1)])
    %hold on
    % semilogy(omegavar,specfiltered,'Color','r');
    set(gca,'FontSize',14)
    %ylim([-1e-2,1e-2])    
    %xlabel('\Delta \omega / \omega ','FontSize',16)
    xlabel('Photon Energy [eV]')
    ylabel('P (\omega) [arb. units]','FontSize',16)
    legend(sprintf(['FWHM = ',num2str(fwhm(photonenergy,specvar))]))
%
figure
plot(zlocations,fullwidth)
xlabel('z [m]')
ylabel('FWHM bandwidth [eV]')
xlim([0,zlocations(end)])
enhance_plot
%save('photonenergy','photonenergy');
%save('specvar','specvar');

%%%%%%%%% SIDEBAND PLOTS %%%%%%%%

% figure(5)
% plot(zlocations,fundpower,'r')
% hold on
% plot(zlocations,sidebandpower,'b')
% legend('Fundamental Power (Fractional)', 'Sideband Power','location','NorthWest')
% ylim([0,1]);
% set(gca,'FontSize',14)
% xlabel('z [m]','FontSize',16)
% ylabel('P/P_{total} [m]','FontSize',16)    
%    fwhm(tvector/(3e8),squeeze(M(end,1,:)))

