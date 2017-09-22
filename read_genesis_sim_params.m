function [n1,n2,xlamd,xlamds,zsep,nslice,indici]=read_genesis_sim_params(filename)

fidin=fopen(filename,'r');
n=0;
while ~feof(fidin)
tline = fgetl(fidin);
    n=n+1;    
            if findstr(tline,'xlamd =')              
            xlamd=str2num(tline(9:end));                       
            end
            
         if findstr(tline,'xlamds')
            k=findstr(tline,'='); 
            tline(k)=' ';
            k=findstr('D',tline);
                if ~isempty(k)
                        tline(k)='E';
                end
            xlamds=sscanf(tline(9:end),'%g');            
         end
              if findstr(tline,'zsep')                        
            k=findstr(tline,'='); 
            tline(k)=' ';
            k=findstr('D',tline);
                if ~isempty(k)
                        tline(k)='E';
                end
            zsep=sscanf(tline,'%*s%f');              
            end
    if numel(tline)>3 && tline(2)=='n' && tline(3)=='s' && tline(4)=='l'        
        nslice=sscanf(tline(9:end),'%g');        
    end
    
             if findstr(tline,'itdp')
            k=findstr(tline,'='); 
            tline(k)=' ';
            k=findstr('D',tline);
                if ~isempty(k)
                        tline(k)='E';
                end
            itdp=sscanf(tline,'%*s%f');            
            if itdp==0
                nslice=1;
            end
         end
    
    if numel(tline)>6 && tline(5)=='z' && tline(6)=='[' && tline(7)=='m'       
        n1 = n;

    end
    
    if numel(tline)>1 && tline(1)=='*' && tline(2)=='*' && tline(3)=='*' 
        n2 = n;
        %break
    end

        if numel(tline)>5 && tline(5)=='p' && tline(6)=='o' && tline(7)=='w' && tline(8)=='e'        
         lout=tline;
         %disp(lout) 
         break
     end
    
end

% Find the indices at which interesting quantities are stored
words=regexp(lout,'\w*');
indici.power=find(words==min(regexp(lout,'power')));
indici.p_mid=find(words==min(regexp(lout,'p_mid')));
indici.phi_mid=find(words==min(regexp(lout,'phi_mid')));
indici.bunching=find(words==min(regexp(lout,'bunching')));
%indici.bunching = 1;
indici.espread=find(words==min(regexp(lout,'e-spread')));
%indici.espread = 1;
indici.r_size=find(words==min(regexp(lout,'r_size')));
%indici.r_size =1;
if ~isempty(regexp(lout,'xrms'))
indici.sigx=find(words==min(regexp(lout,'xrms')));
indici.sigy=find(words==min(regexp(lout,'yrms')));
end
if ~isempty(regexp(lout,'3rd_bunchi'))
indici.bunching3=find(words==min(regexp(lout,'3rd_bunchi')))-2;
indici.power3=find(words==min(regexp(lout,'3rd_power')))-2;
indici.phi_mid3=find(words==min(regexp(lout,'3rd_phase')))-2;
indici.p_mid3=find(words==min(regexp(lout,'3rd_p-mid')))-2;
end

fclose(fidin);