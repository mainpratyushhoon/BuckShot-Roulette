
function twoplayer()
% BUCKSHOTVARIANT  Play the 3-live / 2-empty buckshot game in MATLAB (console).
% Rules implemented:
% - 5 chambers: 3 live bullets, 2 empty
% - Players: 1 vs 2. PLAYER 1 starts with the gun.
% - Each turn the holder chooses to shoot SELF or OPPONENT.
% - If the chamber is EMPTY -> current holder KEEPS the gun.
% - If the chamber is LIVE  -> gun goes to the other player.
% - Each player can SURVIVE 2 live hits; the 3rd live hit kills them.
% - By default the cylinder is spun (random chamber each pull). Change spinMode to 'sequential' to step through chambers.

% ===== Parameters (change if you like) =====
numChambers = 5;
numLive = 3;
numEmpty = numChambers - numLive;
allowed_survivals = 1;   % survive 2 live hits; 3rd hit kills

% ===== Initialize game state =====
rng('shuffle');
% create chamber array: 1 = live, 0 = empty
chambers = [ones(1,numLive), zeros(1,numEmpty)];
% We'll randomize initial order
chambers = chambers(randperm(numChambers));

currentHolder = 1;   % 1 = PLAYER 1, 2 = PLAYER 2
hits = [0,0];        % live hits each player has taken
roundNum = 0;
sequentialIndex = 0; % used only when spinMode == 'sequential'
clc;
fprintf('============================== Buckshot Variant ==============================\n');
pause(3);
fprintf('Chambers: %d (live: %d, empty: %d)\n', numChambers, numLive, numEmpty);
pause(3);
fprintf('Each player survives %d live hits (dies on %d-nd hit)\n\n', allowed_survivals, allowed_survivals+1);
player1 = input('Player 1 name : ',"s");
player2 = input('Player 2 name : ',"s");
pause(3);
fprintf('%s starts with the gun.\n\n',holderName(currentHolder,player1,player2));
pause(5);
% Main game loop
while true
    clc;
    roundNum = roundNum + 1;
    fprintf('--------------------------------------------------------------------------\n');
    fprintf('-------------------------------- Round %d --------------------------------\n', roundNum);
    fprintf('--------------------------------------------------------------------------\n');
    pause(3);
    fprintf('%s hits: %d  |  %s hits: %d\n',player1, hits(1),player2, hits(2));
    pause(3);
    fprintf('Current holder: %s\n', holderName(currentHolder,player1,player2));
    fprintf('--------------------------------------------------------------------------\n');
    % Ask current holder what they do
    if currentHolder == 1
        pause(3);
        fprintf('%s HAS THE GUN\n',holderName(currentHolder,player1,player2))
        % YOU choose action using input()
        fprintf('Choose action:\n 1 - Shoot SELF\n 2 - Shoot OPPONENT\n');
        choice = input('Enter 1 or 2: ');
        if isempty(choice) || ~ismember(choice,[1,2])
            fprintf('Invalid input, defaulting to Shoot SELF.\n');
            choice = 1;
        end
        target = 1 + (choice==2); % if choice==2 then target=2 else 1
        fprintf('\nLOADING...');
        pause(3);
        fprintf('DEEP BREATHING...');
        pause(3);
        fprintf('PULLING THE TRIGGER...\n');
    else
        pause(3);
        fprintf('%s HAS THE GUN.\n',holderName(currentHolder,player1,player2));
        % Opponent strategy: simple heuristic (can be changed)
        % - If opponent has fewer survivals left, prefer to shoot you; otherwise random.
        % Here we choose randomly between shoot self or shoot you.
        pause(3);
        fprintf('Choose action:\n 1 - Shoot SELF\n 2 - Shoot OPPONENT\n');
        choice = input('Enter 1 or 2: ');
        if isempty(choice) || ~ismember(choice,[1,2])
            fprintf('Invalid input, defaulting to Shoot SELF.\n');
            choice = 1;
        end
        target = 1 + (choice==1); % if choice==2 then target=2 else 1
        fprintf('\nLOADING...');
        pause(3);
        fprintf('DEEP BREATHING...');
        pause(3);
        fprintf('PULLING THE TRIGGER...\n');
    end

    sequentialIndex = mod(sequentialIndex, numChambers) + 1;
    chosenIndex = sequentialIndex;
    result = chambers(chosenIndex); % 1 = live, 0 = empty
    pause(3);
    % Show result (conceal chambers except result)
    if result == 1
        fprintf('BANG! It was a LIVE bullet.\n');
        % target gets hit
        hits(target) = hits(target) + 1;
        fprintf('%s took a hit (total hits now %d).\n', holderName(target,player1,player2), hits(target));
    else
        fprintf('Click. It was EMPTY.\n');
        % empty -> current holder keeps the gun (no change)
    end

    %shifting guns
    currentHolder=target;

    % Check for death
    if hits(1) > allowed_survivals
        fprintf('\n*** %s has been killed (received %d hits). %s wins. ***\n',player1, hits(1),player2);
        break;
    elseif hits(2) > allowed_survivals
        fprintf('\n*** %s has been killed (received %d hits). %s wins! ***\n',player2, hits(2),player1);
        break;
    end
    pause(5);
end

fprintf('Game over after %d rounds.\n', roundNum);

end

function s = holderName(player,player1,player2)
    if player == 1
        s = player1;
    else
        s = player2;
    end
end
