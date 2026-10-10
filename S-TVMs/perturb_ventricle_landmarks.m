function new_landmark_indices = perturb_ventricle_landmarks(vertices, landmark_indices, mean_edge_length, times, num_trials)
% PERTURB_VENTRICLE_LANDMARKS 对心室 Landmark 进行基于物理距离半径的随机重采样
%
% 输入参数:
%   vertices          : Nx3 矩阵，心室网格所有顶点的 3D 坐标 [x, y, z]
%   landmark_indices  : num_landmarksx1 或 1xnum_landmarks 向量，原始 num_landmarks 个 Landmark 在 vertices 中的索引 (1-based)
%   mean_edge_length  : 标量，网格的平均边长
%   num_trials        : (可选) 采样次数，默认为 1 (生成一组新的 landmarks)
%
% 输出参数:
%   new_landmark_indices : [num_trials x num_landmarks] 矩阵，每行为一次实验中重采样出的 num_landmarks 个新 Landmark 索引

%% Monte Carlo
    rng(42);
    if nargin < 4
        num_trials = 1;
    end

    % 1. 设定扰动半径 R = 2 * 平均边长
    R = times * mean_edge_length;
    R_sq = R^2; % 使用平方距离加速计算，避免重复开方

    num_landmarks = length(landmark_indices);
    new_landmark_indices = zeros(num_trials, num_landmarks);

    % 2. 为每个 Landmark 找到距离在 R 范围内的候选顶点集合
    candidate_sets = cell(1, num_landmarks);

    for k = 1:num_landmarks
        orig_idx = landmark_indices(k);
        orig_pt = vertices(orig_idx, :); % 当前 Landmark 的 3D 坐标

        % 计算网格所有顶点到当前 Landmark 的欧式距离平方
        dist_sq = sum((vertices - orig_pt).^2, 2);

        % 筛选出距离 <= R 的所有顶点索引 (包含原始点本身)
        candidates = find(dist_sq <= R_sq);

        % 安全检查：确保至少能找到候选点（理论上至少包含原始点自身）
        if isempty(candidates)
            candidates = orig_idx;
        end

        candidate_sets{k} = candidates;
    end
    % candidate_sets

    % 3. 进行 Monte Carlo 随机抽样
    for t = 1:num_trials
        for k = 1:num_landmarks
            candidates = candidate_sets{k};
            % 从候选集中等概率随机选择一个顶点索引
            rand_pick = candidates(randi(length(candidates)));
            new_landmark_indices(t, k) = rand_pick;
        end
    end


% %% LHS
% % 1. 基础数据准备
% N=30;
% num_ref = length(landmark_indices); % 14 个参考点
% ref_coords = vertices(landmark_indices, :);
% 
% % 设定 1倍、2倍、3倍平均边长半径
% radii = [1.0, 2.0, 3.0] * mean_edge_length;
% 
% % 2. 预建模 KD-Tree 用于快速空间邻域搜索
% kdtree = KDTreeSearcher(vertices);
% perturbed_results = struct();
% 
% % 3. 逐级别进行“表面流形 + LHS 逆映射”采样
% for lvl = 1:length(radii)
%     current_R = radii(lvl);
%     sigma = current_R; % 设高斯衰减标准差为半径
% 
%     % 预先分配存储矩阵: N 次抽样，每次得到 14 个顶点的索引 (N x 14)
%     sampled_vertex_indices = zeros(N, num_ref);
% 
%     for k = 1:num_ref
%         % A. 查找在 R 半径内的所有表面顶点 candidates
%         cand_indices = rangesearch(kdtree, ref_coords(k, :), current_R);
%         cand = cand_indices{1};
%         num_cand = length(cand);
% 
%         if num_cand == 1
%             % 如果邻域内只有自己，直接填入自身
%             sampled_vertex_indices(:, k) = cand;
%         else
%             % B. 计算候选点到原参考点的物理空间距离与高斯概率 PDF
%             cand_coords = vertices(cand, :);
%             dists = sqrt(sum((cand_coords - ref_coords(k, :)).^2, 2));
% 
%             pdf_weights = exp(-(dists.^2) / (2 * sigma^2));
%             pdf_weights = pdf_weights / sum(pdf_weights); % 归一化 PDF
% 
%             % C. 计算累积分布函数 CDF
%             cdf_weights = cumsum(pdf_weights);
% 
%             % D. 利用 LHS 生成 [0, 1] 区间内高度均匀分布的分位数 (N x 1)
%             lhs_quantiles = lhsdesign(N, 1);
% 
%             % E. LHS 逆映射 (Inverse Quantile Mapping) 映射回 Mesh 节点
%             for i = 1:N
%                 u = lhs_quantiles(i);
%                 % 找到第一个 CDF >= u 的离散节点位置
%                 chosen_local_idx = find(cdf_weights >= u, 1, 'first');
%                 sampled_vertex_indices(i, k) = cand(chosen_local_idx);
%             end
%         end
%     end
% 
%     % F. 将生成的顶点索引转换为 14x3 的 3D 坐标集合
%     level_sets = cell(N, 1);
%     for i = 1:N
%         level_sets{i} = sampled_vertex_indices(i, :)';
%     end
% 
%     % 保存至结构体 (Level_1, Level_2, Level_3)
%     field_name = sprintf('Level_%d', lvl);
%     perturbed_results.(field_name) = level_sets;
% end
% new_landmark_indices = perturbed_results.Level_3;
    
end