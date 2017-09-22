function [slicedata]=read_genesis_output_data(filename,nslice,nheader,nzstep)
fidin=fopen(filename,'r');

m=0;i=1;slicedata=cell(nslice,1);
[stat, n_l_s] = system(['grep -c ".$" ' filename]);
n_lines = str2double(n_l_s);
%h = waitbar(0,'Please wait...');
tread=tic;
while ~feof(fidin)        
        tline = fgetl(fidin);
        m=m+1;
           if m>nheader+(i-1)*(nzstep+1)+(i-1)*6 && m<nheader+(i)*(nzstep+1)+(i-1)*6
               slicedata{i}=[slicedata{i};str2num(tline)];
           end
             if m==nheader+(i)*(nzstep+1)+(i-1)*6
           i=i+1;
           %disp(i) % Displays slice number                      
             end
     %  if i==nslice+1
     %      break
     %  end
% disp([' Read percentage: ',num2str(m/n_lines * 100,'%.2g')]);        
end
telapsed=toc(tread);
disp('Read time [s] =');disp(telapsed);
fclose(fidin);