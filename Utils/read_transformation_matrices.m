function transformation_matrices = read_transformation_matrices(trans_matrix_pattern, patient_data, NFrames)
    transformation_matrices = cell(NFrames, 1);
    transformation_matrices{1} = affine3d(eye(4));
    for iFrame = 2:NFrames
        trans_matrix_fname = sprintf(trans_matrix_pattern, patient_data{2}, patient_data{4}, iFrame);
        if ~exist(trans_matrix_fname)
            transformation_matrices{iFrame} = affine3d(eye(4));
        else
            transformation_matrices{iFrame} = invert(affine3d(load(trans_matrix_fname, '-ASCII')'));
        end
    end
end