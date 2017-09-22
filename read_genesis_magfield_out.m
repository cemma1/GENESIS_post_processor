function [fielddata]=read_genesis_magfield_out(filename,n1,n2,plotflag)

fidin2=fopen(filename,'r');

m=0;
fielddata=[];
while ~feof(fidin2)
   tline=fgetl(fidin2);
   m=m+1;
   if m>n1 & m<n2-1       
       fielddata=[fielddata;str2num(tline)];       
   end
   if m==n2-1
       break
   end
end
fclose(fidin2);

if plotflag==1
figure(1)
plot(fielddata(:,1),fielddata(:,2))
xlabel('z [m]','FontSize',16);ylabel('A_w (RMS), K_q [T/m]','FontSize',16);
hold on
plot(fielddata(:,1),fielddata(:,3),'r')
set(gca,'FontSize',14)
xlim([0,fielddata(end,1)])
%ylim([-max(fielddata(:,2)),max(fielddata(:,2))])
legend('A_w','K_q [T/m]')
end

