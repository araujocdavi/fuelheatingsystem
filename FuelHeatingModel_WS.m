%% Parametrização

% Definição dos Setpoints de Temperatura
Setpoint_ColdStart = 120;
Setpoint_PostStart = 90;

% Parâmetros de projeto para definição da planta de controle
h = 12000;        % Coeficiente de convecção forçada metal-líquido [W/m2.°C]
A = 0.0003*4;     % Área de superfície do Glow Plug [m^2]
m = (0.4*0.79);   % Capacidade de acúmulo de combustível no common rail [Kg]
EngineTemp = 90;  % Temperatura ideal do líquido de arrefecimento do motor [°C]

% Curva de pressão de vapor do Etanol
Temp_Ethanol = 0:6:120; % [°C]
P_min = 0.22^(1/1.6);
P_max = 1.95^(1/2.28);
Pressure_Ethanol = (P_min:((P_max-P_min)/20):P_max).^4.92; % [bar]

% Parâmetros do Glow Plug
PWM = 0:5:100;
Ts_min = 0^(1/0.7); % Delta de temperatura relativa à ambiente
Ts_max = 475^(1/0.7); % Delta de temperatura relativa à ambiente
Ts = (Ts_min:((Ts_max-Ts_min)/20):Ts_max).^0.7;
Power = 0:20:400;

% Parâmetros de Baterias (Veículo MildHybrid)
Voltage_LeadAcid = 12; 
AmpHour_LeadAcid = 50;
LeadAcid_TotalEnergy = Voltage_LeadAcid*AmpHour_LeadAcid; % Energia total da bateria [Wh]
Lead_MaxTemp = 80;
Voltage_Lithium = 48;
AmpHour_Lithium = 16;
Lithium_TotalEnergy = Voltage_Lithium*AmpHour_Lithium; % Energia total da bateria [Wh]
Lithium_MaxTemp = 80;

% Dados para cálculo do aquecimento de combustível após partida do motor
Fluxo_Injetor = 2.141967;
RPM_Motor = 1000; % Rotações por minuto
Calib_Injecao_OL = [5.003 2.66 2.407 2.76 2.606 2.826 3.607 3.601;900 1500 1800 2000 2200 2500 2700 3200];
Densidade_Combustivel = 0.774; % mg/mm³
VolumeInterno_CommonRail = 7000; % mm³

%% Plotagem de gráficos

figure(1)
plot(PWM,Ts,'-r*','LineWidth',1)
grid on
title('Curva de temperatura para a superfície do Glow Plug')
xlabel('PWM Duty Cycle (%)')
ylabel('Temperatura do Glow Plug relativa à temperatura ambiente (°C)')

figure(2)
subplot(1,2,1)
plot(out.PercentualEtanol_p,'-r','LineWidth',1)
grid on
title('Condições de Entrada do Sistema')
xlabel('Tempo de simulação (cs)')
hold on
plot(out.TemperaturaInicial_T,'-b','LineWidth',1)
hold on
plot(out.TemperaturaAmbiente_T,'-g','LineWidth',1)
legend('Percentual de Etanol (%)','Temperatura Inicial (°C)','Temperatura Ambiente (°C)')
hold off

subplot(1,2,2)
plot(out.ChaveDetectada_b,'-r','LineWidth',2)
grid on
title('Condições Booleanas de Ativação do Sistema')
xlabel('Tempo de simulação (cs)')
ylabel('Estado Booleano')
hold on
plot(out.BotaoStartStop_b,'-b','LineWidth',2)
hold on
plot(out.StatusAquecimento_b,'-g','LineWidth',1)
legend('ChaveDetectada_b','BotaoStartStop_b','StatusAquecimento_b')
hold off

figure(3)
subplot(2,2,1)
plot(out.StatusAquecimento_b,'-r','LineWidth',1)
grid on
title('Status de Aquecimento')
xlabel('Tempo de simulação (cs)')

subplot(2,2,2)
plot(out.PWMDutyCyclePre_p,'-b','LineWidth',1)
hold on
plot(out.PWMDutyCyclePos_p,'-g','LineWidth',1)
grid on
title('Modulação do PWM')
xlabel('Tempo de simulação (cs)')
ylabel('Porcentagem de potência aplicada (%)')
legend('PWM Duty Cycle Pré-Partida (%)','PWM Duty Cycle Pós-Partida (%)')
hold off

subplot(2,2,3)
plot(out.FullPWM,'-r','LineWidth',1)
hold on
plot(out.ModPWM,'-g','LineWidth',1)
hold on
plot(out.TotalPWM,'-b','LineWidth',1)
grid on
title('Contadores de Limitação do Sistema')
xlabel('Tempo de simulação (cs)')
ylabel('Contador (s)')
legend('Full PWM','Modulação de PWM','Tempo total de PWM')
hold off

