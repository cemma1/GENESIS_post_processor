% GENESIS_TDP_Postprocessor.m
% Reads the GENESIS time dependent output file and plots the data
% Claudio Emma
% January 2016
% UCLA/SLAC
close all
tstart=tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User inputs the directory and the name of the GENESIS output file
prompt='Enter file name including path\n';
filename = input(prompt,'s');
% User control flags for plotting stuff and/or saving data
iplots=1;spectralplots=1;make_gif=0;savestuff=0;specifytimewindow=0;
tmin=2e-15;tmax=4e-15;% Ignore if specifytimewindow=0
%%%%%%%%%% USER SHOULD NOT TOUCH ANYTHING BELOW THIS LINE %%%%%%%%%%%%%%%
%% Extract Simulation input parameters
% First extract the number of z steps from the magnetic field output

[n1,n2,xlamd,xlamds,zsep,nslice,indici]=read_genesis_sim_params(filename);
% % Now load the magnetic field data
[magfielddata]=read_genesis_magfield_out(filename,n1,n2,1);
%Extract correct number of z steps
nzstep=size(magfielddata,1);
nheader=n2+5;
%% Importing time dependent data
[slicedata]=read_genesis_output_data(filename,nslice,nheader,nzstep);
%% Calculating average values over s
if nslice>1
M = cat(3,slicedata{:});        %# Convert to a (dim+1)-dimensional matrix (dim+1=3)
if specifytimewindow
disp(sprintf(['TIME WINDOW is\n ',num2str(tmin),'< t <',num2str(tmax)]));imin=round(tmin/(zsep*xlamds)*3e8);imax=round(tmax/(zsep*xlamds)*3e8);
else
    imin=1;imax=size(M,3);
end
meanArray = mean(M(:,:,imin:imax),ndims(slicedata)+1);          % Compute the mean across arrays
else    
    M = cat(3,slicedata{:});        
    meanArray = mean(M,3);  spectralplots=0;
end
%% Plot average values
if iplots         
     plot_average_data
end
%% Spectral Plotting 
    if spectralplots
    bandwidth=10e-3;        
    plot_spectral_data
    end
%% Make gif and save stuff
if make_gif
    plot_to_gif_fctn(M(:,:,imin:imax),magfielddata,xlamd,xlamds,zsep,filename)
end

if savestuff
    Save_Sim_output
end
%% Display script run time
telapsed=toc(tstart)/60;
disp('Script Run time [min] =');disp(telapsed);
