function new_landmark_indices = perturb_ventricle_landmarks(vertices, landmark_indices, mean_edge_length, times, num_trials)
% PERTURB_VENTRICLE_LANDMARKS Randomly resamples ventricle landmarks within a physical distance radius.
%
% Inputs:
%   vertices         : Nx3 matrix of 3D coordinates [x, y, z] for all mesh vertices
%   landmark_indices : vector of original landmark indices (1-based)
%   mean_edge_length : scalar, average mesh edge length
%   times            : multiplier to define the perturbation radius
%   num_trials       : (optional) number of trials, defaults to 1
%
% Output:
%   new_landmark_indices : [num_trials x num_landmarks] matrix of resampled landmark indices

%% Monte Carlo
    rng(42);
    if nargin < 4
        num_trials = 1;
    end

    % 1. Set perturbation radius R
    R = times * mean_edge_length;
    R_sq = R^2; % Use squared distance to avoid redundant sqrt calls

    num_landmarks = length(landmark_indices);
    new_landmark_indices = zeros(num_trials, num_landmarks);

    % 2. Find candidate vertices within distance R for each landmark
    candidate_sets = cell(1, num_landmarks);

    for k = 1:num_landmarks
        orig_idx = landmark_indices(k);
        orig_pt = vertices(orig_idx, :);

        % Compute squared Euclidean distance from all vertices to current landmark
        dist_sq = sum((vertices - orig_pt).^2, 2);

        % Filter vertex indices within distance <= R
        candidates = find(dist_sq <= R_sq);

        % Safety check: fallback to original point if empty
        if isempty(candidates)
            candidates = orig_idx;
        end

        candidate_sets{k} = candidates;
    end
    % candidate_sets

    % 3. Run Monte Carlo sampling
    for t = 1:num_trials
        for k = 1:num_landmarks
            candidates = candidate_sets{k};
            % Uniformly pick a random vertex from candidates
            rand_pick = candidates(randi(length(candidates)));
            new_landmark_indices(t, k) = rand_pick;
        end
    end    
end
