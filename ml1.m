function SimulatedAnnealing()
    nCities = 100;
    initialTemperature = 100;
    endTemperature = 0;
    
    cities = rand(nCities, 2)*10;
    figure
    plot(cities(:,1),cities(:,2),"b--o" ); 
    title('Initial route')
    
    state = OptimiseRoute(cities, initialTemperature, endTemperature); 
    
    figure
    plot(cities(state,1),cities(state,2),"r--o"); 
    title('Optimized route')
end
function [ state ] = OptimiseRoute(cities, initialTemperature, endTemperature)
    nCities = size(cities,1);
    state = [1:nCities]'; 
    currentEnergy = CalculateEnergy(state, cities); 
    disp('Initial route length: ');
    disp(currentEnergy);
    T = initialTemperature;
    
    for k = 1:100000 
        stateCandidate = GenerateStateCandidate(state); 
        candidateEnergy = CalculateEnergy(stateCandidate, cities); 
        
        if(candidateEnergy < currentEnergy) 
            state = stateCandidate; 
            currentEnergy = candidateEnergy;
        else
            p = GetTransitionProbability(candidateEnergy-currentEnergy, T); 
            if (IsTransition(p)) 
                state = stateCandidate; 
                currentEnergy = candidateEnergy;
            end
        end
        T = DecreaseTemperature(initialTemperature, k);
        
        if(T <= endTemperature) 
            break;
        end
    end    
    disp('Final route length: ');
    disp(currentEnergy);
end
function [ E ] = CalculateEnergy(sequence, cities) 
    n = size(sequence,1); 
    E = 0;
    for i = 1:n-1
        E = E + Metric(cities(sequence(i),:), cities(sequence(i+1),:));
    end
    
    E = E + Metric(cities(sequence(end),:), cities(sequence(1),:));
end
function [ distance ] = Metric( A, B ) 
    distance = (A - B).^2;
    distance = sqrt(distance);
    distance = sum(distance);
end
function [ T ] = DecreaseTemperature( initialTemperature, k)
    T = initialTemperature * 0.1 / k; 
end
function [ P ] = GetTransitionProbability( dE, T )
    P = exp(-dE/T);
end
function [ a ] = IsTransition( probability )
    if(rand(1) <= probability)
        a = 1;
    else
        a = 0; 
    end
end
function [ seq ] = GenerateStateCandidate(seq)
    n = size(seq, 1);
    first = randi([1,n-1]);
    second = randi([first+1,n]);
    rev = seq(second:-1:first);
    for i=first:second
        seq(i) = rev(i-first+1);
    end
end




