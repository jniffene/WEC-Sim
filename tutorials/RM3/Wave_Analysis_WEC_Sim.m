load ex_2_H3p6_T7.mat
TS=0; % Time shift
Excitation_Force=body1_out.signals.values(:,27);%-body2_out.signals.values(:,27);
t=body1_out.time;
% Excitation_Force=waves.waveAmpTime(:,2);
% t=waves.waveAmpTime(:,1);
irr.signals.values=Excitation_Force;
irr.time=t;
clear T_s T1_s pn_flag
l_Fe=length(Excitation_Force);
i_T=1;
for index=2:l_Fe
    if Excitation_Force(index)*Excitation_Force(index-1)<=0  %0-crossing detection
        if Excitation_Force(index)>Excitation_Force(index-1)
            pn_flag(i_T)=1; %Positive slope
        else
            pn_flag(i_T)=0; %Negative slope
        end
        T1_s(i_T)=t(index-1);
        if i_T>1
            T_s(i_T)=T1_s(i_T)-T1_s(i_T-1);
        else
            T_s(i_T)=0; 
        end
        i_T=i_T+1;
    end
end
if(find(T_s<0.005))>1
    error('Too small period');
end
T1_s=T1_s-TS;