subplot(2,2,4)
plot(out.LimiteTimerPWM_b,'-r','LineWidth',2)
grid on
title('Limite do contador de PWM aplicado')
xlabel('Tempo de simulação (cs)')
legend('Limite do contador')


figure(4)
subplot(2,2,1)
plot(out.StatusAquecimento_b,'-r','LineWidth',2)
hold on
plot(out.DriveReady,'-b','LineWidth',2)
hold on
grid on
title('Status de Aquecimento')
xlabel('Tempo de simulação (cs)')
legend('Status do Aquecimento de Combustível','Flag para Partida Autorizada ou Motor Ligado')
hold off

subplot(2,2,2)
plot(out.PWMDutyCyclePre_p,'-b','LineWidth',1)
hold on
plot(out.PWMDutyCyclePos_p,'-g','LineWidth',1)
grid on
title('Modulação do PWM')
xlabel('Tempo de simulação (cs)')
ylabel('Porcentagem de potência aplicada (%)')
legend('PWM Duty Cycle Pré-Partida (%)','PWM Duty Cycle Pós-Partida (%)')
hold off

subplot(2,2,3)
plot(out.BateriaLitioCarga_p,'-c','LineWidth',1.5)
hold on
plot(out.BateriaChumboCarga_p,'-m','LineWidth',1.5)
hold on
grid on
title('Gerenciamento de Carga das Baterias')
xlabel('Tempo de simulação (cs)')
ylabel('Carga (%)')
legend('Carga da Bateria de Lítio (%)','Carga da Bateria de Chumbo (%)')
hold off

subplot(2,2,4)
plot(out.BateriaLitioTemperatura_T,'-c','LineWidth',1.5)
hold on
plot(out.BateriaChumboTemperatura_T,'-m','LineWidth',1.5)
grid on
title('Gerenciamento Térmico das Baterias')
xlabel('Tempo de simulação (cs)')
ylabel('Temperatura (°C)')
legend('Temperatura da Bateria de Lítio (°C)','Temperatura da Bateria de Chumbo (°C)')
hold off


figure(5)
plot(out.PWMDutyCyclePre_p,'-b','LineWidth',1)
hold on
plot(out.PWMDutyCyclePos_p,'-g','LineWidth',1)
grid on
title('Modulação do PWM')
xlabel('Tempo de simulação (cs)')
ylabel('Porcentagem de potência aplicada (%)')
legend('PWM Duty Cycle Pré-Partida (%)','PWM Duty Cycle Pós-Partida (%)')
hold off

figure(6)
plot(out.Temp_Sup_PreP,'-r','LineWidth',1)
hold on
plot(out.Temp_Sup_PosP,'-b','LineWidth',1)
grid on
title('Temperatura de Superfície do Glow Plug')
xlabel('Tempo de simulação (s)')
ylabel('Temperatura de Superfície (°C)')
legend('Temperatura de Superfície Pré-Partida (°C)','Temperatura de Superfície Pós-Partida (°C)')
hold off

figure(7)
subplot(2,2,1)
plot(out.StatusAquecimento_b,'-r','LineWidth',2)
hold on
plot(out.DriveReady,'-b','LineWidth',2)
hold on
grid on
title('Status de Aquecimento')
xlabel('Tempo de simulação (cs)')
legend('Status do Aquecimento de Combustível','Flag para Partida Autorizada ou Motor Ligado')
hold off

subplot(2,2,2)
plot(out.PWMDutyCyclePre_p,'-b','LineWidth',1.5)
hold on
plot(out.PWMDutyCyclePos_p,'-g','LineWidth',1.5)
grid on
title('Modulação do PWM')
xlabel('Tempo de simulação (cs)')
ylabel('Porcentagem de potência aplicada (%)')
legend('PWM Duty Cycle Pré-Partida (%)','PWM Duty Cycle Pós-Partida (%)')
hold off

subplot(2,2,3)
plot(out.TemperaturaUnificada_T,'-m','LineWidth',1.8)
hold on
plot(out.SetpointTemperatura_T,'-c','LineWidth',1.8)
grid on
title('Temperatura de Combustível e Definição do Setpoint')
xlabel('Tempo de simulação (cs)')
ylabel('Temperatura (°C)')
legend('Temperatura do Combustível (°C)','Setpoint de Temperatura (°C)')
hold off

subplot(2,2,4)
plot(out.Temp_Sup_PreP,'-y','LineWidth',1.5)
hold on
plot(out.Temp_Sup_PosP,'-k','LineWidth',1.5)
grid on
title('Temperatura de Superfície do Glow Plug')
xlabel('Tempo de simulação (s)')
ylabel('Temperatura de Superfície (°C)')
legend('Temperatura de Superfície Pré-Partida (°C)','Temperatura de Superfície Pós-Partida (°C)')
hold off